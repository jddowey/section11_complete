//
//  TwitterClientReal.swift
//  section11
//
//  Created by nsg on 4/17/17.
//  Copyright © 2017 nsg. All rights reserved.
//

import Foundation

// See documentation at https://dev.twitter.com/oauth/application-only

class TweetClientReal : TweetClient {
    
    func getAuthToken(key clientKey: String, secret clientSecret: String, _ success: @escaping (String) -> Void) -> Void {
        let urlEncodedKey = clientKey.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)!
        let urlEncodedSecret = clientSecret.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bearerTokenCredentials = urlEncodedKey + ":" + urlEncodedSecret
        let bytes = bearerTokenCredentials.data(using: .utf8)!
        let authStr = "Basic " + bytes.base64EncodedString()
        
        let customConfig = URLSessionConfiguration.default.copy() as! URLSessionConfiguration
        customConfig.httpAdditionalHeaders = [ "Authorization": authStr, "ContentType": "application/x-www-form-urlencoded;charset=UTF-8"]
        let urlSession = URLSession(configuration: customConfig)
        var request = URLRequest(url: URL(string: "https://api.twitter.com/oauth2/token")!)
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        request.httpMethod = "POST"
        let task = urlSession.dataTask(with: request) { (data, resp, err) in
            let httpResponse = resp as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            print("response status code is \(statusCode)")
            
            guard let goodData = data else {
                print("didn't get good data")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: goodData, options: .allowFragments) as! [String: Any]
                // {"token_type":"bearer","access_token":"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA%2FAAAAAAAAAAAAAAAAAAAA%3DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"}
                let tokenType = json["token_type"] as! String
                let authToken = json["access_token"] as! String
                guard tokenType == "bearer" else {
                    return
                }
                success(authToken)
            } catch {
                print("got bad json")
            }
        }
        task.resume()
    }
    
    
    /*
     GET /1.1/statuses/user_timeline.json?count=100&screen_name=twitterapi HTTP/1.1
     Host: api.twitter.com
     User-Agent: My Twitter App v1.0.23
     Authorization: Bearer AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA%2FAAAAAAAAAAAA
     AAAAAAAA%3DAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
     Accept-Encoding: gzip
     */
    
    func getTweets(auth authKey : String, query searchQuery: String, _ success: @escaping ([String]) -> Void) -> Void {
        let authStr = "Bearer " + authKey
        let customConfig = URLSessionConfiguration.default.copy() as! URLSessionConfiguration
        customConfig.httpAdditionalHeaders = [ "Authorization": authStr]
        let urlSession = URLSession(configuration: customConfig)
        let url = "https://api.twitter.com/1.1/statuses/user_timeline.json?count=10&screen_name=" + searchQuery
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        
        let task = urlSession.dataTask(with: request) { (data, resp, err) in
            let httpResponse = resp as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            print("response status code is \(statusCode)")
            
            guard let goodData = data else {
                print("didn't get good data")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: goodData, options: .allowFragments) as! [[String: Any]]
                success(json.map { $0["text"] as! String })
            } catch {
                print("got bad json")
            }
        }
        task.resume()
    }
}

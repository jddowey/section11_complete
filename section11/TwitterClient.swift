//
//  TwitterClient.swift
//  section11
//
//  Created by nsg on 4/17/17.
//  Copyright © 2017 nsg. All rights reserved.
//

import Foundation

protocol TweetClient {
    func getAuthToken(key clientKey: String, secret clientSecret: String, _ success: @escaping (String) -> Void) -> Void
    func getTweets(auth authKey : String, query searchQuery: String, _ success: @escaping ([String]) -> Void) -> Void
}

class TwitterClient : TweetClient {
    
    func getAuthToken(key clientKey: String, secret clientSecret: String, _ success: @escaping (String) -> Void) -> Void {
        success("Hardcoded Token")
    }
    
    func getTweets(auth authKey : String, query searchQuery: String, _ success: @escaping ([String]) -> Void) -> Void {
        let jsonPath = Bundle.main.path(forResource: "tweets_response", ofType: "json")
        if let data = FileManager.default.contents(atPath: jsonPath!) {
            let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
            success(json.map { $0["text"] as! String })
        }
    }
}

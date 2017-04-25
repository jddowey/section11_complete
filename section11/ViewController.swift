//
//  ViewController.swift
//  section11
//
//  Created by nsg on 4/17/17.
//  Copyright © 2017 nsg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var token : String?
    let client : TweetClient = TweetClientReal()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var consumeKeyLabel: UILabel!
    @IBOutlet weak var consumerSecretLabel: UILabel!
    
    @IBAction func getApiToken(_ sender: Any) {
        client.getAuthToken(key: AppDelegate.ConsumerKey, secret: AppDelegate.ConsumerSecret) { token in
            self.token = token
            
            let alert = UIAlertController(
                title: "Token received",
                message: "Auth token is \"\(token)\"",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                alert.dismiss(animated: true)
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "showTableViewController", sender: self)
                }
            }
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTableViewController" {
            let tweetTableController = segue.destination as! TweetTableViewController
            tweetTableController.authToken = self.token!
            tweetTableController.client = self.client
        }
    }
}

//
//  LoginViewController.swift
//  NET-APP-FINAL
//
//  Created by Sarah Kharimah on 5/8/17.
//  Copyright © 2017 Sarah Kharimah. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let restApiManager = RestApiManager()
    
    @IBAction func onClick(_ sender: UIButton) {
        /* TODO: Send username and password info to the server */
        let baseUrl = "http://beacons.someurl.com:5000/get_login"
        let username = String(describing: self.usernameField.text!)
        let password = String(describing: self.passwordField.text!)
        let loginHttpUrl = restApiManager.getLoginUrlWithParams(baseUrl: baseUrl, username: username, password: password)
        
        print(loginHttpUrl)
        
        restApiManager.getHttpRequest(urlWithParams: loginHttpUrl, pageView: "Login")
        
        if(restApiManager.getLoginAccountReply() != "Already Registered") {
            /* TODO: Show warning that the account doesnt exist */
        } else if (restApiManager.getLoginAccountReply() == "Already Registered") {
            performSegue(withIdentifier: "Central", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}

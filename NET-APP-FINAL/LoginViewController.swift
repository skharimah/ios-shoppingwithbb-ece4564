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
    
    var restApiManager = RestApiManager()
    
    @IBAction func onClick(_ sender: UIButton) {
        
        let baseUrl = "http://172.29.108.106:5000/get_login"
        let username = String(describing: self.usernameField.text!)
        let password = String(describing: self.passwordField.text!)
        let loginHttpUrl = restApiManager.getLoginUrlWithParams(baseUrl: baseUrl, username: username, password: password)
        
        print(loginHttpUrl)
        
        performSegue(withIdentifier: "Central", sender: self)
        
        //restApiManager.getHttpRequest(urlWithParams: loginHttpUrl, pageView: "Login")
        
        //if(restApiManager.getLoginAccountReply() == ":)") {
        //    performSegue(withIdentifier: "Central", sender: self)
        //}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}

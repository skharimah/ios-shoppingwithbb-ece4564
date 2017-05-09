
//
//  ShoppingViewController.swift
//  NET-APP-FINAL
//
//  Created by Sarah Kharimah on 5/8/17.
//  Copyright © 2017 Sarah Kharimah. All rights reserved.
//

import UIKit

class ShoppingViewController: UIViewController {
    
    let restApiManager = RestApiManager()
    
    @IBOutlet weak var balanceField: UILabel!
    @IBOutlet weak var payButton: UIButton!
    
    @IBAction func payOnClick(_ sender: UIButton) {
        
        let baseUrl = "http://172.29.108.106:5000/get_pay_request"
        let username = "netappsteam01@vt.edu"
        let password = "finalproject"
        let loginHttpUrl = restApiManager.getLoginUrlWithParams(baseUrl: baseUrl, username: username, password: password)
        
        restApiManager.getHttpRequest(urlWithParams: loginHttpUrl, pageView: "Payment")
        
        let paymentResponse = globalVariables.balanceDue
        
        balanceField.text = "$" + paymentResponse
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}

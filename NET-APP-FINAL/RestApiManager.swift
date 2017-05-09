//
//  RestApiManager.swift
//  NET-APP-FINAL
//
//  Created by Sarah Kharimah on 5/8/17.
//  Copyright © 2017 Sarah Kharimah. All rights reserved.
//

import Foundation

struct globalVariables {
    static var recipeTitle = String()
    static var recipeImageUrl = String()
    static var balanceDue = String()
    static var updatedInRestApi = Bool()
    static var updatedBalanceInRestApi = Bool()
}

class RestApiManager {
    
    /* TODO: Update the variable names for specified fields */
    var loginAccountReply = String()
    var recipeTitle = String()
    var recipeImageUrl = String()
    var paymentResponse = String()
    
    /// Generate a url with the required parameters.
    ///
    /// - parameter baseUrl:  Endpoint url for the HTTP request
    /// - parameter uuid:     iBeacon ProximityUUID
    /// - parameter canvasId: Canvas ID associated to user
    /// - parameter major:    iBeacon major number
    /// - parameter minor:    iBeacon minor number
    ///
    /// - returns: base url with specified parameters to be used for HTTP request
    func getUrlWithParams(baseUrl: String, uuid: String, major: (Int), minor: (Int)) -> String {
        let urlWithParams = baseUrl + "?uuid=\(uuid)&major=\(major)&minor=\(minor)"
        return urlWithParams
    }
    
    /// Generate a url with the required parameters.
    ///
    /// - parameter baseUrl:  Endpoint url for the HTTP request
    /// - parameter uuid:     iBeacon ProximityUUID
    /// - parameter canvasId: Canvas ID associated to user
    /// - parameter major:    iBeacon major number
    /// - parameter minor:    iBeacon minor number
    ///
    /// - returns: base url with specified parameters to be used for HTTP request
    func getRecipeUrlWithParams(baseUrl: String, username: String, password: String, uuid: String, major: (Int), minor: (Int)) -> String {
        let urlWithParams = baseUrl + "?username=\(username)&password=\(password)&uuid=\(uuid)&major=\(major)&minor=\(minor)"
        return urlWithParams
    }
    
    /// Generate a url with the required parameters.
    ///
    /// - parameter baseUrl:  Endpoint url for the HTTP request
    /// - parameter uuid:     iBeacon ProximityUUID
    /// - parameter canvasId: Canvas ID associated to user
    /// - parameter major:    iBeacon major number
    /// - parameter minor:    iBeacon minor number
    ///
    /// - returns: base url with specified parameters to be used for HTTP request
    func getLoginUrlWithParams(baseUrl: String, username: String, password: String) -> String {
        let urlWithParams = baseUrl + "?username=\(username)&password=\(password)"
        return urlWithParams
    }
    
    /// Return "reply" field value from JSON response.
    ///
    /// - returns: "reply" field value
    func getLoginAccountReply() -> String {
        return self.loginAccountReply
    }
    
    /// Return "url" field value from JSON response.
    ///
    /// - returns: "url" field value
    func getRecipeTitle() -> String {
        return self.recipeTitle
    }
    
    /// Return "url" field value from JSON response.
    ///
    /// - returns: "url" field value
    func getRecipeImageUrl() -> String {
        return self.recipeImageUrl
    }
    
    /// Return "reply" field value from JSON response.
    ///
    /// - returns: "reply" field value
    func getPaymentResponse() -> String {
        return self.paymentResponse
    }
    
    /// Store the "group_name" field value from JSON response into the class' private variable.
    ///
    /// - parameter newGroupName: "group_name" field value to update the class' variable
    private func setLoginAccountReply(newLoginAccountReply: String) {
        self.loginAccountReply = newLoginAccountReply
    }
    
    /// Store the "canvas_url" field value from JSON response into the class' private variable.
    ///
    /// - parameter newCanvasUrl: "canvas_url" field value to update the class' variable
    private func setRecipeTitle(newRecipeTitle: String) {
        self.recipeTitle = newRecipeTitle
    }
    
    /// Store the "title" field value from JSON response into the class' private variable.
    ///
    /// - parameter newCanvasUrl: "title" field value to update the class' variable
    private func setRecipeImageUrl(newRecipeImageUrl: String) {
        self.recipeImageUrl = newRecipeImageUrl
    }
    
    /// Store the "title" field value from JSON response into the class' private variable.
    ///
    /// - parameter newCanvasUrl: "title" field value to update the class' variable
    private func setPaymentResponse(newPaymentResponse: String) {
        self.paymentResponse = newPaymentResponse
    }
    
    /// Send GET HTTP request to the provided url server.
    ///
    /// - parameter urlWithParams: base url with specified parameters to be used for HTTP request
    /// - parameter pageView: the controller page that sends the request; used to parse JSON field
    func getHttpRequest(urlWithParams: String, pageView: String) {
        
        print("...getHttpRequest")
        
        let urlRequest = URL(string: urlWithParams)
        
        URLSession.shared.dataTask(with:urlRequest!) { (data, response, error) in
            if error != nil {
                print(error as Any)
            } else {
                do {
                    if(pageView == "Login") {
                        let loginString = String(data: data!, encoding: String.Encoding.utf8)
                        let parsedLoginString = String(describing: loginString!)
                        self.setLoginAccountReply(newLoginAccountReply: parsedLoginString)
                    }
                    else if(pageView == "Recipe") {
                        let parsedJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        
                        self.setRecipeTitle(newRecipeTitle: parsedJSON["title"] as! String)
                        self.setRecipeImageUrl(newRecipeImageUrl: parsedJSON["image"] as! String)
                        
                        print("...getRecipeTitle & ImageUrl")
                        print(self.getRecipeTitle())
                        print(self.getRecipeImageUrl())
                        
                        globalVariables.recipeTitle = self.getRecipeTitle()
                        globalVariables.recipeImageUrl = self.getRecipeImageUrl()
                        globalVariables.updatedInRestApi = true
                        print("...globalVariableUpdated")
                    }
                    else if(pageView == "Payment") {
                        let parsedJSON = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
                        
                        print("...getPaymentResponse")
                        self.setPaymentResponse(newPaymentResponse: parsedJSON["pay_response"] as! String)
                        print(self.getPaymentResponse())
                        globalVariables.balanceDue = self.getPaymentResponse()
                        globalVariables.updatedBalanceInRestApi = true
                        print("...updatedBalanceInRestApi = true")
                    }
     
                } catch let error as NSError {
                    print(error)
                }
            }
            
            }.resume()
    }
    
    /// Send POST HTTP request to the provided url server.
    ///
    /// - parameter baseUrl: base url with specified parameters to be used for HTTP request e.g. "http://www.thisismylink.com/postName.php"
    /// - parameter postString: POST query? string e.g."id=13&name=Jack"
    func postHttpRequest(baseUrl: String, postString: String) {
        
        var request = URLRequest(url: URL(string: baseUrl)!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            
        }
        task.resume()
    }
    
}



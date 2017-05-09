//
//  RecipeViewController.swift
//  NET-APP-FINAL
//
//  Created by Sarah Kharimah on 5/8/17.
//  Copyright © 2017 Sarah Kharimah. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {
    
    var recipeControllerList:[String]?
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = NSURL(string: recipeControllerList![0]) {
            if let data = NSData(contentsOf: url as URL) {
                recipeImage.image = UIImage(data: data as Data)
            }        
        }
        
        recipeTitle.text = recipeControllerList?[1]
        
    }
    
}

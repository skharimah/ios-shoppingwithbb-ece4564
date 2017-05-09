//
//  CentralViewController.swift
//  NET-APP-FINAL
//
//  Created by Sarah Kharimah on 4/8/17.
//  Copyright © 2017 Sarah Kharimah. All rights reserved.
//

import UIKit
import CoreLocation

class CentralViewController: UIViewController, CLLocationManagerDelegate {
    
    private var numberOfApples = 0;
    private var numberOfOranges = 0;
    private var numberOfPinapples = 0;
    
    private var recipeControllerList = [String]()
    
    @IBOutlet weak var shoppingCartButton: UIButton!
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "F3F73797-8720-45A1-9C6A-B105E24D1484")! as UUID, major: 1000, minor: 1010, identifier: "F4:B8:5E:58:36:19")
    let secondRegion = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "F3F73797-8720-45A1-9C6A-B105E24D1484")! as UUID, major: 1000, minor: 1012, identifier: "F4:B8:5E:59:4F:A7")
    let thirdRegion = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "F3F73797-8720-45A1-9C6A-B105E24D1484")! as UUID, major: 1000, minor: 1009, identifier: "F4:B8:5E:58:37:9A")
    let restApiManager = RestApiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startRangingBeacons(in: region)
        locationManager.startRangingBeacons(in: secondRegion)
        locationManager.startRangingBeacons(in: thirdRegion)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Recipe") {
            let secondViewController = segue.destination as! RecipeViewController
            
            let recipeImageUrl = restApiManager.getRecipeImageUrl() as String
            let recipeTitle = restApiManager.getRecipeTitle() as String
            recipeControllerList.append(recipeImageUrl)
            recipeControllerList.append(recipeTitle)
            
            secondViewController.recipeControllerList = recipeControllerList
        }
    }

    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        
        /* TODO: Update base URL */
        let url = "http://beacons.someurl.com:5000/get_recipe"
        
        for beacon in beacons {
            var beaconProximity: String;
            switch (beacon.proximity) {
            case CLProximity.unknown:    beaconProximity = "Unknown";
            case CLProximity.far:        beaconProximity = "Far";
            case CLProximity.near:       beaconProximity = "Near";
            case CLProximity.immediate:  beaconProximity = "Immediate";
            }
            print("BEACON RANGED: uuid: \(beacon.proximityUUID) major: \(beacon.major)  minor: \(beacon.minor) proximity: \(beaconProximity)")
            
            if(beaconProximity == "Immediate") {
                
                let urlWithParams = restApiManager.getUrlWithParams(baseUrl: url, uuid: String(describing: beacon.proximityUUID), major: (Int)(beacon.major), minor: (Int)(beacon.minor))
                
                print(urlWithParams)
                
                if((Int)(beacon.minor) == 1010) {
                    if(numberOfApples == 0) {
                        numberOfApples = 1;
                        restApiManager.getHttpRequest(urlWithParams: urlWithParams, pageView: "Recipe")
                        performSegue(withIdentifier: "Recipe", sender: self)
                        
                    }
                }
                else if((Int)(beacon.minor) == 1009) {
                    if(numberOfOranges == 0) {
                        numberOfOranges = 1;
                        restApiManager.getHttpRequest(urlWithParams: urlWithParams, pageView: "Recipe")
                        performSegue(withIdentifier: "Recipe", sender: self)
                    }
                }
                else if((Int)(beacon.minor) == 1012) {
                    if(numberOfPinapples == 0) {
                        numberOfPinapples = 1;
                        restApiManager.getHttpRequest(urlWithParams: urlWithParams, pageView: "Recipe")
                        performSegue(withIdentifier: "Recipe", sender: self)
                    }
                }
            }
        }
    }
    
    @IBAction func onClickShoppingCart(_ sender: UIButton) {
        performSegue(withIdentifier: "Shopping", sender: self)
    }
   
}

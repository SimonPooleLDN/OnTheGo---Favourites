//
//  LocationViewController.swift
//  RestaurantApp
//
//  Created by Simon on 8/7/18.
//  Copyright © 2019 Simon Poole. All rights reserved.
//

import UIKit

protocol LocationActions: class {
    func didTapAllow()
}

class LocationViewController: UIViewController, LocationActions {
    
    func didTapAllow() {
        locationService.requestLocationAuthorization()
    }
    

    @IBOutlet weak var locationView: LocationView!
    weak var delegate: LocationActions?
    let locationService = LocationService()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        locationView.didTapAllow = {
            self.delegate?.didTapAllow()
            self.performSegue(withIdentifier: "toTabBar", sender: nil)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

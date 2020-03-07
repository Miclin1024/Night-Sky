//
//  CurrentLocationVC.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/7/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class CurrentLocationVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        getLocation()
    }
    

    func getLocation() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.locationManager.requestLocation()
    }

}

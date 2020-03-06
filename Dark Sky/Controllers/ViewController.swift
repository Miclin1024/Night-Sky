//
//  ViewController.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/5/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
    }
    
    func getLocation() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.locationManager.requestLocation()
    }
}


//
//  CustomLocationVC.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/7/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import Haptica

class CustomLocationVC: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func delCustomLocationCallback(_ sender: Any) {
        // Disable swipe gesture during transition
        self.pageViewController.isPagingEnabled = false
        Haptic.play(".O---O.", delay: 0)
        let sender = sender as! UIButton
        sender.isUserInteractionEnabled = false
        Manager.shared.delegate?.didDelUserLocation(delIndex: selfLocation.selfIndex)
    }
}

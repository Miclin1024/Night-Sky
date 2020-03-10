//
//  SplashVC.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/9/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import Lottie

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let animationView = AnimationView(name: "loading")
        animationView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        animationView.center = view.center
        animationView.contentMode = .scaleAspectFit
        
        view.addSubview(animationView)
        
        animationView.play()
        
    }
    

}

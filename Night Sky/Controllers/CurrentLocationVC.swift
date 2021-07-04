//
//  CurrentLocationVC.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/7/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import Lottie

class CurrentLocationVC: ViewController {
    
    var loadingView: AnimationView!
    var blurEffectView: UIVisualEffectView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        loadingView = AnimationView(name: "loading")
        loadingView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        loadingView.center = view.center
        loadingView.contentMode = .scaleAspectFit
        
        let blurEffect = UIBlurEffect(style: .regular)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.98
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = self.view.bounds
        blurEffectView.isUserInteractionEnabled = true

        self.view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(loadingView)
        loadingView.play(completion: { complete in
            UIView.animate(withDuration: 1.0, delay: 0.4, animations: {
                self.blurEffectView.alpha = 0
            }, completion: { _ in
                self.blurEffectView.removeFromSuperview()
            })
        })
    }
    

    func getLocation() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.locationManager.requestLocation()
    }
}

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
        
        let blurEffect = UIBlurEffect(style: .prominent)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.frame = self.view.bounds

        self.view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(loadingView)
        loadingView.play(completion: { complete in
            self.loadingView.animation = Animation.named("stillLoading")
            self.loadingView.loopMode = .loop
            self.loadingView.play()
        })
    }
    

    func getLocation() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.locationManager.requestLocation()
    }
    
    override func didUpdateWeather(sender: Location) {
        super.didUpdateWeather(sender: sender)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.blurEffectView.alpha = 0
            }, completion: { _ in
                self.loadingView.stop()
                self.blurEffectView.removeFromSuperview()
            })
        }
    }
}

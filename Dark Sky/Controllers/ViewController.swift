//
//  ViewController.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/5/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import Spring

class ViewController: UIViewController, LocationUpdateDelegate {

    @IBOutlet weak var locationNameLabel: DataDisplayUILabel!
    @IBOutlet weak var locationTempLabel: DataDisplayUILabel!
    @IBOutlet weak var tempRangeLabel: DataDisplayUILabel!
    @IBOutlet weak var weatherTypeImage: UIImageView!
    @IBOutlet weak var windSpeedLabel: DataDisplayUILabel!
    @IBOutlet weak var windBearing: UIImageView!
    @IBOutlet weak var windStackView: UIStackView!
    @IBOutlet weak var weather: DataDisplayUILabel!
    
    var selfLocation: Location!
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationNameLabel.setFont(toType: .Medium, toSize: 44)
        locationTempLabel.setFont(toType: .Regular, toSize: 36)
        tempRangeLabel.setFont(toType: .Light, toSize: 18)
        tempRangeLabel.textColor = .white
        windSpeedLabel.setFont(toType: .Semibold, toSize: 14)
        weather.setFont(toType: .Semibold, toSize: 17)
    }
    
    func getWobbleAnimation(withInitialRotation angle: CGFloat, strength: CGFloat) -> CAKeyframeAnimation {
        let animation = CAKeyframeAnimation(keyPath: "transform")

        animation.values = [NSValue(caTransform3D: CATransform3DMakeRotation(angle + 0.08 * strength, 0.0, 0.0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(angle - 0.06 * strength, 0, 0, 1.0)), NSValue(caTransform3D: CATransform3DMakeRotation(angle + 0.1 * strength, 0, 0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(angle - 0.1 * strength, 0, 0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(angle + 0.11 * strength, 0, 0, 1.0)),NSValue(caTransform3D: CATransform3DMakeRotation(angle - 0.13 * strength, 0, 0, 1.0))]
        animation.autoreverses = true
        animation.duration = 0.55
        animation.repeatCount = Float.infinity
        return animation
    }
    
    func didUpdateWeather(sender: Location) {
        guard let weather = sender.weather else {return}
        DispatchQueue.main.async {
            
            self.locationNameLabel.text = sender.name
            self.locationNameLabel.setSpringAnimation(type: "zoomIn", curve: "easeIn", duration: 1.0)
            self.locationNameLabel.setSpringOffset(x: 0, y: -20, scale: 1)
            self.locationNameLabel.springAnimate()
            
            self.locationTempLabel.text = String(Int(weather.temperature)) + "°"
            
            self.tempRangeLabel.text = String(Int(weather.tempMin)) + "°  -  " + String(Int(weather.tempMax)) + "°"
            
            self.weatherTypeImage.image = UIImage(named: weather.weatherType.rawValue)
        
            self.windSpeedLabel.text = String(Int(weather.windSpeed)) + " MPH"
       
            let weatherText = weather.icon.replacingOccurrences(of: "-", with: " ").capitalized
            self.weather.text = weatherText
        
            self.windBearing.transform = CGAffineTransform(rotationAngle: (CGFloat(weather.windBearing) * .pi) / 180)
            self.windBearing.layer.add(self.getWobbleAnimation(withInitialRotation: CGFloat(weather.windBearing) * .pi / 180, strength: CGFloat(weather.windSpeed / 10)), forKey: "transform")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.weatherTypeImage.alpha = 1
                self.windStackView.alpha = 1
                self.weather.alpha = 1
            })
        }
    }
}

protocol LocationUpdateDelegate: AnyObject {
    func didUpdateWeather(sender: Location)
}

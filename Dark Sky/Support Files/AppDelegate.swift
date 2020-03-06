//
//  AppDelegate.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/5/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    
    let notificationCenter = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            // Update user current location meta stored in Manager.shared.userLocations[0]
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                guard error == nil else {
                    print("Error retrieving location!")
                    return
                }
                
                if let placemark = placemarks?.first {
                    let userCurrLocation = Manager.shared.userLocations[0]
                    if let town = placemark.locality {
                        userCurrLocation.name = town
                    } else {
                        userCurrLocation.name = "Unknown"
                    }
                    userCurrLocation.latitude = location.coordinate.latitude
                    userCurrLocation.longitude = location.coordinate.longitude
                    Weather.forcast(location.coordinate.latitude, location.coordinate.longitude, sender: userCurrLocation)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

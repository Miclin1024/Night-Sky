//
//  Location.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/5/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    var latitude: Double?
    var longitude: Double?
    var weather: Weather?
    var name: String
    
    init (withName location: String) {
        self.name = location
        initWithString(with: location)
    }
    
    // Initialize a placeholder location, waiting to load
    init () {
        self.name = "Loading"
    }
    
    func initWithString(with locationString: String, completion: @escaping ()->Void={}) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationString) { (placemarks, error) in
            if let placemark = placemarks?.first {
                self.latitude = placemark.location!.coordinate.latitude
                self.longitude = placemark.location!.coordinate.longitude
                if let town = placemark.locality {
                    self.name = town
                }
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            
            completion()
        }
    }
}

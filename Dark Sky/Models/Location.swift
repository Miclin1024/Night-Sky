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
    let id: String
    var isCustomLocation: Bool
    var selfIndex: Int {
        get {
            if isCustomLocation {
                return Manager.shared.getIndex(ofLocation: self)!
            } else {
                return 0
            }
            
        }
    }
    weak var delegate: locationUpdateDelegate?
    
    init (withName location: String, completion: @escaping (Location)->Void={_ in}) {
        self.name = location
        self.id = UUID().uuidString
        self.isCustomLocation = true
        initWithString(with: location, completion: completion)
    }
    
    // Initialize a placeholder location, waiting to load
    init () {
        self.name = "--"
        self.id = UUID().uuidString
        self.isCustomLocation = false
    }
    
    func initWithString(with locationString: String, completion: @escaping (Location)->Void={_ in}) {
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
            
            completion(self)
        }
    }
}

extension Location: Equatable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.id == rhs.id
    }
}

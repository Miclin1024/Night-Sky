//
//  Manager.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/5/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation

class Manager {
    
    static let shared = Manager()
    
    weak var delegate: PageViewUpdateDelegate?
    
    // First location will be user's current location
    var userLocations: [Location]
    
    init() {
        // A placeholder location
        let currLocation = Location()
        userLocations = [currLocation]
        self.loadUserLocations()
    }
    
    func getIndex(ofLocation location: Location) -> Int? {
        return userLocations.firstIndex(of: location)
    }
    
    func loadUserLocations() {
        let locations = UserDefaults.standard.stringArray(forKey: "UserLocations")
        if let locations = locations {
            for name in locations {
                if !userLocations.contains(where: { loc in
                    loc.name == name
                }) {
                    userLocations.append(Location(withName: name))
                }
            }
        }
    }
    
    func addUserLocation(name: String) {
        let prev = UserDefaults.standard.stringArray(forKey: "UserLocations")
        if var prev = prev {
            if !prev.contains(name) {
                prev.append(name)
                UserDefaults.standard.set(prev, forKey: "UserLocations")
            }
        } else {
            UserDefaults.standard.set([name], forKey: "UserLocations")
        }
    }
    
    func delUserLocation(atIndex index: Int) {
        let prev = UserDefaults.standard.stringArray(forKey: "UserLocations")
        if var prev = prev {
            prev.remove(at: index - 1)
            UserDefaults.standard.set(prev, forKey: "UserLocations")
        }
    }
}

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
    
    weak var delegate: pageViewUpdateDelegate?
    
    // First location will be user's current location
    var userLocations: [Location]
    
    var currActiveIndex: Int
    
    init() {
        self.currActiveIndex = 0
        
        // A placeholder location
        let currLocation = Location()
        userLocations = [currLocation]
        self.loadUserLocations()
    }
    
    func loadUserLocations() {
        let locations = UserDefaults.standard.object(forKey: "UserLocations") as? [String]
        if let locations = locations {
            for name in locations {
                if !userLocations.contains(where: { loc in
                    loc.name == name
                }) {
                    userLocations.append(Location(withName: name))
                }
            }
        } else {
            print("User Default format error!")
        }
    }
    
    func addUserLocation(name: String) {
        let prev = UserDefaults.standard.object(forKey: "UserLocations") as? [String]
        if var prev = prev {
            if !prev.contains(name) {
                prev.append(name)
                UserDefaults.standard.set(prev, forKey: "UserLocations")
            }
        } else {
            print("User Default format error!")
        }
    }
}

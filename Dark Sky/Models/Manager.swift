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
    
    // First location will be user's current location
    var userLocations: [Location]
    
    var currActiveIndex: Int
    
    init() {
        self.currActiveIndex = 0
        let currLocation = Location()
        userLocations = [currLocation]
        self.loadUserLocations()
    }
    
    func loadUserLocations() {
        let locations = UserDefaults.standard.object(forKey: "UserLocations") as? [String]
        userLocations.append(Location(withName: "Oakland"))
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
}

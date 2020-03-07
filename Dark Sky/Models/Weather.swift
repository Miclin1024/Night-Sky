//
//  Weather.swift
//  Dark Sky
//
//  Created by Michael Lin on 3/5/20.
//  Copyright © 2020 Michael Lin. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class Weather: Decodable {
    
    static let BASE_PATH = "https://api.darksky.net/forecast/8f29427ca29491526c2bc60fcbc9afdc/"
    
    let temperature: Double
    let icon: String
    var weatherType: WeatherType
    let summary: String
    let precipIntensity: Double
    let windBearing: Int
    let windSpeed: Double
    
    enum CodingKeys: String, CodingKey {
        case current = "currently"
        case minute = "minutely"
        case hour = "hourly"
        case daily, alerts, latitude, longitude, timezone
    }
    
    enum WeatherKeys: String, CodingKey {
        case time, summary, icon, nearestStormDistance, precipIntensity, precipIntensityError, precipProbability, precipType, temperature, apparentTemperature, dewPoint, humidity, pressure, windSpeed, windGust, windBearing, cloudCover, uvIndex, visibility, ozone
    }
    
    enum AlertKeys: String, CodingKey {
        case title, time, expires, description, uri
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let currContainer = try container.nestedContainer(keyedBy: WeatherKeys.self, forKey: .current)
        self.temperature = try currContainer.decode(Double.self, forKey: .temperature)
        self.summary = try currContainer.decode(String.self, forKey: .summary)
        self.icon = try currContainer.decode(String.self, forKey: .icon)
        self.precipIntensity = try currContainer.decode(Double.self, forKey: .precipIntensity)
        self.windBearing = try currContainer.decode(Int.self, forKey: .windBearing)
        self.windSpeed = try currContainer.decode(Double.self, forKey: .windSpeed)
        
        self.weatherType = .clear
        self.weatherType = getWeatherType(fromString: icon)
    }
    
    func getWeatherType(fromString string: String) -> WeatherType {
        switch string {
        case "clear-day":
            return .clear
        case "clear-night":
            return .clearNight
        case "rain":
            if self.precipIntensity < 0.5 {
                return .lightRain
            } else if self.precipIntensity < 4 {
                return .moderateRain
            } else {
                return .heavyRain
            }
        case "snow":
            return .snow
        case "sleet":
            return .sleet
        case "wind":
            return .windy
        case "fog":
            return .foggy
        case "cloudy":
            return .cloudy
        case "partly-cloudy-day":
            return .partlyCloudy
        case "partly-cloudy-night":
            return .cloudyNight
        default:
            return .clear
        }
    }
    
    static func forcast(_ latitude: Double, _ longitude: Double, sender: Location, completion: ()->Void={}) {
        let latitude = latitude
        let longitude = longitude
        let url = BASE_PATH + "\(latitude),\(longitude)"
        let request = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let weather = try decoder.decode(Weather.self, from: data)
                    completeUpdateWeather(for: sender, weather: weather)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    static func forcast(withLocation location: Location, completion: ()->Void={}) {
        if let latitude = location.latitude, let longitude = location.longitude {
            forcast(latitude, longitude, sender: location, completion: completion)
        } else {
            location.initWithString(with: location.name, completion: {
                forcast(withLocation: location)
            })
        }
    }
    
    static func completeUpdateWeather(for location: Location, weather: Weather) {
        location.weather = weather
        location.delegate?.didUpdateWeather(sender: location)
    }
}

public enum WeatherType: String, Equatable, CaseIterable {
    case clear, sleet, snow, windy, partlyCloudy, cloudy, lightRain, moderateRain, heavyRain, thunder, clearNight, foggy, cloudyNight
}

public func ==(lhs: WeatherType, rhs: String) -> Bool {
    return lhs.rawValue.lowercased() == rhs.lowercased()
}

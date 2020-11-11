//
//  HourlyWeather.swift
//  Weather-App
//
//  Created by Anil on 11/9/20.
//

import Foundation


struct HourlyWeather: Codable {
    var hourly: [Hourly]
    var city: String?
}

struct Hourly: Codable {
    var date: Int
    var tempature: Double
    var humidity: Double
    var weather: [Weather]
    var minAndSecond: String?
    
    
   private enum CodingKeys: String, CodingKey {
        case date = "dt"
        case tempature = "temp"
        case humidity
        case weather
    }
}

struct Weather: Codable {
    var main: String
    var description: String
}

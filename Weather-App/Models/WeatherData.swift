//
//  WeatherData.swift
//  Weather-App
//
//  Created by Anil on 11/9/20.
//

import Foundation


struct WeatherData: Codable {
    var hourly: [Hourly]
    var daily: [Daily]
    var city: String?
}

struct Hourly: Codable {
    var date: Int
    var tempature: Double
    var weather: [Weather]
    var minAndSecond: String?
    
    
   private enum CodingKeys: String, CodingKey {
        case date = "dt"
        case tempature = "temp"
        case weather
    }
}

struct Daily: Codable{
    var temp: Temp
    var weather: [Weather]
    var yearMonthDay: String?
}

struct Temp: Codable {
    var day: Double
    var night: Double
}

struct Weather: Codable {
    var main: String
    var description: String
}

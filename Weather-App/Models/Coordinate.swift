//
//  Coordinate.swift
//  Weather-App
//
//  Created by Anil on 11/9/20.
//

import Foundation


struct Coordinate: Codable {
    var coord: LatAndLon?
    var sys: Sys
    var name:String?
}

struct Sys: Codable {
    var country:String
}

struct LatAndLon: Codable {
    var lon:Double
    var lat:Double
}

//
//  CoordByLocName.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 22.06.22.
//

import Foundation

struct Geocoding: Codable {
    var cityName: String?
    var localNames: LocalNames?
    var lat: Double
    var lon: Double
    var country: String?
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, country
        case cityName = "name"
        case localNames = "local_names"
    }
}

struct LocalNames: Codable {
    var en: String?
    var ru: String?
}

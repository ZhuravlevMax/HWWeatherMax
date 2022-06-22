//
//  UserStruct.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 18.06.22.
//

import Foundation

struct CurrentWeather: Codable {
    
    struct Coord: Codable {
        var lon: Decimal?
        var lat: Decimal?
    }

    let coord: Coord
    
    let weather: [AboutWeather]
    
    struct AboutWeather: Codable {
        var id: Int?
        var main: String?
        var description: String?
        var icon: String?
    }
    
    let base: String?
    
    struct Main: Codable {
        var temp: Decimal?
        var feelsLike: Decimal?
        var tempMin: Decimal?
        var tempMax: Decimal?
        var pressure: Int?
        var humidity: Int?
        
        enum CodingKeys: String, CodingKey {
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case temp, pressure, humidity
        }
    }
    
    let main: Main
    
    let visibility: Int?
    
    struct Wind: Codable {
        var speed: Decimal?
        var deg: Int?
    }
    
    let wind: Wind
    
    struct Clouds: Codable {
        var all: Int?
    }
    
    let clouds: Clouds
    
    let dt: Int?
    
    struct Sys: Codable {
        var type: Int?
        var id: Int?
        var country: String?
        var sunrise: Int?
        var sunset: Int?
    }
    
    let sys: Sys
    let timezone: Int?
    let id: Int?
    let name: String?
    let cod: Int?
    
}


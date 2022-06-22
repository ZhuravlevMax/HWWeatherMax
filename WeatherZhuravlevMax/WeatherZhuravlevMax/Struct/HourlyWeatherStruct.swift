//
//  MinutelyWeatherStruct.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 22.06.22.
//

import Foundation
//MARK: - Объект для погоды по часам

struct HourlyWeather: Codable {
    
    let lat: String?
    let lon: String?
    let timezone: String?
    let timezone_offset: Int?
    
    let hourly: [hourlyInfo]
    
    struct hourlyInfo: Codable {
        let dt: Int?
        let temp: Double?
        let feelsLike: Double?
        let pressure: Int?
        let humidity: Int?
        let dewPoint: Double?
        let uvi: Double?
        let clouds: Int?
        let visibility: Int?
        let windSpeed: Double?
        let windDeg: Int?
        let windGust: Double?
        
        let weather: [weatherInfo]
        
        struct weatherInfo: Codable {
            let id: Int?
            let main: String?
            let description: String?
            let icon: String?
        }
        
        let pop: Int?
        
        enum CodingKeys: String, CodingKey {
            case feelsLike = "feels_like"
            case dewPoint = "dew_point"
            case windSpeed = "wind_speed"
            case windDeg = "wind_deg"
            case windGust = "wind_gust"
            case dt, temp, pressure, humidity, uvi, clouds, visibility, weather, pop
        }
    }
    
        let alerts: [alertsInfo]
        
        struct alertsInfo: Codable {
            let sender_name: String?
            let event: String?
            let start: Int?
            let end: Int?
            let description: String?
            
            let tags: [String?]
            
        }
    }



//
//  DailyWeatherStruct.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 22.06.22.
//

import Foundation
//MARK: - Объект для погоды по дням

struct DailyWeather: Codable {
    
    let lat: String?
    let lon: String?
    let timezone: String?
    let timezoneOffset: Int?
    
    let dayly: [DaylyInfo]
    
    struct DaylyInfo: Codable {
        let dt: Int?
        let sunrise: Int?
        let sunset: Int?
        let moonrise: Int?
        let moonset: Int?
        let moonPhase: Double?
        
        struct Temp: Codable {
            let day: Double?
            let min: Double?
            let max: Double?
            let night: Double?
            let eve: Int?
            let morn: Double?
        }
        
        let temp: Temp
        
        struct FeelsLike: Codable {
            let day: Double?
            let night: Double?
            let eve: Double?
            let morn: Double?
        }
        
        let feelsLike: FeelsLike
        
        let pressure: Int?
        let humidity: Double?
        let dewPoint: Double?
        let windSpeed: Double?
        let windDeg: Int?
        let windGust: Double?
        
        let weather: [WeatherInfo]
        
        struct WeatherInfo: Codable {
            let id: Int?
            let main: String?
            let description: String?
            let icon: String?
        }
        
        let clouds: Int?
        let pop: Int?
        let uvi: Double?
        
        enum CodingKeys: String, CodingKey {
            case moonPhase = "moon_phase"
            case feelsLike = "feels_like"
            case dewPoint = "dew_point"
            case windSpeed = "wind_speed"
            case windDeg = "wind_deg"
            case windGust = "wind_gust"
            case dt, sunrise, sunset, moonrise, moonset, temp, pressure, humidity, weather, clouds, pop, uvi
        }
        
    }
    
    enum CodingKeys: String, CodingKey {
        case timezoneOffset = "timezone_offset"
        case lat, lon, timezone, dayly
    }
}


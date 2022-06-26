import Foundation


struct DailyWeatherData: Codable {
    var dt: Int?
    var sunrise: Int?
    var sunset: Int?
    var moonrise: Int?
    var moonset: Int?
    var moonPhase: Double?
    var temp: Temp?
    var feelsLike: FeelsLike?
    var pressure: Int?
    var humidity: Int?
    var dewPoint: Double?
    var windSpeed: Double?
    var windDeg: Int?
    var windGust: Double?
    var weather: [WeatherDaily]?
    var clouds: Int?
    var pop: Int?
    var rain: Double?
    var uvi: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset, temp, pressure, humidity, weather, clouds, pop, rain, uvi
        case feelsLike = "feels_like"
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case moonPhase = "moon_phase"
    }
}


struct Temp: Codable {
    var day: Double?
    var min: Double?
    var max: Double?
    var night: Double?
    var eve: Double?
    var morn: Double?
}

struct FeelsLike: Codable {
    var day: Double?
    var night: Double?
    var eve: Double?
    var morn: Double?
}

struct WeatherDaily: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

/*
 "daily": [
         {
             "dt": 1656266400,
             "sunrise": 1656241688,
             "sunset": 1656293384,
             "moonrise": 1656234420,
             "moonset": 1656287100,
             "moon_phase": 0.93,
             "temp": {
                 "day": 308.58,
                 "min": 294.09,
                 "max": 311.13,
                 "night": 294.09,
                 "eve": 298.28,
                 "morn": 301.26
             },
             "feels_like": {
                 "day": 310.26,
                 "night": 294.62,
                 "eve": 298.86,
                 "morn": 302.43
             },
             "pressure": 1017,
             "humidity": 37,
             "dew_point": 291.67,
             "wind_speed": 7.52,
             "wind_deg": 73,
             "wind_gust": 14.27,
             "weather": [
                 {
                     "id": 500,
                     "main": "Rain",
                     "description": "light rain",
                     "icon": "10d"
                 }
             ],
             "clouds": 13,
             "pop": 0.57,
             "rain": 2.12,
             "uvi": 10.47
         },
 */

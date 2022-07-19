//
//  BadWeatherEnum.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 19.07.22.
//

import Foundation

enum BadWeatherEnum {
    case rain
    case snow
    case thunderstorm
    
    var badWeatherOption: BadWeatherEnum {
        switch self {
        case .rain:
            return .rain
        case .snow:
            return .snow
        case .thunderstorm:
            return .thunderstorm
        }
    }
    
    var rangeWeather: ClosedRange<Int> {
        switch self {
        case .rain:
            return 200...232
        case .snow:
            return 500...532
        case .thunderstorm:
            return 600...635
        }
    }
}



//
//  BadWeatherStruct.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 19.07.22.
//

import Foundation
struct BadWeather: OptionSet {
    let rawValue: Int

    static let snow = BadWeather(rawValue: 1 << 0)
    static let rain = BadWeather(rawValue: 1 << 1)
    static let thunderstorm = BadWeather(rawValue: 1 << 2)
    //вторая цифра это сдвиг
    //если все добавлены то будут 111
    //если первый и последний 101
}

//
//  RealmData.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 29.06.22.
//

import Foundation
import RealmSwift

class RealmResponseData: Object {
    @objc dynamic var lat: Double = 0
    @objc dynamic var lon: Double = 0
    @objc dynamic var time: Int = 0
}

class RealmWeatherData: Object {
    @objc dynamic var temp: Double = 0
    @objc dynamic var feelsLike: Double = 0
    @objc dynamic var descriptionWeather: String = ""
    @objc dynamic var time: Int = 0
    @objc dynamic var coordinate: RealmResponseData?
}


//
//  DBManager.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 30.06.22.
//

import Foundation
import RealmSwift

protocol DBManagerProtocol {
    func saveCoordinate (coordinateData: RealmCoordinateData)
    func obtainCoordinate() -> [RealmCoordinateData]
    func saveWeather (weatherData: RealmWeatherData)
    func obtainWeather() -> [RealmWeatherData]
}

class DBManager: DBManagerProtocol {
    let realm = try! Realm()
    
    func saveCoordinate (coordinateData: RealmCoordinateData) {
        try! realm.write {
            realm.add(coordinateData)
        }
    }
    
    func obtainCoordinate() -> [RealmCoordinateData] {
        let models = realm.objects(RealmCoordinateData.self)
        return Array(models)
    }
    
    func saveWeather(weatherData: RealmWeatherData) {
        try! realm.write {
            realm.add(weatherData)
        }
    }
    
    func obtainWeather() -> [RealmWeatherData] {
        let models = realm.objects(RealmWeatherData.self)
        return Array(models)
    }
    
    
}

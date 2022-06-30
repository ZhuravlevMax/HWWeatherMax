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
    
    func saveCoordinate (coordinateData: RealmCoordinateData) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(coordinateData)
        }
    }
    
    func obtainCoordinate() -> [RealmCoordinateData] {
        let realm = try! Realm()
        
        let models = realm.objects(RealmCoordinateData.self)
        
        return Array(models)
    }
    
    func saveWeather(weatherData: RealmWeatherData) {
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(weatherData)
        }
    }
    
    func obtainWeather() -> [RealmWeatherData] {
        let realm = try! Realm()
        
        let models = realm.objects(RealmWeatherData.self)
        
        return Array(models)
    }
    
    
}

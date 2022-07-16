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
    func weatherData() -> Results<RealmWeatherData>
    func saveWeatherStates(states: RealmBadWeatherStates)
    func obtainBadWeather() -> [RealmBadWeatherStates]
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
            //print("ЗДЕСЬ!!! \(realm.configuration.fileURL)")
        }
    }
    
    func obtainWeather() -> [RealmWeatherData] {
        let models = realm.objects(RealmWeatherData.self)
        return Array(models)
    }
    
    func weatherData() -> Results<RealmWeatherData> {
        return realm.objects(RealmWeatherData.self)
    }
    
    func saveWeatherStates(states: RealmBadWeatherStates) {
        try! realm.write{
            realm.add(states)
        }
    }
    
    func obtainBadWeather() -> [RealmBadWeatherStates] {
        let models = realm.objects(RealmBadWeatherStates.self)
        return Array(models)
    }
}

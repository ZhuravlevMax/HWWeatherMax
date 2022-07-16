//
//  AlamofireProvider.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 25.06.22.
//

import Foundation
import Alamofire

enum Language{
    case ru
    case en
}

enum Exclude {
    case current
    case minutely
    case hourly
    case daily
    case alerts
}

enum Units {
    case metric
    case imperial
}

var userLanguage = "\(Language.en)"
var userUnits = "\(Units.imperial)"
let minutely = Exclude.minutely
let alerts = Exclude.alerts
let metric = Units.metric

protocol RestAPIProviderProtocol {
    
    func getCoordinatesByCityName(name: String, completion: @escaping (Result<[Geocoding], Error>) -> Void)
    func getWeatherForCityCoordinates(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> Void)
    
}

class AlamofireProvider: RestAPIProviderProtocol {
    func getCoordinatesByCityName(name: String, completion: @escaping (Result<[Geocoding], Error>) -> Void) {
        
        if Locale.current.languageCode == "\(Language.ru)" {
            userLanguage = "\(Language.ru)"
        }
        
        let params = addParams(queryItems: ["q" : name, "lang": userLanguage])
        
        AF.request(Constants.getCodingURL, method: .get, parameters: params).responseDecodable(of: [Geocoding].self) { response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getWeatherForCityCoordinates(lat: Double, lon: Double, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        
        
        UserDefaults.standard.bool(forKey: UserDefaultsKeys.metricUnitOn.rawValue) ? (userUnits = "\(Units.metric)") : (userUnits = "\(Units.imperial)")
        
        
        let params = addParams(queryItems: ["lat": lat.description, "lon": lon.description, "exclude": "\(minutely),\(alerts)", "lang": userLanguage, "units": userUnits])
        
        AF.request(Constants.weatherURL, method: .get, parameters: params).responseDecodable(of: WeatherData.self) {response in
            switch response.result {
            case .success(let result):
                completion(.success(result))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func addParams(queryItems: [String: String]) -> [String: String] {
        var params: [String: String] = [:]
        params = queryItems
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String {
            params["appid"] = apiKey
        }
        return params
    }
    
    
}

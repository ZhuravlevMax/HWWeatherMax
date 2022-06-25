////
////  RequestWeather.swift
////  WeatherZhuravlevMax
////
////  Created by Максим Журавлев on 21.06.22.
////
//
//import Foundation
//import UIKit
//
////enum для выбора системы
//enum Units {
//    case metric
//    case imperial
//}
//
//enum Limits: String {
//    case one = "1"
//    case two = "2"
//    case three = "3"
//    case four = "4"
//    case five = "5"
//}
//
//enum Language {
//    case ru
//    case en
//}
//
//class WeatherManager {
//
//    var city: String
//    var apiKey: String
//    var units: Units
//    var limit: String
//    var lang: Language
//    
//    init (city: String, apiKey: String, units: Units, limit: String, lang: Language) {
//        self.city = city
//        self.apiKey = apiKey
//        self.units = units
//        self.limit = limit
//        self.lang = lang
//    }
//
//    //MARK: - метод для запроса текущей погоды
//    func makeCurrentlyRequest(completion: ((CurrentWeather) -> Void)?) {
//        
//        getCoordByLocName { coord in
//            let cityLat = coord.first?.lat
//            let cityLon = coord.first?.lon
//            
//            guard let cityLatCheck = cityLat, let cityLonCheck = cityLon else {return}
//            
//            //url по которому будем получать данные
//            if let url =
//                URL(string:"https://api.openweathermap.org/data/2.5/onecall?lat=\(cityLatCheck)&lon=\(cityLonCheck)&lon&exclude=minutaly,hourly,daily&appid=\(self.apiKey)&units=\(self.units)&lang=\(self.lang)") {
//
//                //Создаю реквест
//                var urlRequest = URLRequest(url: url)
//                
//                //Указываю тип запроса GET, т.к. получаю данные с сайта
//                urlRequest.httpMethod = "GET"
//                
//                //Указываю тип контента json
//                urlRequest.setValue("application/json", forHTTPHeaderField: "content-Type")
//                
//                
//                let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//
//                    if let response = response {
//                        print(response)
//                    }
//                    
//                    if let data = data {
//                        let currentWeather = try! JSONDecoder().decode(CurrentWeather.self, from: data)
//                        completion?(currentWeather)
//                    }
//                    
//                    if let error = error {
//                        print(error)
//                    }
//                }
//                dataTask.resume()
//            }
//        }
//    }
//
//    //MARK: - Метод для получения координат по имени города
//    func getCoordByLocName(completion: (([CoordByLocName]) -> Void)?) {
//        //url по которому будем получать данные
//        if let url = URL(string:"https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=\(limit)&appid=\(apiKey)") {
//            
//            //Создаю реквест
//            var urlRequest = URLRequest(url: url)
//            
//            //Указываю тип запроса GET, т.к. получаю данные с сайта
//            urlRequest.httpMethod = "GET"
//            
//            //Указываю тип контента json
//            urlRequest.setValue("application/json", forHTTPHeaderField: "content-Type")
//            
//            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//
//                if let response = response {
//                    print(response)
//                }
//                
//                if let data = data {
//                    let coordByLocName = try! JSONDecoder().decode([CoordByLocName].self, from: data)
//                    completion?(coordByLocName)
//                }
//                
//                if let error = error {
//                    print(error)
//                }
//            }
//            dataTask.resume()
//        }
//    }
//    
//    //MARK: - метод для запроса почасовой погоды
//    func makeHourlyRequest(completion: ((HourlyWeather) -> Void)?) {
//        
//        getCoordByLocName { coord in
//            let cityLat = coord.first?.lat
//            let cityLon = coord.first?.lon
//            
//            guard let cityLatCheck = cityLat, let cityLonCheck = cityLon else {return}
//            //url по которому будем получать данные
//            if let url =
//                URL(string:"https://api.openweathermap.org/data/2.5/onecall?lat=\(cityLatCheck)&lon=\(cityLonCheck)&lon&exclude=current,minutaly,daily&appid=\(self.apiKey)&units=\(self.units)&lang=\(self.lang)") {
//
//                //Создаю реквест
//                var urlRequest = URLRequest(url: url)
//                
//                //Указываю тип запроса GET, т.к. получаю данные с сайта
//                urlRequest.httpMethod = "GET"
//                
//                //Указываю тип контента json
//                urlRequest.setValue("application/json", forHTTPHeaderField: "content-Type")
//                
//                
//                let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//
//                    if let response = response {
//                        print(response)
//                    }
//                    
//                    if let data = data {
//                        let hourlyWeather = try! JSONDecoder().decode(HourlyWeather.self, from: data)
//                        completion?(hourlyWeather)
//                    }
//                    
//                    if let error = error {
//                        print(error)
//                    }
//                }
//                dataTask.resume()
//            }
//        }
//    }
//}
//
//

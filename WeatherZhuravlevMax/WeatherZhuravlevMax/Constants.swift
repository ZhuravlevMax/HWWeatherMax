//
//  Constants.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 25.06.22.
//

import Foundation

struct Constants {
    static var baseURL = "https://api.openweathermap.org/"
    
    static var getCodingURL: String {
        return baseURL.appending("geo/1.0/direct")
    }
    
    static var weatherURL: String {
        return baseURL.appending("data/2.5/onecall")
    }
    
    static var imageURL: String {
        return "https://openweathermap.org/img/wn/"
    }
    
}

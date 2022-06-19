//
//  ViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 18.06.22.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let city = "Minsk"
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String else {
            print("There is no any key")
            return
        }
        //enum для выбора системы
        enum Units: String {
            case metric
            case imperial
        }
        
        //url по которому будем получать данные
        if let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=\(Units.metric.rawValue)") {
            
            //Создаю реквест
            var urlRequest = URLRequest(url: url)
            
            //Указываю тип запроса GET, т.к. получаю данные с сайта
            urlRequest.httpMethod = "GET"
            
            //Указываю тип контента json
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-Type")
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                
                if let response = response {
                    print(response)
                }
                
                if let data = data {
                    let weather = try! JSONDecoder().decode(Weather.self, from: data)
                    print(weather)
                }
                
                if let error = error {
                    print(error)
                }
            }
            dataTask.resume()
        }
    }
    
    
}


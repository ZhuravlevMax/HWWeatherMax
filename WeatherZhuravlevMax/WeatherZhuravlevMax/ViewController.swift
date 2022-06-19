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
        let apiKey = "e3d520a7f75cff3164067d89df3e34a8"

        //url по которому будем получать данные
        if let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)") {
            
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


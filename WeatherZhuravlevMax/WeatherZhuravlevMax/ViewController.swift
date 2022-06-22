//
//  ViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 18.06.22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let city = "Minsk"
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String else {
            print("There is no any key")
            return
        }
        let units: Units = .metric
        let limit = Limits.one.rawValue
        
        var WeatherManager = WeatherManager(city: city, apiKey: apiKey, units: units, limit: limit)
        
        WeatherManager.makeCurrentlyRequest { currentWeather in
            print(currentWeather)
        }
        
        DispatchQueue.main.async {
            WeatherManager.getCoordByLocName { coord in
                print(coord)
            }
        }
        
//        let imageUrl = URL(string: "https://openweathermap.org/img/wn/10d@4x.png")
//        if let data = try? Data(contentsOf: imageUrl!) {
//            weatherImage.image = UIImage(data: data)
//        }
    }
    
}











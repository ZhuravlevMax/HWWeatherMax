//
//  ViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 18.06.22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let city = "Minsk"
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String else {
            print("There is no any key")
            return
        }
        let units: Units = .metric
        let limit = Limits.one.rawValue
        let lang = Language.russian.rawValue
        tempLabel.text = ""
        feelsLikeTempLabel.text = ""
        descriptionWeatherLabel.text = ""
        
        var WeatherManager = WeatherManager(city: city, apiKey: apiKey, units: units, limit: limit, lang: lang)
        
        WeatherManager.makeCurrentlyRequest { currentWeather in
            print(currentWeather)
            
            //Получаю картинку погоды
            guard let weatherIconId = currentWeather.weather[0].icon else {return}
            DispatchQueue.main.async { [self] in
                let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(weatherIconId)@4x.png")
                if let data = try? Data(contentsOf: imageUrl!) {
                    self.weatherImage.image = UIImage(data: data)
                }
                // Текущая температура
                guard let currentTemp = currentWeather.main.temp else {return}
                self.tempLabel.text = "+ \(Int(currentTemp))"
                
                //Ощущается как
                guard let feelsLikeTemp = currentWeather.main.feelsLike else {return}
                feelsLikeTempLabel.text = "Чувствуется как + \(Int(feelsLikeTemp))"
                
                //Ясность / облачность
                guard let descriptionWeather = currentWeather.weather[0].description else {return}
                descriptionWeatherLabel.text = "\(descriptionWeather)"
            }
            
        }
        
        DispatchQueue.main.async {
            WeatherManager.getCoordByLocName { coord in
                print(coord)
            }
            
        }
    }
    
}











//
//  ViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 18.06.22.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    
    @IBOutlet weak var testButton: UIButton!
    
    private var apiProvider: RestAPIProviderProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempLabel.text = ""
        feelsLikeTempLabel.text = ""
        descriptionWeatherLabel.text = ""
        
        apiProvider = AlamofireProvider()
        
        getCoordByCityName()
        
    }
    
    func getCoordByCityName() {
        apiProvider.getCoordinatesByCityName(name: "Minsk") { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let value):
                if let city = value.first {
                    self.getWeatherByCoordinates(city: city)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getWeatherByCoordinates(city: Geocoding) {
        apiProvider.getWeatherForCityCoordinates(lat: city.lat, lon: city.lon) { result in
            switch result {
            case .success(let value):
                guard let weatherIconId = value.current?.weather?.first?.icon else {return}
                DispatchQueue.main.async {
                    guard let temp = value.current?.temp else {return}
                    self.tempLabel.text = "+\(Int(temp))"
                    
                    guard let feelsLikeTemp = value.current?.feelsLike else {return}
                    self.feelsLikeTempLabel.text = "Ощущается как +\(Int(feelsLikeTemp))"
                    
                    guard let descriptionWeather = value.current?.weather?.first?.description else {return}
                    self.descriptionWeatherLabel.text = "\(descriptionWeather)"
                    
                    guard let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(weatherIconId)@4x.png") else {return}
                    if let data = try? Data(contentsOf: imageUrl) {
                        self.weatherImage.image = UIImage(data: data)
                    }
                    
                    print(value)
                }
                
            case .failure(let error):
                print(error)
            }
            
        }

            
        }
    @IBAction func testButtonPressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MapStoryboard", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "MapStoryboard") as? MapViewController {
            present(viewController, animated: true)
        }
    }
}
    












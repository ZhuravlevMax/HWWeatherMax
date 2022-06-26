//
//  ViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 18.06.22.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    
    @IBOutlet weak var dailyTableView: UITableView!
    
    private var apiProvider: RestAPIProviderProtocol!
    
    var hourlyWeatherArray: [HourlyWeatherData] = []
    var dailyWeatherArray: [DailyWeatherData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()


        view.layoutSubviews()
        
        cityNameLabel.text = ""
        tempLabel.text = ""
        feelsLikeTempLabel.text = ""
        descriptionWeatherLabel.text = ""
        
        apiProvider = AlamofireProvider()
        
        getCoordByCityName()
        
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        
        hourlyCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HourlyCollectionViewCell.key)
        
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        
        dailyTableView.register(UINib(nibName: "DailyTableViewCell", bundle: nil), forCellReuseIdentifier: DailyTableViewCell.key)
        
    }
    
    func getCoordByCityName() {
        apiProvider.getCoordinatesByCityName(name: "Minsk") { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let value):
                if let city = value.first {
                    self.getWeatherByCoordinates(city: city)
                    DispatchQueue.main.async {
                        self.cityNameLabel.text = city.cityName
                    }
                    
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
                    
                    if let hourly = value.hourly {
                        self.hourlyWeatherArray = hourly
                    }
                    if let daily = value.daily {
                        self.dailyWeatherArray = daily
                    }
                    guard let temp = value.current?.temp else {return}
                    
                    self.tempLabel.text = "+\(Int(temp))"
                    
                    guard let feelsLikeTemp = value.current?.feelsLike else {return}
                    self.feelsLikeTempLabel.text = "ощущается как +\(Int(feelsLikeTemp))"
                    
                    guard let descriptionWeather = value.current?.weather?.first?.description else {return}
                    self.descriptionWeatherLabel.text = "\(descriptionWeather)"
                    
                    guard let imageUrl = URL(string: "https://openweathermap.org/img/wn/\(weatherIconId)@2x.png") else {return}
                    if let data = try? Data(contentsOf: imageUrl) {
                        self.weatherImage.image = UIImage(data: data)
                        
                    }
                    
                    self.hourlyCollectionView.reloadData()
                    self.dailyTableView.reloadData()
                    print(value)
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
}


extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyWeatherArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionCell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.key, for: indexPath) as? HourlyCollectionViewCell {
            collectionCell.hourlyLabel.text = "\( hourlyWeatherArray[indexPath.row].temp)"
            return collectionCell
        }
        return UICollectionViewCell()
    }
    
}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyWeatherArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let dailyCell = dailyTableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.key) as? DailyTableViewCell {
            dailyCell.dailyLabel.text = "\(dailyWeatherArray[indexPath.row].temp)"
            return dailyCell
        }
       return UITableViewCell()
    }
    
}











//
//  ViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 18.06.22.
//

import UIKit
import RealmSwift
import UserNotifications

class WeatherViewController: UIViewController {
    //MARK: - добавление outlets
    //loading view
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    //main view с таблицей
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    
    //хедер таблицы
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    //    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    //
    //    @IBOutlet weak var dailyTableView: UITableView!
    
    //MARK: - создание переменных
    private var apiProvider: RestAPIProviderProtocol!
    private var dBManager: DBManagerProtocol!
    
    var hourlyWeatherArray: [HourlyWeatherData] = []
    var dailyWeatherArray: [DailyWeatherData] = []
    var defaultCity: String = "Minsk"
    var searchCity: String!
    
    //enum для выбора ячейки
    enum CellType: Int {
        case collectionView = 0
        case tableView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        loadingLabel.text = "Загрузка данных о погоде..."
        
        mainView.isHidden = true
        dateLabel.text = ""
        cityNameLabel.text = ""
        tempLabel.text = ""
        //        feelsLikeTempLabel.text = ""
        descriptionWeatherLabel.text = ""
        
        apiProvider = AlamofireProvider()
        dBManager = DBManager()
        
        getCoordByCityName(searchCity: defaultCity)
        
        //        hourlyCollectionView.delegate = self
        //        hourlyCollectionView.dataSource = self
        //
        //        hourlyCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HourlyCollectionViewCell.key)
        //
        //        dailyTableView.delegate = self
        //        dailyTableView.dataSource = self
        //
        //        dailyTableView.register(UINib(nibName: "DailyTableViewCell", bundle: nil), forCellReuseIdentifier: DailyTableViewCell.key)
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "ForCollectionViewTableViewCell", bundle: nil), forCellReuseIdentifier: ForCollectionViewTableViewCell.key)
        
        mainTableView.register(UINib(nibName: "ForTableVIewTableViewCell", bundle: nil), forCellReuseIdentifier: ForTableVIewTableViewCell.key)
        
        //MARK: - Добавляю refresher to mainTableView
        let refresh = UIRefreshControl()
        mainTableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refresher(sender: )), for: .valueChanged)
        
    }
    
    @objc private func refresher(sender: UIRefreshControl) {
        
        guard let city = cityNameLabel.text else {return}
        getCoordByCityName(searchCity: city)
        mainTableView.reloadData()
        sender.endRefreshing()
    }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        guard let checkedSearchCity = searchTextField.text else {return}
        getCoordByCityName(searchCity: checkedSearchCity)
    }
    
    func getCoordByCityName(searchCity: String) {
        apiProvider.getCoordinatesByCityName(name: searchCity) { [weak self] result in
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
                    // MARK: - работа с БД
                    //Сохраняю в таблицу RealmResponseData
                    
                    guard let lonData = value.lon,
                          let latData = value.lat
                    else {return}
                    let date = Date()
                    let coordRealmData = RealmCoordinateData()
                    coordRealmData.lat = latData
                    coordRealmData.lon = lonData
                    coordRealmData.time = Int(date.timeIntervalSince1970)
                    
                    self.dBManager.saveCoordinate(coordinateData: coordRealmData)
                    
                    print(coordRealmData)
                    
                    // Сохраняем в таблицу RealmWeatherData
                    guard let tempData = value.current?.temp,
                          let feelsLikeData = value.current?.feelsLike,
                          let descriptionData = value.current?.weather?.first?.description
                    else {return}
                    
                    let weatherRealmData = RealmWeatherData()
                    weatherRealmData.temp = tempData
                    weatherRealmData.feelsLike = feelsLikeData
                    weatherRealmData.descriptionWeather = descriptionData
                    weatherRealmData.time = Int(date.timeIntervalSince1970)
                    weatherRealmData.coordinate = coordRealmData
                    
                    self.dBManager.saveWeather(weatherData: weatherRealmData)
                    
                    guard let hourlyWeatherDataArray = value.hourly else {return}
                    self.weatherIdCheck(hourlyWeatherData: hourlyWeatherDataArray)
                    
                    
                    
                    if let hourly = value.hourly {
                        self.hourlyWeatherArray = hourly
                    }
                    if let daily = value.daily {
                        self.dailyWeatherArray = daily
                    }
                    //MARK: - работа с UI
                    
                    self.mainView.isHidden = false
                    self.loadingView.isHidden = true
                    
                    self.cityNameLabel.text = city.cityName
                    
                    guard let temp = value.current?.temp else {return}
                    
                    self.tempLabel.text = "+\(Int(temp))°"
                    //
                    //                    guard let feelsLikeTemp = value.current?.feelsLike else {return}
                    //                    self.feelsLikeTempLabel.text = "ощущается как +\(Int(feelsLikeTemp))"
                    //
                    let currentDate =  Int(Date().timeIntervalSince1970).decoderDt(format: "EEEE, d MMMM")
                    self.dateLabel.text = currentDate
                    guard let descriptionWeather = value.current?.weather?.first?.description else {return}
                    self.descriptionWeatherLabel.text = descriptionWeather
                    
                    guard let imageUrl = URL(string: "\(Constants.imageURL)\(weatherIconId)@4x.png") else {return}
                    self.weatherImage.load(url: imageUrl)
                    //
                    //                    self.hourlyCollectionView.reloadData()
                    //                    self.dailyTableView.reloadData()
                    self.mainTableView.reloadData()
                    print(value)
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
}


//extension WeatherViewController: UICollectionViewDelegate, UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        hourlyWeatherArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        if let collectionCell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.key, for: indexPath) as? HourlyCollectionViewCell {
//
//            if let hourlyTemp = hourlyWeatherArray[indexPath.row].temp,
//               let hourlyIconId = hourlyWeatherArray[indexPath.row].weather?.first?.icon,
//               let hourlyTime = hourlyWeatherArray[indexPath.row].dt,
//               let imageUrl = URL(string: "\(Constants.imageURL)\(hourlyIconId)@2x.png"),
//               let data = try? Data(contentsOf: imageUrl) {
//
//                let decodedTime = hourlyTime.decoderDt(format: "HH mm ss")
//                collectionCell.timeLabel.text = "\(decodedTime)"
//                collectionCell.hourlyLabel.text = "+\(Int(hourlyTemp))"
//                collectionCell.hourlyImageView.image = UIImage(data: data)
//
//            }
//
//            return collectionCell
//        }
//        return UICollectionViewCell()
//    }
//
//}
//
//
//
//extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        dailyWeatherArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let dailyCell = dailyTableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.key) as? DailyTableViewCell {
//
//            if let dailyWeatherDay = dailyWeatherArray[indexPath.row].dt,
//               let dailyWeatherMax = dailyWeatherArray[indexPath.row].temp?.max {
//
//                let decodedDay = dailyWeatherDay.decoderDt(format: "dd MMM YYYY")
//                dailyCell.dailyLabelDay.text = "\(decodedDay)"
//                dailyCell.dailyLabelTemp.text = "+\(Int(dailyWeatherMax))"
//
//            }
//            return dailyCell
//        }
//        return UITableViewCell()
//    }
//
//}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        20
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let collectionCell = mainTableView.dequeueReusableCell(withIdentifier: ForCollectionViewTableViewCell.key) as? ForCollectionViewTableViewCell {
                collectionCell.models = self.hourlyWeatherArray
                return collectionCell
            }
        } else {
            if let tableCell = mainTableView.dequeueReusableCell(withIdentifier: ForTableVIewTableViewCell.key) as? ForTableVIewTableViewCell {
                tableCell.models = self.dailyWeatherArray
                return tableCell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 150.0
        } else {
            return 900.0
        }
    }
    
}










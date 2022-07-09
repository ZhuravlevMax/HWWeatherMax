//
//  ViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 18.06.22.
//

import UIKit
import RealmSwift
import UserNotifications
import CoreLocation

class WeatherViewController: UIViewController {
    //MARK: - добавление outlets
    //loading view
    @IBOutlet weak var loadingView: UIView!
    
    //main view с таблицей
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    
    //хедер таблицы
    @IBOutlet weak var currentPositionButton: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
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
    
    //enum для кнопок поиска и локации
    enum StateButtons: String {
        case search
        case location
        case city
        case state
    }
    
    //Для работы с GPS пользователя
    private lazy var coreManager: CLLocationManager = {
        let manager = CLLocationManager()
        //точность передвижения
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        
        mainView.isHidden = true
        
        dateLabel.text = ""
        locationLabel.text = ""
        cityNameLabel.text = defaultCity
        tempLabel.text = ""
        descriptionWeatherLabel.text = ""
        apiProvider = AlamofireProvider()
        dBManager = DBManager()
        coreManager.delegate = self
        
        if UserDefaults.standard.string(forKey: StateButtons.state.rawValue) == StateButtons.location.rawValue {
            //Запрашиваем авторизацию у юзера
            DispatchQueue.main.async {
                self.coreManager.requestWhenInUseAuthorization()
                self.coreManager.startUpdatingLocation()
            }
        } else if UserDefaults.standard.string(forKey: StateButtons.state.rawValue) == StateButtons.search.rawValue {
            
            guard let city = UserDefaults.standard.string(forKey: StateButtons.city.rawValue) else {return}
            
            DispatchQueue.main.async {
                self.getCoordByCityName(searchCity: city)
                self.searchButtonOnState()
            }
        } else {
            self.getCoordByCityName(searchCity: defaultCity)
        }
        
        hideKeyboardWhenTappedAround()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(UINib(nibName: "ForCollectionViewTableViewCell", bundle: nil), forCellReuseIdentifier: ForCollectionViewTableViewCell.key)
        
        mainTableView.register(UINib(nibName: "ForTableVIewTableViewCell", bundle: nil), forCellReuseIdentifier: ForTableVIewTableViewCell.key)
        
        //MARK: - Работа с refresher to mainTableView
        let refresh = UIRefreshControl()
        mainTableView.refreshControl = refresh
        refresh.addTarget(self, action: #selector(refresher(sender: )), for: .valueChanged)
        
    }
    
    @objc private func refresher(sender: UIRefreshControl) {
        
        guard let city = cityNameLabel.text else {return}
        getCoordByCityName(searchCity: city)
        sender.endRefreshing()
    }
    
    //MARK: - Работа с кнопкой текущей позиции
    @IBAction func currentPositionButtonPressed(_ sender: Any) {
        
        //Запрашиваем авторизацию у юзера
        coreManager.requestWhenInUseAuthorization()
        coreManager.startUpdatingLocation()
        
        UserDefaults.standard.set(StateButtons.location.rawValue, forKey: StateButtons.state.rawValue)
        
        
    }
    
    //MARK: - Работа с кнопкой поиска
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        //MARK: - AlertController для поиска города
        let findCityAlertController = UIAlertController(title: "Выбор города", message: "Погода по названию города", preferredStyle: .alert)
        findCityAlertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Введите название города"
        }
        
        let okButtonFindCityAction = UIAlertAction(title: "Выбрать", style: .default) { [self] _ in
            
            let findCityTextField = (findCityAlertController.textFields?[0] ?? UITextField()) as UITextField
            guard let cityName = findCityTextField.text else {return}
            
            getCoordByCityName(searchCity: cityName)
            
            searchButtonOnState()
            
            UserDefaults.standard.set(StateButtons.search.rawValue, forKey: StateButtons.state.rawValue)
            UserDefaults.standard.set(cityName, forKey: StateButtons.city.rawValue)
            
            
        }
        let cancelButtonFindCityAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        findCityAlertController.addAction(okButtonFindCityAction)
        findCityAlertController.addAction(cancelButtonFindCityAction)
        self.present(findCityAlertController, animated: true)
        
    }
    
    func searchButtonOnState() {
        coreManager.stopUpdatingLocation()
        searchButton.tintColor = .orange
        currentPositionButton.setImage(UIImage(systemName: "location"), for: .normal)
        currentPositionButton.tintColor = .white
    }
    
    
    
    //MARK: - Получение координат по названию города
    func getCoordByCityName(searchCity: String) {
        apiProvider.getCoordinatesByCityName(name: searchCity) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let value):
                if let city = value.first {
                    self.getWeatherByCoordinates(lat: city.lat, lon: city.lon)
                    self.cityNameLabel.text = city.cityName
                } else {
                    //MARK: - AlertController для ошибки
                    let cityNotExistAlertController = UIAlertController(title: "Ошибка!", message: "Проверьте правильность названия города!", preferredStyle: .alert)
                    let okButtonCityNotExistAction = UIAlertAction(title: "Ok", style: .default)
                    cityNotExistAlertController.addAction(okButtonCityNotExistAction)
                    self.present(cityNotExistAlertController, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    //MARK: - Получение погоды по координатам
    func getWeatherByCoordinates(lat: Double, lon: Double) {
        apiProvider.getWeatherForCityCoordinates(lat: lat, lon: lon) { result in
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
                    
                    
                    self.locationLabel.text = value.timeZone
                    
                    guard let temp = value.current?.temp else {return}
                    
                    self.tempLabel.text = "+\(Int(temp))°"
                    
                    let currentDate =  Int(Date().timeIntervalSince1970).decoderDt(format: "EEEE, d MMMM")
                    self.dateLabel.text = currentDate
                    guard let descriptionWeather = value.current?.weather?.first?.description else {return}
                    self.descriptionWeatherLabel.text = descriptionWeather
                    
                    guard let imageUrl = URL(string: "\(Constants.imageURL)\(weatherIconId)@4x.png") else {return}
                    self.weatherImage.load(url: imageUrl)
                    
                    self.mainTableView.reloadData()
                    print(value)
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
}


//MARK: - Работа с таблицей
extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let collectionCell = mainTableView.dequeueReusableCell(withIdentifier: ForCollectionViewTableViewCell.key) as? ForCollectionViewTableViewCell {
                collectionCell.models = self.hourlyWeatherArray
                collectionCell.inTableCellCollectionView.reloadData()
                return collectionCell
            }
        } else {
            if let tableCell = mainTableView.dequeueReusableCell(withIdentifier: ForTableVIewTableViewCell.key) as? ForTableVIewTableViewCell {
                tableCell.models = self.dailyWeatherArray
                tableCell.inTableCellTableView.reloadData()
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

//MARK: - Для работы с локацией пользователя
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .authorizedAlways ||
            manager.authorizationStatus == .authorizedWhenInUse {
            
            //coreManager.startUpdatingLocation()
            
            currentPositionButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
            
        } else if manager.authorizationStatus == .denied {
            currentPositionButton.isEnabled = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        
        getWeatherByCoordinates(lat: location.coordinate.latitude, lon: location.coordinate.longitude)
        
        DispatchQueue.main.async {
            self.currentPositionButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
            self.currentPositionButton.tintColor = .orange
            self.searchButton.tintColor = .white
            self.cityNameLabel.text = "Вокруг меня"
            self.coreManager.stopUpdatingLocation()
        }
        
        print(" ЛОКАЦИЯ: \(location)")
    }
    
}









//
//  MapViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 25.06.22.
//

import UIKit
import GoogleMaps
import RealmSwift

class MapViewController: UIViewController {
    
    //MARK: - Привязка outlets
    @IBOutlet weak var forMapView: UIView!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    //MARK: - Создание переменных
    private var apiProviderMap: RestAPIProviderProtocol!
    private var dBManager: DBManagerProtocol!
    
    //Переменные для хранения значений погоды
    var windSpeedForMarker = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        
        tempLabel.text = "Нажмите на карту"
        feelsLikeTempLabel.text = "для определения"
        descriptionWeatherLabel.text = "погоды в выбранной точке"
        
        apiProviderMap = AlamofireProvider()
        dBManager = DBManager()
        
        view.layoutSubviews()
        
        //Дефолтный вид карты
        let camera = GMSCameraPosition.camera(withLatitude: 54.029, longitude: 27.597, zoom: 9.0)
        let mapView = GMSMapView.map(withFrame: forMapView.frame, camera: camera)
        forMapView.addSubview(mapView)
        mapView.delegate = self
    
    }
    
    
}
//MARK: - extension для работы с картой
extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate.latitude)
        
        apiProviderMap.getWeatherForCityCoordinates(lat: coordinate.latitude, lon: coordinate.longitude) { result in
            switch result {
            case .success(let value):
                guard let weatherIconId = value.current?.weather?.first?.icon else {return}
                DispatchQueue.main.async {
                    
                    // MARK: - работа с БД
                    //Сохраняю в таблицу RealmResponseData
                    guard let lonData = value.lon,
                          let latData = value.lat,
                          let temp = value.current?.temp,
                          let imageUrl = URL(string: "\(Constants.imageURL)\(weatherIconId)@4x.png"),
                          let windSpeed = value.current?.windSpeed
                    else {return}
                    
                    //Значение текущего времени
                    let date = Date()
                    let coordRealmData = RealmCoordinateData()
                    coordRealmData.lat = latData
                    coordRealmData.lon = lonData
                    coordRealmData.time = Int(date.timeIntervalSince1970)

                    self.dBManager.saveCoordinate(coordinateData: coordRealmData)
                
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
                    
                    //MARK: -работа с маркером
                    mapView.clear()
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latData, longitude: lonData)
                    marker.map = mapView

                    // MARK: - работа с UI
                    
                    self.windSpeedForMarker = "\(windSpeed)"
                    self.tempLabel.text = "+\(Int(temp))°"
                    
                    guard let feelsLikeTemp = value.current?.feelsLike else {return}
                    self.feelsLikeTempLabel.text = "ощущается как +\(Int(feelsLikeTemp))°"
                    
                    guard let descriptionWeather = value.current?.weather?.first?.description else {return}
                    self.descriptionWeatherLabel.text = descriptionWeather

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
    
    //метод работы с маркером
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let markerView = Bundle.main.loadNibNamed(MarkerWindowUIView.key, owner: self, options: nil)![0] as? MarkerWindowUIView

        markerView?.markerMainView.layer.cornerRadius = 10
        markerView?.markerWindSpeedLabel.text = "Ветер: \(windSpeedForMarker) м/с"
        markerView?.markerTempLabel.text = tempLabel.text
        markerView?.markerImageView.image = weatherImage.image
        return markerView
    }
}

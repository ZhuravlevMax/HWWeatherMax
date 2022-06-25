//
//  MapViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 25.06.22.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    @IBOutlet weak var forMapView: UIView!
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLikeTempLabel: UILabel!
    @IBOutlet weak var descriptionWeatherLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    private var apiProviderMap: RestAPIProviderProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempLabel.text = "--"
        feelsLikeTempLabel.text = "--"
        descriptionWeatherLabel.text = "--"
        
        apiProviderMap = AlamofireProvider()
        
        view.layoutSubviews()
        
        let camera = GMSCameraPosition.camera(withLatitude: 54.029, longitude: 27.597, zoom: 9.0)
        let mapView = GMSMapView.map(withFrame: forMapView.frame, camera: camera)
        forMapView.addSubview(mapView)
        mapView.delegate = self
    }
    
    
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate.latitude)
        apiProviderMap.getWeatherForCityCoordinates(lat: coordinate.latitude, lon: coordinate.longitude) { result in
            switch result {
            case .success(let value):
                guard let weatherIconId = value.current?.weather?.first?.icon else {return}
                DispatchQueue.main.async {
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
                print(value)
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

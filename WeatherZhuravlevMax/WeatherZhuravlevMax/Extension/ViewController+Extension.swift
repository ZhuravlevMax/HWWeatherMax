//
//  ViewController+Extension.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 3.07.22.
//

import Foundation
import UIKit
import UserNotifications
import RealmSwift

extension UIViewController {
    
    func weatherIdCheck(hourlyWeatherData: [HourlyWeatherData], badWeather: [RealmBadWeatherStates]) {
        
        
        
        let weather = hourlyWeatherData.first {
            guard let id = $0.weather?.first?.id else {return false}
            return (200...232).contains(id) || (500...531).contains(id) || (600...622).contains(id)
        }
        guard let weather = weather else {return}

        setNotification(weather: weather)
    }
    
    func setNotification(weather: HourlyWeatherData) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        guard let time = weather.dt,
              let body = weather.weather?.first?.description else {return}

        notificationCenter.requestAuthorization(options: [.alert, .sound]) { isAuthorized, error in
            if isAuthorized {
                
                let content = UNMutableNotificationContent()
                content.title = "Weather"
                content.subtitle = "About weather"
                content.body = "\(body) через 30 минут"
                content.sound = UNNotificationSound.default
                
                //MARK: Нотификация за 30 минут
                //time - время начала плохой погоды
                var timeForTrigger = time - 1800
                let date = timeForTrigger.decoderIntToDate()
                let timeTrigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: false)
                
                //Для натификейшена надо создать уникальные идентификатор для уведомления
                let identifier = "identifier"
                
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: timeTrigger)
                
                notificationCenter.add(request) { error in
                    if let error = error {
                        print(error)
                    }
                }
                
            } else if let error = error {
                print(error)
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                         action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
}

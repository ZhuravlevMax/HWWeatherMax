//
//  ViewController+Extension.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 3.07.22.
//

import Foundation
import UIKit
import UserNotifications

extension UIViewController {
    
    func weatherIdCheck(hourlyWeatherData: [HourlyWeatherData]) {
        
        let weather = hourlyWeatherData.first {
            guard let id = $0.weather?.first?.id else {return false}
            return (200...232).contains(id) || (500...531).contains(id) || (200...232).contains(id)
        }
        guard let weather = weather else {return}

        setNotification(weather: weather)
    }
    
    func setNotification(weather: HourlyWeatherData) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { isAuthorized, error in
            if isAuthorized {
                
                let content = UNMutableNotificationContent()
                content.title = "Weather"
                content.subtitle = "About weather"
                
                guard let body = weather.weather?.first?.main else {return}
                content.body = "\(body) in 30 minutes"
                content.sound = UNNotificationSound.default
                
                //MARK: Нотификация за 30 минут
                //time - время начала плохой погоды
                guard let time = weather.dt else {return}
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
}

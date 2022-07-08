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
        
        for hour in hourlyWeatherData {
            
            guard let id = hour.weather?.first?.id,
                  let time = hour.dt
            else {return}
            
            switch id {
            case 200...232:
                setNotification(time: time, body: "Thunderstorm starts in 30 minutes")
                return
            case 500...531:
                setNotification(time: time, body: "Rain starts in 30 minutes")
                return
            case 600...622:
                setNotification(time: time, body: "Snow starts in 30 minutes")
                return
            default: break
            }
        }
    }
    
    func setNotification(time: Int, body: String) {
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { isAuthorized, error in
            if isAuthorized {
                
                let content = UNMutableNotificationContent()
                content.title = "Weather"
                content.subtitle = "About weather"
                content.body = body
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
}

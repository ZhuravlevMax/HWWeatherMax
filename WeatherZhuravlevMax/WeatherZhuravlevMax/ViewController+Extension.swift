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
    func weatherNotification(badWeather: String) {
        
        enum BadWeatherEnum: String {
            case rain = "Rain"
            case thunderstorm = "Thunderstorm"
            case snow = "Snow"
            case clouds = "Clouds"
        }
        
        if badWeather == BadWeatherEnum.rain.rawValue ||
            badWeather == BadWeatherEnum.snow.rawValue ||
            badWeather == BadWeatherEnum.thunderstorm.rawValue
        //Облачность для проверки работы
           // badWeather == BadWeatherEnum.clouds.rawValue
        {
            
            let notificationCenter = UNUserNotificationCenter.current()
            
            notificationCenter.requestAuthorization(options: [.alert, .sound]) { isAuthorized, error in
                if isAuthorized {
    
                    
                    let content = UNMutableNotificationContent()
                    content.title = "Weather"
                    content.subtitle = "About weather"
                    content.body = "Precipitation expected in 30 minutes"
                    content.sound = UNNotificationSound.default

                    
                    //Нотификация через 30 минут
                    let date = Date().addingTimeInterval(60*30)
                    let dateComponent = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
                    
                    let timeTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
                
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
}

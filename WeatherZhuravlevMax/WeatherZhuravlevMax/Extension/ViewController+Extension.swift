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
        guard let badWeatherState = badWeather.last?.badWeatherBitCode else {return}
        
        //выбираем элемент подходящий по условиям заданным в настройках
        let weather = hourlyWeatherData.first {
            guard let id = $0.weather?.first?.id else {return false}
            
            switch badWeatherState {
            case 7:
                return (500...531).contains(id) || (600...622).contains(id) || (200...232).contains(id)
            case 6:
                return (500...531).contains(id) || (200...232).contains(id)
            case 5:
                return (600...622).contains(id) || (200...232).contains(id)
            case 4:
                return (200...232).contains(id)
            case 3:
                return (500...531).contains(id) || (600...622).contains(id)
            case 2:
                return (500...531).contains(id)
            case 1:
                return (600...622).contains(id)
            default:
                false
            }
            return false
        }
//            if rainState && snowState && thunderstormState {
//                return (500...531).contains(id) || (600...622).contains(id) || (200...232).contains(id)
//            } else if rainState && snowState {
//                return (500...531).contains(id) || (600...622).contains(id)
//            } else if rainState && thunderstormState {
//                return (500...531).contains(id) || (200...232).contains(id)
//            } else if snowState && thunderstormState {
//                return (600...622).contains(id) || (200...232).contains(id)
//            } else if rainState {
//                return (500...531).contains(id)
//            } else if snowState {
//                return (600...622).contains(id)
//            } else if thunderstormState {
//                return (200...232).contains(id)
//            }
//            return false
        
        guard let weatherChecked = weather else {return}
        print(weatherChecked.dt?.decoderDt(format: "HH:mm"))
        setNotification(weather: weatherChecked)
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

/*
 
 Побитовое сложение
 Каждому элементу списка присваивается номер
 -----
 optionSet
 
 */
//struct BadWeather: OptionSet {
//    let rawValue: Int
//    
//    static let snow = BadWeather(rawValue: 1 << 0)
//    static let rain = BadWeather(rawValue: 1 << 1)
//    static let thunder = BadWeather(rawValue: 1 << 2)
//    static let tornado = BadWeather(rawValue: 1 << 3)
//    static let dust = BadWeather(rawValue: 1 << 4)
//    //вторая цифра это сдвиг
//    //если все добавлены то будут 11111
//    //если первый и последний 10001
//}
//
//var badWeather = BadWeather(/* сюда значение и реалма*/)
//badWeather.insert(.snow)
//badWeather.insert(.rain)

//
//  Extension+Int.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 29.06.22.
//

import Foundation
//Форматирую dt в dd MMM YYYY формат
extension Int {
    func decoderDt(int: Int, format: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(int))
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = format
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    //Форматирование Int в DateComponents
    func decoderIntToDate(int: Int) -> DateComponents {
        
        let timeInterval = TimeInterval(int)
        let myNSDate = Date(timeIntervalSince1970: timeInterval)
        let comps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: myNSDate)
        return comps
    }
}

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
}

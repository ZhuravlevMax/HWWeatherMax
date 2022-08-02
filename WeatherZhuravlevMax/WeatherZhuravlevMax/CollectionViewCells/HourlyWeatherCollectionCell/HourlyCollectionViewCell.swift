//
//  HourlyCollectionViewCell.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 26.06.22.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var hourlyLabel: UILabel!
    @IBOutlet weak var hourlyImageView: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    var formatTime = ""
    static let key = "HourlyCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    public func configure(with model: HourlyWeatherData) {
    
        UserDefaults.standard.bool(forKey: UserDefaultsKeys.twentyFormatOn.rawValue) ? (formatTime = "hh:mm") : (formatTime = "HH:mm")
        if let hourlyIconId = model.weather?.first?.icon,
           let imageUrl = URL(string: "\(Constants.imageURL)\(hourlyIconId)@2x.png"),
           let decodedTime = model.dt?.decoderDt(format: formatTime),
           let hourlyTemp = model.temp {
            
            self.hourlyImageView.load(url: imageUrl)
            self.hourlyLabel.text = "\(Int(hourlyTemp))°"
            self.timeLabel.text = decodedTime

        }

    }
    
}

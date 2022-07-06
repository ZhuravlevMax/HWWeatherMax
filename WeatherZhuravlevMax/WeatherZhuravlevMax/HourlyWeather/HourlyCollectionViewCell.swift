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
    static let key = "HourlyCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    public func configure(with model: HourlyWeatherData) {
    
        if let hourlyIconId = model.weather?.first?.icon,
           let imageUrl = URL(string: "\(Constants.imageURL)\(hourlyIconId)@2x.png"),
           let data = try? Data(contentsOf: imageUrl),
           let hourlyTime = model.dt,
           let decodedTime = model.dt?.decoderDt(format: "HH:mm"),
           let hourlyTemp = model.temp {
            
            
            self.hourlyImageView.image = UIImage(data: data)
            self.hourlyLabel.text = "+\(Int(hourlyTemp))"
            self.timeLabel.text = decodedTime
        }

    }
    
}

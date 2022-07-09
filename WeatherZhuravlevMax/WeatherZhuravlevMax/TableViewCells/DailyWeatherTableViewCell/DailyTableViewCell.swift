//
//  DailyTableViewCell.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 26.06.22.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dailyStackView: UIStackView!
    @IBOutlet weak var dailyLabelDay: UILabel!
    @IBOutlet weak var dailyImageView: UIImageView!
    @IBOutlet weak var dailyLabelMaxTemp: UILabel!
    @IBOutlet weak var dailyLabelMinTemp: UILabel!
    
    static let key = "DailyTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(with model: DailyWeatherData) {
        
        if let dailyIconId = model.weather?.first?.icon,
           let imageUrl = URL(string: "\(Constants.imageURL)\(dailyIconId)@4x.png"),
           let MaxTemp = model.temp?.max,
           let MinTemp = model.temp?.min
        {
            
            dailyLabelDay.text = model.dt?.decoderDt(format: "EEEE")
            
            dailyImageView.load(url: imageUrl)
            dailyLabelMinTemp.text = String("+\(Int(MinTemp))°")
            dailyLabelMaxTemp.text = String("...+\(Int(MaxTemp))°")
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

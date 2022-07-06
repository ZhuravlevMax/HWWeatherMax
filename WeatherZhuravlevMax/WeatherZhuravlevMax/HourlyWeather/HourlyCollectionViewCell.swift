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

}

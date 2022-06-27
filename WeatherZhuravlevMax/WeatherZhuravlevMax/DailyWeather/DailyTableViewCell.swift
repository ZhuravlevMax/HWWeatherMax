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
    @IBOutlet weak var dailyLabelTemp: UILabel!
    
    static let key = "DailyTableViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  ForCollectionViewTableViewCell.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 6.07.22.
//

import UIKit

class ForCollectionViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var inTableCellCollectionView: UICollectionView!
    
    var hourlyWeatherData: [HourlyWeatherData]?
    
    static let key = "ForCollectionViewTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        inTableCellCollectionView.delegate = self
        inTableCellCollectionView.dataSource = self
        inTableCellCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HourlyCollectionViewCell.key)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

extension ForCollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        hourlyWeatherData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionCell = inTableCellCollectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.key, for: indexPath) as? HourlyCollectionViewCell {
            
            if let hourlyWeatherArray = hourlyWeatherData,
               let hourlyTemp = hourlyWeatherArray[indexPath.row].temp,
               let hourlyIconId = hourlyWeatherArray[indexPath.row].weather?.first?.icon,
               let hourlyTime = hourlyWeatherArray[indexPath.row].dt,
               let imageUrl = URL(string: "\(Constants.imageURL)\(hourlyIconId)@2x.png"),
               let data = try? Data(contentsOf: imageUrl) {
                
                let decodedTime = hourlyTime.decoderDt(format: "HH mm ss")
                collectionCell.timeLabel.text = "\(decodedTime)"
                collectionCell.hourlyLabel.text = "+\(Int(hourlyTemp))"
                collectionCell.hourlyImageView.image = UIImage(data: data)
                
            }
            return collectionCell
        }
        return UICollectionViewCell()
    }
    
    
}

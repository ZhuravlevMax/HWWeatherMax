//
//  ForCollectionViewTableViewCell.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 6.07.22.
//

import UIKit

class ForCollectionViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var inTableCellCollectionView: UICollectionView!
    
    var models = [HourlyWeatherData]()
    
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
        inTableCellCollectionView.reloadData()
    }
    
    func configure( with models: [HourlyWeatherData]) {
        self.models = models
    }
    
}

extension ForCollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let collectionCell = inTableCellCollectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.key, for: indexPath) as? HourlyCollectionViewCell {

            collectionCell.configure( with: models[indexPath.row])
            return collectionCell
        }
        return UICollectionViewCell()
    }
    
    
}

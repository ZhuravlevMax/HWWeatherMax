//
//  ForTableVIewTableViewCell.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 8.07.22.
//

import UIKit

class ForTableVIewTableViewCell: UITableViewCell {

    @IBOutlet weak var inTableCellTableView: UITableView!
    
    var models: [DailyWeatherData] = []
    
    static let key = "ForTableVIewTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        inTableCellTableView.delegate = self
        inTableCellTableView.dataSource = self
        inTableCellTableView.register(UINib(nibName: "DailyTableViewCell" , bundle: nil), forCellReuseIdentifier: DailyTableViewCell.key)
        
        inTableCellTableView.tintColor = .blue
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //inTableCellTableView.reloadData() //Работает
        // Configure the view for the selected state
    }
    
    func configure( with models: [DailyWeatherData]) {
        self.models = models
        //self.inTableCellTableView.reloadData() Не работает
    }
    
}

extension ForTableVIewTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = inTableCellTableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.key, for: indexPath) as? DailyTableViewCell {
            tableCell.configure(with: models[indexPath.row])
            return tableCell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }


}

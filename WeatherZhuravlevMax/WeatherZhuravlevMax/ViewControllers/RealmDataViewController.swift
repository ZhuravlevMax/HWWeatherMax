//
//  RealmDataViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 29.06.22.
//

import UIKit
import RealmSwift

class RealmDataViewController: UIViewController {
    
    @IBOutlet weak var realmDataTableView: UITableView!
    
    
    var sortedRealmWeatherData: [RealmWeatherData] = []
    private var dBManager: DBManagerProtocol!

    @IBOutlet weak var realmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        dBManager = DBManager()
        //Массив для того чтобы вверху были последние запросы
        sortedRealmWeatherData = dBManager.obtainWeather().sorted {$0.time > $1.time}
        //sortedRealmWeatherData = realm.objects(RealmWeatherData.self).sorted {$0.time > $1.time}
        
        realmDataTableView.delegate = self
        realmDataTableView.dataSource = self
        
        realmDataTableView.register(UINib(nibName: "RealmDataTableViewCell", bundle: nil), forCellReuseIdentifier: RealmDataTableViewCell.key)
        realmDataTableView.reloadData()
    }


}

extension RealmDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedRealmWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let realmDataTableViewCell = realmDataTableView.dequeueReusableCell(withIdentifier: RealmDataTableViewCell.key) as? RealmDataTableViewCell {
            
            let decodedTime = sortedRealmWeatherData[indexPath.row].time.decoderDt(int: sortedRealmWeatherData[indexPath.row].time, format: "HH:mm:ss dd MMM YYYY")
            
            realmDataTableViewCell.tempLabel.text = "\(Int(sortedRealmWeatherData[indexPath.row].temp))"
            realmDataTableViewCell.feelsLikeLable.text = "\(Int(sortedRealmWeatherData[indexPath.row].feelsLike))"
            realmDataTableViewCell.descriptionLabel.text = "\(sortedRealmWeatherData[indexPath.row].descriptionWeather)"
            
            realmDataTableViewCell.timeLabel.text = decodedTime
            
            if let latCoord = sortedRealmWeatherData[indexPath.row].coordinate?.lat,
               let lonCoord = sortedRealmWeatherData[indexPath.row].coordinate?.lon {
            realmDataTableViewCell.latLabel.text = "\(latCoord)"
            realmDataTableViewCell.lonLabel.text = "\(lonCoord)"
            }
            return realmDataTableViewCell
        }
        return RealmDataTableViewCell()
    }
    
    
}

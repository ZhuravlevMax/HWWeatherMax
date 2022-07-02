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
    
    //Переменная для работы с observe realm
    var notificationToken: NotificationToken?
    
    var sortedRealmWeatherData: [RealmWeatherData] = []
    private var dBManager: DBManagerProtocol!

    @IBOutlet weak var realmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dBManager = DBManager()
        
       //MARK: - Наблюдатель за изменением БД и обновление таблицы
        let realm = try! Realm()
        
        let results = realm.objects(RealmWeatherData.self)
        
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.realmDataTableView else {return}
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
 
                tableView.performBatchUpdates({
 
                    tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                         with: .automatic)
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                    tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                         with: .automatic)
                }, completion: { finished in
                    tableView.reloadData()
                })
            case.error(let error):

                fatalError("\(error)")
            }
        }
        
        //MARK: - Регистрация ячеек
        
        realmDataTableView.delegate = self
        realmDataTableView.dataSource = self
        
        realmDataTableView.register(UINib(nibName: "RealmDataTableViewCell", bundle: nil), forCellReuseIdentifier: RealmDataTableViewCell.key)
        realmDataTableView.reloadData()
    }
}

extension RealmDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dBManager.obtainWeather().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let realmDataTableViewCell = realmDataTableView.dequeueReusableCell(withIdentifier: RealmDataTableViewCell.key) as? RealmDataTableViewCell {
            
            sortedRealmWeatherData = dBManager.obtainWeather().sorted {$0.time > $1.time}
            
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

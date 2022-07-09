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
    
    //var sortedRealmWeatherData: [RealmWeatherData] = []
    var sortedRealmWeatherData: Results<RealmWeatherData>!
    private var dBManager: DBManagerProtocol!

    @IBOutlet weak var realmLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dBManager = DBManager()
        
       //MARK: - Наблюдатель за изменением БД и обновление таблицы
        let realm = try! Realm()
        
        sortedRealmWeatherData = realm.objects(RealmWeatherData.self).sorted(byKeyPath: "time", ascending: false)
        
        notificationToken = sortedRealmWeatherData.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.realmDataTableView else {return}
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
 
                tableView.performBatchUpdates({
                    tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
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
    
    deinit {
        notificationToken?.invalidate()
    }
}

extension RealmDataViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        sortedRealmWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let realmDataTableViewCell = realmDataTableView.dequeueReusableCell(withIdentifier: RealmDataTableViewCell.key) as? RealmDataTableViewCell {

            let decodedTime = sortedRealmWeatherData[indexPath.row].time.decoderDt(format: "HH:mm:ss dd MMM YYYY")
            
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

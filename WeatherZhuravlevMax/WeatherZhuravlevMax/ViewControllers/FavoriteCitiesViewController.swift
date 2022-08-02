//
//  FavoriteCitiesViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 27.07.22.
//

import UIKit
import SnapKit

class FavoriteCitiesViewController: UIViewController {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var favoriteTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutSubviews()
    
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
    
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
        
    
        
    }
    
}

extension FavoriteCitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = favoriteTableView.dequeueReusableCell(withIdentifier: FavoriteTableViewCell.key) as? FavoriteTableViewCell {
            return cell
        }
        return UITableViewCell()
    }
    
    
}

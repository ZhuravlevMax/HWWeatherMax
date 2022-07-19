//
//  TabbarViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 19.07.22.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = UIColor.white
        guard let currentWeatherVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherStoryboard") as? WeatherViewController else {return}
        guard let MapVC = UIStoryboard(name: "MapStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MapStoryboard") as? MapViewController else {return}
        guard let SettingsVC = UIStoryboard(name: "SettingsStoryboard", bundle: nil).instantiateViewController(withIdentifier: "SettingsStoryboard") as? SettingsViewController else {return}

        viewControllers = [currentWeatherVC, MapVC, SettingsVC]
        currentWeatherVC.tabBarItem.title = NSLocalizedString("SceneDelegate.tabBarController.currentWeatherVC.tabBarItem.title", comment: "")
        currentWeatherVC.tabBarItem.image = UIImage(systemName: "cloud.sun")
        MapVC.tabBarItem.title = NSLocalizedString("SceneDelegate.tabBarController.MapVC.tabBarItem.title", comment: "")
        MapVC.tabBarItem.image = UIImage(systemName: "map")
        
        SettingsVC.tabBarItem.title = NSLocalizedString("SceneDelegate.tabBarController.SettingsVC.tabBarItem.title", comment: "")
        SettingsVC.tabBarItem.image = UIImage(systemName: "gearshape")
 
    }
    

}

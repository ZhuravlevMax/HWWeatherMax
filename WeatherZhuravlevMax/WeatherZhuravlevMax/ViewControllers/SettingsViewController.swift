//
//  SettingsViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 15.07.22.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var unitsButton: UIButton!
    @IBOutlet weak var timeFormatButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationButton.layer.cornerRadius = 10
        historyButton.layer.cornerRadius = 10
        unitsButton.layer.cornerRadius = 10
        timeFormatButton.layer.cornerRadius = 10

    }
    @IBAction func notificationButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "NotificationStoryboard", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "NotificationStoryboard") as? NotificationViewController {
            present(viewController, animated: true)
        }
            
    }
    
    @IBAction func historyButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "RealmDataStoryboard", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "RealmDataStoryboard") as? RealmDataViewController {
            present(viewController, animated: true)
        }
    }
    @IBAction func unitsButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UnitsStoryboard", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "UnitsStoryboard") as? UnitsViewController {
            present(viewController, animated: true)
            
        }
        
    }
    @IBAction func timeFormatButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "TimeFormatStoryboard", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "TimeFormatStoryboard") as? TimeFormatViewController {
            present(viewController, animated: true)
            
        }
    }


    
}

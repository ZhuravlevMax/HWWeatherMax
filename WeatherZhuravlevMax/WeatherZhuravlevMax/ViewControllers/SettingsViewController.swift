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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func notificationButtonPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "NotificationStoryboard", bundle: nil)
        
        if let viewController = storyboard.instantiateViewController(withIdentifier: "NotificationStoryboard") as? NotificationViewController {
            present(viewController, animated: true)
        }
            
    }
    

}

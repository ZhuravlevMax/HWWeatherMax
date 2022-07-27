//
//  TimeFormatViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 16.07.22.
//

import UIKit

class TimeFormatViewController:
    UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeSegmentControl: UISegmentedControl!
    
    var twentyFormat = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.setTitle(NSLocalizedString("NotificationViewController.cancelButton.title", comment: ""), for: .normal)
        saveButton.setTitle(NSLocalizedString("NotificationViewController.saveButton.title", comment: ""), for: .normal)
        timeLabel.text = NSLocalizedString("TimeFormatViewController.timeLabel.text", comment: "")
        timeSegmentControl.setTitle(NSLocalizedString("TimeFormatViewController.timeSegmentControl.title0", comment: ""), forSegmentAt: 0)
        timeSegmentControl.setTitle(NSLocalizedString("TimeFormatViewController.timeSegmentControl.title1", comment: ""), forSegmentAt: 1)

        timeSegmentControl.backgroundColor = UIColor(red: 158/255, green: 210/255, blue: 241/255, alpha: 1)
        twentyFormat =  UserDefaults.standard.bool(forKey: UserDefaultsKeys.twentyFormatOn.rawValue)
        
        twentyFormat ? (timeSegmentControl.selectedSegmentIndex = 0) : (timeSegmentControl.selectedSegmentIndex = 1)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        (timeSegmentControl.selectedSegmentIndex == 0) ? (twentyFormat = true) : (twentyFormat = false)
        UserDefaults.standard.set(twentyFormat, forKey: UserDefaultsKeys.twentyFormatOn.rawValue)
        dismiss(animated: true)
    }
    

}

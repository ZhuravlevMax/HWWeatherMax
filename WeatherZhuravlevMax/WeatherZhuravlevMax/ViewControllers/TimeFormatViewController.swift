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
    
    @IBOutlet weak var timeSegmentControl: UISegmentedControl!
    
    var twentyFormat = true
    override func viewDidLoad() {
        super.viewDidLoad()

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

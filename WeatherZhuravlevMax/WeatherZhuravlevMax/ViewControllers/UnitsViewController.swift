//
//  UnitsViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 16.07.22.
//

import UIKit

enum UserDefaultsKeys: String {
    case metricUnitOn
    case twentyFormatOn
}

class UnitsViewController: UIViewController {
    
    @IBOutlet weak var unitsSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var choiceLabel: UILabel!
    
    var metricUnitOn = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.setTitle(NSLocalizedString("NotificationViewController.cancelButton.title", comment: ""), for: .normal)
        saveButton.setTitle(NSLocalizedString("NotificationViewController.saveButton.title", comment: ""), for: .normal)
        choiceLabel.text = NSLocalizedString("UnitsViewController.choiceLabel.text", comment: "")
        unitsSegmentControl.setTitle(NSLocalizedString("UnitsViewController.unitsSegmentControl.title0", comment: ""), forSegmentAt: 0)
        unitsSegmentControl.setTitle(NSLocalizedString("UnitsViewController.unitsSegmentControl.title1", comment: ""), forSegmentAt: 1)
        
        unitsSegmentControl.backgroundColor = UIColor(red: 158/255, green: 210/255, blue: 241/255, alpha: 1)
        metricUnitOn = UserDefaults.standard.bool(forKey: UserDefaultsKeys.metricUnitOn.rawValue)
        
        metricUnitOn ? (unitsSegmentControl.selectedSegmentIndex = 0) : (unitsSegmentControl.selectedSegmentIndex = 1)
        
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        (unitsSegmentControl.selectedSegmentIndex == 0) ? (metricUnitOn = true) : (metricUnitOn = false)
        UserDefaults.standard.set(metricUnitOn, forKey: UserDefaultsKeys.metricUnitOn.rawValue)
        dismiss(animated: true)
    }
    
}

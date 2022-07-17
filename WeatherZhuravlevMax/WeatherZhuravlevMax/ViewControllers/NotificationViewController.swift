//
//  NotificationViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 15.07.22.
//

import UIKit
import RealmSwift

class NotificationViewController: UIViewController {
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var snowLabel: UILabel!
    @IBOutlet weak var thunderstormLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var choiceLabel: UILabel!
    
    @IBOutlet weak var rainCheckButton: UIButton!
    @IBOutlet weak var snowCheckButton: UIButton!
    @IBOutlet weak var thunderstormCheckButton: UIButton!
    
    var isRaining: Bool = false
    var isSnowing: Bool = false
    var isThunderstorming: Bool = false
    
    private var dBManager: DBManagerProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cancelButton.setTitle(NSLocalizedString("NotificationViewController.cancelButton.title", comment: ""), for: .normal)
        saveButton.setTitle(NSLocalizedString("NotificationViewController.saveButton.title", comment: ""), for: .normal)
        
        choiceLabel.text = NSLocalizedString("NotificationViewController.choiceLabel.text", comment: "")
        rainLabel.text = NSLocalizedString("NotificationViewController.rainLabel.text", comment: "")
        snowLabel.text = NSLocalizedString("NotificationViewController.snowLabel.text", comment: "")
        thunderstormLabel.text = NSLocalizedString("NotificationViewController.thunderstormLabel.text", comment: "")
        
        dBManager = DBManager()
        if let rainChecked = dBManager.obtainBadWeather().last?.rainState {
        isRaining = rainChecked
        }
        if let snowChecked = dBManager.obtainBadWeather().last?.snowState {
        isSnowing = snowChecked
        }
        if let thunderstormchecked = dBManager.obtainBadWeather().last?.thunderstormState {
        isThunderstorming = thunderstormchecked
        }
        rainCheckButton.setImage(UIImage(systemName: isRaining ? "checkmark.square" : "square"), for: .normal)
        snowCheckButton.setImage(UIImage(systemName: isSnowing ? "checkmark.square" : "square"), for: .normal)
        thunderstormCheckButton.setImage(UIImage(systemName: isThunderstorming ? "checkmark.square" : "square"), for: .normal)
   
        
        
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func rainCheckButtonPressed(_ sender: Any) {
        isRaining ? (isRaining = false) : (isRaining = true)
        rainCheckButton.setImage(UIImage(systemName: isRaining ? "checkmark.square" : "square"), for: .normal)
        
    }
    @IBAction func snowCheckButtonPressed(_ sender: Any) {
        isSnowing ? (isSnowing = false) : (isSnowing = true)
        snowCheckButton.setImage(UIImage(systemName: isSnowing ? "checkmark.square" : "square"), for: .normal)
    }
    
    @IBAction func thunderstormCheckButtonPressed(_ sender: Any) {
        isThunderstorming ? (isThunderstorming = false) : (isThunderstorming = true)
        thunderstormCheckButton.setImage(UIImage(systemName: isThunderstorming ? "checkmark.square" : "square"), for: .normal)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let realmBadWeatherStates = RealmBadWeatherStates()
        realmBadWeatherStates.rainState = isRaining
        realmBadWeatherStates.snowState = isSnowing
        realmBadWeatherStates.thunderstormState = isThunderstorming
        
        dBManager.saveWeatherStates(states: realmBadWeatherStates)
        dismiss(animated: true)
    }
    
}

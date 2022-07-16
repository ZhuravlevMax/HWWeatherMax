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
    
    var rain: Bool = false
    var snow: Bool = false
    var thunderstorm: Bool = false
    
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
        rain = rainChecked
        }
        if let snowChecked = dBManager.obtainBadWeather().last?.snowState {
        snow = snowChecked
        }
        if let thunderstormchecked = dBManager.obtainBadWeather().last?.thunderstormState {
        thunderstorm = thunderstormchecked
        }
        rain ? (rainCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)) : (rainCheckButton.setImage(UIImage(systemName: "square"), for: .normal))
        snow ? (snowCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)) : (snowCheckButton.setImage(UIImage(systemName: "square"), for: .normal))
        thunderstorm ? (thunderstormCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)) : (thunderstormCheckButton.setImage(UIImage(systemName: "square"), for: .normal))
        
        
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func rainCheckButtonPressed(_ sender: Any) {
        rain ? (rain = false) : (rain = true)
        rain ? (rainCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)) : (rainCheckButton.setImage(UIImage(systemName: "square"), for: .normal))
    }
    @IBAction func snowCheckButtonPressed(_ sender: Any) {
        snow ? (snow = false) : (snow = true)
        snow ? (snowCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)) : (snowCheckButton.setImage(UIImage(systemName: "square"), for: .normal))
    }
    
    @IBAction func thunderstormCheckButtonPressed(_ sender: Any) {
        thunderstorm ? (thunderstorm = false) : (thunderstorm = true)
        thunderstorm ? (thunderstormCheckButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)) : (thunderstormCheckButton.setImage(UIImage(systemName: "square"), for: .normal))
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let realmBadWeatherStates = RealmBadWeatherStates()
        realmBadWeatherStates.rainState = rain
        realmBadWeatherStates.snowState = snow
        realmBadWeatherStates.thunderstormState = thunderstorm
        
        dBManager.saveWeatherStates(states: realmBadWeatherStates)
        dismiss(animated: true)
    }
    
}

//
//  NotificationViewController.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 15.07.22.
//

import UIKit
import RealmSwift
import UniformTypeIdentifiers

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
    var resultStateData: Results<RealmBadWeatherStates>!
    var badWeather: BadWeather!
    
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
        resultStateData = dBManager.stateData()
        guard let badWeatherBit = resultStateData.last?.badWeatherBitCode else {return}
        
        badWeather = BadWeather(rawValue: badWeatherBit)
 
 
        isRaining = badWeather.contains(.rain)
        isSnowing = badWeather.contains(.snow)
        isThunderstorming = badWeather.contains(.thunderstorm)

        rainCheckButton.setImage(UIImage(systemName: isRaining ? "checkmark.square" : "square"), for: .normal)
        snowCheckButton.setImage(UIImage(systemName: isSnowing ? "checkmark.square" : "square"), for: .normal)
        thunderstormCheckButton.setImage(UIImage(systemName: isThunderstorming ? "checkmark.square" : "square"), for: .normal)
        
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
    @IBAction func rainCheckButtonPressed(_ sender: Any) {
        if isRaining {
            badWeather.remove(.rain)
            isRaining = false
        } else {
            badWeather.insert(.rain)
            isRaining = true
        }
        rainCheckButton.setImage(UIImage(systemName: isRaining ? "checkmark.square" : "square"), for: .normal)
        
    }
    @IBAction func snowCheckButtonPressed(_ sender: Any) {
        if isSnowing {
            badWeather.remove(.snow)
            isSnowing = false
        } else {
            badWeather.insert(.snow)
            isSnowing = true
        }
        snowCheckButton.setImage(UIImage(systemName: isSnowing ? "checkmark.square" : "square"), for: .normal)
    }
    
    @IBAction func thunderstormCheckButtonPressed(_ sender: Any) {
        if isThunderstorming {
            badWeather.remove(.thunderstorm)
            isThunderstorming = false
        } else {
            badWeather.insert(.thunderstorm)
            isThunderstorming = true
        }
        thunderstormCheckButton.setImage(UIImage(systemName: isThunderstorming ? "checkmark.square" : "square"), for: .normal)
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        let realmBadWeatherStates = RealmBadWeatherStates()
        realmBadWeatherStates.badWeatherBitCode = badWeather.rawValue
        print(badWeather.rawValue)
        
        dBManager.saveWeatherStates(states: realmBadWeatherStates)
        dismiss(animated: true)
    }
    
}

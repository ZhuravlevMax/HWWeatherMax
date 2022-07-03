//
//  AppDelegate.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 18.06.22.
//

import UIKit
import GoogleMaps
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapKey") as? String {
            GMSServices.provideAPIKey("\(key)")
        }

            let options: UNAuthorizationOptions = [.alert, .badge, .sound]
            self.center.requestAuthorization(options: options) { (granted, error) in
                if granted {
                   print("granted")
                }
            }
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}


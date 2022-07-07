//
//  SceneDelegate.swift
//  WeatherZhuravlevMax
//
//  Created by Максим Журавлев on 18.06.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        //MARK: - Создаю tabBar 
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window?.windowScene = windowScene
        guard let currentWeatherVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherStoryboard") as? WeatherViewController else {return}
        guard let MapVC = UIStoryboard(name: "MapStoryboard", bundle: nil).instantiateViewController(withIdentifier: "MapStoryboard") as? MapViewController else {return}
        guard let RealmDataVC = UIStoryboard(name: "RealmDataStoryboard", bundle: nil).instantiateViewController(withIdentifier: "RealmDataStoryboard") as? RealmDataViewController else {return}
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([currentWeatherVC, MapVC, RealmDataVC], animated: true)
        currentWeatherVC.tabBarItem.title = "Weather"
        currentWeatherVC.tabBarItem.image = UIImage(systemName: "cloud.sun")
        MapVC.tabBarItem.title = "Map"
        MapVC.tabBarItem.image = UIImage(systemName: "map")
        RealmDataVC.tabBarItem.title = "WeatherRequestInfo"
        RealmDataVC.tabBarItem.image = UIImage(systemName: "tablecells")
        
        tabBarController.tabBar.backgroundColor = UIColor.white
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}


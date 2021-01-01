//
//  SceneDelegate.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 21/12/2020.
//

import UIKit
import AWeather

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = DailyForecastFactory.dailyForecastViewController()
        window?.makeKeyAndVisible()
    }
}


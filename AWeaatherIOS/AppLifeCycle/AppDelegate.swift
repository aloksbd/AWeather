//
//  AppDelegate.swift
//  AWeaatherIOS
//
//  Created by Alok Subedi on 21/12/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}


func runOnMainThread(_ task: @escaping () -> ()){
    if Thread.isMainThread{
        task()
    }else{
        DispatchQueue.main.async{task()}
    }
}


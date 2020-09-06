//
//  AppDelegate.swift
//  MishiPayCodeTest
//
//  Created by Shyam Bhudia on 06/09/2020.
//  Copyright © 2020 Shyam Bhudia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let databaseInitialInsert = DatabaseManager()
        
        /// Check if anything is already in the realm instant
        if (databaseInitialInsert.fetchObjects(for: Product.self)?.count ?? 0) != 0 {
            /// Delete last basket session
            databaseInitialInsert.deleteObjects(for: Basket.self)
            return true
        }
        
        let first = Product(name: "Febreze Air Cotton Fresh", price: 2.99, barcode: "5413149462656")
        let second = Product(name: "Air Wick Lavender & Camomile", price: 1.99, barcode: "3059943016507")
        let third = Product(name: "Glade Citrus", price: 2.39, barcode: "5000204144703")
        let fourth = Product(name: "Oust Garden Fresh", price: 1.23, barcode: "5000204883381")
        databaseInitialInsert.addObjects(with: [first, second, third, fourth])
        
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


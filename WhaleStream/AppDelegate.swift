//
//  AppDelegate.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/2/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit
import Firebase
@UIApplicationMain
 class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        InstanceID.instanceID().instanceID { (result, error) in
          if let error = error {
            print("Error fetching remote instance ID: \(error)")
          } else if let result = result {
            print("Remote instance ID token: \(result.token)")
//            self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
          }
        }

        RemoteConfigManager.configure(expirationDuration: 0)
        if #available(iOS 13.0, *) {} else {
            window = UIWindow()
            window?.makeKeyAndVisible()
            let navController = UINavigationController(rootViewController: AddClassCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout()))

            navController.modalPresentationStyle = .fullScreen
            window?.rootViewController = navController
        }
        return true

    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


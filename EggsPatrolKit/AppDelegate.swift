//
//  AppDelegate.swift
//  EggsPatrolKit
//
//  Created by Роман Главацкий on 03.11.2025.
//

import UIKit
import AppsFlyerLib
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var restrictRotation: UIInterfaceOrientationMask = .all


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // AppsFlyer Init
        AppsFlyerLib.shared().appsFlyerDevKey = "4uZ5JcaNsdAdEBzpKz7p9b"
        AppsFlyerLib.shared().appleAppID = "6751494044"
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().isDebug = true
        AppsFlyerLib.shared().disableAdvertisingIdentifier = true
        
        AppsFlyerLib.shared().start()
        

        OneSignalService.shared.requestPermissionAndInitialize()
        return true
    }

    lazy var persistentContainer: NSPersistentContainer = {
        let conteiner = NSPersistentContainer(name: "Model")
        conteiner.loadPersistentStores { (description,
                                          error) in
            if let error {
                print(error.localizedDescription)
            }
        }
        return conteiner
    }()
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolver error \(error), \(nsError.userInfo)")
            }
        }
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


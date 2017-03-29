//
//  AppDelegate.swift
//  TMinus
//
//  Created by Dalton Claybrook on 3/11/17.
//  Copyright © 2017 Claybrook Software. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let registrar = BackgroundNotificationRegistrar()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        registrar.register { [weak self] (result) in
            if result == .newData {
                self?.updateRegistrationCount()
            }
            completionHandler(result)
        }
        registrar.register(with: completionHandler)
    }
    
    //MARK: Private
    
    private func updateRegistrationCount() {
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKey.backgroundFetchCount)
        UserDefaults.standard.set(count + 1, forKey: UserDefaultsKey.backgroundFetchCount)
        UserDefaults.standard.synchronize()
    }
}

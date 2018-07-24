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
        application.setMinimumBackgroundFetchInterval(.oneHour)
        configureAppearance()
        return true
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        registrar.register { [weak self] (result) in
            if result == .newData {
                self?.updateRegistrationCount()
            }
            completionHandler(result)
        }
    }
    
    // MARK: Private
    
    private func updateRegistrationCount() {
        let count = UserDefaults.standard.integer(forKey: UserDefaultsKey.backgroundFetchCount)
        UserDefaults.standard.set(count + 1, forKey: UserDefaultsKey.backgroundFetchCount)
        UserDefaults.standard.synchronize()
    }

    private func configureAppearance() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.barTintColor = .twilightBlue
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = false
        let attributes: [NSAttributedStringKey: Any] = [
            .foregroundColor: UIColor.white
        ]
        navigationBar.titleTextAttributes = attributes
        navigationBar.largeTitleTextAttributes = attributes

        let tabBar = UITabBar.appearance()
        tabBar.barTintColor = .twilightBlue
        tabBar.tintColor = .white
        tabBar.isTranslucent = false
    }
}

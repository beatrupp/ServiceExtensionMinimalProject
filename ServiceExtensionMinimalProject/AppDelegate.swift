//
//  AppDelegate.swift
//  ServiceExtensionMinimalProject
//
//  Created by Beat Rupp on 26.09.17.
//  Copyright © 2017 Beat Rupp. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    var center: UNUserNotificationCenter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        center = UNUserNotificationCenter.current()
        center?.delegate = self
        
        center?.requestAuthorization(options: UNAuthorizationOptions(rawValue: UNAuthorizationOptions.sound.rawValue | UNAuthorizationOptions.alert.rawValue | UNAuthorizationOptions.badge.rawValue), completionHandler: { (granted, error) in
            DispatchQueue.main.sync {
                UIApplication.shared.registerForRemoteNotifications()
            }
        })
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let str = deviceToken.map { String(format: "%02hhx", $0) }.joined()
        
        print("Device Token: \(str)")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }

}


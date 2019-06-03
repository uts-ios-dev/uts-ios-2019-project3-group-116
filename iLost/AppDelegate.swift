//
//  AppDelegate.swift
//  iLost
//
//  Created by ak on 17.05.19.
//  Copyright © 2019 ak. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        customizeNavigationBar()
        customizeTabBar()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Set navigation bar layout
    func customizeNavigationBar() {
        let navigationBarAppearance = UINavigationBar.appearance()
        
        navigationBarAppearance.tintColor = UIColor(red: 39/255, green: 159/255, blue: 238/255, alpha: 1)
        navigationBarAppearance.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Verdana", size: 20)!,NSAttributedString.Key.foregroundColor : UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)]
        
        navigationBarAppearance.barTintColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
    }
    
    // Set tab bar layout
    func customizeTabBar() {
        let tabBarAppearance = UITabBar.appearance()
        let tabBarItemAppreance = UITabBarItem.appearance()
        
        tabBarAppearance.barTintColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        tabBarAppearance.tintColor = UIColor(red: 39/255, green: 159/255, blue: 238/255, alpha: 1)
        tabBarAppearance.unselectedItemTintColor = UIColor(red: 73/255, green: 73/255, blue: 73/255, alpha: 1)
        
        tabBarItemAppreance.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Verdana", size: 12)!], for: .normal)
    }
}


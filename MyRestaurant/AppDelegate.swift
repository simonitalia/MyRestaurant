//
//  AppDelegate.swift
//  MyRestaurant
//
//  Created by Simon Italia on 6/6/19.
//  Copyright © 2019 Magical Tomato. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    //MARK: - Custom properties / methods to respond to app wide changes
    
    //Trigger My Order Tab bar item updates
    static var myOrderTabBarItem: UITabBarItem!
    
    @objc func updateMyOrderBadge() {
        AppDelegate.myOrderTabBarItem.badgeValue = String(MenuController.order.menuItems.count)
    }
    
    var window: UIWindow?
    
    //Added method to load saved Order object if it exist
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        Order.load()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Set temp Url cdirectory and cache size
        let tempCacheDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 25_000_000, diskCapacity: 50_000_000, diskPath: tempCacheDirectory)
        URLCache.shared = urlCache
        
        //Respond to order object changes by triggering an update to the My Order Tab Bar value
        NotificationCenter.default.addObserver(self, selector: #selector(updateMyOrderBadge), name: MenuController.orderUpdateNotification, object: nil)
        
        //Inform App Delegate of what object is myOrderTabBarItem
        AppDelegate.myOrderTabBarItem = (self.window!.rootViewController! as! UITabBarController).viewControllers![1].tabBarItem
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //Save order object to disk
        Order.save()
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


}


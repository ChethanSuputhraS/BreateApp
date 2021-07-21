//
//  AppDelegate.swift
//  BreathingApp
//
//  Created by Ashwin on 1/30/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit
var isCircleAvail : Bool = false
var  alSz : CGFloat = 1
var windowglobal: UIWindow?

var isSmoothChart : Bool = false


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var globalDeviceToken : NSString = NSString()
    var  isNetworkReachable = false
  var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        UserDefaults.standard.set("NA", forKey: "AbdomenUUID")
        UserDefaults.standard.synchronize()

            // Override point for customization after application launch.
            //DATA base
                DataBaseController.shared.createDB()
                let strUrlPath =  DataBaseController.shared.getDocumentsDirectory()
                print("Local Db Path is : \(strUrlPath)")

    //let view1 : PairChestVC = PairChestVC()
//              let view1 : RecordVC = RecordVC()
            let view1 : HomeVC = HomeVC()
//            let view1 : LogInVC = LogInVC()
            let frame = UIScreen.main.bounds
            window = UIWindow(frame: frame)
            if let window = self.window
            {
                window.rootViewController = UINavigationController(rootViewController: view1)
            }
        
            windowglobal = window
           alSz = 1
                             if window?.frame.height == 667
                             {
                                 alSz = 1.17
                             }
                             else if window?.frame.height == 736
                             {
                                 alSz = 1.29
                             }
            window!.makeKeyAndVisible()



//            if UserDefaults.standard.bool(forKey: "IS_LOGGED_IN") == true
//            {
//                let view1 : HomeVC = HomeVC()
//                let frame = UIScreen.main.bounds
//                window = UIWindow(frame: frame)
//                if let window = self.window
//                {
//                    window.rootViewController = UINavigationController(rootViewController: view1)
//                }
//                window!.makeKeyAndVisible()
//            }
//            else
//            {
//                let view1 : LogInVC = LogInVC()
//                let frame = UIScreen.main.bounds
//                window = UIWindow(frame: frame)
//                if let window = self.window
//                {
//                    window.rootViewController = UINavigationController(rootViewController: view1)
//                }
//                window!.makeKeyAndVisible()
//
//            }
            
            return true
        }
    func checkForValidString(String : NSString) -> NSString
    {
        var strRequest : NSString = NSString()
        if String.isEqual(to: "") || String.isEqual(to: "NA")
        {
            strRequest = "NA"
        }
        else
        {
            strRequest = String.mutableCopy() as! NSString
        }
        return strRequest
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

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        globalDeviceToken = deviceToken.description as NSString
        globalDeviceToken = globalDeviceToken.replacingOccurrences(of: "<",  with: "") as NSString
        globalDeviceToken = globalDeviceToken.replacingOccurrences(of: ">",  with: "") as NSString
        globalDeviceToken = globalDeviceToken.replacingOccurrences(of: " ",  with: "") as NSString as NSString
        print("My device token  ============================>>>>>>>>>>>%@",globalDeviceToken)
    }
    

}



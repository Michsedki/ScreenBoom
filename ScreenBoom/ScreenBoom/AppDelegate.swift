//
//  AppDelegate.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
    
    // this variable allow rotation for the app when it is true and when it is false disable rotation
    var enableAllOrientation = true
    // Control rotation in viewControllers
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if (enableAllOrientation == true){
            return UIInterfaceOrientationMask.allButUpsideDown
        }
        return UIInterfaceOrientationMask.portrait
    }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    FirebaseApp.configure()


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
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    
    print("url \(url)")
    print("url host :\(url.host!)")
    print("url path :\(url.path)")
    
    let urlPath : String = url.path as String!
    let urlHost : String = url.host as String!
    var pathStringArray = urlPath.components(separatedBy: "/")
    pathStringArray.remove(at: 0)
    let urlPathRoot = pathStringArray[0]
    let eventName = pathStringArray[1]
    let eventCode = pathStringArray[2]
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    if(urlHost != "screenBoomEvent")
    {
      print("Host is not correct")
      return false
    }

    if(urlPathRoot == "joinDL"){
      
      if let joinEventViewController = mainStoryboard.instantiateViewController(withIdentifier: "JoinEventViewController") as? JoinEventViewController {
        let navigationController = UINavigationController(rootViewController: joinEventViewController)
          self.window?.rootViewController = navigationController
        joinEventViewController.getEventAndCmpareCode(eventName: eventName, eventCode: eventCode)
        
      } else {
        return false
      }
      
    } else {
      return false
    }
    
    
    
    
    return true
  }
  // dlt://swiftdeveloperblog.com/inner



}


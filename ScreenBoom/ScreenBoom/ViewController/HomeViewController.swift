//
//  HomeViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import CloudKit


class HomeViewController: BaseViewController {

  // Struct
  struct Constant {
    static let imageTopDistanceLandScape: CGFloat = 20
    static let imageTopDistancePortrait: CGFloat = 100
  }
  let userDefaultICloudViewModel = UserDefaultICloudViewModel()
  
  // Constrains
  
  @IBOutlet weak var topDistance: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    handleUserICloudSignIn()
    // Do any additional setup after loading the view, typically from a nib.
  }
    
   

  override func viewWillLayoutSubviews() {
    let isLandscape = UIDevice.current.orientation.isLandscape
    if isLandscape {
      topDistance.constant = Constant.imageTopDistanceLandScape
      return
    }
    
    topDistance.constant = Constant.imageTopDistancePortrait
  }
  
  
  func handleUserICloudSignIn() {
    
    userDefaultICloudViewModel.getICloudUserID { (userID, error) in
      guard error == nil , let userID = userID
        else {
        self.showAlertOfUserNotConnectedToICloud()
        return}
      self.handleOldUserAndOldEvent(userID: userID)
    }
    
  }
  
  func showAlertOfUserNotConnectedToICloud () {
    let alert = UIAlertController(title: "ICloud log in not found", message: "Would you log in your ICloud Account ", preferredStyle: UIAlertControllerStyle.alert)
            // add the actions (buttons)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in self.handleUserICloudSignIn()}))
            // show the alert
            self.present(alert, animated: true, completion: nil)
    
  }
  
  
  
  func handleOldUserAndOldEvent (userID: String) -> Bool {
   print("Michael")
    userDefaultICloudViewModel.getICloudUserID { (userID, error) in
      
      if error != nil {
        
        
      }
      }
    
    guard userDefaultICloudViewModel.checkIfTheSameUserIcloudID(userID: userID) else {return false}
    guard let eventName = userDefaultICloudViewModel.checkIfOldEventNameIsExist(), let eventCode = userDefaultICloudViewModel.checkIfOldEventCodeIsExist() else { return false}
    
    // create the alert
    let alert = UIAlertController(title: "Last Event", message: "Would you like to continue join \(eventName) Event", preferredStyle: UIAlertControllerStyle.alert)
    
    // add the actions (buttons)
    alert.addAction(UIAlertAction(title: "Join", style: UIAlertActionStyle.default, handler: nil))
    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
    
    // show the alert
    self.present(alert, animated: true, completion: nil)
    
    
    return false
    
  }
  
  
}


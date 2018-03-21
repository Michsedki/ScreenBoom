//
//  HomeViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import CloudKit
import FirebaseDatabase



class HomeViewController: BaseViewController {
  
  let userDefaultICloudViewModel = UserDefaultICloudViewModel()
  let eventViewModel = EventViewModel()
  var isDeepLinking = false
  
  // Struct
  struct Constant {
    static let imageTopDistanceLandScape: CGFloat = 20
    static let imageTopDistancePortrait: CGFloat = 100
  }
 
  
  
  // Constrains
  
  @IBOutlet weak var topDistance: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
//    firebaseDatabaseReference = Database.database().reference()
    if !isDeepLinking {
      rigisterUser()
    }
  }
  
  override func viewWillLayoutSubviews() {
    let isLandscape = UIDevice.current.orientation.isLandscape
    if isLandscape {
      topDistance.constant = Constant.imageTopDistanceLandScape
      return
    }
    topDistance.constant = Constant.imageTopDistancePortrait
  }
  
  
  func rigisterUser() {
    userDefaultICloudViewModel.getICloudUserID { (userID, error) in
      if error == nil , let userID = userID {
        _ = self.userDefaultICloudViewModel.checkIfTheSameUserIcloudID(userID: userID)
        if let oldEventName = self.userDefaultICloudViewModel.checkIfOldEventNameIsExist() ,
          let oldEventCode = self.userDefaultICloudViewModel.checkIfOldEventCodeIsExist() {
          let oldEvent = Event(eventName: oldEventName, eventIsLive: "no", eventType: .Unknown, eventCode: oldEventCode)
          self.eventViewModel.checkIfEventExists(event: oldEvent, completion: { (isExist, eventSnapShot) in
            if isExist, let eventuserIDFirebase = eventSnapShot?.childSnapshot(forPath: self.firebaseNodeNames.eventUserIDChild).value as? String {
              if eventuserIDFirebase == userID {
                self.showJoinOldEventAlert(eventName: oldEventName, eventCode: oldEventCode)
              }
            }
          })
        }
      } else {
        // show alert
        self.showNotSignedInICloud()
      }
    }
    
  }
  
  // show alert that user not sign in ICloud
  func showNotSignedInICloud() {
    
    let alert = UIAlertController(title: "ICloud account not found", message: "Would you sign in your ICloud Account ", preferredStyle: UIAlertControllerStyle.alert)
    // add the actions (buttons)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in self.rigisterUser()}))
    // show the alert
    self.present(alert, animated: true, completion: nil)
    
  }
  
  // show alert that user not sign in ICloud
  func showJoinOldEventAlert(eventName: String, eventCode: String) {
    
    let alert = UIAlertController(title: "Previous Event", message: "Would you like to join your previous event \n Name: \(eventName) \n Code: \(eventCode)", preferredStyle: UIAlertControllerStyle.alert)
    // add the actions (buttons)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.joinOldEvent(eventName: eventName, eventCode: eventCode)}))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    // show the alert
    self.present(alert, animated: true, completion: nil)
    
  }
  
  func joinOldEvent(eventName: String, eventCode: String) {
    if let joinEventViewController = storyboard?.instantiateViewController(withIdentifier: "JoinEventViewController") as? JoinEventViewController {
      joinEventViewController.getEventAndCmpareCode(eventName: eventName, eventCode: eventCode)
      self.navigationController?.pushViewController(joinEventViewController, animated: true)
    }
    
  }
  
}


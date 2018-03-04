//
//  UserDefault+ICloudViewModel.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/1/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class UserDefaultICloudViewModel {
  let userDefault = UserDefaults.standard
  let userDefaultKeyNames = UserDefaultKeyNames()
  
  
//  func checkIfOldEventExistForCurrentUser (userID: String) -> Bool {
//    guard checkIfTheSameUserIcloudID(userID: userID) else {return false}
//    guard let eventName = checkIfOldEventNameIsExist(), let eventCode = checkIfOldEventCodeIsExist() else { return false}
//
//    // create the alert
//    let alert = UIAlertController(title: "Last Event", message: "Would you like to continue join \(eventName) Event", preferredStyle: UIAlertControllerStyle.alert)
//
//    // add the actions (buttons)
//    alert.addAction(UIAlertAction(title: "Join", style: UIAlertActionStyle.default, handler: nil))
//    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//
//    // show the alert
//    present(alert, animated: true, completion: nil)
//
//
//    return false
//
//  }
  
  
  // check if old event name is exist or not and return event name or nil
  func checkIfOldEventNameIsExist () -> String? {
    if let oldEventUserDefault = userDefault.object(forKey: userDefaultKeyNames.eventNameKey) as? String {
      return oldEventUserDefault
    }
    return nil
  }
  
  // check if old event code is exist or not and return event name or nil
  func checkIfOldEventCodeIsExist() -> String? {
    if let oldEventCodeUserDefault = userDefault.object(forKey: userDefaultKeyNames.eventCodeKey) as? String {
      return oldEventCodeUserDefault
    }
    return nil
    
  }
  
  func checkIfTheSameUserIcloudID(userID: String) -> Bool {
    if let userdefaultUserID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
      if userID == userdefaultUserID {
        return true
      } else {
        UserDefaults.standard.set(userID, forKey: userDefaultKeyNames.userIDKey)
        return false
      }
    }
    UserDefaults.standard.set(userID, forKey: userDefaultKeyNames.userIDKey)
    return false
  }
  
  
  
  
  
  ///  gets iCloud record ID object of logged-in iCloud user
  func getICloudUserID(complete: @escaping (String?, String?) -> ()) {
    let container = CKContainer.default()
    container.fetchUserRecordID() {
      recordID, error in
      if error != nil {
        print(error!.localizedDescription)
        complete(nil, error!.localizedDescription)
      } else {
        if let userID = recordID?.recordName {
          complete(userID, nil)
        } else  {
          complete(nil, "Couldn't find User ICloudID")
        }
      }
    }
  }
  
  
  
}

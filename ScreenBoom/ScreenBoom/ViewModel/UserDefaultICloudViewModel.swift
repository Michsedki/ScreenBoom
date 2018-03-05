//
//  UserDefault+ICloudViewModel.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/1/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import CloudKit

class UserDefaultICloudViewModel {
  let userDefault = UserDefaults.standard
  let userDefaultKeyNames = UserDefaultKeyNames()
  
  
  
  
  
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

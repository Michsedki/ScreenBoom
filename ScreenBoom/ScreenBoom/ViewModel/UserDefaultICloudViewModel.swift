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
  
  
  func checkIfOldEventExistForCurrentUser () {
    
  }
  
  func checkIfOldEventIsExist () -> Bool {
    if let oldEventUserDefault = userDefault.object(forKey: userDefaultKeyNames.eventNameKey) {
      return true
    }
    return false
  }
  
  func geteventCodeFromUserDefault() {
    
  }
  
  func checkIfTheSameUserIcloudID(userID: String) -> Bool {
    if let userdefaultUserID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
      if userID == userdefaultUserID {
        return true
      } else {
        UserDefaults.standard.set(userdefaultUserID, forKey: userDefaultKeyNames.userIDKey)
        return false
      }
    }
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
          complete(nil, "Couldn't find User IcloudID")
        }
      }
    }
  }
  
  
  
}

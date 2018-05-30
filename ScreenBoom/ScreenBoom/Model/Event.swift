//
//  Event.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

enum EventType: String {
  case Text = "text"
  case Photo = "photo"
  case Animation = "animation"
  case Unknown = "unknown"
}
let userDefaultKeyNames = UserDefaultKeyNames()
class Event: NSObject {
  
  var eventName: String
  var eventIsLive: String
  var eventType: EventType
  var userID: String?
  var eventCode: String
  
    init (eventName: String,
          eventIsLive: String,
          eventType: EventType,
          eventCode: String,
          userID: String? = (UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as! String)) {
    self.eventName = eventName
    self.eventType = eventType
    self.eventIsLive = eventIsLive
    self.eventCode = eventCode
        // ***** this need atention
    self.userID = userID
//    self.userID = "123"
    super.init()
  }
}

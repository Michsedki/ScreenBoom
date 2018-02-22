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

class Event: NSObject {
  
  var eventName: String
  var eventIsLive: String
  var eventType: EventType
//  lazy var eventTypeString: String = {
//    switch eventType {
//    case .Text:
//      return "Text"
//    case .Photo:
//      return "Photo"
//    case .Animation:
//      return "Animation"
//    case .Unknown:
//      return ""
//    }
//  }()
  
  init (eventName: String, eventIsLive: String, eventType: EventType) {
    self.eventName = eventName
    self.eventType = eventType
    self.eventIsLive = eventIsLive
    
    super.init()
  }
}

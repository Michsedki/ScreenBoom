//
//  Event.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

enum EventType: Int {
  case Text
  case Photo
  case Animation
}

class Event: NSObject {
  
  var eventName: String
  var eventType: EventType
  lazy var eventTypeString: String = {
    switch eventType {
    case .Text:
      return "Text"
    case .Photo:
      return "Photo"
    case .Animation:
      return "Animation"
    }
  }()
  
  init (eventName: String, eventType: EventType) {
    self.eventName = eventName
    self.eventType = eventType
    
    super.init()
  }
}

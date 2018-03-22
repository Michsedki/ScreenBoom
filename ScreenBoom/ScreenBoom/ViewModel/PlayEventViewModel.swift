//
//  ViewModel.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/21/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class PlayEventViewModel: NSObject {
  var event: Event
  var eventDetail: EventDetail
  
  
  init(event: Event, eventDetail: EventDetail) {
    self.event = event
    self.eventDetail = eventDetail
  }
  
  
}

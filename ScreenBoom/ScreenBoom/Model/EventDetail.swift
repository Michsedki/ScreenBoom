//
//  EventDetails.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/18/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation


class EventDetail: Decodable {
  
  var code: String?
  
  init(code: String?){
    self.code = code
  }
}

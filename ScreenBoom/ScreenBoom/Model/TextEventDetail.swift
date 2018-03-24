//
//  TextEventDetail.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/22/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class TextEventDetail: EventDetail {
  
  var animationName: String?
  var backgroundcolor: String?
  var textcolor: String?
  var speed: Int?
  var text: String?
  var font: String?
  var fontsize: Double?
  
  init(
    animationName: String?,
    backgroundcolor: String?,
    textcolor: String?,
    speed: Int?,
    text: String?,
    font: String?,
    fontsize: Double?,
    code: String?
    ) {
    
    super.init(code: code)
    
    self.animationName = animationName
    self.backgroundcolor = backgroundcolor
    self.textcolor = textcolor
    self.speed = speed
    self.text = text
    self.font = font
    self.fontsize = fontsize
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
}

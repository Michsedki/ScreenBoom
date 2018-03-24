//
//  AnimationEventDetail.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/22/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class AnimationEventDetail: EventDetail {
  
  var animationStringURL: String?
  
  init(animationStringURL: String?, code: String?){
    
    super.init(code: code)
    self.animationStringURL = animationStringURL
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
}

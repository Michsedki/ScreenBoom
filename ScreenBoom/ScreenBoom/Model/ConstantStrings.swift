//
//  FirebaseNoodNames.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/26/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
struct FirebaseNodeNames {
  // Event Node
  let eventNode = "Event"
  let eventNodeCodeChild = "code"
  let eventNodeTypeChild = "type"
    let eventNodeTypeTextValue = "text"
    let eventNodeTypePhotoValue = "photo"
    let eventNodeTypeAnimationValue = "animation"
    let eventNodeTypeDefaultValue = ""
  let eventNodeIsLiveChild = "islive"
    let eventNodeIsLiveYesValue = "yes"
    let eventNodeIsLiveNoValue = "no"
    let eventNodeIsLivePauseValue = "pause"
  let eventUserIDChild = "userid"
  
  // Event Detail Node
  let eventDetailPhotoStringURLChild = "photoStringURL"
  let eventDetailNode = "EventDetails"
  let eventDetailTextChild = "text"
  let eventDetailTextColorChild = "textcolor"
  let eventDetailBackGroundColorChild = "backgroundcolor"
  let eventDetailPhotoNameChild = "photoname"
  let eventDetailAnimationNameChild = "animationName"
  let eventDetailSpeedChild = "speed"
  let eventDetailCodeChild = "code"
 
  //Storage
  let eventImagesFolderName = "EventImages"
  
}


struct UserDefaultKeyNames {
  let userIDKey = "userID"
  let eventNameKey = "eventName"
  let eventCodeKey = "eventCode"
  let savedImageCodeKey = "savedImage"
  
}

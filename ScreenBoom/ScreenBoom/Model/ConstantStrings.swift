//
//  FirebaseNoodNames.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/26/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit

struct FirebaseNodeNames {
    static let sharedInstance = FirebaseNodeNames()

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
  let eventDetailAnimationStringURLChild = "animationStringURL"
    let eventDetailNode = "EventDetails"
    let eventDetailTextChild = "text"
    let eventDetailTextColorChild = "textcolor"
    let eventDetailBackGroundColorChild = "backgroundcolor"
    let eventDetailPhotoNameChild = "photoname"
    let eventDetailAnimationNameChild = "animationName"
    let eventDetailSpeedChild = "speed"
    let eventDetailCodeChild = "code"
    let eventDetailFoneChild = "font"
    let eventDetailFontSizeChild = "fontsize"
    let eventViewerCount = "views"
  
  
  // Event User Log
  let eventUsersNodeChild = "Users"
  let isOwnerChild = "isowner"
    let isOwnerYesValue = "yes"
    let isOwnerNoValue = "No"
    
 
  //Storage
  let eventImagesFolderName = "EventImages"
  
}

struct GADAppToken {
    static let sharedInstance = GADAppToken()

    let token = "ca-app-pub-3940256099942544/2934735716"
}

struct ImageNames {
  let delete = "delete"
  let share = "share"
  let playEnable = "playEnable"
  let playNotEnable = "playNotEnable"
  let pauseEnable = "pauseEnable"
  let pauseNotEnable = "pauseNotEnable"
  let placeHolder = "placeHolder"
}

struct ConstantNames {
    static let sharedInstance = ConstantNames()
  let colorsNamesList = ["Black",
                         "Blue",
                         "Brown",
                         "Cyan",
                         "Dark Gray",
                         "Gray",
                         "Green",
                         "Light Gray",
                         "Magenta",
                         "Orange",
                         "Purple",
                         "Red",
                         "White",
                         "Yellow"]
  let animationNamesArray = ["Shake", "Zoom", "pop"]
  var fontNames = [String]()
  var fontStyle = [String]()  
  let textColorButtonTitle = "Text Colors"
  let backgroungButtonTitle = "Background Colors"
  let animationButtonTitle = "Animation"
  let fontButtonTitle = "Font"
  let fontSizeButtonTitle = "Size"
  
  init() {
    UIFont.familyNames.sorted().forEach{ familyName in
      //  print("*** \(familyName) ***")
      UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
        fontNames.append(fontName)
      // print("\(fontName)")
      }
      
    }
  }
  
}


struct UserDefaultKeyNames {
    static let sharedInstance = UserDefaultKeyNames()
  let userIDKey = "userID"
  let eventNameKey = "eventName"
  let eventCodeKey = "eventCode"
  let savedImageCodeKey = "savedImage"
  
}

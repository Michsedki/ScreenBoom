//
//  EventDetails.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/18/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation


struct EventDetail: Decodable {
  
  //photo
  var photoStringURL: String?
  // text
  var animationName: String?
  var photoname: String?
  var backgroundcolor: String?
  var textcolor: String?
  var speed: String?
  var text: String?
  var code: String?
}

//struct AnimationEventDetail {
//  var animationName: String?
//  var code: String?
//}
//
//
//struct PhotoEventDetail {
//  var PhotoStringURL: String?
//  var code: String?
//}
//
//struct TextEventDetail: Decodable {
//  var animationName: String?
//  var backgroundPhotoStringURL: String?
//  var backgroundcolor: String?
//  var textcolor: String?
//  var speed: String?
//  var text: String?
//  var code: String?
//}
//
//struct MultiPhotoEventDetail {
//  var PhotoStringNames: [String?]
//}






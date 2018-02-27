//
//  String+RandomString.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit

extension String {
  
  static func random(length: Int = 5) -> String {
    let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    var randomString: String = ""
    
    for _ in 0..<length {
      let randomValue = arc4random_uniform(UInt32(base.count))
      randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
    }
    return randomString
  }
  
  func stringToUIColor () -> UIColor {
    switch self {
    case "White":
      return UIColor.white
    case "Green":
      return UIColor.green
    case "Blue":
      return UIColor.blue
    case "Yellow":
      return UIColor.yellow
    case "Black":
      return UIColor.black
    default:
      return UIColor.white
    }
  }
}





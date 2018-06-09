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
  
  
  func stringToUIColor () -> UIColor? {
    switch self {
    case "Black":
      return UIColor.black
    case "Blue":
      return UIColor.blue
    case "Brown":
      return UIColor.brown
    case "Cyan":
      return UIColor.cyan
    case "Dark Gray":
      return UIColor.darkGray
    case "Gray":
      return UIColor.gray
    case "Green":
      return UIColor.green
    case "Light Gray":
      return UIColor.lightGray
    case "Magenta" :
      return UIColor.magenta
    case "Orange":
        return UIColor.orange
    case "Purple":
        return UIColor.purple
    case "Red":
        return UIColor.red
    case "White" :
        return UIColor.white
    case "Yellow" :
        return UIColor.yellow
    default:
      print("Fail to cast string to color")
      return nil
    }
  }
}





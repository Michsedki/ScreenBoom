//
//  PhotoEventDetail.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/22/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class PhotoEventDetail: EventDetail {
  
  var photoname: String?
  var photo: UIImage?
  
  init(photoname: String?, code: String?, photo:UIImage? = nil) {
    super.init(code: code)
    
    self.photoname = photoname
    self.photo = photo
  }
  
  required init(from decoder: Decoder) throws {
    fatalError("init(from:) has not been implemented")
  }
  
  func configureWithPhoto(photo: UIImage) {
    self.photo = photo
  }
  
}

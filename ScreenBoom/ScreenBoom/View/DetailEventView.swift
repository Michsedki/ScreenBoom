//
//  DetailEventView.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/27/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit

class DetailEventView: UIView , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // Constants
  let firebaseNodeNames = FirebaseNodeNames()
  let detailView = UIView()
  
  let detailEventImageView: UIImageView = {
    let view = UIImageView()
    return view
  }()
  let detailEventImageViewButtonViewMenu : UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.green
    return view
  }()
  
  
  func configure(event: Event) {
    
    detailView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    detailView.backgroundColor = UIColor.yellow
    switch event.eventType {
    case .Text:
      break
    case .Photo:
      showDetailEventImageView()
      break
    case .Animation:
      break
    case .Unknown:
      break
    }
    self.addSubview(detailView)
  }
  
  func showDetailEventTextView() {
    
  }
  
  // show Photo Event View
  func showDetailEventImageView() {
    
//    detailEventImageView.image = UIImage(named: "Ironbg")
    detailEventImageView.backgroundColor = UIColor.gray
    
    detailView.addSubview(detailEventImageView)
    detailEventImageView.addSubview(detailEventImageViewButtonViewMenu)
    
    
    detailEventImageView.translatesAutoresizingMaskIntoConstraints = false
    detailEventImageViewButtonViewMenu.translatesAutoresizingMaskIntoConstraints = false
    
    detailEventImageView.frame = CGRect(x: 0, y: 0, width: detailView.frame.width, height: detailView.frame.height)
    detailEventImageViewButtonViewMenu.frame = CGRect(x: detailEventImageView.bounds.midX - ((detailEventImageView.bounds.width - 20) / 2) , y: detailEventImageView.bounds.maxY - detailEventImageView.bounds.height / 5, width: detailEventImageView.bounds.width - 20, height: detailEventImageView.bounds.height / 5)
    
  }
  
  
}

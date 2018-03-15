//
//  RightMenuView.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit

class RightMenuView: UIView {
  
  let blurEffectView : UIVisualEffectView = {
    let view = UIVisualEffectView()
    view.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
    return view
  }()
//  let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//  let blurEffectView = UIVisualEffectView(effect: blurEffect)
//  blurEffectView.frame = view.bounds
//  blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//  view.addSubview(blurEffectView)
  
  
  
  
  let label : UILabel = {
    let view = UILabel()
    view.sizeToFit()
    view.adjustsFontSizeToFitWidth = true
    view.numberOfLines = 0
    view.textAlignment = .left
    view.backgroundColor = UIColor.lightGray
    return view
  }()
  let shareImage : UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "share")
    view.isUserInteractionEnabled = true 
    return view
  }()
  
  func configureWith(eventName: String, eventCode: String) {
    backgroundColor = UIColor.clear
   
    addSubview(blurEffectView)
    addSubview(shareImage)
    addSubview(label)
    
    
    blurEffectView.anchor(top: topAnchor,
                     leading: leadingAnchor,
                     bottom: bottomAnchor,
                     trailing: trailingAnchor,
                     padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    shareImage.anchor(top: nil,
                      leading: leadingAnchor,
                      bottom: bottomAnchor,
                      trailing: trailingAnchor,
                      padding: .init(top: 0, left: 10, bottom: 2, right: 10),
                      size: .init(width: 0, height: 100))
    label.anchor(top: nil,
                 leading: leadingAnchor,
                 bottom: shareImage.topAnchor,
                 trailing: trailingAnchor,
                 padding: .init(top: 0, left: 10, bottom: 2, right: 10),
                 size: .init(width: 0, height: 100))
    
  }
  
  
  
}

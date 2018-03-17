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
    view.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    return view
  }()
  let editButton : UIButton = {
    let view = UIButton()
    view.setTitle("Edit", for: .normal)
    view.titleLabel?.textColor = UIColor.blue
    view.titleLabel?.backgroundColor = UIColor.clear
    view.backgroundColor = UIColor.clear
    return view
  }()
  let pauseImage : UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "pauseEnable")
    view.isUserInteractionEnabled = true
    return view
  }()
  let playImage : UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "playNotEnable")
    view.isUserInteractionEnabled = false
    return view
  }()
  let deleteImage : UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "delete")
    view.isUserInteractionEnabled = true
    return view
  }()
  let eventNameAndCodeButtonLabel : UIButton = {
    let view = UIButton()
    view.sizeToFit()
    view.titleLabel?.adjustsFontSizeToFitWidth = true
    view.titleLabel?.numberOfLines = 0
    view.titleLabel?.textAlignment = .left
    view.backgroundColor = UIColor.clear
    view.titleLabel?.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    view.isEnabled = false
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
    addSubview(editButton)
    addSubview(playImage)
    addSubview(pauseImage)
    addSubview(deleteImage)
    addSubview(shareImage)
    addSubview(eventNameAndCodeButtonLabel)
    
    
    blurEffectView.anchor(top: topAnchor,
                     leading: leadingAnchor,
                     bottom: bottomAnchor,
                     trailing: trailingAnchor,
                     padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    editButton.anchor(top: topAnchor,
                      leading: leadingAnchor,
                      bottom: nil,
                      trailing: trailingAnchor,
                      padding: .init(top: 84, left: 10, bottom: 0, right: 10),
                      size: .init(width: 0, height: 30))
    playImage.anchor(top: editButton.bottomAnchor,
                     leading: leadingAnchor,
                     bottom: nil,
                     trailing: trailingAnchor,
                     padding: .init(top: 15, left: 20, bottom: 0, right: 20),
                     size: .init(width: 0, height: 40))
    pauseImage.anchor(top: playImage.bottomAnchor,
                      leading: leadingAnchor,
                      bottom: nil,
                      trailing: trailingAnchor,
                      padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                      size: .init(width: 0, height: 40))
    deleteImage.anchor(top: pauseImage.bottomAnchor,
                       leading: leadingAnchor,
                       bottom: nil,
                       trailing: trailingAnchor,
                       padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                       size: .init(width: 0, height: 40))
    shareImage.anchor(top: deleteImage.bottomAnchor,
                      leading: leadingAnchor,
                      bottom: nil,
                      trailing: trailingAnchor,
                      padding: .init(top: 15, left: 20, bottom: 0, right: 20),
                      size: .init(width: 0, height: 40))
    eventNameAndCodeButtonLabel.anchor(top: shareImage.bottomAnchor,
                                       leading: leadingAnchor,
                                       bottom: bottomAnchor,
                                       trailing: trailingAnchor,
                                       padding: .init(top: 10, left: 20, bottom: 10, right: 20),
                                       size: .init(width: 0, height: 0))
  }
  
  
  
}

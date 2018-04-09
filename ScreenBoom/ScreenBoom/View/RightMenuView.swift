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
  
  let eventViewModel = EventViewModel()
  let imageNames = ImageNames()
  var sideMenuDelegate : SideMenuDelegate?
  
  let blurEffectView : UIVisualEffectView = {
    let view = UIVisualEffectView()
    view.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    return view
  }()
  let editButton : UIButton = {
    let view = UIButton()
//    view.isHidden = true
    view.setTitle("Edit", for: .normal)
    view.titleLabel?.textColor = UIColor.blue
    view.titleLabel?.backgroundColor = UIColor.clear
    view.backgroundColor = UIColor.clear
    return view
  }()
  let pauseButton : UIButton = {
    let view = UIButton()
//    view.isHidden = true
    view.setImage(UIImage(named: "pauseEnable"), for: .normal)
    return view
  }()
  let playButton : UIButton = {
    let view = UIButton()
//    view.isHidden = true
    view.setImage(UIImage(named: "playNotEnable"), for: .normal)
    return view
  }()
  let deleteButton : UIButton = {
    let view = UIButton()
//    view.isHidden = true
    view.setImage(UIImage(named: "delete"), for: .normal)
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
  let shareButton : UIButton = {
    let view = UIButton()
    view.setImage(UIImage(named: "share"), for: .normal)
    return view
  }()
  
  
  
  func configureWith(event: Event, eventCode: String) {
    
    backgroundColor = UIColor.clear
    eventNameAndCodeButtonLabel.setTitle("Title: \(event.eventName) \n Code: \(eventCode)", for: .normal)
    
    
    addSubview(blurEffectView)
    addSubview(shareButton)
    addSubview(eventNameAndCodeButtonLabel)
    
    // set the right Menu only if the owner is playing the event
    if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String,
      userID == event.userID {
      print("isOwner")
      addSubview(editButton)
      addSubview(playButton)
      addSubview(pauseButton)
      addSubview(deleteButton)
    }
   
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
    playButton.anchor(top: editButton.bottomAnchor,
                     leading: leadingAnchor,
                     bottom: nil,
                     trailing: trailingAnchor,
                     padding: .init(top: 15, left: 20, bottom: 0, right: 20),
                     size: .init(width: 0, height: 40))
    pauseButton.anchor(top: playButton.bottomAnchor,
                      leading: leadingAnchor,
                      bottom: nil,
                      trailing: trailingAnchor,
                      padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                      size: .init(width: 0, height: 40))
    deleteButton.anchor(top: pauseButton.bottomAnchor,
                       leading: leadingAnchor,
                       bottom: nil,
                       trailing: trailingAnchor,
                       padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                       size: .init(width: 0, height: 40))
    shareButton.anchor(top: deleteButton.bottomAnchor,
                      leading: leadingAnchor,
                      bottom: nil,
                      trailing: trailingAnchor,
                      padding: .init(top: 15, left: 20, bottom: 0, right: 20),
                      size: .init(width: 0, height: 40))
    eventNameAndCodeButtonLabel.anchor(top: shareButton.bottomAnchor,
                                       leading: leadingAnchor,
                                       bottom: bottomAnchor,
                                       trailing: trailingAnchor,
                                       padding: .init(top: 10, left: 20, bottom: 10, right: 20),
                                       size: .init(width: 0, height: 0))
    
    addButtonsAction()
    
    
  }
  
  func addButtonsAction() {
    
    shareButton.addTarget(self, action: #selector(sideMenuShareButtonPressed(_:)), for: .touchUpInside)
    
    pauseButton.addTarget(self, action:#selector(sideMenuPauseButtonPressed(_:)), for: .touchUpInside)
    
    playButton.addTarget(self, action: #selector(sideMenuPlayButtonPressed(_:)), for: .touchUpInside)
    
    deleteButton.addTarget(self, action: #selector(sideMenuDeleteButtonPressed(_:)), for: .touchUpInside)
    
    editButton.addTarget(self, action: #selector(sideMenuEditButtonPressed(_:)), for: .touchUpInside)
  }
  
  @objc func sideMenuEditButtonPressed(_ sender: UIButton) {
    
  }
  
  @objc func sideMenuDeleteButtonPressed(_ sender: UIButton) {
    
    self.sideMenuDelegate?.sideMenuDeleteButtonPressed()
    
  }
  
  @objc func sideMenuPlayButtonPressed(_ sender: UIButton) {
    
    pauseButton.setImage(UIImage(named: imageNames.pauseEnable), for: .normal)
    playButton.setImage(UIImage(named: imageNames.playNotEnable), for: .normal)
    
    pauseButton.isEnabled = true
    playButton.isEnabled = false
    
    self.sideMenuDelegate?.sideMenuPlayButtonPressed()
   
  }
  
  @objc func sideMenuPauseButtonPressed(_ sender: UIButton) {

    pauseButton.setImage(UIImage(named: imageNames.pauseNotEnable), for: .normal)
    playButton.setImage(UIImage(named: imageNames.playEnable), for: .normal)
    
    pauseButton.isEnabled = false
    playButton.isEnabled = true
    
    self.sideMenuDelegate?.sideMenuPauseButtonPressed()
  }
  
  @objc func sideMenuShareButtonPressed(_ sender: UIButton) {
    
    self.sideMenuDelegate?.sideMenuShareButtonPressed()
  }
  
}

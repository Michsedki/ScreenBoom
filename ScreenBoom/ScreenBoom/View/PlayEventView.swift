//
//  PlayEventView.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/21/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit
import Canvas

class PlayEventView: UIView {
  // Constants
  let firebaseNodeNames = FirebaseNodeNames()
  let userDefaultKeyNames = UserDefaultKeyNames()
  
  // create Canvas Animation View
  let textLabelAnimationView: CSAnimationView = {
    let view = CSAnimationView()
    view.backgroundColor = UIColor.clear
    return view
  }()
  let textLabel: UILabel = {
    let view = UILabel()
    view.backgroundColor = UIColor.clear
    view.numberOfLines = 0
    view.sizeToFit()
    view.adjustsFontSizeToFitWidth = true
    view.font = UIFont.boldSystemFont(ofSize: 25)
    view.textAlignment = .center
    return view
  }()
  let photoEventImageView : UIImageView = {
    let view = UIImageView()
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
    view.contentMode = .scaleAspectFit // OR .scaleAspectFill
    view.clipsToBounds = true
    return view
  }()
  let pendingLabelAnimationView: CSAnimationView = {
    let view = CSAnimationView()
    view.backgroundColor = UIColor.clear
    return view
  }()
  let pendingLabel: UILabel = {
    let view = UILabel()
    view.font = UIFont.boldSystemFont(ofSize: 25)
    view.textColor = UIColor.red
    view.textAlignment = .center
    view.backgroundColor = UIColor.clear
    return view
  }()
  func configureWithPhotoEventImage(image: UIImage) {
    photoEventImageView.image = image
  }
  
  func configure(viewModel: PlayEventViewModel) {
    let eventDetail = viewModel.eventDetail
    let event = viewModel.event
    
    
    self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    
    // Check if the Event not is live, set playView with Label Event pending
    guard event.eventIsLive != firebaseNodeNames.eventNodeIsLivePauseValue else {
      showPendingAndDefaultEventView(message: "Pending Event")
      [textLabelAnimationView, photoEventImageView].forEach{$0.removeFromSuperview()}
      return
    }
    
    switch event.eventType {
    case .Text:
      showTextEventView(eventDetail: eventDetail)
      [pendingLabelAnimationView,photoEventImageView].forEach{$0.removeFromSuperview() }
      break
    case .Photo:
      showPhotoEventView(eventDetail: eventDetail)
      [pendingLabelAnimationView,textLabelAnimationView].forEach{$0.removeFromSuperview() }
      break
    case .Animation:[pendingLabelAnimationView,photoEventImageView,pendingLabelAnimationView,textLabelAnimationView].forEach{$0.removeFromSuperview() }
      showAnimationEventView(eventDetail: eventDetail)
      break
    default:
      showPendingAndDefaultEventView(message: "Couldn't find Event Type")
       [textLabelAnimationView, photoEventImageView].forEach{$0.removeFromSuperview() }
      break
    }
  }
  
  // Show Animation Event View
  func showAnimationEventView(eventDetail: EventDetail) {
    if let animationStringURL = eventDetail.animationStringURL {
      photoEventImageView.loadGif(name: animationStringURL)
    } else {
      // Place Holder Emage
      photoEventImageView.image = UIImage(named: "placeHolder")
    }
    addSubview(photoEventImageView)
    photoEventImageView.anchor(top: self.topAnchor,
                               leading: self.leadingAnchor,
                               bottom: self.bottomAnchor,
                               trailing: self.trailingAnchor,
                               padding: .zero)
  }
  // show Photo Event View
  func showPhotoEventView(eventDetail: EventDetail) {
    if eventDetail.photoname == "placeHolder" {
      //Place Holder
      photoEventImageView.image = UIImage(named: "placeHolder")
    } else if eventDetail.photoname == userDefaultKeyNames.savedImageCodeKey {
      
      let data = UserDefaults.standard.object(forKey: userDefaultKeyNames.savedImageCodeKey) as! NSData
      photoEventImageView.image = UIImage(data: data as Data)
    
    } else {
      if let photoName = eventDetail.photoname, let url = URL(string : photoName) {
        photoEventImageView.sd_setShowActivityIndicatorView(true)
        photoEventImageView.sd_setIndicatorStyle(.gray)
        photoEventImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeHolder"), options: [.continueInBackground, .progressiveDownload])
        
      } else {
        //Place Holder
         photoEventImageView.image = UIImage(named: "placeHolder")
      }
    }
    addSubview(photoEventImageView)
    photoEventImageView.anchor(top: self.topAnchor,
                               leading: self.leadingAnchor,
                               bottom: self.bottomAnchor,
                               trailing: self.trailingAnchor,
                               padding: .zero)
  }
  
  // Show Text Event View
  func showTextEventView(eventDetail: EventDetail) {
    // i should add if let statement to unwrap all this value first
    
    // set PlayView background color
    backgroundColor = eventDetail.backgroundcolor?.stringToUIColor()
    // Set textLabel with text and textColor
    textLabel.text = eventDetail.text
    textLabel.textColor = eventDetail.textcolor?.stringToUIColor()
    textLabel.font = UIFont(name: eventDetail.font!+"-Bold", size: CGFloat(Int(eventDetail.fontsize!)!))
    // Add Canvas Animation to the pendingLabelAnimationView
    textLabelAnimationView.type = eventDetail.animationName
    textLabelAnimationView.duration = 10
    textLabelAnimationView.delay = 0
    // adding subviews
    textLabelAnimationView.addSubview(textLabel)
     addSubview(textLabelAnimationView)
    // set views Anchors
    textLabelAnimationView.anchor(top: self.topAnchor,
                                  leading: self.leadingAnchor,
                                  bottom: self.bottomAnchor,
                                  trailing: self.trailingAnchor,
                                  padding: .zero)
    textLabel.anchor(top: textLabelAnimationView.topAnchor,
                     leading: textLabelAnimationView.leadingAnchor,
                     bottom: textLabelAnimationView.bottomAnchor,
                     trailing: textLabelAnimationView.trailingAnchor,
                     padding: .zero)
    textLabelAnimationView.startCanvasAnimation()
  }
  
  // Show Pending Event View
  func showPendingAndDefaultEventView(message: String) {
    backgroundColor = UIColor.gray
    pendingLabel.text = message
    // Add Canvas Animation to the pendingLabelAnimationView
    pendingLabelAnimationView.type = "shake"
    pendingLabelAnimationView.duration = 10
    pendingLabelAnimationView.delay = 0
    // Add views
    addSubview(pendingLabelAnimationView)
    pendingLabelAnimationView.addSubview(pendingLabel)
    // set Anchors
    pendingLabelAnimationView.anchor(top: self.topAnchor,
                                     leading: self.leadingAnchor,
                                     bottom: self.bottomAnchor,
                                     trailing: self.trailingAnchor,
                                     padding: .init(top: 30,left: 30,bottom: 30,right: 30))
    pendingLabel.anchor(top: pendingLabelAnimationView.topAnchor,
                                     leading: pendingLabelAnimationView.leadingAnchor,
                                     bottom: pendingLabelAnimationView.bottomAnchor,
                                     trailing: pendingLabelAnimationView.trailingAnchor,
                                     padding: .zero)
    pendingLabelAnimationView.startCanvasAnimation()
  }
  
}



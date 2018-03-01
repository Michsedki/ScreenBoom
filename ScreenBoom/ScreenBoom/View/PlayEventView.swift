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
  let playView = UIView()
  
  // create Canvas Animation View
  let textLabelAnimationView: CSAnimationView = {
    let view = CSAnimationView()
    view.backgroundColor = UIColor.clear
    return view
  }()
  let textLabel: UILabel = {
    let view = UILabel()
    view.backgroundColor = UIColor.clear
    view.font = UIFont.boldSystemFont(ofSize: 25)
    view.textAlignment = .center
    return view
  }()
  let photoEventImageView : UIImageView = {
    let view = UIImageView()
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
  
  func configure(viewModel: PlayEventViewModel) {
    let eventDetail = viewModel.eventDetail
    let event = viewModel.event
    
    playView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    
    // Check if the Event not is live, set playView with Label Event pending
    guard event.eventIsLive == firebaseNodeNames.eventNodeIsLiveYesValue else {
//      pendingLabelAnimationView.isHidden = false
      showPendingAndDefaultEventView(message: "Pending Event")
      [textLabelAnimationView, photoEventImageView].forEach{$0.removeFromSuperview()}
      return
    }
    switch event.eventType {
    case .Text:
//      textLabelAnimationView.isHidden = false
      showTextEventView(eventDetail: eventDetail)
      [pendingLabelAnimationView,photoEventImageView].forEach{$0.removeFromSuperview() }
      break
    case .Photo:
//      photoEventImageView.isHidden = false
      showPhotoEventView(eventDetail: eventDetail)
      [pendingLabelAnimationView,textLabelAnimationView].forEach{$0.removeFromSuperview() }
      break
    case .Animation:
      break
    default:
//      pendingLabelAnimationView.isHidden = false
      showPendingAndDefaultEventView(message: "Couldn't find Event Type")
       [textLabelAnimationView, photoEventImageView].forEach{$0.removeFromSuperview() }
      break
    }
    self.addSubview(playView)
  }
  
  
  
  // Show Animation Event View
  func showAnimationEventView(eventDetail: EventDetail) {
    
  }
  
  
  // show Photo Event View
  func showPhotoEventView(eventDetail: EventDetail) {
    photoEventImageView.image = UIImage(named: "Ironbg")
    playView.addSubview(photoEventImageView)
    photoEventImageView.translatesAutoresizingMaskIntoConstraints = false
    photoEventImageView.frame = CGRect(x: playView.frame.minX, y: playView.frame.minY, width: playView.frame.width, height: playView.frame.height)
  }
  
  // Show Text Event View
  func showTextEventView(eventDetail: EventDetail) {
    // set PlayView background color
    playView.backgroundColor = eventDetail.backgroundcolor?.stringToUIColor()
    // Set textLabel with text and textColor
    textLabel.text = eventDetail.text
    textLabel.textColor = eventDetail.textcolor?.stringToUIColor()
    // Add Canvas Animation to the pendingLabelAnimationView
    textLabelAnimationView.type = "pop"
    textLabelAnimationView.duration = 10
    textLabelAnimationView.delay = 0

    // adding subviews
    playView.addSubview(textLabelAnimationView)
    textLabelAnimationView.addSubview(textLabel)
    // set views translatesAutoresizingMaskIntoConstraints to false
    textLabelAnimationView.translatesAutoresizingMaskIntoConstraints = false
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    // set views frame
    textLabelAnimationView.frame = CGRect(x: playView.frame.minX, y: playView.frame.minY, width: playView.frame.width, height: playView.frame.height)
    textLabel.frame = CGRect(x: textLabelAnimationView.frame.minX, y: textLabelAnimationView.frame.minY, width: textLabelAnimationView.frame.width, height: textLabelAnimationView.frame.height)
    textLabelAnimationView.startCanvasAnimation()
  }
  
  
  // Show Pending Event View
  func showPendingAndDefaultEventView(message: String) {
    
    playView.backgroundColor = UIColor.gray
    pendingLabel.text = message
    // Add Canvas Animation to the pendingLabelAnimationView
    pendingLabelAnimationView.type = "shake"
    pendingLabelAnimationView.duration = 10
    pendingLabelAnimationView.delay = 0
    // Add views
    playView.addSubview(pendingLabelAnimationView)
    pendingLabelAnimationView.addSubview(pendingLabel)
    
    // set view translatesAutoresizingMaskIntoConstraints to false
    pendingLabelAnimationView.translatesAutoresizingMaskIntoConstraints = false
    pendingLabel.translatesAutoresizingMaskIntoConstraints = false
    
    // set constraints
    pendingLabelAnimationView.frame = CGRect(x: playView.frame.midX - 100, y: playView.frame.midY - 100, width: 200, height: 200)
    pendingLabel.frame = CGRect(x: 0, y: 0, width: pendingLabelAnimationView.frame.width, height: pendingLabelAnimationView.frame.height)
    pendingLabelAnimationView.startCanvasAnimation()
  }
  
}
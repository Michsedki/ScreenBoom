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
//  let playView = UIView()
  
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
    view.backgroundColor = UIColor.yellow
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
    case .Animation:
      break
    default:
      showPendingAndDefaultEventView(message: "Couldn't find Event Type")
       [textLabelAnimationView, photoEventImageView].forEach{$0.removeFromSuperview() }
      break
    }
//    self.addSubview(playView)
  }
  
  // Show Animation Event View
  func showAnimationEventView(eventDetail: EventDetail) {
    
  }
  
  
  // show Photo Event View
  func showPhotoEventView(eventDetail: EventDetail) {
    photoEventImageView.image = UIImage(named: "Ironbg")
    addSubview(photoEventImageView)
    photoEventImageView.translatesAutoresizingMaskIntoConstraints = false
    photoEventImageView.anchor(top: self.topAnchor,
                               leading: self.leadingAnchor,
                               bottom: self.bottomAnchor,
                               trailing: self.trailingAnchor,
                               padding: .zero)
  }
  
  // Show Text Event View
  func showTextEventView(eventDetail: EventDetail) {
    print(eventDetail)
    // set PlayView background color
    backgroundColor = eventDetail.backgroundcolor?.stringToUIColor()
    // Set textLabel with text and textColor
    textLabel.text = eventDetail.text
    textLabel.textColor = eventDetail.textcolor?.stringToUIColor()
    // Add Canvas Animation to the pendingLabelAnimationView
    textLabelAnimationView.type = "pop"
    textLabelAnimationView.duration = 10
    textLabelAnimationView.delay = 0

    // adding subviews
    textLabelAnimationView.addSubview(textLabel)
     addSubview(textLabelAnimationView)
    
    // set views translatesAutoresizingMaskIntoConstraints to false
    textLabelAnimationView.translatesAutoresizingMaskIntoConstraints = false
    textLabel.translatesAutoresizingMaskIntoConstraints = false
    
    // set views frame
    textLabelAnimationView.anchor(top: self.topAnchor,
                                  leading: self.leadingAnchor,
                                  bottom: self.bottomAnchor,
                                  trailing: self.trailingAnchor,
                                  padding: .init(top: 100,left: 100,bottom: 100,right: 100))
    
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
    
    // set view translatesAutoresizingMaskIntoConstraints to false
    pendingLabelAnimationView.translatesAutoresizingMaskIntoConstraints = false
    pendingLabel.translatesAutoresizingMaskIntoConstraints = false
    
    // set constraints
    pendingLabelAnimationView.anchor(top: self.topAnchor,
                                     leading: self.leadingAnchor,
                                     bottom: self.bottomAnchor,
                                     trailing: self.trailingAnchor,
                                     padding: .init(top: 100,left: 100,bottom: 100,right: 100))
    pendingLabel.anchor(top: pendingLabelAnimationView.topAnchor,
                                     leading: pendingLabelAnimationView.leadingAnchor,
                                     bottom: pendingLabelAnimationView.bottomAnchor,
                                     trailing: pendingLabelAnimationView.trailingAnchor,
                                     padding: .zero)
    pendingLabelAnimationView.startCanvasAnimation()
  }
  
}

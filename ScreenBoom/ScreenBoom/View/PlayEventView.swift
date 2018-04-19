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
    
    let event = viewModel.event
    
    self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    
    // Check if the Event not is live, set playView with Label Event pending
    guard event.eventIsLive != firebaseNodeNames.eventNodeIsLivePauseValue else {
      showPendingAndDefaultEventView(message: "Pending Event")
      return
    }
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



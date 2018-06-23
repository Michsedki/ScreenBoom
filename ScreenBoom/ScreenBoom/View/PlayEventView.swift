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
    
    let viewerCountView : UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    let blurEffectView : UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        return view
    }()
    let viewerCountLabel : UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.textAlignment = .center
        view.textColor = .white
        view.numberOfLines = 0
        view.sizeToFit()
        view.text = "Views \n 0"
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
    
//    let event = viewModel.event
    
//    self.frame = CGRect(x: 0,
//                        y: 0,
//                        width: self.frame.width,
//                        height: self.frame.height)
    
    // take care that you remove all subviews here 
    for view in self.subviews {
        view.removeFromSuperview()
    }
   
  }
    
  // Show Pending Event View
  func showPendingAndDefaultEventView(message: String) {
//    backgroundColor = UIColor.gray
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
//    pendingLabelAnimationView.startCanvasAnimation()
    
    updateViewerLabel(viewerCount : 0)
  }
    
    func updateViewerLabel(viewerCount : Int) {
        
        addSubview(viewerCountView)
        viewerCountView.addSubview(blurEffectView)
        viewerCountView.addSubview(viewerCountLabel)
        
        blurEffectView.anchor(top: viewerCountView.topAnchor,
                              leading: viewerCountView.leadingAnchor,
                              bottom: viewerCountView.bottomAnchor,
                              trailing: viewerCountView.trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                              size: .init(width: 0, height: 0))
        
        viewerCountView.anchor(top: nil,
                                leading: nil,
                                bottom: self.bottomAnchor,
                                trailing: self.trailingAnchor,
                                padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                                size: .init(width: 80, height: 50))
        viewerCountLabel.anchor(top: viewerCountView.topAnchor,
                              leading: viewerCountView.leadingAnchor,
                              bottom: viewerCountView.bottomAnchor,
                              trailing: viewerCountView.trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                              size: .init(width: 0, height: 0))
        
        viewerCountLabel.text = "Views \n \(viewerCount)"

        print(viewerCount)
    }
}



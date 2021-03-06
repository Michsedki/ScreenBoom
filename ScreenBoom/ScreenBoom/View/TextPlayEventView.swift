//
//  TextPlayEventView.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/23/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit
import Canvas

class TextPlayEventView : PlayEventView {
  
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
  
  override func configure(viewModel: PlayEventViewModel) {
    super.configure(viewModel: viewModel)
    let eventDetail = viewModel.eventDetail
    
    guard let textEventDetail = eventDetail as? TextEventDetail else  { return }
    
    // set PlayView background color
    backgroundColor = textEventDetail.backgroundcolor?.stringToUIColor()
    // Set textLabel with text and textColor
    textLabel.text = textEventDetail.text
    textLabel.textColor = textEventDetail.textcolor?.stringToUIColor()
    textLabel.font = UIFont(name: textEventDetail.font!+"-Bold", size: CGFloat(Int(textEventDetail.fontsize!)))
    // Add Canvas Animation to the pendingLabelAnimationView
    textLabelAnimationView.type = textEventDetail.animationName
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
}

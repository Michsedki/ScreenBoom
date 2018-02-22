//
//  PlayEventView.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/21/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit

class PlayEventView: UIView {
  
  var playEventViewModel: PlayEventViewModel
  
  init(viewModel: PlayEventViewModel, frame:CGRect) {
    self.playEventViewModel = viewModel
    
    super.init(frame: frame)
    
    // the first time, we need to configure the view
    // ourselves
    self.configure(viewModel: self.playEventViewModel)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure(viewModel: PlayEventViewModel) {
    let eventDetail = viewModel.eventDetail
    
    let playView = UIView()
    playView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    playView.backgroundColor = eventDetail.backgroundcolor?.stringToUIColor()
    let textLabelView = UILabel()
    textLabelView.backgroundColor = UIColor.green
    textLabelView.font = UIFont.boldSystemFont(ofSize: 25)
    textLabelView.textAlignment = .center
    textLabelView.text = eventDetail.text
    textLabelView.textColor = eventDetail.textcolor?.stringToUIColor()
    textLabelView.frame = CGRect(x: playView.frame.minX, y: playView.frame.minY, width: playView.frame.width, height: playView.frame.height)
    playView.addSubview(textLabelView)
    
    self.addSubview(playView)
    
    // capture reference
    self.playEventViewModel = viewModel
  }
  
}

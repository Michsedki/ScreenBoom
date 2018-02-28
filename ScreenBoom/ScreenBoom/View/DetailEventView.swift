//
//  EventDetailView.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/27/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit

class DetailEventView: UIView {
  
  func configureWithEvent(event: Event) {
    
    let detailView = UIView()
    detailView.translatesAutoresizingMaskIntoConstraints = false
    detailView.frame = CGRect(x: 0, y: 0, width: super.frame.width, height: super.frame.height)
    detailView.backgroundColor = UIColor.green
    
    
    let previewView: UIView = {
      let view = UIView()
      view.backgroundColor = UIColor.blue
      return view
    }()
    
    
    [previewView].forEach {detailView.addSubview($0) }
    
    // Anchors
    
    previewView.anchor(top: detailView.topAnchor, leading: detailView.leadingAnchor, bottom: nil, trailing: detailView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: detailView.frame.width / 3))
    
    
    
    
    
    
    
    
    self.addSubview(detailView)
    
    
  }
  
  
}

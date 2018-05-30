//
//  UIView+Anchors.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/27/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit

// this extension to round the UIButtons
extension UIView {
    func roundIt() {
        self.layer.cornerRadius = self.frame.height/2
    }
}


// this extention to set
extension UIView {
  
  // fill the whole superiew with this view
  func fillSuperView() {
    anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    
  }
  
  // set this view to same width and height of another view
  func anchorEqualSize(to view: UIView) {
    widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
  }
  
  // set the anchor constarins, padding and size of this view
  func anchor (top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
    
    translatesAutoresizingMaskIntoConstraints = false
    if let top = top {
      topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
    }
    if let leading = leading {
      leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
    }
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
    }
    if let trailing = trailing {
      trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
    }
    
    if size.width != 0 {
      widthAnchor.constraint(equalToConstant: size.width).isActive = true
    }
    if size.height != 0 {
      heightAnchor.constraint(equalToConstant: size.height).isActive = true
    }
  }
}

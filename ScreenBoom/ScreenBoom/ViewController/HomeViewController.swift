//
//  HomeViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit



class HomeViewController: BaseViewController {

  // Struct
  struct Constant {
    static let imageTopDistanceLandScape: CGFloat = 20
    static let imageTopDistancePortrait: CGFloat = 100
  }
  
  
  // Constrains
  
  @IBOutlet weak var topDistance: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillLayoutSubviews() {
    let isLandscape = UIDevice.current.orientation.isLandscape
    if isLandscape {
      topDistance.constant = Constant.imageTopDistanceLandScape
      return
    }
    
    topDistance.constant = Constant.imageTopDistancePortrait
  }
}


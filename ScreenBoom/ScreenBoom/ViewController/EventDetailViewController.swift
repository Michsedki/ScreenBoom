//
//  EventDetailViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class EventDetailViewController: BaseViewController {

  
  
  // Variables
  var eventName:String
  
//  convenience init() {
//    self.init(eventName: "")
//  }
  
  init(eventName:String) {
    self.eventName = eventName

    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      self.view.backgroundColor = UIColor.blue
      print(eventName)

        // Do any additional setup after loading the view.
  }


    

  

}

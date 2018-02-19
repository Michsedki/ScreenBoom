//
//  PlayEventViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/8/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class PlayEventViewController: BaseViewController {
  
  
  // variables
  var event: Event
  
  
  // init
  init (event:Event) {
    self.event = event
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

   

}

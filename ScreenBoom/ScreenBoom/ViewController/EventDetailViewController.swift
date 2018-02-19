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
  var event:Event
  let eventDetailViewModel = EventDetailsViewModel()
  
//  convenience init() {
//    self.init(eventName: "")
//  }
  
  init(event:Event) {
    self.event = event

    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      self.view.backgroundColor = UIColor.white
      print(event.eventName)
 putViewsInPlace()
        // Do any additional setup after loading the view.
  }
  
  override func viewWillLayoutSubviews() {
   
  }

  func putViewsInPlace() {
    
    // Navigation bar Right Button Setup
    
    let sendRightBarButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(EventDetailViewController.rightBarButtonPressed(_:)))
    
    navigationItem.rightBarButtonItem = sendRightBarButton
    
    
    
  }
  // Selectors
  
  @objc func rightBarButtonPressed (_ sender: UIBarButtonItem!) {
    
    eventDetailViewModel.checkIfEventDetailExist(event: event) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
      case .Success(()):
        print(result)
        
      }
    }
    print("Send")
    
  }

  

  

}

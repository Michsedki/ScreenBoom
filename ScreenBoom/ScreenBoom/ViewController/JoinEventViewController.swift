//
//  JoinEventViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class JoinEventViewController: BaseViewController {
  
  // variables
  let userDefaultICloudViewModel = UserDefaultICloudViewModel()
  var event: Event?
  var eventManager = EventManager()
  var eventDetailManager = EventDetailManager()
    
  // Outlets
  @IBOutlet weak var eventNameTextField: UITextField!
  @IBOutlet weak var codeTextField: UITextField!
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
    setupJoinLastEventView()
  }
  
    
    @IBAction func joinBarButtonPressed(_ sender: UIBarButtonItem) {
        
        // check if textfields is empty
        guard let eventName = eventNameTextField.text, !eventName.isEmpty else {
            let message = "Please enter Valid event name"
            self.infoView(message: message, color: Colors.smoothRed)
            return
        }
        guard let eventCode = codeTextField.text, !eventCode.isEmpty else {
            let message = "Please enter Valid event code"
            self.infoView(message: message, color: Colors.smoothRed)
            return
        }
        getEventAndCmpareCode(eventName: eventName, eventCode: eventCode)
        //
    }
      
  func getEventAndCmpareCode(eventName: String, eventCode: String) {
    
    self.event = Event(eventName: eventName, eventIsLive: "no", eventType: .Unknown, eventCode: eventCode)
    // start spinner
    self.ShowSpinner()
    guard let event = self.event else { return }
    eventManager.checkIfEventExists(newEvent: event) { [unowned self] (isExist,eventObj)  in
      guard isExist else {
        self.infoView(message: "event is not Exist", color: Colors.smoothRed)
        return
      }
        guard let eventFound = eventObj else {
            self.infoView(message: "Couldn't retrive event", color: Colors.smoothRed)
            return
        }
        
      if eventFound.eventCode == eventCode {
        event.eventIsLive = eventFound.eventIsLive
        event.userID = eventFound.userID
        event.eventType = eventFound.eventType
        
        // we need to update our captures reference to the event
        self.event = event
        // we also need to get an event detail before showing the play view controller
        self.getEventDetail()
      } else {
        self.infoView(message: "Code is not valid", color: Colors.smoothRed)
      }
    }
    self.HideSpinner()
  }
    
  func getEventDetail() {
    guard let event = self.event else { return }
    self.eventDetailManager.checkIfEventDetailExist(event: event, completion: { result in
        switch (result) {
            case .Failure(let errorString):
                print(errorString)
            case .Success(let eventDetail):
                self.showPlayEventViewController(event: event, eventDetail: eventDetail)
        }
    })
  }
  
  func setupJoinLastEventView() {
    guard let lastEventName = self.userDefaultICloudViewModel.checkIfOldEventNameIsExist() ,
      let lastEventCode = self.userDefaultICloudViewModel.checkIfOldEventCodeIsExist() else { return }

    
  }
    
//  @objc func joinLastEventButtonPressed (){
//    if let lastEventName = self.userDefaultICloudViewModel.checkIfOldEventNameIsExist() ,
//      let lastEventCode = self.userDefaultICloudViewModel.checkIfOldEventCodeIsExist() {
//      getEventAndCmpareCode(eventName: lastEventName, eventCode: lastEventCode)
//    }
//
//  }

  // Push PlayEventViewController
  func showPlayEventViewController(event: Event, eventDetail: EventDetail) {
    let PlayViewController = PlayEventViewController(event: event, eventDetail:eventDetail)
    self.navigationController?.pushViewController(PlayViewController, animated: true)
  }
}


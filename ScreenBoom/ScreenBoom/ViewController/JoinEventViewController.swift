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
  var baseDatabaseReference = Database.database().reference()
  var event: Event?
  var eventViewModel = EventViewModel()
  var eventDetailViewModel = EventDetailsViewModel()
    
  // Outlets
  @IBOutlet weak var eventNameTextField: UITextField!
  @IBOutlet weak var codeTextField: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  @IBAction func goButtonPressed(_ sender: UIButton) {
    
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
    
    self.event = Event(eventName: eventName, eventIsLive: "yes", eventType: .Unknown)
    
    // start spinner
    self.ShowSpinner()
    guard let event = self.event else { return }
    eventViewModel.checkIfEventExists(event: event) { [unowned self] (result,snapshot)  in
      guard result else {
        self.infoView(message: "event is not Exist", color: Colors.smoothRed)
        return
      }
      
      guard let eventCodeFirebase = snapshot?.childSnapshot(forPath: "code").value as? String, let eventTypeFirebase = snapshot?.childSnapshot(forPath: "type").value as? String
        else {
          self.infoView(message: "Couldn't retrive event", color: Colors.smoothRed)
          return
      }
      
      if eventCodeFirebase == eventCode {
        
        switch eventTypeFirebase {
          case "text":
            event.eventType = .Text
          case "animation":
            event.eventType = .Animation
          case "photo" :
            event.eventType = .Photo
          default:
            break
        }
        
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
    self.eventDetailViewModel.checkIfEventDetailExist(event: event, completion: { result in
        switch (result) {
            case .Failure(let errorString):
                print(errorString)
            case .Success(let eventDetail):
                self.showPlayEventViewController(event: event, eventDetail: eventDetail)
        }
    })
  }
  
  // Push PlayEventViewController
  func showPlayEventViewController(event: Event, eventDetail: EventDetail) {
    let PlayViewController = PlayEventViewController(event: event, eventDetail:eventDetail)
    self.navigationController?.pushViewController(PlayViewController, animated: true)
  }
}

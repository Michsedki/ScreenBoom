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
  var eventName: String?
  var eventCode: String?
  
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

    let eventToPlay = Event(eventName: eventName, eventType: .Unknown)
    let eventViewModel = EventViewModel()
    
    // start spinner
    self.ShowSpinner()
    eventViewModel.checkIfEventExists(event: eventToPlay) { (result,snapshot)  in
      guard result else {
        self.infoView(message: "event is not Exist", color: Colors.smoothRed)
        return
      }
      guard let eventCodeFirebase = snapshot.childSnapshot(forPath: "code").value as? String else {
        self.infoView(message: "Couldn't retrive event Code", color: Colors.smoothRed)
        return
        
      }
      
      guard let eventTypeFirebase = snapshot.childSnapshot(forPath: "type").value as? String else {
        self.infoView(message: "Couldn't retrive event type", color: Colors.smoothRed)
        return
        
      }
      
      if eventCodeFirebase == eventCode {
        
        switch eventTypeFirebase {
        case "text":
          eventToPlay.eventType = .Text
        case "animation":
          eventToPlay.eventType = .Animation
        case "photo" :
          eventToPlay.eventType = .Photo
        default:
         break
        }
        
        
        
        self.showPlayEventViewController(event: eventToPlay)

      } else {
        self.infoView(message: "Code is not matching", color: Colors.smoothRed)

      }
      
      
    }
    self.HideSpinner()
    
  }
  
  // Push PlayEventViewController
  func showPlayEventViewController(event: Event) {
    let PlayViewController = PlayEventViewController(event: event)
    self.navigationController?.pushViewController(PlayViewController, animated: true)
    
  }
 

}

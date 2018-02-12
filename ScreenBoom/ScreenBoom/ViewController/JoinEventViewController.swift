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
  var baseDatabaseReference: DatabaseReference?
  var eventName: String?
  var eventCode: String?
  
  // Outlets
  @IBOutlet weak var eventNameTextField: UITextField!
  
  @IBOutlet weak var codeTextField: UITextField!
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      // Set firebase referance
      baseDatabaseReference = Database.database().reference()

        // Do any additional setup after loading the view.
    }

  
    
  @IBAction func goButtonPressed(_ sender: UIButton) {
    
    // check if textfields is empty
    guard let eventName = eventNameTextField.text, !eventName.isEmpty else {
      let message = "No event name!"
      self.infoView(message: message, color: Colors.smoothRed)
      return
    }
    guard let eventCode = codeTextField.text, !eventCode.isEmpty else {
      let message = "No Code!"
      self.infoView(message: message, color: Colors.smoothRed)
      return
    }

    
    
    
    
    
  }
  
 

}

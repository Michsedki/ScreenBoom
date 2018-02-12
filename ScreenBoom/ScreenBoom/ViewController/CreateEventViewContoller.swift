//
//  CreateEventViewContoller.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateEventViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
  
  // Varibales
  var firebaseDatabaseReference: DatabaseReference = Database.database().reference()
  
  let eventTypePickerviewDataSource = ["Text", "Picture", "Animation"]
  var currentEventType:EventType = .Text
  
  // Outlets
  @IBOutlet weak var eventNameTextfield: UITextField!
  
  @IBOutlet weak var eventTypePickerview: UIPickerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// Mask:- Delegate
    eventTypePickerview.delegate = self
    eventTypePickerview.dataSource = self
  }
  
  
  
  // PickerView Protocol
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return eventTypePickerviewDataSource.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return eventTypePickerviewDataSource[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    guard let eventType = EventType(rawValue: row) else { return }
    self.currentEventType = eventType
  }
  
  /// Mask:-  Buttons Functions
  @IBAction func createEventButtonPressed(_ sender: UIButton) {
    
    // prepare all data
    // check if textfields is empty
    guard let eventName = eventNameTextfield.text, !eventName.isEmpty else {
      let message = "No event name!"
      self.infoView(message: message, color: Colors.smoothRed)
      return
    }
    
    let currentEvent = Event(eventName: eventName, eventType: currentEventType)
    let eventViewModel = EventViewModel()
    
    // We need to show a spinner to wait for the network
    // request inside the configure method on the view model
    self.ShowSpinner()
    eventViewModel.configureWithEvent(event: currentEvent) { [weak self] eventExists in
      
      if eventExists {
        
        let message = "event name already exists"
        self?.infoView(message: message, color: Colors.smoothRed)
        
      }else{
        
        
        self?.ShowSpinner()
        
        // call addEvent
        eventViewModel.addEvent(event: currentEvent, completion: { (result) in
          switch result {
          case .Failure(let error):
            if let error = error {
              self?.infoView(message: error.localizedDescription, color: Colors.smoothRed)
            }
          case .Success(()):
            self?.infoView(message: "Event created successfully!", color: Colors.lightGreen)
          }
        })
        
        self?.HideSpinner()
        self?.showDetailViewController(eventName: eventName)
       
      }
      
      self?.HideSpinner()
    }
  }
  
  // add event to event Node with type and return code
  
//  func addEvent (eventName: String)  {
//
//
//    let eventCode = String.random()
//    let eventFIRReferance = firebaseDatabaseReference.child("Event").child(eventName)
//
//    // show spinner
//    self.ShowSpinner()
//
//
//
//    eventFIRReferance.setValue(["type":eventTypePickerviewDataSource[currentEventType.rawValue], "code":eventCode], withCompletionBlock: {[weak self] (error, databaseReference) in
//      if error != nil {
//        let message = error?.localizedDescription ?? "Event created faild!"
//        self?.infoView(message: message, color: Colors.smoothRed)
//      } else {
//        let message =  "Event created successfully!"
//        self?.infoView(message: message, color: Colors.lightGreen)
//      }
//
//
//
//
//
//    })
//    self.HideSpinner()
//    self.showDetailViewController(eventName: eventName)
//  }
//
  func showDetailViewController(eventName: String) {
    let detailViewController = EventDetailViewController(eventName: eventName)
    self.navigationController?.pushViewController(detailViewController, animated: true)
    
  }
  
  
  
  
  
  
  
}

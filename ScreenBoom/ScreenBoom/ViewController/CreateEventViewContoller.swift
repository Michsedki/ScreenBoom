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
  let eventViewModel = EventViewModel()
  
  
  let eventTypePickerviewDataSource = ["Text", "Photo", "Animation"]
  lazy var currentEventType:EventType = .Text
  
  // Outlets
  @IBOutlet weak var eventNameTextfield: UITextField!
  
  
  
  
  @IBOutlet weak var eventTypePickerview: UIPickerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// Mark:- Delegate
    eventTypePickerview.delegate = self
    eventTypePickerview.dataSource = self
    eventNameTextfield.delegate = self
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
    var eventType: EventType
    switch (row) {
    case 0:
      eventType = .Text
    case 1:
      eventType = .Photo
    case 2:
      eventType = .Animation
    default:
      eventType = .Unknown
    }
    
    self.currentEventType = eventType
  }
  
  /// Mark:-  Buttons Functions
  @IBAction func createEventButtonPressed(_ sender: UIButton) {
    
    // prepare all data
    // check if textfields is empty
    guard let eventName = eventNameTextfield.text, !eventName.isEmpty else {
      self.infoView(message: "No event name!", color: Colors.smoothRed)
      return
    }
    let currentEvent = Event(eventName: eventName, eventIsLive: "no", eventType: currentEventType, eventCode: "")
    ShowSpinner()
    eventViewModel.checkIfEventExists(event: currentEvent) { (isExist, _) in
      if isExist {
        self.infoView(message: "Event name is Already Exist", color: Colors.smoothRed)
      } else {
        self.showDetailViewController(event : currentEvent)
      }
    }
    HideSpinner()
    
  }
  
  
  func showDetailViewController(event: Event) {
 
    let detailViewController = EventDetailViewController(event: event)
    self.navigationController?.pushViewController(detailViewController, animated: true)
    
  }
  
  
  
  
  
  
  
}

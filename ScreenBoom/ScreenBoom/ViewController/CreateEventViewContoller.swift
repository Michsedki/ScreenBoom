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
  
  let eventTypePickerviewDataSource = ["Text", "Photo", "Animation"]
  var currentEventType:EventType = .Text
  
  // Outlets
  @IBOutlet weak var eventNameTextfield: UITextField!
  
  @IBOutlet weak var eventTypePickerview: UIPickerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    /// Mark:- Delegate
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
      let message = "No event name!"
      self.infoView(message: message, color: Colors.smoothRed)
      return
    }
    
    let currentEvent = Event(eventName: eventName, eventIsLive: "no", eventType: currentEventType)
    let eventViewModel = EventViewModel()
    
    // We need to show a spinner to wait for the network
    // request inside the configure method on the view model
    self.ShowSpinner()
    eventViewModel.configureWithEvent(event: currentEvent) { [weak self] result in
      
      switch result {
      case .Failure(let error):
        
          self?.infoView(message: error, color: Colors.smoothRed)
        
      case .Success(()):
        
        //************* Should we remove the show spinner line it is already shown
        self?.ShowSpinner()
        
        // call addEvent
        eventViewModel.addEvent(event: currentEvent, completion: { (result) in
          switch result {
          case .Failure(let error):
            
              self?.infoView(message: error, color: Colors.smoothRed)
            
          case .Success(()):
            self?.infoView(message: "Event created successfully!", color: Colors.lightGreen)
            //****** i moved this line from down there
            self?.showDetailViewController(event : currentEvent)
          }
        })
        self?.HideSpinner()
        //****** moved line to inside the add event call in the success state of the switch
       
      }
      
      self?.HideSpinner()
    }
  }
  
 
  func showDetailViewController(event: Event) {
    let detailViewController = EventDetailViewController(event: event)
    self.navigationController?.pushViewController(detailViewController, animated: true)
    
  }
  
  
  
  
  
  
  
}

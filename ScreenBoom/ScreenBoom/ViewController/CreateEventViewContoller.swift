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
  let eventViewModel = EventViewModel()
  let eventDetailViewModel = EventDetailViewModel()
  let eventTypePickerviewDataSource = ["Text", "Photo", "Animation"]
  var currentEventType:EventType = .Text
  let constantNames = ConstantNames()
  
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
    
    let currentEvent = Event(eventName: eventName, eventIsLive: "no", eventType: self.currentEventType, eventCode: "")
    
    ShowSpinner()
    eventViewModel.checkIfEventExists(event: currentEvent) { (isExist, eventSnapShot) in
      if !isExist {
        self.showDetailViewController(event : currentEvent, eventDetail: nil)
      } else {
    guard let eventCodeFirebase = eventSnapShot?.childSnapshot(forPath: "code").value as? String,
       let eventTypeFirebase = eventSnapShot?.childSnapshot(forPath: "type").value as? String,
       let eventIsLiveFirebase = eventSnapShot?.childSnapshot(forPath: "islive").value as? String,
       let eventuserIDFirebase = eventSnapShot?.childSnapshot(forPath: "userid").value as? String,
       let userID = UserDefaults.standard.object(forKey: self.userDefaultKeyNames.userIDKey) as? String,
        eventuserIDFirebase == userID else {
          // if event name is exist and the user is not the owner of the event
          self.infoView(message: "Event name is Already Exist", color: Colors.smoothRed)
          return
        }
        // set current event with firebase old event information
        currentEvent.eventIsLive = eventIsLiveFirebase
        currentEvent.eventCode = eventCodeFirebase
        currentEvent.userID = eventuserIDFirebase
        if eventTypeFirebase == currentEvent.eventType.rawValue {
          // same type
          self.eventDetailViewModel.checkIfEventDetailExist(event: currentEvent, completion: { (result) in
            switch result {
            case .Failure( _):
              self.showDetailViewController(event : currentEvent, eventDetail: nil)
              break
            case .Success(let eventDetail):
              self.showDetailViewController(event : currentEvent, eventDetail: eventDetail)
              break
            }
          })
          //tell the showDetailViewController that is old event to drow it
        } else {
          // deferent type
          // remove the old one before you show the event detail view controller
          currentEvent.eventType = EventType(rawValue: eventTypeFirebase)!
          self.ShowSpinner()
          self.eventDetailViewModel.removeEventAndEventDetail(event: currentEvent, eventDetail: nil, completion: { (result) in
            switch result {
            case .Failure( _):
              self.infoView(message: "Event name is Already Exist", color: Colors.smoothRed)
              break
            case .Success(()):
              currentEvent.eventType = self.currentEventType
              self.showDetailViewController(event : currentEvent, eventDetail: nil)
              break
            }
          })
          self.HideSpinner()
        }
      }
      
    }
    HideSpinner()
  }
  
  func showDetailViewController(event: Event, eventDetail : EventDetail?) {
    var eventDetailItem = EventDetail()
    switch event.eventType {
    case .Text:
      eventDetailItem = EventDetail(
        animationStringURL: nil,
        animationName: constantNames.animationNamesArray[0],
        photoname: nil,
        backgroundcolor: constantNames.colorsNamesList[3],
        textcolor: constantNames.colorsNamesList[0],
        speed: "",
        text: "Your Text",
        code: "",
        font: constantNames.fontNames[0],
        fontsize: constantNames.fontsize[25] )
      break
    case .Photo:
      eventDetailItem = EventDetail(
        animationStringURL: nil,
        animationName: nil,
        photoname: "Place holder",
        backgroundcolor: nil,
        textcolor: nil,
        speed: nil,
        text: nil,
        code: "",
        font: nil,
        fontsize: nil )
      break
    case .Animation:
      eventDetailItem = EventDetail(
        animationStringURL: constantNames.gifAnimationNamesArray[0],
        animationName: nil,
        photoname: nil,
        backgroundcolor: nil,
        textcolor: nil,
        speed: nil,
        text: nil,
        code: "",
        font: nil,
        fontsize: nil )
      break
    case .Unknown:
      break
      
    }
    
    if let eventDetail = eventDetail {
       eventDetailItem = eventDetail
    }
    let eventDetailViewController = EventDetailViewController(event: event,eventDetail : eventDetailItem)
    self.navigationController?.pushViewController(eventDetailViewController, animated: true)
  }
  
  
}

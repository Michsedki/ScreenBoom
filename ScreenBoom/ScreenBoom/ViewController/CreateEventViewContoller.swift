//
//  CreateEventViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class CreateEventViewController: BaseViewController {
    
    /// Mark:- Constants
    let constantNames = ConstantNames.sharedInstance
    
    /// Mark:- Varibales
    let eventViewModel = EventManager()
    let eventDetailViewModel = EventDetailViewModel()
    let eventTypePickerviewDataSource = ["Text", "Photo", "Animation"]
    var currentEventType:EventType = .Text
    var createdEvents = [[String:String]]()
    
    /// Mark:- Outlets
    @IBOutlet weak var eventNameTextfield: UITextField!
    @IBOutlet weak var eventTypePickerview: UIPickerView!
    @IBOutlet weak var max10EventsLabel: UILabel!
    @IBOutlet weak var createdEventsTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Mark:- Delegate
        eventTypePickerview.delegate = self
        eventTypePickerview.dataSource = self
        eventNameTextfield.delegate = self
        createdEventsTableView.delegate = self
        createdEventsTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // we need to show the navigation bar after it was hidden in the homeViewController
        self.navigationController?.isNavigationBarHidden = false
        
        // disaple Rotation for this view controller
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = false
        
        
        // we will check number of created events by current user if equal to 10 we will
        // disable the createEventButton untill the user delete some events
        checkUserCreatedEventsCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // allow rotation for other viewControllers
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = true
    }
    
    
    func checkUserCreatedEventsCount() {
        FireBaseManager.sharedInstance.getUserCreatedEvents { (result) in
            switch result {
            case .Failure(let error):
                print(error)
            case .Success(let createdEvents):
                self.createdEvents = createdEvents
                self.createdEventsTableView.reloadData()
                print(createdEvents)
            }
        }
    }
    
    
    @IBAction func addNewEventBarButtonPressed(_ sender: UIBarButtonItem) {
        // check if user has 10 events already, if yes show info message
        // check if we have the event name and event type, by checking the value of the
        // textfield and pickerView
        // then create currentEvent with standard values eventName, eventISLive : "no", eventType
        // and eventCode : ""
        // check if the event name is exist in the Event node and show info message if exist
        // if not show event detail view controller
        
        guard self.createdEvents.count < 10 else {
            self.infoView(message: "10 Events reached", color: Colors.smoothRed)
            return
        }
        
        guard let eventName = eventNameTextfield.text, !eventName.isEmpty else {
            self.infoView(message: "No event name!", color: Colors.smoothRed)
            return
        }
        // create current event with current userID
        let currentEvent = Event(eventName: eventName,
                                 eventIsLive: "no",
                                 eventType: self.currentEventType,
                                 eventCode: "")
        
        ShowSpinner()
        eventViewModel.checkIfEventExists(newEvent: currentEvent) { (isExist, eventObj) in
            if !isExist {
                self.showDetailViewController(event : currentEvent, eventDetail: nil)
            } else {
                guard let eventFound = eventObj else {
                    // couldn't retrive the event data from firebase snapshot
                    self.infoView(message: "Event name is Already Exist", color: Colors.smoothRed)
                    return
                }
                
                guard eventFound.userID == currentEvent.userID else {
                    // user is not the owner of the event, so he can't change it
                    self.infoView(message: "Event name is Already Exist", color: Colors.smoothRed)
                    return
                }
                
                if eventFound.eventType == currentEvent.eventType {
                    // same type
                    // tell the showDetailViewController that is old event to drow it
                    //  **** no need to get the eventDetail here as long as we will get it
                    // in the next view controller
                    self.eventDetailViewModel.checkIfEventDetailExist(event: eventFound, completion: { (result) in
                        switch result {
                        case .Failure( _):
                            self.showDetailViewController(event : eventFound, eventDetail: nil)
                            break
                        case .Success(let eventDetail):
                            self.showDetailViewController(event : eventFound, eventDetail: eventDetail)
                            break
                        }
                    })
                    
                } else {
                    // deferent type
                    // remove the old one before you show the event detail view controller
                    self.ShowSpinner()
                    self.eventDetailViewModel.removeEventAndEventDetail(event: eventFound, eventDetail: nil, completion: { (result) in
                        switch result {
                        case .Failure( _):
                            self.infoView(message: "Event name is Already Exist", color: Colors.smoothRed)
                            break
                        case .Success(()):
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
        var eventDetailItem:EventDetail
        var eventDetailVC: EventDetailViewController?
        
        switch event.eventType {
        case .Text:
            if let oldTextEventDetail = eventDetail {
                eventDetailItem = oldTextEventDetail
            } else {
                eventDetailItem = TextEventDetail(
                    animationName: constantNames.animationNamesArray[0],
                    backgroundcolor: constantNames.colorsNamesList[3],
                    textcolor: constantNames.colorsNamesList[0],
                    speed: 0,
                    text: "Your Text",
                    font: constantNames.fontNames[0],
                    fontsize: 25,
                    code: "")
            }
            guard let textEventDetail = eventDetailItem as? TextEventDetail else { return }
            eventDetailVC = TextEventDetailViewController(event: event, eventDetail: textEventDetail)
            break
            
        case .Photo:
            if let oldPhotoEventDetail = eventDetail {
                eventDetailItem = oldPhotoEventDetail
            } else {
                eventDetailItem = PhotoEventDetail(
                    photoname: imageNames.placeHolder,
                    code: "")
            }
            guard let photoEventDetail = eventDetailItem as? PhotoEventDetail else { return }
            eventDetailVC = PhotoEventDetailViewController(event: event, eventDetail: photoEventDetail)
            break
            
        case .Animation:
            if let oldAnimationEventDetail = eventDetail {
                eventDetailItem = oldAnimationEventDetail
            } else {
                eventDetailItem = AnimationEventDetail(
                    animationStringURL: constantNames.gifAnimationNamesArray[0],
                    code: "")
            }
            guard let animationEventDetail = eventDetailItem as? AnimationEventDetail else { return }
            eventDetailVC = AnimationEventDetailViewController(event: event, eventDetail: animationEventDetail)
            break
            
        case .Unknown:
            
            eventDetailVC = nil
            break
            
        }
        
        if let vc = eventDetailVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}

// Extension to handle the PickerView Protocol
extension CreateEventViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
}

// Extension to handle the createdEvents TableView Protocol

extension CreateEventViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.createdEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.createdEventsTableView.dequeueReusableCell(withIdentifier: "CreatedEventsTableViewCell", for: indexPath) as? CreatedEventsTableViewCell {
            if let eventName = self.createdEvents[indexPath.row]["eventName"],
                let eventCode = self.createdEvents[indexPath.row]["eventCode"] {
                cell.label.text = "Event: \(eventName) \nCode: \(eventCode)"
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
    
    
    
    
}



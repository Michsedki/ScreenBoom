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
  var eventViewModel = EventManager()
  var eventDetailViewModel = EventDetailViewModel()
    
  // Outlets
  @IBOutlet weak var eventNameTextField: UITextField!
  @IBOutlet weak var codeTextField: UITextField!
  @IBOutlet weak var joinButton: UIButton!
  
  let lastEventLabel : UILabel = {
    let view = UILabel()
    view.numberOfLines = 0
    view.textAlignment = .center
    view.sizeToFit()
    view.adjustsFontSizeToFitWidth = true
    view.backgroundColor = UIColor.lightGray
    return view
  }()
  let joinLastEventButton : UIButton = {
    let view = UIButton()
    view.setTitle("Join last Event.", for: .normal)
    view.backgroundColor = UIColor.blue
    return view
  }()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
    setupJoinLastEventView()
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
    getEventAndCmpareCode(eventName: eventName, eventCode: eventCode)
    //
  }
  
  func getEventAndCmpareCode(eventName: String, eventCode: String) {
    
    self.event = Event(eventName: eventName, eventIsLive: "no", eventType: .Unknown, eventCode: eventCode)
    // start spinner
    self.ShowSpinner()
    guard let event = self.event else { return }
    eventViewModel.checkIfEventExists(event: event) { [unowned self] (result,snapshot)  in
      guard result else {
        self.infoView(message: "event is not Exist", color: Colors.smoothRed)
        return
      }
      guard let eventCodeFirebase = snapshot?.childSnapshot(forPath: "code").value as? String,
            let eventTypeFirebase = snapshot?.childSnapshot(forPath: "type").value as? String,
            let eventIsLiveFirebase = snapshot?.childSnapshot(forPath: "islive").value as? String,
            let eventUserIDFirebase = snapshot?.childSnapshot(forPath: "userid").value as? String
        else {
          self.infoView(message: "Couldn't retrive event", color: Colors.smoothRed)
          return
      }
      if eventCodeFirebase == eventCode {
        event.eventIsLive = eventIsLiveFirebase
        event.userID = eventUserIDFirebase
        switch eventTypeFirebase {
        case "text":
          event.eventType = .Text
        case "animation":
          event.eventType = .Animation
        case "photo" :
          event.eventType = .Photo
        default:
          event.eventType = .Unknown
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
  
  func setupJoinLastEventView() {
    guard let lastEventName = self.userDefaultICloudViewModel.checkIfOldEventNameIsExist() ,
      let lastEventCode = self.userDefaultICloudViewModel.checkIfOldEventCodeIsExist() else { return }
    lastEventLabel.text = "Last Event \n Title : \(lastEventName) \n Code : \(lastEventCode)"
    joinLastEventButton.addTarget(self, action: #selector(joinLastEventButtonPressed), for: .touchUpInside)
    self.view.addSubview(lastEventLabel)
    self.view.addSubview(joinLastEventButton)
    lastEventLabel.anchor(top: joinButton.bottomAnchor,
                          leading: self.view.leadingAnchor,
                          bottom: nil,
                          trailing: self.view.trailingAnchor,
                          padding: .init(top: 40, left: 20, bottom: 0, right: 20),
                          size: .init(width: 0, height: 50))
    joinLastEventButton.anchor(top: lastEventLabel.bottomAnchor,
                               leading: self.view.leadingAnchor,
                               bottom: nil,
                               trailing: self.view.trailingAnchor,
                               padding: .init(top: 8, left: 20, bottom: 0, right: 20),
                               size: .init(width: 0, height: 40))
    
  }
  @objc func joinLastEventButtonPressed (){
    if let lastEventName = self.userDefaultICloudViewModel.checkIfOldEventNameIsExist() ,
      let lastEventCode = self.userDefaultICloudViewModel.checkIfOldEventCodeIsExist() {
      getEventAndCmpareCode(eventName: lastEventName, eventCode: lastEventCode)
    } else {
      lastEventLabel.text = "We have a problem!"
      lastEventLabel.textColor = UIColor.red
      joinLastEventButton.isEnabled = false
    }
    
  }

  // Push PlayEventViewController
  func showPlayEventViewController(event: Event, eventDetail: EventDetail) {
    let PlayViewController = PlayEventViewController(event: event, eventDetail:eventDetail)
    self.navigationController?.pushViewController(PlayViewController, animated: true)
  }
}


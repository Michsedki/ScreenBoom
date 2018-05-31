//
//  PlayEventViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/8/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PlayEventViewController: BaseViewController, PlayEventViewModelSourceObserver {
  
  func update(viewModel: PlayEventViewModel) {
    self.playEventView?.configure(viewModel: viewModel)
  }
  
  // variables
  var event: Event
  var eventDetail: EventDetail
  var eventManager = EventManager()
  var eventDetailManager = EventDetailManager()
  var playEventView: PlayEventView?
  var rightMenuView: RightMenuView?
  var playEventViewModelSource: PlayEventViewModelSource?
  var isShowEventNameAndCodeLabel = false
  
  // init
  init (event:Event, eventDetail: EventDetail) {
    self.event = event
//    var tempEventDetail : EventDetail?
//    if let texteventDetail = eventDetail as? TextEventDetail {
//        print(texteventDetail.text)
//        tempEventDetail = texteventDetail
//    }
    self.eventDetail = eventDetail
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // setup observation.
    
    self.playEventViewModelSource = PlayEventViewModelSource(event: self.event, eventDetail: eventDetail)
    self.playEventViewModelSource?.addObserver(observer: self)
    self.playEventViewModelSource?.configureWithFirebaseUpdatedEvent()
    self.playEventViewModelSource?.configureWithFirebaseUpdateEventDetail()
    
    saveUserDefaultOldEventAndUserID()
    
    setupViews()
    
  }
  
  //AddSwipeGesture
  func addSwipGuestureRecognizers() {
    [UISwipeGestureRecognizerDirection.right,
     UISwipeGestureRecognizerDirection.left,
     UISwipeGestureRecognizerDirection.up,
     UISwipeGestureRecognizerDirection.down].forEach { (direction) in
      let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
      swipe.direction = direction
      self.view.addGestureRecognizer(swipe)
    }
  }
  //respondToSwipeGesture
  @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer
    {
      switch swipeGesture.direction
      {
      case UISwipeGestureRecognizerDirection.right:
        if isShowEventNameAndCodeLabel {
          isShowEventNameAndCodeLabel = false
          self.rightMenuView?.frame.origin.x = self.view.frame.maxX - 10
        }
        print("Swiped right")
      case UISwipeGestureRecognizerDirection.down:
        self.navigationController?.isNavigationBarHidden = false
        print("Swiped down")
      case UISwipeGestureRecognizerDirection.left:
        if !isShowEventNameAndCodeLabel {
          isShowEventNameAndCodeLabel = true
          self.rightMenuView?.frame.origin.x =  self.view.frame.maxX - 80
        }
        print("Swiped left")
      case UISwipeGestureRecognizerDirection.up:
        self.navigationController?.isNavigationBarHidden = true
        print("Swiped up")
      default:
        break
      }
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    if let playView = playEventView {
        self.view.addSubview(playView)
        playView.frame = CGRect(x: 0,
                                y: 0,
                                width: size.width,
                                height: size.height)
    }
    
    if let rightMenu = rightMenuView {
        rightMenu.frame = CGRect(x: size.width - 10,
                                 y: 0,
                                 width: 80,
                                 height: size.height)
        self.view.bringSubview(toFront: rightMenu)
    }
    
   
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    self.navigationController?.isNavigationBarHidden = false
   
    addSwipGuestureRecognizers()
    
    // add user to list of viewer
    addToViewList()
    
    // add Event To User Log
//    addEventToUserEvents()
    
    // Now that the view has been loaded we can safely setup our
    // constraints
    setupConstraints()
    
    setupSideMenu()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    removeFromViewList()
    self.playEventViewModelSource?.removeObserver(observer: self)
  }
  
  // Here we want to setup the correct play view based on the the event type that we have
  // we switch on the event type and add the appropriate playView to our view hierarchy
  func setupViews() {
    var playView: PlayEventView?
    
    switch (self.event.eventType) {
    case .Text:
      playView = TextPlayEventView()
      break
    case .Photo:
      playView = PhotoPlayEventView()
      break
    case .Animation:
      playView = AnimationPlayEventView()
      break
    case .Unknown:
      playView = nil
      break
    }
    
    guard let finalPlayView = playView else { return }
    self.playEventView = finalPlayView
  }
  
  func setupConstraints() {
    if let playView = playEventView {
      self.view.addSubview(playView)
      playView.frame = CGRect(x: 0,
                              y: 0,
                              width: self.view.bounds.width,
                              height: self.view.bounds.height)
    }
    
  }
  
  func setupSideMenu() {
    
    let rightMenu = RightMenuView()
    
    self.view.addSubview(rightMenu)
    rightMenu.frame = CGRect(x: self.view.frame.maxX - 10,
                             y: 0,
                             width: 80,
                             height: self.view.frame.height)
    
    rightMenu.configureWith(event: self.event, eventCode: self.event.eventCode)
   
    self.view.bringSubview(toFront: rightMenu)
    self.rightMenuView = rightMenu
    
    // Delegates
    self.rightMenuView?.sideMenuDelegate = self
  }
  
  
//  func addEventToUserEvents() {
//    if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
//      firebaseDatabaseReference.child(firebaseNodeNames.eventUsersNodeChild).child(userID).child(self.event.eventName).setValue(
//        [firebaseNodeNames.eventNodeCodeChild: self.eventDetail.code,
//         firebaseNodeNames.isOwnerChild: self.event.userID == userID ?  firebaseNodeNames.isOwnerYesValue : firebaseNodeNames.isOwnerNoValue], withCompletionBlock: { (error, _) in
//          if error != nil {
//            print("Couldn't Add Event to User Log, Error: \(String(describing: error?.localizedDescription))")
//          }
//      })
//    }
//  }
//  func removeFromUserEvents() {
//    if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
//      firebaseDatabaseReference.child(firebaseNodeNames.eventUsersNodeChild).child(userID).child(self.event.eventName).removeValue(completionBlock: { (error, _) in
//        if error != nil {
//          print("Couldn't remove Event From User Log, Error: \(String(describing: error?.localizedDescription))")
//        }
//      })
//    }
//  }
  
  // add user to list of viewer
  func addToViewList() {
    if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String,
      userID != self.event.userID {
      firebaseDatabaseReference.child(firebaseNodeNames.eventDetailNode).child(self.event.eventName).child("views").child(userID).setValue("", withCompletionBlock: { (error, _) in
        if error != nil {
          print("Couldn't add user to views, Error: \(String(describing: error?.localizedDescription))")
        }
      })
    }
  }
  // remove user from list of viewer
  func removeFromViewList() {
    if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String,
      userID != self.event.userID {
      firebaseDatabaseReference.child(firebaseNodeNames.eventDetailNode).child(self.event.eventName).child("views").child(userID).removeValue(completionBlock: { (error, _) in
        if error != nil {
          print("Couldn't remove user from views, Error: \(String(describing: error?.localizedDescription))")
        }
      })
    }
    
  }
  
  func saveUserDefaultOldEventAndUserID(){
    UserDefaults.standard.set(self.event.eventName, forKey: userDefaultKeyNames.eventNameKey)
    UserDefaults.standard.set(self.event.eventCode, forKey: userDefaultKeyNames.eventCodeKey)
  }
  
  
}

extension PlayEventViewController: SideMenuDelegate {
  func sideMenuEditButtonPressed() {
    // Here we need to implement update feature
  }
  
  func sideMenuShareButtonPressed() {
    
    // Here it should present the Activity View Controller to send the event Deep link URL
    // useing Email or SMS    
   let deepLinkURL =  DeepLinkManager.sharedInstance.shareMyDeepLinkURL(eventName: self.event.eventName, eventCode: self.event.eventCode)
    let activityController = UIActivityViewController(activityItems: [deepLinkURL], applicationActivities: nil)
    
    present(activityController, animated: true, completion: nil)
  }
  
  func sideMenuPlayButtonPressed() {
//    for view in (self.playEventView?.subviews)! {
//      view.removeFromSuperview()
//    }
    ShowSpinner()
    
    eventManager.updateEvenIsLive(event: self.event, isLive: firebaseNodeNames.eventNodeIsLiveYesValue) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
      case .Success():
        self.infoView(message: "Play", color: Colors.lightGreen)
      }
    }
    
    HideSpinner()
  }
  
  func sideMenuDeleteButtonPressed() {
    
    ShowSpinner()
    
    eventDetailManager.removeEventDetailWithEventAndEventDetail(event: self.event, eventDetail: self.eventDetail) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
        break
      case .Success():
        self.infoView(message: "Event Deleted successfully", color: Colors.lightGreen)
        // set the eventDetail.photoName in the event detail view controller
        self.navigationController?.popViewController(animated: true)
        break
      }
    }
    
    HideSpinner()
    
  }
  
  func sideMenuPauseButtonPressed() {
//    for view in (self.playEventView?.subviews)! {
//      view.removeFromSuperview()
//    }
    ShowSpinner()
    
    eventManager.updateEvenIsLive(event: self.event, isLive: firebaseNodeNames.eventNodeIsLivePauseValue) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
      case .Success():
        self.infoView(message: "Pause", color: Colors.lightGreen)
      }
    }
    
    HideSpinner()
  }
  
  
}















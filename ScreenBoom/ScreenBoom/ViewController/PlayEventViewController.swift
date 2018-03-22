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
  var eventViewModel = EventViewModel()
  var eventDetailViewModel = EventDetailViewModel()
  var playEventView: PlayEventView?
  var rightMenuView: RightMenuView?
  var playEventViewModelSource: PlayEventViewModelSource?
  var isPreviewInDetailEventViewController: Bool
  var isShowEventNameAndCodeLabel = false
  var setPhotoEventDetailDelegate : SetPhotoEventDetailDelegate!
  // init
  init (event:Event, eventDetail: EventDetail, isPreviewInDetailEventViewController: Bool) {
    self.event = event
    self.eventDetail = eventDetail
    self.isPreviewInDetailEventViewController = isPreviewInDetailEventViewController
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    if !isPreviewInDetailEventViewController {
      // PlayEventViewController is playing event live and not previewing in EventDetailViewController
      // setup observation.
      self.playEventViewModelSource = PlayEventViewModelSource(event: self.event, eventDetail: eventDetail)
      self.playEventViewModelSource?.addObserver(observer: self)
      self.playEventViewModelSource?.configureWithFirebaseUpdatedEvent()
      self.playEventViewModelSource?.configureWithFirebaseUpdateEventDetail()
      saveUserDefaultOldEventAndUserID()
      
      
    }
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
        print("Swiped down")
      case UISwipeGestureRecognizerDirection.left:
        if !isShowEventNameAndCodeLabel {
          isShowEventNameAndCodeLabel = true
          self.rightMenuView?.frame.origin.x =  self.view.frame.maxX - 80
        }
        print("Swiped left")
      case UISwipeGestureRecognizerDirection.up:
        print("Swiped up")
      default:
        break
      }
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    playEventViewModelSource?.configureWithViewWillTransition()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupViews()
    addSwipGuestureRecognizers()
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.setPhotoEventDetailDelegate?.updateOldEventDetail(oldEventDetail: self.eventDetail)
    self.setPhotoEventDetailDelegate?.updateEventDetailPhotoNameDelegate(eventDetailPhotoName: self.userDefaultKeyNames.savedImageCodeKey)
    removeFromViewList()
  }
  
  func setupViews() {
    // create playEventView to view the events
    let playEventView = PlayEventView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: self.view.bounds.width,
                                                    height: self.view.bounds.height))
    self.view.addSubview(playEventView)
    // PlayEventViewController is previewing in EventDetailViewController and not playing event live
    if isPreviewInDetailEventViewController {
      let viewModel = PlayEventViewModel(event: self.event, eventDetail: self.eventDetail)
      playEventView.configure(viewModel: viewModel)
    }
    self.playEventView = playEventView
    if !isPreviewInDetailEventViewController{
      // create rightMenuView to show options
      let rightMenuView = RightMenuView(frame: CGRect(x: self.view.frame.maxX - 10,
                                                      y: 0,
                                                      width: 80,
                                                      height: self.view.frame.height))
      self.view.addSubview(rightMenuView)
      rightMenuView.configureWith(eventName: self.event.eventName, eventCode: self.event.eventCode)
      rightMenuView.eventNameAndCodeButtonLabel.setTitle("Title: \(self.event.eventName) \n Code: \(self.event.eventCode)", for: .normal)
      rightMenuView.shareImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGuestureOnShareImage)))
      rightMenuView.pauseImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGestureOnPauseImage)))
      rightMenuView.playImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizerOnPlayImage)))
      rightMenuView.deleteImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGestureRecognizerOnDeleteImage)))
      rightMenuView.editButton.addTarget(self, action: #selector(handleEditButtonPressed(_:)), for: .touchUpInside)
      // show this options for event owner only (Edit, play, pause and delete)
      if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String,
        userID == self.event.userID {
        print("isOwner")
        [rightMenuView.editButton, rightMenuView.deleteImage, rightMenuView.pauseImage, rightMenuView.playImage].forEach{$0.isHidden = false}
      }
      // add user to list of viewer
     addToViewList()
      // add Event To User Log
      addEventToUserEvents()
      self.view.bringSubview(toFront: rightMenuView)
      self.rightMenuView = rightMenuView
    }
  }
  
  
  func addEventToUserEvents() {
    if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
      firebaseDatabaseReference.child(firebaseNodeNames.eventUsersNodeChild).child(userID).child(self.event.eventName).setValue(
        [firebaseNodeNames.eventNodeCodeChild: self.event.eventCode,
         firebaseNodeNames.isOwnerChild: self.event.userID == userID ?  firebaseNodeNames.isOwnerYesValue : firebaseNodeNames.isOwnerNoValue], withCompletionBlock: { (error, _) in
          if error != nil {
            print("Couldn't Add Event to User Log, Error: \(String(describing: error?.localizedDescription))")
          }
      })
    }
  }
  func removeFromUserEvents() {
    if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
      firebaseDatabaseReference.child(firebaseNodeNames.eventUsersNodeChild).child(userID).child(self.event.eventName).removeValue(completionBlock: { (error, _) in
        if error != nil {
          print("Couldn't remove Event From User Log, Error: \(String(describing: error?.localizedDescription))")
        }
      })
    }
  }
  
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
  
  
  // handle Edit button pressed
  @objc func handleEditButtonPressed(_ sender: UIButton) {
    
  }
  
  // handle tap gesture recognizer on delete image
  @objc func handleTapGestureRecognizerOnDeleteImage() {
    ShowSpinner()
    eventDetailViewModel.removeEventDetailWithEventAndEventDetail(event: self.event, eventDetail: self.eventDetail) { (result) in
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
  
  // handle tap gesture recognizer on the Play image
  @objc func handleTapGestureRecognizerOnPlayImage() {
    rightMenuView?.pauseImage.image = UIImage(named: imageNames.pauseEnable)
    rightMenuView?.playImage.image = UIImage(named: imageNames.playNotEnable)
    rightMenuView?.pauseImage.isUserInteractionEnabled = true
    rightMenuView?.playImage.isUserInteractionEnabled = false
    ShowSpinner()
    eventViewModel.updateEvenIsLive(event: self.event, isLive: firebaseNodeNames.eventNodeIsLiveYesValue) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
      case .Success():
        self.infoView(message: "Play", color: Colors.lightGreen)
      }
    }
    HideSpinner()
  }
  
  // handle tap gesture recognizer on the Pause image
  @objc func handleTapGestureOnPauseImage() {
    rightMenuView?.pauseImage.image = UIImage(named: imageNames.pauseNotEnable)
    rightMenuView?.playImage.image = UIImage(named: imageNames.playEnable)
    rightMenuView?.pauseImage.isUserInteractionEnabled = false
    rightMenuView?.playImage.isUserInteractionEnabled = true
    ShowSpinner()
    eventViewModel.updateEvenIsLive(event: self.event, isLive: firebaseNodeNames.eventNodeIsLivePauseValue) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
      case .Success():
        self.infoView(message: "Pause", color: Colors.lightGreen)
      }
    }
    HideSpinner()
  }
  // handle tap gesture recognizer on the share image
  @objc func handleTapGuestureOnShareImage() {
    let deepLinkURL = "sbdl://screenBoomEvent/joinDL/\(self.event.eventName)/\(self.event.eventCode)"
    let activityController = UIActivityViewController(activityItems: [deepLinkURL], applicationActivities: nil)
    present(activityController, animated: true, completion: nil)
  }
  func saveUserDefaultOldEventAndUserID(){
    UserDefaults.standard.set(self.event.eventName, forKey: userDefaultKeyNames.eventNameKey)
    UserDefaults.standard.set(self.eventDetail.code, forKey: userDefaultKeyNames.eventCodeKey)
  }

  
}

















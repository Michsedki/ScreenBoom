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
  var firebaseDatabaseReference: DatabaseReference = Database.database().reference()
  var playEventView: PlayEventView?
  var rightMenuView: RightMenuView?
  var playEventViewModelSource: PlayEventViewModelSource?
  var isPreviewInDetailEventViewController: Bool
  var isShowEventNameAndCodeLabel = false
  
  
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
          self.rightMenuView?.frame.origin.x =  self.view.frame.maxX - 110
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
    saveUserDefaultOldEventAndUserID()
    addSwipGuestureRecognizers()
    
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
      playEventView.configure(viewModel: PlayEventViewModel(event: self.event, eventDetail: self.eventDetail))
    }
    self.playEventView = playEventView
    if !isPreviewInDetailEventViewController{
    // create rightMenuView to show options
    let rightMenuView = RightMenuView(frame: CGRect(x: self.view.frame.maxX - 10,
                                                    y: 0,
                                                    width: 120,
                                                    height: self.view.frame.height))
    self.view.addSubview(rightMenuView)
    self.rightMenuView = rightMenuView
    rightMenuView.configureWith(eventName: self.event.eventName, eventCode: self.event.eventCode)
    self.view.bringSubview(toFront: rightMenuView)
    self.rightMenuView?.label.text = "Title: \n \(self.event.eventName) \n Code: \n \(self.event.eventCode)"
    self.rightMenuView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGuestureOnShareImage)))
    }
  }
  // handle tap gesture recognizer on the share image
  @objc func handleTapGuestureOnShareImage() {
    let activityController = UIActivityViewController(activityItems: [self.rightMenuView?.label.text ?? "Ops we have a problem sharing this Event!"], applicationActivities: nil)
    present(activityController, animated: true, completion: nil)
  }
  func saveUserDefaultOldEventAndUserID(){
    UserDefaults.standard.set(self.event.eventName, forKey: userDefaultKeyNames.eventNameKey)
    UserDefaults.standard.set(self.eventDetail.code, forKey: userDefaultKeyNames.eventCodeKey)
    
    
  }
  
}

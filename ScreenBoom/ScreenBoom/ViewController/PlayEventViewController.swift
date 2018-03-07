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
  var playEventViewModelSource: PlayEventViewModelSource?
  var isPreviewInDetailEventViewController: Bool
  
  
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
  
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      playEventViewModelSource?.configureWithViewWillTransition()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupViews()
    saveUserDefaultOldEventAndUserID()
  }
  func setupViews() {
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
  }
  
  func saveUserDefaultOldEventAndUserID(){
    UserDefaults.standard.set(self.event.eventName, forKey: userDefaultKeyNames.eventNameKey)
    UserDefaults.standard.set(self.eventDetail.code, forKey: userDefaultKeyNames.eventCodeKey)
    
    
  }
  
}

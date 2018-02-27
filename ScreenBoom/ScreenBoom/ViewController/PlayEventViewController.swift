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
  
  // init
    init (event:Event, eventDetail: EventDetail) {
    self.event = event
    self.eventDetail = eventDetail
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
      setupViews()
    
      // setup observation.
      self.playEventViewModelSource = PlayEventViewModelSource(event: self.event, eventDetail: eventDetail)
      self.playEventViewModelSource?.addObserver(observer: self)
      self.playEventViewModelSource?.configureWithFirebaseUpdatedEventType()
  }
    
  func setupViews() {
      let playEventView = PlayEventView(frame: CGRect(x: 0,
                                                      y: 0,
                                                  width: self.view.bounds.width,
                                                 height: self.view.bounds.height))
      self.view.addSubview(playEventView)
    
      self.playEventView = playEventView
  }
    
  /// methods
  
  func checkEventTypeAndIsLive(event: Event, eventDetail: EventDetail) {
    // check event Type
    // check event isLive
    // call the propere play event method and give it EventDetail
  }
  
  func trackEvent(event: Event) -> EventDetail {
   // call checkEventTypeAndIsLive
    // stop trackEventDetail
    return EventDetail()
  }
  
  func trackEventDetail(event: Event) -> EventDetail {
    
    // track the EventDetail Node to update the Event
    
    
//    firebaseDatabaseReference.child("EventDetails").child(event.eventName).ob
    
    return EventDetail()
  }
  
  
  
  
  
  func playTextEvent(eventDetail: EventDetail) {
    
    
    
    
    
  }
  
  func playAnimationEvent(eventDetail: EventDetail) {
    
  }
  
  func playPhotoEvent(eventDetail: EventDetail) {
    let imageView = UIImageView()
    imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    imageView.backgroundColor = UIColor.yellow
    view.addSubview(imageView)
    
    
  }
  
  

}

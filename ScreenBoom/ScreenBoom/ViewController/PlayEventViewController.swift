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
      self.playEventViewModelSource?.configureWithFirebaseUpdatedEvent()
      self.playEventViewModelSource?.configureWithFirebaseUpdateEventDetail()
  }
    
  func setupViews() {
      let playEventView = PlayEventView(frame: CGRect(x: 0,
                                                      y: 0,
                                                  width: self.view.bounds.width,
                                                 height: self.view.bounds.height))
      self.view.addSubview(playEventView)
    
      self.playEventView = playEventView
  }
  
}

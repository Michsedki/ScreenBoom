//
//  AnimationPlayEventViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/23/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class AnimationPlayEventViewController : PlayEventViewController {
  
  var eventDetail: AnimationEventDetail
  
  init(event:Event, eventDetail: AnimationEventDetail) {
    self.eventDetail = eventDetail
    
    super.init(event: event)
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
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupViews()
  }
  
  func setupViews() {
    // create playEventView to view the events
    let animationplayEventView = AnimationPlayEventView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: self.view.bounds.width,
                                                    height: self.view.bounds.height))
    self.view.addSubview(animationplayEventView)
    self.playEventView = animationplayEventView
  }
  
}






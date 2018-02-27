//
//  PlayEventModelSource.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/21/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import FirebaseDatabase
class PlayEventViewModelSource {
  
  // Varibales
  var firebaseDatabaseReference: DatabaseReference = Database.database().reference()
  private var event: Event
  private var eventDetail: EventDetail
  
  
  init(event: Event,
       eventDetail:EventDetail) {
    self.event = event
    self.eventDetail = eventDetail
  }
  
  private var observers: [PlayEventViewModelSourceObserver] = []
  
  func addObserver(observer: PlayEventViewModelSourceObserver ) {
    for item in observers {
      if item === observer {
        // already added
        return;
      }
    }
    
    observers.append(observer)
  }
  
  func removeObserver (observer: PlayEventViewModelSourceObserver) {
    for (index, item) in observers.enumerated() {
      if item === observer {
        observers.remove(at: index)
      }
    }
  }
  
  // Configure Method
  func configureWithFirebaseUpdatedEventType() {
    firebaseDatabaseReference.child("Event").child(event.eventName).observe(.childChanged) { (eventSnapShot) in
      guard let eventTypeFirbase = eventSnapShot.value as? String else { return }
      
      if eventTypeFirbase != self.event.eventType.rawValue {
        guard let eventTypeNew = EventType(rawValue: eventTypeFirbase) else { return }
        self.event.eventType = eventTypeNew
        
        // event type changed. Create new model and update observers.
        self.updateObservers(viewModel: PlayEventViewModel(event: self.event, eventDetail: self.eventDetail))
      }
    }
    
    // run on initial call
    updateObservers(viewModel: PlayEventViewModel(event: self.event, eventDetail: self.eventDetail))
  }
  
  func updateObservers(viewModel: PlayEventViewModel) {
    for observer in observers {
      observer.update(viewModel: viewModel)
    }
  }
  
}

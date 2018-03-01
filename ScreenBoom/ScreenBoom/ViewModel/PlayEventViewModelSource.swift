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
  let firebaseNodeNames = FirebaseNodeNames()
  
  
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
  func configureWithFirebaseUpdatedEvent() {
    firebaseDatabaseReference.child("Event").child(event.eventName).observe(.value) { (eventSnapShot) in
      if eventSnapShot.exists() {
        guard let eventSnapShotValue = eventSnapShot.value as? [String: String] else { return }
        if let eventtype = eventSnapShotValue[self.firebaseNodeNames.eventNodeTypeChild] {
          self.event.eventType = EventType(rawValue: eventtype) ?? .Unknown
        }
        if let eventIsLive = eventSnapShotValue[self.firebaseNodeNames.eventNodeIsLiveChild] {
          self.event.eventIsLive = eventIsLive
        }
      } else {
        print("Event Updated Failed")
      }
      self.updateObservers(viewModel: PlayEventViewModel(event: self.event, eventDetail: self.eventDetail))
    }
//    updateObservers(viewModel: PlayEventViewModel(event: self.event, eventDetail: self.eventDetail))
  }
  
  
  func configureWithFirebaseUpdateEventDetail() {
    firebaseDatabaseReference.child(firebaseNodeNames.eventDetailNode).child(event.eventName).observe(.value) { (eventDetailSnapShot) in
      if eventDetailSnapShot.exists() {
        guard let eventDetailSnapshotValue = eventDetailSnapShot.value as? [String: Any] else { return }
        
        do {
          let jsonData = try JSONSerialization.data(withJSONObject: eventDetailSnapshotValue, options: [])
          let eventDetailFirebase = try JSONDecoder().decode(EventDetail.self, from: jsonData)
          self.eventDetail = eventDetailFirebase
          self.updateObservers(viewModel: PlayEventViewModel(event: self.event, eventDetail: self.eventDetail))
          print("Event Detail Updated successfully")
        } catch {
          print("Couldn't pdate Event Detail cause of jsonserialization")
        }
      } else {
        print("Event Detail Updated Failed")
      }
    }
    // event type changed. Create new model and update observers.
    self.updateObservers(viewModel: PlayEventViewModel(event: self.event, eventDetail: self.eventDetail))
  }
  
  
  func updateObservers(viewModel: PlayEventViewModel) {
    for observer in observers {
      observer.update(viewModel: viewModel)
    }
  }
  
}

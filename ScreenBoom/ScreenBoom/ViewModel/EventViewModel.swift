//
//  EventViewModel.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import FirebaseDatabase

enum Result<T> {
  case Success(T)
  case Failure(Error?)
}

class EventViewModel: NSObject {

  let firebaseDatabaseReference = Database.database().reference()  
  var event: Event?
  
  func configureWithEvent(event:Event, completion:((Bool) -> Void)? = nil) {
    checkIfEventExists(event: event, completion: { eventExists in
      if !eventExists {
        // if the event exists set the value
        self.event = event
      }
      
      // run the completion block if we have one
      // and pass the result
      completion?(eventExists)
    })
  }
  
  // check if event is already exist
  func checkIfEventExists (event: Event, completion:(@escaping (Bool) -> Void)) {
    
    firebaseDatabaseReference.child("Event").observeSingleEvent(of: .value, with: { (snapshot) in
      
        completion(snapshot.hasChild(event.eventName))
    })
  }
  
  func addEvent(event: Event, completion:(@escaping(Result<Void>) -> Void)) {
    
    let eventCode = String.random()
    let eventFIRReferance = firebaseDatabaseReference.child("Event").child(event.eventName)
    
    eventFIRReferance.setValue(["type":event.eventTypeString, "code":eventCode], withCompletionBlock: { (error, response) in
      guard error == nil else {
        completion(Result.Failure(error))
        return
      }
      
      completion(Result.Success(()))
    })
  }

}










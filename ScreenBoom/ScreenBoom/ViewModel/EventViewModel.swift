//
//  EventViewModel.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import FirebaseDatabase


let firebaseNodeNames = FirebaseNodeNames()
enum Result<T> {
  case Success(T)
  case Failure(String)
}

typealias ConfigureWithEventCompletionHandler = (_:Result<Void>) -> Void

class EventViewModel: NSObject {
  
  let firebaseDatabaseReference = Database.database().reference()
  let firebaseNodeNames = FirebaseNodeNames()
  var event: Event?
  
  func configureWithEvent(event:Event, completion:ConfigureWithEventCompletionHandler? = nil) {
    checkIfEventExists(event: event, completion: { eventExists, snapshot  in
      
      
      if !eventExists {
        // if the event is not exists set the value
        self.event = event
        completion?(Result.Success(()))
      } else {
        // run the completion block if we have one
        // and pass the result
        
        completion?(Result.Failure("Event is Already Exist"))
      }
      
    })
  }
  
  // check if event is already exist
  func checkIfEventExists (event: Event, completion:(@escaping (Bool, DataSnapshot?) -> Void)) {
    
    firebaseDatabaseReference.child("Event").child(event.eventName).observeSingleEvent(of: .value, with: { (snapshot) in
      
      if snapshot.exists() {
        completion(true,snapshot )
        
      } else {
        completion(false,nil )
      }
    })
  }
  
  
  // add event method takes event and completion to insert the event in the firbase
  //Database and return result (error or firebasedatareferense
  func addEvent(event: Event, completion:(@escaping(Result<Void>) -> Void)) {
    
    let eventCode = String.random()
    let eventFIRReferance = firebaseDatabaseReference.child("Event").child(event.eventName)
    
    eventFIRReferance.setValue([firebaseNodeNames.eventNodeTypeChild:event.eventType.rawValue,firebaseNodeNames.eventNodeIsLiveChild: event.eventIsLive ,firebaseNodeNames.eventNodeCodeChild:eventCode], withCompletionBlock: { (error, response) in
      guard error == nil else {
        completion(Result.Failure((error?.localizedDescription)!))
        return
      }
      
      completion(Result.Success(()))
    })
  }
  
  //Michael start
  /// update the Event islive node with yes or no
  func updateEvenIsLive(event: Event, isLive: String, completion:(@escaping(Result<Void>) -> Void)) {
 firebaseDatabaseReference.child(firebaseNodeNames.eventNode).child(event.eventName).child(firebaseNodeNames.eventNodeIsLiveChild).setValue(isLive) { (error, _) in
      if error != nil {
        completion(Result.Failure((error?.localizedDescription)!))
      } else {
        completion(Result.Success(()))
      }
    }
  }
  
  
  /// update the Event type node with text, photo or animation
  func updateEvenType(event: Event, eventType: EventType, completion:(@escaping(Result<Void>) -> Void)) {
  firebaseDatabaseReference.child(firebaseNodeNames.eventNode).child(event.eventName).child(firebaseNodeNames.eventNodeTypeChild).setValue(eventType.rawValue) { (error, _) in
      if error != nil {
        completion(Result.Failure((error?.localizedDescription)!))
      } else {
        completion(Result.Success(()))
      }
    }
  }
  
  /// update the Event node with new Event
  func updateEvenType(event: Event, completion:(@escaping(Result<Void>) -> Void)) {
    firebaseDatabaseReference.child(firebaseNodeNames.eventNode).child(event.eventName).updateChildValues([firebaseNodeNames.eventNodeTypeChild : event.eventType, firebaseNodeNames.eventNodeIsLiveChild: event.eventIsLive]) { (error, _) in
      if error != nil {
        completion(Result.Failure((error?.localizedDescription)!))
      } else {
        completion(Result.Success(()))
      }
   }
  }
  
  /// remove Event
  func removeEvent(event: Event,completion:(@escaping(Result<Void>) -> Void )) {
    firebaseDatabaseReference.child(firebaseNodeNames.eventNode).child(event.eventName).removeValue { (error, _) in
      if error != nil {
        completion(Result.Failure((error?.localizedDescription)!))
      } else {
        completion(Result.Success(()))
      }

    }
  }
  
  // get Event
  
  func getEvent(eventName: String,completion:(@escaping(Result<Event>) -> Void )) {
    firebaseDatabaseReference.child(firebaseNodeNames.eventNode).child(eventName).observeSingleEvent(of: .value) { (eventSnapShot) in
      if let eventValue = eventSnapShot.value as? [String:String] {
        guard let eventIsLive = eventValue[self.firebaseNodeNames.eventNodeIsLiveChild], let eventType = eventValue[self.firebaseNodeNames.eventNodeTypeChild] else {
          completion(Result.Failure("Event Not Found"))
          return }
        let event = Event(eventName: eventName, eventIsLive: eventIsLive, eventType: EventType(rawValue: eventType) ?? .Unknown)
        completion(Result.Success(event))
      }
    }
    completion(Result.Failure("Event Not Found"))
  }
  
  
  
  // Michael end
  
}










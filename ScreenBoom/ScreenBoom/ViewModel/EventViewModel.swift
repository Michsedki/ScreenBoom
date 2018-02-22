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
  case Failure(String)
}

typealias ConfigureWithEventCompletionHandler = (_:Result<Void>) -> Void

class EventViewModel: NSObject {

  let firebaseDatabaseReference = Database.database().reference()  
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
    
    eventFIRReferance.setValue(["type":event.eventType.rawValue, "code":eventCode], withCompletionBlock: { (error, response) in
      guard error == nil else {
        completion(Result.Failure((error?.localizedDescription)!))
        return
      }
      
      completion(Result.Success(()))
    })
  }

}










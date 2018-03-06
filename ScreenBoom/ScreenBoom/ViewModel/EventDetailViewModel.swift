//
//  EventDetailViewModel.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/18/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import FirebaseDatabase


class EventDetailViewModel: NSObject {
  
  let firebaseDatabaseReference = Database.database().reference()
  var eventDetail: EventDetail?
  
  // Check if event detail is exist and return the eventDetail if success or error string if failure
  func checkIfEventDetailExist (event: Event, completion: (@escaping(Result<EventDetail>) -> Void) ) {
  firebaseDatabaseReference.child("EventDetails").child(event.eventName).observeSingleEvent(of: .value, with: {  (eventDetailSnapshot) in
      
      if eventDetailSnapshot.exists() {
        guard let eventDetailSnapshotValue = eventDetailSnapshot.value as? [String: Any] else { return }
        
        do {
          let jsonData = try JSONSerialization.data(withJSONObject: eventDetailSnapshotValue, options: [])
           let eventDetail = try JSONDecoder().decode(EventDetail.self, from: jsonData)
          completion(Result.Success(eventDetail))
        } catch {
         completion(Result.Failure("Error serializing Data from firebase"))
        }
      } else {
        completion(Result.Failure("EventDetails Not Found"))
      }
    })
  }
  
  
  
  // Add Event Detail
  func addEventDetail(event :Event , eventdetail: EventDetail, completion:(@escaping(Result<String>) -> Void)) {
    
    let eventFIRReferance = firebaseDatabaseReference.child(firebaseNodeNames.eventDetailNode).child(event.eventName)
    eventFIRReferance.setValue(
      [firebaseNodeNames.eventDetailTextChild : eventdetail.text,
       firebaseNodeNames.eventDetailTextColorChild : eventdetail.textcolor,
       firebaseNodeNames.eventDetailBackGroundColorChild : eventdetail.backgroundcolor,
       firebaseNodeNames.eventDetailAnimationNumberChild : eventdetail.animationnumber,
       firebaseNodeNames.eventDetailSpeedChild : eventdetail.speed,
       firebaseNodeNames.eventDetailPhotoNameChild : eventdetail.photoname,
       firebaseNodeNames.eventDetailCodeChild : eventdetail.code],
      withCompletionBlock: { (error, response) in
      guard error == nil else {
        completion(Result.Failure((error?.localizedDescription)!))
        return
      }
        
        guard let eventCode = eventdetail.code else {return}
      completion(Result.Success(eventCode))
    })
  }
  
  
}

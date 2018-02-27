//
//  EventDetailViewModel.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/18/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import FirebaseDatabase


class EventDetailsViewModel: NSObject {
  
  let firebaseDatabaseReference = Database.database().reference()
  var eventDetail: EventDetail?
  
  // Check if event detail is exist and return the eventDetail if success or error string if failure
  func checkIfEventDetailExist (event: Event, completion: (@escaping(Result<EventDetail>) -> Void) ) {
  firebaseDatabaseReference.child("eventDetails").child(event.eventName).observeSingleEvent(of: .value, with: {  (eventDetailSnapshot) in
      
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
}

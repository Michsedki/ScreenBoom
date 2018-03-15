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
    
    var eventDetails = [String:String]()
    switch event.eventType {
    case .Text:
      guard let text = eventdetail.text ,
            let textColor = eventdetail.textcolor,
            let backgroundColor = eventdetail.backgroundcolor,
            let animationName = eventdetail.animationName,
            let speed = eventdetail.speed,
            let code = eventdetail.code else {
        completion(Result.Failure("Couldn't build text eventDetail"))
        return
      }
      eventDetails = [firebaseNodeNames.eventDetailTextChild : text,
                      firebaseNodeNames.eventDetailTextColorChild : textColor,
                      firebaseNodeNames.eventDetailBackGroundColorChild : backgroundColor,
                      firebaseNodeNames.eventDetailAnimationNameChild : animationName,
                      firebaseNodeNames.eventDetailSpeedChild : speed,
                      firebaseNodeNames.eventDetailCodeChild : code ]
      break
    case .Photo:
      guard let photoName = eventdetail.photoname,
            let code = eventdetail.code else {
                completion(Result.Failure("Couldn't build photo eventDetail"))
                return
      }
      eventDetails = [firebaseNodeNames.eventDetailPhotoNameChild : photoName,
                      firebaseNodeNames.eventDetailCodeChild : code]
      break
    case .Animation:
      guard let animationStringURL = eventdetail.animationStringURL,
            let code = eventdetail.code else {
                completion(Result.Failure("Couldn't build animation eventDetail"))
                return
      }
      eventDetails = [firebaseNodeNames.eventDetailAnimationStringURLChild : animationStringURL,
                     firebaseNodeNames.eventDetailCodeChild : code]
      break
    case.Unknown:
      completion(Result.Failure("Unknown event type"))
      break
    }
    
    eventFIRReferance.setValue(
      eventDetails,
      withCompletionBlock: { (error, response) in
      guard error == nil else {
        completion(Result.Failure((error?.localizedDescription)!))
        return
      }
        
        guard let eventCode = eventdetail.code else {
          completion(Result.Failure("Couldn't Retrive the event Code"))
          return}
      completion(Result.Success(eventCode))
    })
  }
  
  
}

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
  
  //  var firebaseDatabaseReference2: DatabaseReference = Database.database().reference()
  var eventDetail: EventDetail?
  //  let eventViewModel = EventViewModel()
  let firebaseNodeNames = FirebaseNodeNames()
  
  // Check if event detail is exist and return the eventDetail if success or error string if failure
  func checkIfEventDetailExist (event: Event, completion: (@escaping(Result<EventDetail>) -> Void) ) {
    Database.database().reference().child("EventDetails").child(event.eventName).observeSingleEvent(of: .value, with: {  (eventDetailSnapshot) in
      
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
  func addEventDetail(event :Event , eventdetail: EventDetail, completion:(@escaping(Result<Void>) -> Void)) {
    
    let eventFIRReferance = Database.database().reference().child(firebaseNodeNames.eventDetailNode).child(event.eventName)
    // we create one eventDetail as String Dectionary to hold the key value of any type of event
    var eventDetails = [String:String]()
    // we switch on the event type to find out which event type we will constract
    switch event.eventType {
    case .Text:
        // make sure that we received text event type
      guard let textEventDetail = eventdetail as? TextEventDetail else { return }
      // make sure that all values are exist
      guard let text = textEventDetail.text ,
        let textColor = textEventDetail.textcolor,
        let backgroundColor = textEventDetail.backgroundcolor,
        let animationName = textEventDetail.animationName,
        let speed = textEventDetail.speed,
        let code = textEventDetail.code,
        let font = textEventDetail.font,
        let fontSize = textEventDetail.fontsize
        else {
          completion(Result.Failure("Couldn't build text eventDetail"))
          return
      }
      // set the eventDetail dectionary with keys and values
      eventDetails = [firebaseNodeNames.eventDetailTextChild : text,
                      firebaseNodeNames.eventDetailTextColorChild : textColor,
                      firebaseNodeNames.eventDetailBackGroundColorChild : backgroundColor,
                      firebaseNodeNames.eventDetailAnimationNameChild : animationName,
                      firebaseNodeNames.eventDetailSpeedChild : String(describing: speed),
                      firebaseNodeNames.eventDetailCodeChild : code,
                      firebaseNodeNames.eventDetailFoneChild : font,
                      firebaseNodeNames.eventDetailFontSizeChild : String(describing: fontSize)]
      break
    case .Photo:
        // make sure that we received a photo event type
      guard let photoEventDetail = eventdetail as? PhotoEventDetail else { return }
      // make sure that all values are exist
      guard let photoName = photoEventDetail.photoname,
        let code = photoEventDetail.code
        else {
          completion(Result.Failure("Couldn't build photo eventDetail"))
          return}
      // set the eventDetail dectionary with keys and values
      eventDetails = [firebaseNodeNames.eventDetailPhotoNameChild : photoName,
                      firebaseNodeNames.eventDetailCodeChild : code]
      break
    case .Animation:
        // make sure that we received a Animation event type
      guard let animationEventDetail = eventdetail as? AnimationEventDetail else { return }
      // make sure that all values are exist
      guard let animationStringURL = animationEventDetail.animationStringURL,
        let code = animationEventDetail.code
        else {
          completion(Result.Failure("Couldn't build animation eventDetail"))
          return
      }
      // set the eventDetail dectionary with keys and values
      eventDetails = [firebaseNodeNames.eventDetailAnimationStringURLChild : animationStringURL,
                      firebaseNodeNames.eventDetailCodeChild : code]
      break
    case.Unknown:
      completion(Result.Failure("Unknown event type"))
      break
    }
    eventFIRReferance.setValue(
      eventDetails,
      withCompletionBlock: { (error, _) in
        guard error == nil else {
          completion(Result.Failure((error?.localizedDescription)!))
          return
        }
        completion(Result.Success(()))
    })
  }
  
  
  // remove event and eventdetail
  func removeEventAndEventDetail(event: Event,eventDetail: EventDetail? ,completion:(@escaping(Result<Void>) -> Void )) {
    if let eventDetail = eventDetail {
      // eventDetail is exist
      removeEventDetailWithEventAndEventDetail(event: event, eventDetail: eventDetail, completion: { (resultOfDelete) in
        switch resultOfDelete {
        case .Failure( _):
          completion(Result.Failure("Event not deleted!"))
          break
        case .Success():
          completion(Result.Success(()))
          break
          
        }
      })
      
    } else {
      // eventDetail not exist and we need to get it
      self.checkIfEventDetailExist(event: event, completion: { (result) in
        switch result {
        case .Failure( _):
          completion(Result.Failure("Event not deleted!"))
          break
        case .Success(let eventDetailFirebase):
          self.removeEventDetailWithEventAndEventDetail(event: event, eventDetail: eventDetailFirebase, completion: { (resultOfDelete) in
            switch resultOfDelete {
            case .Failure( _):
              completion(Result.Failure("Event not deleted!"))
              break
            case .Success():
              completion(Result.Success(()))
              break
            }
          })
          break
        }
      })
    }
  }
  
  
  /// remove eventDetail givin event and event detail
  func removeEventDetailWithEventAndEventDetail(event: Event, eventDetail: EventDetail,completion:(@escaping(Result<Void>) -> Void )) {
    if event.eventType == .Photo {
      guard let photoEventDetail = eventDetail as? PhotoEventDetail else { return }
      let imageUploadManager = ImageUploadManager()
      imageUploadManager.deleteImage(eventDetail: photoEventDetail, completion: { (result) in
        switch result {
        case.Failure(let error):
          print("couldn't remove the Image")
          completion(Result.Failure(error))
          break
        case .Success():
          print("Image removed successsfully")
          break
        }
      })
    }
    Database.database().reference().child(firebaseNodeNames.eventDetailNode).child(event.eventName).removeValue { (error, _) in
      if error != nil {
        completion(Result.Failure((error?.localizedDescription)!))
      } else {
        Database.database().reference().child(self.firebaseNodeNames.eventNode).child(event.eventName).removeValue(completionBlock: { (error, _) in
          if error != nil {
            self.updateEvenIsLive(event: event, isLive: self.firebaseNodeNames.eventNodeIsLiveNoValue, completion: { (result) in
              switch result {
              case .Failure(let error):
                completion(Result.Failure(error))
                break
              case .Success():
                completion(Result.Failure("Event Blocked, sorry we have a problem"))
                break
              }
            })
          } else {
            completion(Result.Success(()))
          }
        })
      }
    }
  }
  
  /// update the Event islive node with yes or no
  func updateEvenIsLive(event: Event, isLive: String, completion:(@escaping(Result<Void>) -> Void)) {
    Database.database().reference().child(firebaseNodeNames.eventNode).child(event.eventName).child(firebaseNodeNames.eventNodeIsLiveChild).setValue(isLive) { (error, _) in
      if error != nil {
        completion(Result.Failure((error?.localizedDescription)!))
      } else {
        completion(Result.Success(()))
      }
    }
  }
}

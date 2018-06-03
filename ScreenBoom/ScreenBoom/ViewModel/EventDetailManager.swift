//
//  EventDetailViewModel.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/18/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import FirebaseDatabase


class EventDetailManager: NSObject {
    
    var eventDetail: EventDetail?
    let firebaseNodeNames = FirebaseNodeNames()
    
    // Check if event detail is exist and return the eventDetail if success or error string if failure
    func checkIfEventDetailExist (event: Event, completion: (@escaping(Result<EventDetail>) -> Void) ) {
        Database.database().reference().child("EventDetails").child(event.eventName).observeSingleEvent(of: .value, with: {  (eventDetailSnapshot) in
            guard eventDetailSnapshot.exists() else {
                completion(Result.Failure("Event Not Found"))
                return
            }
            
            var eventDetail : EventDetail?
            
            switch event.eventType {
            case .Text:
                
                guard let animationName = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventDetailAnimationNameChild).value as? String,
                    let backgroundcolor = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventDetailBackGroundColorChild).value as? String,
                    let textcolor = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventDetailTextColorChild).value as? String,
                    let speed = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventDetailSpeedChild).value as? String,
                    let text = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventDetailTextChild).value as? String,
                    let font = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventDetailFoneChild).value as? String,
                    let fontsize = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventDetailFontSizeChild).value as? String,
                    let code = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventNodeCodeChild).value as? String else {
                        completion(Result.Failure("Event Not Found"))
                        return
                }
                
                eventDetail = TextEventDetail(animationName: animationName,
                                              backgroundcolor: backgroundcolor,
                                              textcolor: textcolor,
                                              speed: Int(speed),
                                              text: text,
                                              font: font,
                                              fontsize: Double(fontsize),
                                              code: code)
                break
                
            case .Photo:
                guard let photoname = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventDetailPhotoNameChild).value as? String,
                    let code = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventNodeCodeChild).value as? String else {
                        completion(Result.Failure("Event Not Found"))
                        return
                }
                
                eventDetail = PhotoEventDetail(photoname: photoname, code: code)
                break
                
            case .Animation:
                guard let animationStringURL = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventDetailAnimationStringURLChild).value as? String,
                    let code = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventNodeCodeChild).value as? String else {
                        completion(Result.Failure("Event Not Found"))
                        return
                }
                
                eventDetail = AnimationEventDetail(animationStringURL: animationStringURL, code: code)
                break
            case .Unknown:
                completion(Result.Failure("Unknown event type "))
                break
            }
            
            if let eventViewer = eventDetailSnapshot.childSnapshot(forPath: self.firebaseNodeNames.eventViewerCount).value as? [String:String] {
                eventDetail?.viewerCount = eventViewer.count
                print(eventDetail?.viewerCount!)
            }
            
            
            if let eventDetailFinal = eventDetail {
                completion(Result.Success(eventDetailFinal))
            } else {
                completion(Result.Failure("Event Not Found"))
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
                let fontSize = textEventDetail.fontsize else {
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
                let code = photoEventDetail.code else {
                    completion(Result.Failure("Couldn't build photo eventDetail"))
                    return
            }
            
            // set the eventDetail dectionary with keys and values
            eventDetails = [firebaseNodeNames.eventDetailPhotoNameChild : photoName,
                            firebaseNodeNames.eventDetailCodeChild : code]
            break
        case .Animation:
            // make sure that we received a Animation event type
            guard let animationEventDetail = eventdetail as? AnimationEventDetail else { return }
            // make sure that all values are exist
            guard let animationStringURL = animationEventDetail.animationStringURL,
                let code = animationEventDetail.code else {
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
                
                guard let eventCode = eventdetail.code else {
                    completion(Result.Failure("Couldn't Retrive the event Code"))
                    return}
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
        FireBaseManager.sharedInstance.REF_EventDetails.child(event.eventName).removeValue { (error, _) in
            if error != nil {
                completion(Result.Failure((error?.localizedDescription)!))
            } else {
                FireBaseManager.sharedInstance.REF_Event.child(event.eventName).removeValue(completionBlock: { (error, _) in
                    if error != nil {
                        // ***** we need to put "Blocked" in islive and deal with it later on the play view
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
                        FireBaseManager.sharedInstance.removeFromUserCreatedEvents(event: event, completion: { (result) in
                            if result {
                                completion(Result.Success(()))
                            } else {
                                completion(Result.Failure("Couldn't remove event from user created events"))
                            }
                        })
                        
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

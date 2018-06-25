//
//  FireBaseManager.swift
//  ScreenBoom
//
//  Created by Apple on 5/29/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import Firebase

// we need to implement firebase functions for :
// add / get / remove / update event under uuid-event node
//

let DB_BASE = Database.database().reference()

class FireBaseManager {
    static let sharedInstance = FireBaseManager()
    
    // General firebase ref
    private (set) var REF_BASE = DB_BASE
    private (set) var REF_Event = DB_BASE.child("Event")
    private (set) var REF_EventDetails = DB_BASE.child("EventDetails")
    private (set) var REF_UUID_Events = DB_BASE.child("uuid-events")

    // Current user ref as computed values
    var REF_Event_Current_User: DatabaseReference? {
        if let  userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
            let ref = REF_Event.child(userID)
            return ref
        }
        return nil
    }
    var REF_EventDetails_Current_User: DatabaseReference? {
        if let  userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
        let ref = REF_EventDetails.child(userID)
        return ref
        }
        return nil
    }
    var REF_UUID_Events_Current_User_Created : DatabaseReference? {
        if let  userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
        let ref = REF_UUID_Events.child(userID).child("Created")
        return ref
        }
        return nil
    }
    var REF_UUID_Events_Current_User_Joined : DatabaseReference? {
        if let  userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
            let ref = REF_UUID_Events.child(userID).child("Joined")
            return ref
        }
        return nil
    }
    
    // for created event
    func addEventToUserCreatedEvents(event: Event, eventDetail: EventDetail) {
        // we need to keep track of the type so we retrive the type when we build the created tableview
        // also we need to keep track for the photoURL or gifPhotoURL
        // that is why we concatenate the type of the event with the code and separate them by "**"
        var eventCode_Type_url = "\(event.eventCode)**\(event.eventType.rawValue)"
        switch event.eventType {
        case .Text, .Unknown:
            break
        case .Photo, .Animation:
            if let photoEventDetail = eventDetail as? PhotoEventDetail,
                let photoURL = photoEventDetail.photoname {
                eventCode_Type_url = eventCode_Type_url + "**\(photoURL))"
            } else if let animationEventDetail = eventDetail as? AnimationEventDetail,
                let animationURL = animationEventDetail.animationStringURL {
                eventCode_Type_url = eventCode_Type_url + "**\(animationURL)"
            }
            break
        }
        
        REF_UUID_Events_Current_User_Created?.updateChildValues([event.eventName: eventCode_Type_url], withCompletionBlock: { (error, _) in
            if error != nil {
                 print("Couldn't Add Event to User Events, Error: \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    func removeFromUserCreatedEvents(event: Event, completion: @escaping (Bool) -> Void) {
        REF_UUID_Events_Current_User_Created?.child(event.eventName).removeValue(completionBlock: { (error, _) in
            if error != nil {
                print("Couldn't remove Event from User Events, Error: \(String(describing: error?.localizedDescription))")
                completion(false)
            } else {
                completion(true)
            }
            
        })
    }
    
    func getUserCreatedEvents(completion: (@escaping(Result<[[String:String]]>) -> Void)) {
        
        var createdEvents = [[String:String]]()
        var images = [UIImage?]()

        REF_UUID_Events_Current_User_Created?.observeSingleEvent(of: .value, with: { (createdEventsSnapShot) in
            if let createdEventDic = createdEventsSnapShot.value as? [String:String] {
                for item in createdEventDic {
                    let eventInfoDic = self.separateEventCodeAndType(eventCodeAndType: item.value)
                    var eventInfoObject = ["eventName" : item.key ,
                                           "eventCode" : eventInfoDic[0],
                                           "eventType" : eventInfoDic[1]]
                    if eventInfoDic[1] == "photo" || eventInfoDic[1] == "animation" {
                        eventInfoObject["eventPhotoURL"] = eventInfoDic[2]
                    }
                    
                    createdEvents.append(eventInfoObject)
                }
                let sortedcreatedEvents : [[String:String]] =
                    createdEvents.sorted(by: { $0["eventName"]! < $1["eventName"]! })
                print(sortedcreatedEvents)
                completion(Result.Success(sortedcreatedEvents))
            } else {
           completion(Result.Failure("No Created Events"))
            }
        })
    }
    
    func separateEventCodeAndType(eventCodeAndType: String) -> ([String]) {
        let dic = eventCodeAndType.components(separatedBy: "**")

        return dic
    }
    
    // for join event
    func addEventToUserJoinedEvents(event: Event, eventDetail: EventDetail) {
        var eventCode_Type_url = "\(event.eventCode)**\(event.eventType.rawValue)"
        switch event.eventType {
        case .Text, .Unknown:
            break
        case .Photo, .Animation:
            if let photoEventDetail = eventDetail as? PhotoEventDetail,
                let photoURL = photoEventDetail.photoname {
                eventCode_Type_url = eventCode_Type_url + "**\(photoURL))"
            } else if let animationEventDetail = eventDetail as? AnimationEventDetail,
                let animationURL = animationEventDetail.animationStringURL {
                eventCode_Type_url = eventCode_Type_url + "**\(animationURL)"
            }
            break
        }
        
        REF_UUID_Events_Current_User_Joined?.childByAutoId().updateChildValues([event.eventName: eventCode_Type_url], withCompletionBlock: { (error, _) in
            if error != nil {
                print("Couldn't Add Event to User Joined Events, Error: \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    func removeFromUserJoinedEvents(joinedEventID: String, completion: @escaping (Bool) -> Void) {
        REF_UUID_Events_Current_User_Joined?.child(joinedEventID).removeValue(completionBlock: { (error, _) in
            if error != nil {
                print("Couldn't remove Event from User Joined Events, Error: \(String(describing: error?.localizedDescription))")
                completion(false)
            } else {
                completion(true)

            }
        })
    }
    // here we need to get all history of joined events for that user
    // then sort them by date and limit them to 10 events, and remove the rest
    // so we use autChild when we add the events and the use it again to order them
    func getUserJoinedEvents(completion: (@escaping(Result<[[String:String]]>) -> Void)) {
        var finalJoinedEvents = [[String:String]]()
        var joinedEvents = [[String:String]]()
        REF_UUID_Events_Current_User_Joined?.observeSingleEvent(of: .value, with: { (joinedEventsSnapShot) in
            
            if let joinedEventsSnapShotValue = joinedEventsSnapShot.value as? [String:[String:String]] {
                for(key, value) in joinedEventsSnapShotValue {
                    
                        for item in value {
                            let eventInfoDic = self.separateEventCodeAndType(eventCodeAndType: item.value)
                            var eventInfoObject = ["key" : key,
                                                   "eventName" : item.key ,
                                                   "eventCode" : eventInfoDic[0],
                                                   "eventType" : eventInfoDic[1]]
                            if eventInfoDic[1] == "photo" || eventInfoDic[1] == "animation" {
                                eventInfoObject["eventPhotoURL"] = eventInfoDic[2]
                            }
                            
                            joinedEvents.append(eventInfoObject)
                        }
                }
                
                let sortedjoinedEvents : [[String:String]] =
                    joinedEvents.sorted(by: { $0["key"]! > $1["key"]! })
                
                var count = 1
                
                for Obj in sortedjoinedEvents {
                    print(count)
                    if count <= 10 {
                  finalJoinedEvents.append(Obj)
                    } else {
                        // remove the next object
                        self.REF_UUID_Events_Current_User_Joined?.child(Obj["key"]!).removeValue()
                    }
                    count = count + 1
                }
//                print(finalJoinedEvents)
                completion(Result.Success(finalJoinedEvents))
                
            } else {
                completion(Result.Failure("No Joined Events"))
            }
        })
    }
    
    
    // event viewer list
    
    // add user to list of viewer
    func addToViewList(event: Event) {
        if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String {
        REF_EventDetails.child(event.eventName).child("views").child(userID).setValue("", withCompletionBlock: { (error, _) in
                if error != nil {
                    print("Couldn't add user to views, Error: \(String(describing: error?.localizedDescription))")
                }
            })
        }
    }
    // remove user from list of viewer
    func removeFromViewList(event: Event) {
        if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String
             {
            REF_EventDetails.child(event.eventName).child("views").child(userID).removeValue(completionBlock: { (error, _) in
                if error != nil {
                    print("Couldn't remove user from views, Error: \(String(describing: error?.localizedDescription))")
                }
            })
        }
        
    }
    
    func getEventsCount(completion: (@escaping(Result<String>) -> Void))  {
        REF_Event.observeSingleEvent(of: .value) { (eventSnapShot) in
            if eventSnapShot.childrenCount > 0 {
                completion(Result.Success(String(eventSnapShot.childrenCount)))
            } else {
                completion(Result.Failure("No Event count to show"))
                
            }
        }
        
    }
    
    func getUserCount(completion: (@escaping(Result<String>) -> Void)) {
        REF_UUID_Events.observeSingleEvent(of: .value) { (userSnapShot) in
            if userSnapShot.childrenCount > 0 {
                completion(Result.Success(String(userSnapShot.childrenCount)))
            } else {
                completion(Result.Failure("No User count to show"))
                
            }
        }
        
    }
    
    
}

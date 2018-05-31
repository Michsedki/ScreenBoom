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
    
    let  userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String
    
    // General firebase ref
    private (set) var REF_BASE = DB_BASE
    private (set) var REF_Event = DB_BASE.child("Event")
    private (set) var REF_EventDetails = DB_BASE.child("EventDetails")
    private (set) var REF_UUID_Events = DB_BASE.child("uuid-events")

    // Current user ref as computed values
    var REF_Event_Current_User: DatabaseReference? {
        if let userID = userID {
            let ref = REF_Event.child(userID)
            return ref
        }
        return nil
    }
    var REF_EventDetails_Current_User: DatabaseReference? {
        if let userID = userID {
        let ref = REF_EventDetails.child(userID)
        return ref
        }
        return nil
    }
    var REF_UUID_Events_Current_User_Created : DatabaseReference? {
        if let userID = userID {
        let ref = REF_UUID_Events.child(userID).child("Created")
        return ref
        }
        return nil
    }
    var REF_UUID_Events_Current_User_Joined : DatabaseReference? {
        if let userID = userID {
            let ref = REF_UUID_Events.child(userID).child("Joined")
            return ref
        }
        return nil
    }
    
    
    // for created event
    func addEventToUserCreatedEvents(event: Event) {
        // we need to keep track of the type so we retrive the type when we build the created tableview
        // that is why we concatenate the type of the event with the code and separate them by _
        let eventCode_Type = "\(event.eventCode)_\(event.eventType.rawValue)"
        REF_UUID_Events_Current_User_Created?.updateChildValues([event.eventName: eventCode_Type], withCompletionBlock: { (error, _) in
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
        REF_UUID_Events_Current_User_Created?.observeSingleEvent(of: .value, with: { (createdEventsSnapShot) in
            if let createdEventDic = createdEventsSnapShot.value as? [String:String] {
                for item in createdEventDic {
                    createdEvents.append(["eventName" : item.key ,"eventCode" : item.value])
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
    
    
    // for join event
    func addEventToUserJoinedEvents(event: Event) {
        REF_UUID_Events_Current_User_Joined?.updateChildValues([event.eventName: event.eventCode], withCompletionBlock: { (error, _) in
            if error != nil {
                print("Couldn't Add Event to User Events, Error: \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    func removeFromUserJoinedEvents(event: Event) {
        REF_UUID_Events_Current_User_Joined?.child(event.eventName).removeValue(completionBlock: { (error, _) in
            if error != nil {
                print("Couldn't remove Event from User Events, Error: \(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    func getUserJoinedEvents(completion: (@escaping(Result<[String:String]>) -> Void)) {
        REF_UUID_Events_Current_User_Joined?.observeSingleEvent(of: .value, with: { (joinedEventsSnapShot) in
            if let joinedEventDic = joinedEventsSnapShot.value as? [String:String] {
                print(joinedEventDic)
                completion(Result.Success(joinedEventDic))
            }
            completion(Result.Failure("No Created Events"))
        })
    }
    
    
}

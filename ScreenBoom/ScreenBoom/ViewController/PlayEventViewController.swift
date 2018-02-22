//
//  PlayEventViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/8/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PlayEventViewController: BaseViewController {
  
  
  // variables
  var event: Event
  var eventDetail : EventDetail?
  let eventViewModel = EventViewModel()
  let eventDetailViewModel = EventDetailsViewModel()
  var firebaseDatabaseReference: DatabaseReference = Database.database().reference()
  
  // init
  init (event:Event) {
    self.event = event
    super.init(nibName: nil, bundle: nil)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func viewDidLoad() {
        super.viewDidLoad()
      
      
     

      
      
      
//
        // Do any additional setup after loading the view.
    }
  
  override func viewWillLayoutSubviews() {
    

    
    
    
//    getEventDetail()
  }
  
  func getEventDetail() {
    firebaseDatabaseReference.child("EventDetails").child(event.eventName).observe(.value) { (eventDetailSnapshot) in
      
      guard let eventDetailSnapshotValue = eventDetailSnapshot.value as? [String: Any] else {
        
        /// create view in the middle of the scren say sorry
        self.infoView(message: "Couldn't load event Details", color: Colors.smoothRed)
        
        return }
      
      do {
        
        let jsonData = try JSONSerialization.data(withJSONObject: eventDetailSnapshotValue, options: [])
        
        let eventDetail = try JSONDecoder().decode(EventDetail.self, from: jsonData)
        
        switch self.event.eventType {
        case .Text:
          
          guard let backgroundcolor = eventDetail.backgroundcolor else { return}
                    self.view.backgroundColor = backgroundcolor.stringToUIColor()
          
          
          
          
          break
          
          
        case .Animation:
          break
          
        case.Photo:
          break
          
        case .Unknown:
          break
          
        }
        
        
        
        
        print(eventDetail)
        
        
      } catch let error {
        print(error)
      }
    }
    
  }

  
  /// methods
  
  func checkEventTypeAndIsLive(event: Event, eventDetail: EventDetail) {
    // check event Type
    // check event isLive
    // call the propere play event method and give it EventDetail
  }
  
  func trackEvent(event: Event) -> EventDetail {
   // call checkEventTypeAndIsLive
    // stop trackEventDetail
    return EventDetail()
  }
  
  func trackEventDetail(event: Event) -> EventDetail {
    
    // track the EventDetail Node to update the Event
    
    
//    firebaseDatabaseReference.child("EventDetails").child(event.eventName).ob
    
    return EventDetail()
  }
  
  
  
  
  
  func playTextEvent(eventDetail: EventDetail) {
    let playView = UIView()
    playView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    playView.backgroundColor = eventDetail.backgroundcolor?.stringToUIColor()
    let textLabelView = UILabel()
    textLabelView.backgroundColor = UIColor.clear
    textLabelView.font = UIFont.boldSystemFont(ofSize: 25)
    textLabelView.textAlignment = .center
    textLabelView.text = eventDetail.text
    textLabelView.textColor = eventDetail.textcolor?.stringToUIColor()
    textLabelView.frame = CGRect(x: playView.frame.minX, y: playView.frame.minY, width: playView.frame.width, height: playView.frame.height)
    playView.addSubview(textLabelView)
    
    view.addSubview(playView)
    
    
    
    
  }
  
  func playAnimationEvent(eventDetail: EventDetail) {
    
  }
  
  func playPhotoEvent(eventDetail: EventDetail) {
    let imageView = UIImageView()
    imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    imageView.backgroundColor = UIColor.yellow
    view.addSubview(imageView)
    
    
  }
  
  

}

//
//  EventDetailViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class EventDetailViewController: BaseViewController  {
  
  // Variables
  var event:Event
  var oldEventDetail: EventDetail?
  let eventViewModel = EventManager()
  let eventDetailViewModel = EventDetailManager()
  var playEventPreviewContainerView = UIView()
  
  var playPreviewEventViewController: PlayPreviewEventViewController?
  let constantNames = ConstantNames.sharedInstance

  init(event:Event) {
    self.event = event
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.lightGray
    self.navigationItem.title = self.event.eventName
  }
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    playPreviewEventViewController?.willMove(toParentViewController: nil)
    playPreviewEventViewController?.view.removeFromSuperview()
    playPreviewEventViewController?.removeFromParentViewController()
  }
  
  // Push PlayEventViewController
  func showPlayEventViewController(event: Event, eventDetail: EventDetail) {
    let PlayViewController = PlayEventViewController(event: event, eventDetail:eventDetail)
    self.navigationController?.pushViewController(PlayViewController, animated: true)
  }
    
    // here after we create the event successfully we can do all extra work
    // like add the event to uuid-Events node under created node
    func completeCreateEvent(event :Event, eventDetail: EventDetail) {
        FireBaseManager.sharedInstance.addEventToUserCreatedEvents(event: event, eventDetail: eventDetail)
    }
}





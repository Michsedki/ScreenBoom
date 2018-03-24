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
  let eventViewModel = EventViewModel()
  let eventDetailViewModel = EventDetailViewModel()
  var playEventPreviewContainerView = UIView()
  
  var playPreviewEventViewController: PlayPreviewEventViewController?
  let constantNames = ConstantNames()

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
}

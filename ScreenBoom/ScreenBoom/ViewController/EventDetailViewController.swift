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
  let eventDetailViewModel = EventDetailViewModel()
  var playEventPreviewContainerView = UIView()
  let eventTextField: UITextField = UITextField()
  var playEventViewController: PlayEventViewController?
  
//  convenience init() {
//    self.init(eventName: "")
//  }
  init(event:Event) {
    self.event = event
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
      super.viewDidLoad()
      self.view.backgroundColor = UIColor.white
      
    setupViews()
        // Do any additional setup after loading the view.
  }
  
  override func viewWillLayoutSubviews() {
   
  }
  
  func setupViews() {
    
    // create Navigation bar right buttom (Send)
    let sendRightBarButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(EventDetailViewController.rightBarButtonPressed(_:)))
    navigationItem.rightBarButtonItem = sendRightBarButton
    
    // create container view to hold the play event preview
    self.view.addSubview(playEventPreviewContainerView)
//    playEventPreviewContainerView.anchor(top: self.view.topAnchor,
//                                         leading: self.view.leadingAnchor,
//                                         bottom: nil,
//                                         trailing: self.view.trailingAnchor,
//                                         padding: .init(top: 84, left: 20, bottom: 0, right: 20),
//                                         size: .init(width: 0, height: 300))
    playEventPreviewContainerView.frame = CGRect(x: 20,
                                                 y: 84,
                                                 width: self.view.frame.width - 40,
                                                 height: 300)
    playEventPreviewContainerView.backgroundColor = UIColor.green
    
    // add text input field
    self.view.addSubview(eventTextField)
    eventTextField.anchor(top: playEventPreviewContainerView.bottomAnchor,
                          leading: self.view.leadingAnchor,
                          bottom: nil,
                          trailing: self.view.trailingAnchor,
                          padding: .init(top: 10, left: 20, bottom: 0, right: 20),
                          size: .init(width: 0, height: 40))
    eventTextField.backgroundColor = UIColor.blue
    
    
   
    let event = Event(eventName: "wedding", eventIsLive: "yes", eventType: .Text)
    playEventViewController = PlayEventViewController(event: event,
                                                      eventDetail: EventDetail(animationnumber: "4", photoname: "", backgroundcolor: "Green", textcolor: "Blue", speed: "", text: "LOL"))
    
    if let playEventVC = playEventViewController {
      self.addChildViewController(playEventVC)
      
      playEventPreviewContainerView.addSubview(playEventVC.view)
      playEventVC.view.frame = self.playEventPreviewContainerView.bounds
      
      playEventVC.didMove(toParentViewController: self)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    playEventViewController?.view.anchor(top: playEventPreviewContainerView.topAnchor,
                                         leading: playEventPreviewContainerView.leadingAnchor,
                                         bottom: playEventPreviewContainerView.bottomAnchor,
                                         trailing: playEventPreviewContainerView.trailingAnchor,
                                         padding: .zero)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    playEventViewController?.willMove(toParentViewController: nil)
    
    playEventViewController?.view.removeFromSuperview()
    
    playEventViewController?.removeFromParentViewController()
  }
 
  // Selectors
  @objc func rightBarButtonPressed (_ sender: UIBarButtonItem!) {
    
    eventDetailViewModel.checkIfEventDetailExist(event: event) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
      case .Success(let eventDetail):
        print(eventDetail)
      }
    }
  }
}

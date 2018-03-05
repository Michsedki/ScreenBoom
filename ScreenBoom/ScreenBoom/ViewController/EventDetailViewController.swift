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
  var textColorDropDownButton: dropDownBtn = dropDownBtn()
  var backgroundColorDropDownButton: dropDownBtn = dropDownBtn()
  var animationNameColorDropDownButton: dropDownBtn = dropDownBtn()
  var playEventViewController: PlayEventViewController?
  var updatePlayViewDelegate : PlayEventViewModelSourceObserver!
  
  
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
                          padding: .init(top: 10, left: 10, bottom: 0, right: 10),
                          size: .init(width: 0, height: 40))
    eventTextField.backgroundColor = UIColor.blue
    
    //add textColorDropDown
    //Configure the button
    textColorDropDownButton = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    textColorDropDownButton.setTitle("Text Colors", for: .normal)
    
    
    backgroundColorDropDownButton = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    backgroundColorDropDownButton.setTitle("Background Colors", for: .normal)
    
    animationNameColorDropDownButton = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    animationNameColorDropDownButton.setTitle("Animation", for: .normal)
    
    
    
     //Add Button to the View Controller
    self.view.addSubview(textColorDropDownButton)
    self.view.addSubview(backgroundColorDropDownButton)
    self.view.addSubview(animationNameColorDropDownButton)
    //button Constraints
    textColorDropDownButton.anchor(top: eventTextField.bottomAnchor,
                                   leading: self.view.leadingAnchor,
                                   bottom: nil,
                                   trailing: backgroundColorDropDownButton.leadingAnchor,
                                   padding: .init(top: 10, left: 10, bottom: 0, right: 5),
                                   size: .init(width: (self.view.frame.width - 30) / 3, height: 40))
    
    backgroundColorDropDownButton.anchor(top: eventTextField.bottomAnchor,
                                   leading: textColorDropDownButton.trailingAnchor,
                                   bottom: nil,
                                   trailing: animationNameColorDropDownButton.leadingAnchor,
                                   padding: .init(top: 10, left: 5, bottom: 0, right: 5),
                                   size: .init(width: (self.view.frame.width - 30) / 3, height: 40))
    
    animationNameColorDropDownButton.anchor(top: eventTextField.bottomAnchor,
                                         leading: backgroundColorDropDownButton.trailingAnchor,
                                         bottom: nil,
                                         trailing: self.view.trailingAnchor,
                                         padding: .init(top: 10, left: 5, bottom: 0, right: 10),
                                         size: .init(width: (self.view.frame.width - 30) / 3, height: 40))
    
    
    //Set the drop down menu's options
    textColorDropDownButton.dropView.dropDownOptions = ["Blue", "Green", "Magenta", "White", "Black", "Pink"]
    backgroundColorDropDownButton.dropView.dropDownOptions = ["Blue", "Green", "Magenta", "White", "Black", "Pink"]
    animationNameColorDropDownButton.dropView.dropDownOptions = ["Shake", "Zoom", "Magenta", "White", "Black", "Pink"]
    
    
    
    
    
    
   
    let event = Event(eventName: "wedding", eventIsLive: "yes", eventType: .Text)
    playEventViewController = PlayEventViewController(event: event,
                                                      eventDetail: EventDetail(animationnumber: "4", photoname: "", backgroundcolor: "Blue", textcolor: "Blue", speed: "", text: "LOL"), isPreviewInDetailEventViewController: true)
    
   
    
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
    
    let event = Event(eventName: "wedding", eventIsLive: "yes", eventType: .Text)
    playEventViewController = PlayEventViewController(event: event,
                                                      eventDetail: EventDetail(animationnumber: "4", photoname: "", backgroundcolor: "Blue", textcolor: "Blue", speed: "", text: "Ya Rab"), isPreviewInDetailEventViewController: true)
    playEventViewController?.playEventView?.configure(viewModel: PlayEventViewModel(event: event, eventDetail: EventDetail(animationnumber: "4", photoname: "", backgroundcolor: "Blue", textcolor: "Blue", speed: "", text: "Ya Rab")))
    playEventViewController?.setupViews()
    
    
    
    
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

//
//  EventDetailViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class EventDetailViewController: BaseViewController, DropDownSelectionDelegate  {
  func didSelectItem(changedFieldName: String, itemName: String) {
    
    switch changedFieldName {
    case firebaseNodeNames.eventDetailTextColorChild:
      self.eventDetail.textcolor = itemName
    case firebaseNodeNames.eventDetailBackGroundColorChild:
      self.eventDetail.backgroundcolor = itemName
    case firebaseNodeNames.eventDetailAnimationNumberChild:
      self.eventDetail.animationnumber = itemName
    default:
      break
    }
    let playEventViewModel = PlayEventViewModel(event: self.event, eventDetail: self.eventDetail)
    if let playEventVC = self.playPreviewEventViewController {
      playEventVC.configureWithPreviewPlayViewModel(playViewModel: playEventViewModel)
    }
  }
  
  // Variables
  var event:Event
  var eventDetail: EventDetail
  let eventViewModel = EventViewModel()
  let eventDetailViewModel = EventDetailViewModel()
  var playEventPreviewContainerView = UIView()
  let eventTextField: UITextField = UITextField()
  var textColorDropDownButton: dropDownBtn = dropDownBtn()
  var backgroundColorDropDownButton: dropDownBtn = dropDownBtn()
  var animationNameColorDropDownButton: dropDownBtn = dropDownBtn()
  var playPreviewEventViewController: PlayPreviewEventViewController?
  var updatePlayViewDelegate : PlayEventViewModelSourceObserver!
  var dropDownSelectionDelegate:DropDownSelectionDelegate!
  
  
  //  convenience init() {
  //    self.init(eventName: "")
  //  }
  init(event:Event) {
    self.event = event
    self.eventDetail = EventDetail(animationnumber: "shake", photoname: "Image", backgroundcolor: "Blue", textcolor: "White", speed: "fast", text: "Your Text", code: "")
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.navigationController?.navigationItem.title = self.event.eventName
    
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
    textColorDropDownButton.dropView.dropDownButtonTitle = firebaseNodeNames.eventDetailTextColorChild
    backgroundColorDropDownButton.dropView.dropDownOptions = ["Blue", "Green", "Magenta", "White", "Black", "Pink"]
    backgroundColorDropDownButton.dropView.dropDownButtonTitle = firebaseNodeNames.eventDetailBackGroundColorChild
    animationNameColorDropDownButton.dropView.dropDownOptions = ["Shake", "Zoom", "Magenta", "White", "Black", "Pink"]
    animationNameColorDropDownButton.dropView.dropDownButtonTitle = firebaseNodeNames.eventDetailAnimationNumberChild
    
    // set the dropdown delegation for all buttons
    self.textColorDropDownButton.dropView.dropDownSelectionDelegate = self
    self.backgroundColorDropDownButton.dropView.dropDownSelectionDelegate = self
    self.animationNameColorDropDownButton.dropView.dropDownSelectionDelegate = self
    
    
    
    
    playPreviewEventViewController = PlayPreviewEventViewController(event: self.event,
                                                                    eventDetail: self.eventDetail, isPreviewInDetailEventViewController: true)
    //    let playEventViewModel = PlayEventViewModel(event: self.event, eventDetail: self.eventDetail)
    //    if let playEventVC = self.playPreviewEventViewController {
    //      playEventVC.configureWithPreviewPlayViewModel(playViewModel: playEventViewModel)
    //    }
    
    
    
    if let playEventVC = playPreviewEventViewController {
      self.addChildViewController(playEventVC)
      playEventPreviewContainerView.addSubview(playEventVC.view)
      playEventVC.view.frame = self.playEventPreviewContainerView.bounds
      playEventVC.didMove(toParentViewController: self)
    }
    
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    playPreviewEventViewController?.view.anchor(top: playEventPreviewContainerView.topAnchor,
                                                leading: playEventPreviewContainerView.leadingAnchor,
                                                bottom: playEventPreviewContainerView.bottomAnchor,
                                                trailing: playEventPreviewContainerView.trailingAnchor,
                                                padding: .zero)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    playPreviewEventViewController?.willMove(toParentViewController: nil)
    
    playPreviewEventViewController?.view.removeFromSuperview()
    
    playPreviewEventViewController?.removeFromParentViewController()
  }
  
  // Selectors
  @objc func rightBarButtonPressed (_ sender: UIBarButtonItem!) {
    
    // check if textfields is empty
    guard let eventText = eventTextField.text,
      !eventText.trimmingCharacters(in: .whitespaces).isEmpty else {
      self.infoView(message: "No event text!", color: Colors.smoothRed)
      return
    }
    guard let _ = textColorDropDownButton.currentTitle?.stringToUIColor() else {
      self.infoView(message: "No event text Color!", color: Colors.smoothRed)
      return
    }
    guard let _ = backgroundColorDropDownButton.currentTitle?.stringToUIColor() else {
      self.infoView(message: "No event background Color!", color: Colors.smoothRed)
      return
    }
    self.ShowSpinner()
    eventViewModel.addEvent(event: self.event) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
      case .Success(let code):
        //************* Should we remove the show spinner line it is already shown
        self.eventDetail.code = code
        self.eventDetailViewModel.addEventDetail(event: self.event, eventdetail: self.eventDetail, completion: { (result) in
          switch result {
          case .Failure(let error):
            self.infoView(message: error, color: Colors.smoothRed)
          case .Success(let eventCode):
            self.infoView(message: "Event Created Successfully: EventName\(self.event.eventName), Code: \(eventCode) ", color: Colors.lightGreen)
            
          }
        })
      }
    }
    self.HideSpinner()
    
  }
}

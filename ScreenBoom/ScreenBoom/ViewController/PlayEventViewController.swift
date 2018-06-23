//
//  PlayEventViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/8/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PlayEventViewController: BaseViewController, PlayEventViewModelSourceObserver {
  
  func update(viewModel: PlayEventViewModel) {
    self.playEventView?.configure(viewModel: viewModel)
    
    if let viewerCount = viewModel.eventDetail.viewerCount {
       self.playEventView?.updateViewerLabel(viewerCount : viewerCount)
    } else {
        self.playEventView?.updateViewerLabel(viewerCount : 0)
    }
  }
  
  // variables
  var event: Event
  var eventDetail: EventDetail
  var eventManager = EventManager()
  var eventDetailManager = EventDetailManager()
  var playEventView: PlayEventView?
  var rightMenuView: RightMenuView?
  var playEventViewModelSource: PlayEventViewModelSource?
  var isShowEventNameAndCodeLabel = false
    
    // **** we need to move this code into a viewModel
    let blurEffectView : UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        return view
    }()
    let shareView : UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
   
    let eventNameAndCodeButtonLabel : UIButton = {
        let view = UIButton()
        view.sizeToFit()
        view.titleLabel?.adjustsFontSizeToFitWidth = true
        view.titleLabel?.numberOfLines = 0
        view.titleLabel?.textAlignment = .left
        view.backgroundColor = UIColor.clear
        view.isEnabled = false
        return view
    }()
    let shareButton : UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "share"), for: .normal)
        return view
    }()
  
  // init
   init (event:Event, eventDetail: EventDetail) {
    self.event = event

    self.eventDetail = eventDetail
    
    super.init(nibName: nil, bundle: nil)
  }
    
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // setup observation.
    
    self.playEventViewModelSource = PlayEventViewModelSource(event: self.event, eventDetail: eventDetail)
    self.playEventViewModelSource?.addObserver(observer: self)
    self.playEventViewModelSource?.configureWithFirebaseUpdatedEvent()
    self.playEventViewModelSource?.configureWithFirebaseUpdateEventDetail()
    
    saveUserDefaultOldEventAndUserID()
    
    setupViews()

  }

  //AddSwipeGesture
  func addSwipGuestureRecognizers() {
    [UISwipeGestureRecognizerDirection.right,
     UISwipeGestureRecognizerDirection.left,
     UISwipeGestureRecognizerDirection.up,
     UISwipeGestureRecognizerDirection.down].forEach { (direction) in
      let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
      swipe.direction = direction
      self.view.addGestureRecognizer(swipe)
    }
  }
  //respondToSwipeGesture
  @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer
    {
      switch swipeGesture.direction
      {
      case UISwipeGestureRecognizerDirection.right:
        if isShowEventNameAndCodeLabel {
          isShowEventNameAndCodeLabel = false
          self.rightMenuView?.frame.origin.x = self.view.frame.maxX - 10
        }
        print("Swiped right")
      case UISwipeGestureRecognizerDirection.down:
        self.navigationController?.isNavigationBarHidden = false
        self.shareView.isHidden = false
        print("Swiped down")
      case UISwipeGestureRecognizerDirection.left:
        if !isShowEventNameAndCodeLabel {
          isShowEventNameAndCodeLabel = true
          self.rightMenuView?.frame.origin.x =  self.view.frame.maxX - 80
        }
        print("Swiped left")
      case UISwipeGestureRecognizerDirection.up:
        self.navigationController?.isNavigationBarHidden = true
        self.shareView.isHidden = true
        print("Swiped up")
      default:
        break
      }
    }
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    if let playView = playEventView {
        self.view.addSubview(playView)
        playView.frame = CGRect(x: 0,
                                y: 0,
                                width: size.width,
                                height: size.height)
    }
    
    if let rightMenu = rightMenuView {
        rightMenu.frame = CGRect(x: size.width - 10,
                                 y: 0,
                                 width: 80,
                                 height: size.height - 50)
        self.view.bringSubview(toFront: rightMenu)
        rightMenu.configureWith(event: self.event, eventCode: self.event.eventCode)
    }
    self.shareView.frame = CGRect(x: 0,
                                  y: size.height - 50,
                                  width: size.width,
                                  height: size.height - 50)
    self.view.bringSubview(toFront: shareView)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    self.navigationController?.isNavigationBarHidden = false
   
    addSwipGuestureRecognizers()
    

    // Now that the view has been loaded we can safely setup our
    // constraints
    setupConstraints()
    
     setupShareView()
    
    if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String,
        userID == event.userID {
        prepareForEventOwner()
    } else {
        
        // add this user to event viewers
        prepareForEventViewer()
    }
  }
    
    func prepareForEventOwner() {
        setupSideMenu()
    }
    
    func prepareForEventViewer() {
        // here we add the current user to the view list of this event
        FireBaseManager.sharedInstance.addToViewList(event: self.event)
        
    }
  
  override func viewWillDisappear(_ animated: Bool) {
    // here we remove the current user from the view list of this event
    if !eventManager.isEventOwner(eventUserID: self.event.userID!) {
        FireBaseManager.sharedInstance.removeFromViewList(event: self.event)
    }
    self.playEventViewModelSource?.removeObserver(observer: self)
    
    changeTransition(direction: "backword")
  }
  
  // Here we want to setup the correct play view based on the the event type that we have
  // we switch on the event type and add the appropriate playView to our view hierarchy
  func setupViews() {
    var playView: PlayEventView?
    
    switch (self.event.eventType) {
    case .Text:
      playView = TextPlayEventView()
      break
    case .Photo:
      playView = PhotoPlayEventView()
      break
    case .Animation:
      playView = AnimationPlayEventView()
      break
    case .Unknown:
      playView = nil
      break
    }
    
    guard let finalPlayView = playView else { return }
    self.playEventView = finalPlayView
   
    self.playEventView?.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
  
  }
  
  func setupConstraints() {
    if let playView = playEventView {
      self.view.addSubview(playView)
        playView.anchor(top: self.view.safeAreaLayoutGuide.topAnchor,
                        leading: self.view.leadingAnchor,
                        bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                        trailing: self.view.trailingAnchor)
        
//      playView.frame = CGRect(x: self.view.safeAreaLayoutGuide.layoutFrame.minX,
//                              y: 0,
//                              width: self.view.safeAreaLayoutGuide.layoutFrame.size.width,
//                              height: self.view.safeAreaLayoutGuide.layoutFrame.size.height)
    }
    
  }
    
    func setupShareView() {
        self.view.addSubview(shareView)
        shareView.addSubview(blurEffectView)
        shareView.addSubview(eventNameAndCodeButtonLabel)
        shareView.addSubview(shareButton)
        
        blurEffectView.anchor(top: shareView.topAnchor,
                              leading: shareView.leadingAnchor,
                              bottom: shareView.bottomAnchor,
                              trailing: shareView.trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        shareView.anchor(top: nil,
                         leading: self.view.leadingAnchor,
                         bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                         trailing: self.view.trailingAnchor,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 80),
                         size: .init(width: 0, height: 50))
      
        eventNameAndCodeButtonLabel.anchor(top: shareView.topAnchor,
                                           leading: shareView.leadingAnchor,
                                           bottom: shareView.bottomAnchor,
                                           trailing: shareButton.leadingAnchor,
                                           padding: .init(top: 10, left: 5, bottom: 10, right: 0),
                                           size: .init(width: 0, height: 0))

        shareButton.anchor(top: shareView.topAnchor,
                           leading: eventNameAndCodeButtonLabel.trailingAnchor,
                           bottom: shareView.bottomAnchor,
                           trailing: shareView.trailingAnchor,
                           padding: .init(top: 10, left: 5, bottom: 10, right: 5),
                           size: .init(width: 30, height: 0))
       
        
        eventNameAndCodeButtonLabel.setTitle("Title: \(self.event.eventName) \n Code: \(self.event.eventCode)", for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonPressed(_:)), for: .touchUpInside)
        
        
        self.view.bringSubview(toFront: shareView)
    }
  
  func setupSideMenu() {
    
    let rightMenu = RightMenuView()
    
    self.view.addSubview(rightMenu)
    
    rightMenu.frame = CGRect(x: self.view.frame.maxX - 10,
                             y: self.view.safeAreaLayoutGuide.layoutFrame.minY,
                             width: 80,
                             height: self.view.safeAreaLayoutGuide.layoutFrame.size.height - 50)
    
    rightMenu.configureWith(event: self.event, eventCode: self.event.eventCode)
   
    self.view.bringSubview(toFront: rightMenu)
    self.rightMenuView = rightMenu
    
    // Delegates
    self.rightMenuView?.sideMenuDelegate = self
    
    
  }
  
      @objc func shareButtonPressed(_ sender: UIButton) {
        // Here it should present the Activity View Controller to send the event Deep link URL
        // useing Email or SMS
        let deepLinkURL =  DeepLinkManager.sharedInstance.shareMyDeepLinkURL(eventName: self.event.eventName, eventCode: self.event.eventCode)
        let activityController = UIActivityViewController(activityItems: [deepLinkURL], applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil)
      }

  // remove user from list of viewer
  func removeFromViewList() {
    if let userID = UserDefaults.standard.object(forKey: userDefaultKeyNames.userIDKey) as? String,
      userID != self.event.userID {
      firebaseDatabaseReference.child(firebaseNodeNames.eventDetailNode).child(self.event.eventName).child("views").child(userID).removeValue(completionBlock: { (error, _) in
        if error != nil {
          print("Couldn't remove user from views, Error: \(String(describing: error?.localizedDescription))")
        }
      })
    }
    
  }
  
  func saveUserDefaultOldEventAndUserID(){
    UserDefaults.standard.set(self.event.eventName, forKey: userDefaultKeyNames.eventNameKey)
    UserDefaults.standard.set(self.event.eventCode, forKey: userDefaultKeyNames.eventCodeKey)
  }
}

extension PlayEventViewController: SideMenuDelegate {
  func sideMenuEditButtonPressed() {
    // Here we need to implement update feature
  }

  func sideMenuPlayButtonPressed() {

    ShowSpinner()
    
    eventManager.updateEvenIsLive(event: self.event, isLive: firebaseNodeNames.eventNodeIsLiveYesValue) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
      case .Success():
        self.infoView(message: "Play", color: Colors.lightGreen)
      }
    }
    
    HideSpinner()
  }
  
  func sideMenuDeleteButtonPressed() {
    
    ShowSpinner()
    
    eventDetailManager.removeEventDetailWithEventAndEventDetail(event: self.event, eventDetail: self.eventDetail) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
        break
      case .Success():
        self.infoView(message: "Event Deleted successfully", color: Colors.lightGreen)
        // set the eventDetail.photoName in the event detail view controller
        self.navigationController?.popViewController(animated: true)
        break
      }
    }
    
    HideSpinner()
    
  }
  
  func sideMenuPauseButtonPressed() {
//    for view in (self.playEventView?.subviews)! {
//      view.removeFromSuperview()
//    }
    ShowSpinner()
    
    eventManager.updateEvenIsLive(event: self.event, isLive: firebaseNodeNames.eventNodeIsLivePauseValue) { (result) in
      switch result {
      case .Failure(let error):
        self.infoView(message: error, color: Colors.smoothRed)
      case .Success():
        self.infoView(message: "Pause", color: Colors.lightGreen)
      }
    }
    
    HideSpinner()
  }
  
  
}















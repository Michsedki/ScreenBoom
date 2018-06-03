//
//  HomeViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import CloudKit
import FirebaseDatabase



class HomeViewController: BaseViewController, UIViewControllerTransitioningDelegate {
  
  let userDefaultICloudViewModel = UserDefaultICloudViewModel()
  let eventViewModel = EventManager()
  let transition = CircularTransition()
  
//  var isDeepLinking = false
  
  let logoImageView : UIImageView = {
    let view = UIImageView(image: #imageLiteral(resourceName: "Ironbg"))
    view.translatesAutoresizingMaskIntoConstraints = false
    view.sizeToFit()
    return view
  }()
  
  let joinEventBottun : UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.titleLabel?.textColor = UIColor.white
    view.setTitle("JOIN EVENT", for: .normal)
    view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    view.backgroundColor = Colors.lightBlue
    view.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
    view.roundIt()
    return view
  }()
  
  let createEventBottun : UIButton = {
    let view = UIButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.titleLabel?.textColor = UIColor.white
    view.setTitle("CREATE EVENT", for: .normal)
    view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
    view.backgroundColor = Colors.lightBlue
    view.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
    view.roundIt()
    return view
  }()
  
  let bottunStackView : UIStackView = {
    let view = UIStackView()
    view.distribution = .fillEqually
    view.spacing = 20
    return view
  } ()
  
  let desceptionTextView : UITextView = {
    let view = UITextView()
    let attributedText = NSMutableAttributedString(string: "WELCOME TO SCREENBOOM SHARING SCREEN APP.", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)])
    attributedText.append(NSMutableAttributedString(string: "\n\n\n SCREENBOOM allows you to create Event and share it with others, no need for big screens or projectors, so easy and simple", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13),
                     NSAttributedStringKey.foregroundColor: UIColor.gray]))
    view.attributedText = attributedText
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isEditable = false
    view.isScrollEnabled = false
    view.textAlignment = .center
    return view
  }()
  
  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .present
    transition.startingPoint = createEventBottun.center
    transition.circleColor = createEventBottun.backgroundColor!
    return transition
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    transition.transitionMode = .dismiss
    transition.startingPoint = createEventBottun.center
    transition.circleColor = createEventBottun.backgroundColor!
    return transition
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    setupViews()
    
    rigisterUser()
//    if !isDeepLinking { rigisterUser() }
  }
  
  
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
  }
  
  private func setupViews() {
    
    let topImageContainerView : UIView = {
      let view = UIView()
      return view
    }()
    
    view.addSubview(topImageContainerView)
    view.addSubview(bottunStackView)
    view.addSubview(desceptionTextView)
    topImageContainerView.addSubview(logoImageView)
    
    topImageContainerView.anchor(top: view.topAnchor,
                                 leading: view.leadingAnchor,
                                 bottom: nil,
                                 trailing: view.trailingAnchor)
    topImageContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
    
    NSLayoutConstraint.activate([
      logoImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
      logoImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor),
      logoImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5),
      logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 4/3)
      ])
    
    
    bottunStackView.addArrangedSubview(createEventBottun)
    bottunStackView.addArrangedSubview(joinEventBottun)
    bottunStackView.anchor(top: topImageContainerView.bottomAnchor,
                           leading: view.safeAreaLayoutGuide.leadingAnchor,
                           bottom: nil,
                           trailing: view.safeAreaLayoutGuide.trailingAnchor,
                           padding: .init(top: 10, left: 10, bottom: 0, right: 10),
                           size: .init(width: 0, height: 50))
    
    desceptionTextView.anchor(top: nil,
                              leading: bottunStackView.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: bottunStackView.trailingAnchor)
    
    addButtonsAction()
    
  }
  
  func addButtonsAction() {
    
    createEventBottun.addTarget(self, action: #selector(createEventBottunPressed(_:)), for: .touchUpInside)
    joinEventBottun.addTarget(self, action: #selector(joinEventBottunPressed(_:)), for: .touchUpInside)
  }
  
  @objc func createEventBottunPressed(_ sender: UIButton) {
    let createEventViewController = self.storyboard?.instantiateViewController(withIdentifier: "CreateEventViewController") as! CreateEventViewController
    createEventViewController.transitioningDelegate = self
    
    self.navigationController?.pushViewController(createEventViewController, animated: true)
  }
  
  @objc func joinEventBottunPressed(_ sender: UIButton) {
    let joinEventViewController = self.storyboard?.instantiateViewController(withIdentifier: "JoinEventViewController") as! JoinEventViewController
    self.navigationController?.pushViewController(joinEventViewController, animated: true)
    
  }
  
  
  func rigisterUser() {
    userDefaultICloudViewModel.getICloudUserID { (userID, error) in
      if error == nil , let userID = userID {
        _ = self.userDefaultICloudViewModel.checkIfTheSameUserIcloudID(userID: userID)
        if let oldEventName = self.userDefaultICloudViewModel.checkIfOldEventNameIsExist() ,
          let oldEventCode = self.userDefaultICloudViewModel.checkIfOldEventCodeIsExist() {
          let oldEvent = Event(eventName: oldEventName, eventIsLive: "no", eventType: .Unknown, eventCode: oldEventCode)
            self.eventViewModel.checkIfEventExists(newEvent: oldEvent, completion: { (isExist, eventObj) in
            if isExist,
                let eventFound = eventObj {
              if eventFound.userID == userID {
                self.showJoinOldEventAlert(eventName: oldEventName, eventCode: oldEventCode)
              }
            }
          })
        }
      } else {
        // show alert
        self.showNotSignedInICloud()
      }
    }
    
  }
  
  // show alert that user not sign in ICloud
  func showNotSignedInICloud() {
    
    let alert = UIAlertController(title: "ICloud account not found", message: "Would you sign in your ICloud Account ", preferredStyle: UIAlertControllerStyle.alert)
    // add the actions (buttons)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {action in self.rigisterUser()}))
    // show the alert
    self.present(alert, animated: true, completion: nil)
    
  }
  
  // show alert that user not sign in ICloud
  func showJoinOldEventAlert(eventName: String, eventCode: String) {
    
    let alert = UIAlertController(title: "Previous Event", message: "Would you like to join your previous event \n Name: \(eventName) \n Code: \(eventCode)", preferredStyle: UIAlertControllerStyle.alert)
    // add the actions (buttons)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {action in self.joinOldEvent(eventName: eventName, eventCode: eventCode)}))
    
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    // show the alert
    self.present(alert, animated: true, completion: nil)
    
  }
  
  func joinOldEvent(eventName: String, eventCode: String) {
    if let joinEventViewController = storyboard?.instantiateViewController(withIdentifier: "JoinEventViewController") as? JoinEventViewController {
      joinEventViewController.getEventAndCmpareCode(eventName: eventName, eventCode: eventCode)
      self.navigationController?.pushViewController(joinEventViewController, animated: true)
    }
    
  }
  
}


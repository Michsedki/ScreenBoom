//
//  CreateEventViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import GoogleMobileAds

class CreateEventViewController: BaseViewController {
    
    /// Mark:- Outlets
    @IBOutlet weak var eventNameTextfield: UITextField!
    @IBOutlet weak var eventTypePickerview: UIPickerView!
    @IBOutlet weak var max10EventsLabel: UILabel!
    
    var createdEventsTableView : UITableView = {
        let view = UITableView()
        return view
    }()
    
    let noEventToShowLabel : UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.text = "No Events"
        view.textColor = Colors.lightBlue
        return view
    }()
    
    /// Mark:- Constants
    let constantNames = ConstantNames.sharedInstance
    
    /// Mark:- Varibales
    let eventViewModel = EventManager()
    let eventDetailManager = EventDetailManager()
    let eventTypePickerviewDataSource = ["Text", "Photo", "Animation"]
    var currentEventType:EventType = .Text
    var createdEvents = [[String:String]]()
    var bannerView: GADBannerView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        /// Mark:- Delegate
        eventNameTextfield.delegate = self
        
        pickerViewDelegateAndDataSourceAndCellRegister()
        
        tableViewDelegateAndDataSourceAndCellRegister()
        
        setUpTableView()
        
        GADDelegateAndSetup()
        
    }
    
    override func viewWillLayoutSubviews() {
        self.setUpEventTypePickerview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // we need to show the navigation bar after it was hidden in the homeViewController
        self.navigationController?.isNavigationBarHidden = false
        
       prepareForViewWillAppearWithForcedPortrait()
    
        // we will check number of created events by current user if equal to 10 we will
        // disable the createEventButton untill the user delete some events
        getUserCreatedEvents()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        prepareForViewWillDisapear()
    }
    
    
    func getUserCreatedEvents() {
        self.ShowSpinner()
        FireBaseManager.sharedInstance.getUserCreatedEvents { (result) in
            switch result {
            case .Failure(let error):
                self.setupNoEventToShowLAbel()
                print(error)
            case .Success(let createdEvents):
                self.createdEvents = createdEvents
                self.noEventToShowLabel.removeFromSuperview()
                self.createdEventsTableView.reloadData()
                print(createdEvents)
            }
            self.HideSpinner()
        }

    }
    
    func setupNoEventToShowLAbel() {
        view.addSubview(noEventToShowLabel)
        noEventToShowLabel.anchor(top: max10EventsLabel.bottomAnchor,
                                  leading: max10EventsLabel.leadingAnchor,
                                  bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                                  trailing: max10EventsLabel.trailingAnchor,
                                  padding: .init(top: 0, left: 0, bottom: 50, right: 0))
        
    }
    
    @IBAction func addNewEventBarButtonPressed(_ sender: UIBarButtonItem) {
        // check if user has 10 events already, if yes show info message
        // check if we have the event name and event type, by checking the value of the
        // textfield and pickerView
        // then create currentEvent with standard values eventName, eventISLive : "no", eventType
        // and eventCode : ""
        // check if the event name is exist in the Event node and show info message if exist
        // if not show event detail view controller
        
        guard self.createdEvents.count < 10 else {
            self.infoView(message: "10 Events reached", color: Colors.smoothRed)
            return
        }
        
        guard let eventName = eventNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), !eventName.isEmpty else {
            self.infoView(message: "No event name!", color: Colors.smoothRed)
            return
        }
        // create current event with current userID
        let currentEvent = Event(eventName: eventName,
                                 eventIsLive: "no",
                                 eventType: self.currentEventType,
                                 eventCode: "")
        
        ShowSpinner()
        eventViewModel.checkIfEventExists(newEvent: currentEvent) { (isExist, eventObj) in
            if !isExist {
                self.showDetailViewController(event : currentEvent, eventDetail: nil)
            } else {
                guard let eventFound = eventObj else {
                    // couldn't retrive the event data from firebase snapshot
                    self.infoView(message: "Event name is Already Exist", color: Colors.smoothRed)
                    return
                }
                
                guard eventFound.userID == currentEvent.userID else {
                    // user is not the owner of the event, so he can't change it
                    self.infoView(message: "Event name is Already Exist", color: Colors.smoothRed)
                    return
                }
                
                if eventFound.eventType == currentEvent.eventType {
                    // same type
                    // tell the showDetailViewController that is old event to drow it
                    //  **** no need to get the eventDetail here as long as we will get it
                    // in the next view controller
                    self.eventDetailManager.checkIfEventDetailExist(event: eventFound, completion: { (result) in
                        switch result {
                        case .Failure( _):
                            self.showDetailViewController(event : eventFound, eventDetail: nil)
                            break
                        case .Success(let eventDetail):
                            self.showDetailViewController(event : eventFound, eventDetail: eventDetail)
                            break
                        }
                    })
                    
                } else {
                    // deferent type
                    // remove the old one before you show the event detail view controller
                    self.ShowSpinner()
                    self.eventDetailManager.removeEventAndEventDetail(event: eventFound, eventDetail: nil, completion: { (result) in
                        switch result {
                        case .Failure( _):
                            self.infoView(message: "Event name is Already Exist", color: Colors.smoothRed)
                            break
                        case .Success(()):
                            self.showDetailViewController(event : currentEvent, eventDetail: nil)
                            break
                        }
                    })
                    self.HideSpinner()
                }
            }
            
        }
        HideSpinner()
    }
    
    func showDetailViewController(event: Event, eventDetail : EventDetail?) {
        var eventDetailItem:EventDetail
        var eventDetailVC: EventDetailViewController?
        
        switch event.eventType {
        case .Text:
            if let oldTextEventDetail = eventDetail {
                eventDetailItem = oldTextEventDetail
            } else {
                eventDetailItem = TextEventDetail(
                    animationName: constantNames.animationNamesArray[0],
                    backgroundcolor: constantNames.colorsNamesList[1],
                    textcolor: constantNames.colorsNamesList[12],
                    speed: 0,
                    text: "Your Text",
                    font: constantNames.fontNames[0],
                    fontsize: 25,
                    code: "")
            }
            guard let textEventDetail = eventDetailItem as? TextEventDetail else { return }
            eventDetailVC = TextEventDetailViewController(event: event, eventDetail: textEventDetail)
            break
            
        case .Photo:
            if let oldPhotoEventDetail = eventDetail {
                eventDetailItem = oldPhotoEventDetail
            } else {
                eventDetailItem = PhotoEventDetail(
                    photoname: imageNames.placeHolder,
                    code: "")
            }
            guard let photoEventDetail = eventDetailItem as? PhotoEventDetail else { return }
            eventDetailVC = PhotoEventDetailViewController(event: event, eventDetail: photoEventDetail)
            break
            
        case .Animation:
            if let oldAnimationEventDetail = eventDetail {
                eventDetailItem = oldAnimationEventDetail
            } else {
                eventDetailItem = AnimationEventDetail(
                    animationStringURL: "",
                    code: ""
                    )
//                animationPreviewURL: ""
            }
            guard let animationEventDetail = eventDetailItem as? AnimationEventDetail else { return }
            eventDetailVC = AnimationEventDetailViewController(event: event, eventDetail: animationEventDetail)
            break
            
        case .Unknown:
            
            eventDetailVC = nil
            break
            
        }
        
        if let vc = eventDetailVC {
            changeTransition(direction: "forword")
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}

// Extension to handle the PickerView Protocol
extension CreateEventViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerViewDelegateAndDataSourceAndCellRegister () {
        eventTypePickerview.delegate = self
        eventTypePickerview.dataSource = self
    }
    
    func setUpEventTypePickerview() {
        eventTypePickerview.backgroundColor = .white
        eventTypePickerview.subviews[1].isHidden = true
        eventTypePickerview.subviews[2].isHidden = true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventTypePickerviewDataSource.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return eventTypePickerviewDataSource[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var eventType: EventType
        switch (row) {
        case 0:
            eventType = .Text
        case 1:
            eventType = .Photo
        case 2:
            eventType = .Animation
        default:
            eventType = .Unknown
        }
        self.currentEventType = eventType
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let attributedString = NSAttributedString(string: eventTypePickerviewDataSource[row], attributes: [NSAttributedStringKey.foregroundColor : Colors.lightBlue])
//
//        return attributedString
//    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let label = UILabel()
        label.textAlignment = .center
        label.frame = CGRect(x: 0, y: 0, width: pickerView.frame.width, height: 35)

       

        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = eventTypePickerviewDataSource[row]
        label.textColor = Colors.lightBlue

        return label
    }
    
    
}



// Extension to handle the createdEvents TableView Protocol

extension CreateEventViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableViewDelegateAndDataSourceAndCellRegister() {
        createdEventsTableView.delegate = self
        createdEventsTableView.dataSource = self
        createdEventsTableView.register(CreatedEventsTableViewCell.self, forCellReuseIdentifier: "CreatedEventsTableViewCell")
    }
    
    func setUpTableView() {
        
        self.view.addSubview(createdEventsTableView)
        createdEventsTableView.anchor(top: max10EventsLabel.bottomAnchor,
                                     leading: max10EventsLabel.leadingAnchor,
                                     bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                                     trailing: max10EventsLabel.trailingAnchor,
                                     padding: .init(top: 0, left: 0, bottom: 50, right: 0))
        createdEventsTableView.rowHeight = UITableViewAutomaticDimension
        createdEventsTableView.estimatedRowHeight = 140
        createdEventsTableView.backgroundColor = .clear
        createdEventsTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.createdEvents.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let joinEventViewController = storyboard?.instantiateViewController(withIdentifier: "JoinEventViewController") as? JoinEventViewController,
            let eventName = self.createdEvents[indexPath.row]["eventName"],
            let eventCode = self.createdEvents[indexPath.row]["eventCode"] {
            
            joinEventViewController.getEventAndCmpareCode(eventName: eventName, eventCode: eventCode)
            changeTransition(direction: "forword")
            self.navigationController?.pushViewController(joinEventViewController, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.createdEventsTableView.dequeueReusableCell(withIdentifier: "CreatedEventsTableViewCell", for: indexPath) as? CreatedEventsTableViewCell {
           
                cell.configureCell(eventInfoDic: self.createdEvents[indexPath.row])
                cell.eventShareButton.tag = indexPath.row
                cell.eventShareButton.addTarget(self, action: #selector(shareButtonPressed(_:)), for: .touchUpInside)
                return cell
            
        }
        return UITableViewCell()
    }
    
    @objc func shareButtonPressed(_ sender: UIButton) {
        let index = IndexPath(row: sender.tag, section: 0)
        
        // Here it should present the Activity View Controller to send the event Deep link URL
        // useing Email or SMS
        let deepLinkURL =  DeepLinkManager.sharedInstance.shareMyDeepLinkURL(eventName: self.createdEvents[index.row]["eventName"]!, eventCode: self.createdEvents[index.row]["eventCode"]!)
        
        let activityController = UIActivityViewController(activityItems: [deepLinkURL], applicationActivities: nil)
        
        present(activityController, animated: true, completion: nil)
        print("\(sender.tag) : \(deepLinkURL)")
    }
    
    // here we add an extra separator gray line between cells
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let additionalSeparatorThickness = CGFloat(5)
        let additionalSeparator = UIView.init(frame: CGRect(x: 0,
                                                            y: cell.frame.size.height - additionalSeparatorThickness,
                                                            width: cell.frame.size.width,
                                                            height: additionalSeparatorThickness))
        
        additionalSeparator.backgroundColor = UIColor.lightGray
        cell.addSubview(additionalSeparator)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let deleteEvent = Event(eventName: self.createdEvents[indexPath.row]["eventName"]!,
                                    eventIsLive: "no",
                                    eventType: EventType(rawValue: self.createdEvents[indexPath.row]["eventType"]!)!,
                                    eventCode: self.createdEvents[indexPath.row]["eventCode"]!)
            
            self.ShowSpinner()
            self.eventDetailManager.removeEventAndEventDetail(event: deleteEvent, eventDetail: nil, completion: { (result) in
                switch result {
                case .Failure( _):
                    self.infoView(message: "Event not deleted", color: Colors.smoothRed)
                    break
                case .Success(()):
                    self.createdEvents.remove(at: indexPath.row)
                    self.createdEventsTableView.reloadData()
                    self.infoView(message: "Event deleted", color: Colors.lightGreen)
                    if self.createdEvents.count == 0 {
                    self.setupNoEventToShowLAbel()
                    }
                    break
                }
                self.HideSpinner()
            })
        }
    }
    
}

extension CreateEventViewController : GADBannerViewDelegate {
    
    func GADDelegateAndSetup() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        bannerView.delegate = self
        bannerView.rootViewController = self
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView.adUnitID = "ca-app-pub-2855997463993070/3784246274"
        bannerView.load(GADRequest())
        
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        bannerView.anchor(top: nil,
                          leading: self.view.leadingAnchor,
                          bottom: self.view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: self.view.trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                          size: .init(width: 0, height: 50))
        
    }
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerViewToView(bannerView)
        print("adViewDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
    
}





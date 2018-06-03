//
//  JoinEventViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class JoinEventViewController: BaseViewController {
    
    // variables
    let userDefaultICloudViewModel = UserDefaultICloudViewModel()
    var event: Event?
    var eventManager = EventManager()
    var eventDetailManager = EventDetailManager()
    var joinedEvents = [[String:String]]()
    
    var joinedEventsTableView : UITableView = {
        let view = UITableView()
        return view
    }()
    
    // Outlets
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDelegateAndDataSourceAndCellRegister()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpTableView()
        
        getUserJoinedEvents()
        
        self.navigationController?.isNavigationBarHidden = false
        setupJoinLastEventView()
    }
    
    func getUserJoinedEvents() {
        FireBaseManager.sharedInstance.getUserJoinedEvents { (result) in
            switch result {
            case .Failure(let error):
                // we need to update user that there is no history of joined events
                print(error)
                break
            case .Success(let joinedEvents):
                self.joinedEvents = joinedEvents
                self.joinedEventsTableView.reloadData()
                
                //                print(joinedEvents)
                break
            }
        }
    }
    
    
    @IBAction func joinBarButtonPressed(_ sender: UIBarButtonItem) {
        
        // check if textfields is empty
        guard let eventName = eventNameTextField.text, !eventName.isEmpty else {
            let message = "Please enter Valid event name"
            self.infoView(message: message, color: Colors.smoothRed)
            return
        }
        guard let eventCode = codeTextField.text, !eventCode.isEmpty else {
            let message = "Please enter Valid event code"
            self.infoView(message: message, color: Colors.smoothRed)
            return
        }
        getEventAndCmpareCode(eventName: eventName, eventCode: eventCode)
        //
    }
    
    func getEventAndCmpareCode(eventName: String, eventCode: String) {
        
        self.event = Event(eventName: eventName, eventIsLive: "no", eventType: .Unknown, eventCode: eventCode)
        // start spinner
        self.ShowSpinner()
        guard let event = self.event else { return }
        eventManager.checkIfEventExists(newEvent: event) { [unowned self] (isExist,eventObj)  in
            guard isExist else {
                self.infoView(message: "event is not Exist", color: Colors.smoothRed)
                return
            }
            guard let eventFound = eventObj else {
                self.infoView(message: "Couldn't retrive event", color: Colors.smoothRed)
                return
            }
            
            if eventFound.eventCode == eventCode {
                event.eventIsLive = eventFound.eventIsLive
                event.userID = eventFound.userID
                event.eventType = eventFound.eventType
                
                // we need to update our captures reference to the event
                self.event = event
                // we also need to get an event detail before showing the play view controller
                self.getEventDetail()
            } else {
                self.infoView(message: "Code is not valid", color: Colors.smoothRed)
            }
        }
        self.HideSpinner()
    }
    
    func getEventDetail() {
        guard let event = self.event else { return }
        self.eventDetailManager.checkIfEventDetailExist(event: event, completion: { result in
            switch (result) {
            case .Failure(let errorString):
                print(errorString)
            case .Success(let eventDetail):
    if !self.eventManager.isEventOwner(eventUserID: event.userID!) && !self.joinedEventsContains(eventName: event.eventName)  {
                    FireBaseManager.sharedInstance.addEventToUserJoinedEvents(event: event)
                }
                self.showPlayEventViewController(event: event, eventDetail: eventDetail)
            }
        })
    }
    
    // this condition to prevent adding exists event to joined event list
    // we do that by checking if we have the event in the table view Datasource or not
    func joinedEventsContains(eventName: String) -> Bool {
        for jointEventItem in self.joinedEvents {
            if jointEventItem["eventName"] == eventName {
                return true
            }
        }
        return false
    }
    func setupJoinLastEventView() {
        guard let lastEventName = self.userDefaultICloudViewModel.checkIfOldEventNameIsExist() ,
            let lastEventCode = self.userDefaultICloudViewModel.checkIfOldEventCodeIsExist() else { return }
        
        
    }
    
    //  @objc func joinLastEventButtonPressed (){
    //    if let lastEventName = self.userDefaultICloudViewModel.checkIfOldEventNameIsExist() ,
    //      let lastEventCode = self.userDefaultICloudViewModel.checkIfOldEventCodeIsExist() {
    //      getEventAndCmpareCode(eventName: lastEventName, eventCode: lastEventCode)
    //    }
    //
    //  }
    
    // Push PlayEventViewController
    func showPlayEventViewController(event: Event, eventDetail: EventDetail) {
        let PlayViewController = PlayEventViewController(event: event, eventDetail:eventDetail)
        self.navigationController?.pushViewController(PlayViewController, animated: true)
    }
}

extension JoinEventViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableViewDelegateAndDataSourceAndCellRegister() {
        joinedEventsTableView.delegate = self
        joinedEventsTableView.dataSource = self
        joinedEventsTableView.register(CreatedEventsTableViewCell.self, forCellReuseIdentifier: "CreatedEventsTableViewCell")
    }
    
    func setUpTableView() {
        
        self.view.addSubview(joinedEventsTableView)
        joinedEventsTableView.anchor(top: codeTextField.bottomAnchor,
                                     leading: codeTextField.leadingAnchor,
                                     bottom: self.view.bottomAnchor,
                                     trailing: codeTextField.trailingAnchor,
                                     padding: .init(top: 0, left: 0, bottom: 50, right: 0))
        joinedEventsTableView.rowHeight = UITableViewAutomaticDimension
        joinedEventsTableView.estimatedRowHeight = 140
        joinedEventsTableView.backgroundColor = .clear
        joinedEventsTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return joinedEvents.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let eventName = self.joinedEvents[indexPath.row]["eventName"],
            let eventCode = self.joinedEvents[indexPath.row]["eventCode"] {
            
            getEventAndCmpareCode(eventName: eventName, eventCode: eventCode)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.joinedEventsTableView.dequeueReusableCell(withIdentifier: "CreatedEventsTableViewCell", for: indexPath) as? CreatedEventsTableViewCell {
            if let eventName = self.joinedEvents[indexPath.row]["eventName"],
                let eventCode = self.joinedEvents[indexPath.row]["eventCode"],
                let eventType = self.joinedEvents[indexPath.row]["eventType"] {
                cell.configureCell(eventName: eventName, eventCode: eventCode, eventType: eventType)
                cell.eventShareButton.tag = indexPath.row
                cell.eventShareButton.addTarget(self, action: #selector(shareButtonPressed(_:)), for: .touchUpInside)
                
                return cell
            }
            
            
        }
        return UITableViewCell()
    }
    
    @objc func shareButtonPressed(_ sender: UIButton) {
        let index = IndexPath(row: sender.tag, section: 0)
        
        // Here it should present the Activity View Controller to send the event Deep link URL
        // useing Email or SMS
        let deepLinkURL =  DeepLinkManager.sharedInstance.shareMyDeepLinkURL(eventName: self.joinedEvents[index.row]["eventName"]!, eventCode: self.joinedEvents[index.row]["eventCode"]!)
        
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
            
            ShowSpinner()
            
//            print(joinedEvents[indexPath.row]["Key"])
            FireBaseManager.sharedInstance.removeFromUserJoinedEvents(joinedEventID:  joinedEvents[indexPath.row]["Key"]!) { (result) in
                if result {
                    self.joinedEvents.remove(at: indexPath.row)
                    self.joinedEventsTableView.reloadData()
                }
            }
            HideSpinner()
        }
    }
    
}


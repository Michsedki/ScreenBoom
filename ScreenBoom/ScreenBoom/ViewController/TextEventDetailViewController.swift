//
//  TextEventDetailViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/22/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class TextEventDetailViewController: EventDetailViewController, DropDownSelectionDelegate {
  
    var eventDetail: TextEventDetail
    
    let eventTextField: UITextField = {
       let view = UITextField()
        view.backgroundColor = .lightGray
        // Create a padding view for padding on left
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: view.frame.height))
        view.leftViewMode = .always
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        view.roundIt()
        return view
    }()
    
    var textColorDropDownButton: dropDownBtn = dropDownBtn()
    var backgroundColorDropDownButton: dropDownBtn = dropDownBtn()
    
    let increaseFontSizeButton : UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.setImage(UIImage(named: "increaseFontSize"), for: .normal)
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.roundIt()
        return view
    }()
    
    let decreaseFontSizeButton : UIButton = {
        let view = UIButton()
        view.backgroundColor = .clear
        view.tag = 1
        view.setImage(UIImage(named: "decreaseFontSize"), for: .normal)
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.roundIt()
        return view
    }()
    
    //Delegate
    var dropDownSelectionDelegate:DropDownSelectionDelegate!

  func updatePreviewEventViewController () {
    let playEventViewModel = PlayEventViewModel(event: self.event, eventDetail: self.eventDetail)
    if let playEventVC = self.playPreviewEventViewController {
      playEventVC.configureWithPreviewPlayViewModel(playViewModel: playEventViewModel)
    }
  }
    
  init(event:Event, eventDetail: TextEventDetail) {
    self.eventDetail = eventDetail
    
    super.init(event: event)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
     setupViews()
    
    self.eventTextField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let value = UIInterfaceOrientation.portrait.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
    
    // disaple Rotation for this view controller
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.enableAllOrientation = false
    
   
    loadData()

  }
    
    override func viewWillDisappear(_ animated: Bool) {
        // allow rotation for other viewControllers
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = true
    }
  
  @objc func textFieldDidChanged(_ textField : UITextField) {
    self.eventDetail.text = textField.text
    
    updatePreviewEventViewController()
  }
    
    @objc func fontResizeButtonPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0 :
            self.eventDetail.fontsize = self.eventDetail.fontsize! * 1.1
            updatePreviewEventViewController()
            break
        case 1:
             self.eventDetail.fontsize = self.eventDetail.fontsize! * 0.9
             updatePreviewEventViewController()
            break
        default:
            break
        }
    }
  
  // load old eventDetail data
    func loadData() {
        eventTextField.text = self.eventDetail.text
        textColorDropDownButton.setTitle(self.eventDetail.textcolor, for: .normal)
        backgroundColorDropDownButton.setTitle(self.eventDetail.backgroundcolor, for: .normal)
    }
    
  func setupViews() {
    
    self.view.backgroundColor = .white
    
    // create Navigation bar right buttom "Create"
    let createRightBarButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(TextEventDetailViewController.rightBarButtonPressed(_:)))
    navigationItem.rightBarButtonItem = createRightBarButton
    
    // create container view to hold the play event preview
    self.view.addSubview(playEventPreviewContainerView)
    playEventPreviewContainerView.frame = CGRect(x: 20,
                                                 y: 84,
                                                 width: self.view.frame.width - 40,
                                                 height: 300)
    playEventPreviewContainerView.backgroundColor = UIColor.clear
    
    playPreviewEventViewController = PlayPreviewEventViewController(event: self.event,
                                                                    eventDetail: self.eventDetail)
    
    if let playEventVC = playPreviewEventViewController {
      self.addChildViewController(playEventVC)
      playEventPreviewContainerView.addSubview(playEventVC.view)
      playEventVC.view.frame = self.playEventPreviewContainerView.bounds
      playEventVC.didMove(toParentViewController: self)
    }
    
    playPreviewEventViewController?.view.anchor(top: playEventPreviewContainerView.topAnchor,
                                                leading: playEventPreviewContainerView.leadingAnchor,
                                                bottom: playEventPreviewContainerView.bottomAnchor,
                                                trailing: playEventPreviewContainerView.trailingAnchor,
                                                padding: .zero)
    playEventPreviewContainerView.addSubview(increaseFontSizeButton)
    playEventPreviewContainerView.addSubview(decreaseFontSizeButton)
    playEventPreviewContainerView.bringSubview(toFront: increaseFontSizeButton)
    playEventPreviewContainerView.bringSubview(toFront: decreaseFontSizeButton)
    
    increaseFontSizeButton.anchor(top: playEventPreviewContainerView.topAnchor,
                                  leading: nil,
                                  bottom: nil,
                                  trailing: playEventPreviewContainerView.trailingAnchor,
                                  padding: .init(top: 20, left: 0, bottom: 0, right: 10),
                                  size: .init(width: 20, height: 20))
    
    decreaseFontSizeButton.anchor(top: increaseFontSizeButton.bottomAnchor,
                                  leading: increaseFontSizeButton.leadingAnchor,
                                  bottom: nil,
                                  trailing: increaseFontSizeButton.trailingAnchor,
                                  padding: .init(top: 20, left: 0, bottom: 0, right: 0),
                                  size: .init(width: 20, height: 20))
    
    increaseFontSizeButton.addTarget(self, action: #selector(fontResizeButtonPressed(_:)), for: .touchUpInside)
    decreaseFontSizeButton.addTarget(self, action: #selector(fontResizeButtonPressed(_:)), for: .touchUpInside)
    
    self.view.addSubview(eventTextField)
    self.view.addSubview(textColorDropDownButton)
    self.view.addSubview(backgroundColorDropDownButton)
    
    eventTextField.anchor(top: playEventPreviewContainerView.bottomAnchor,
                          leading: self.view.leadingAnchor,
                          bottom: nil,
                          trailing: self.view.trailingAnchor,
                          padding: .init(top: 10, left: 10, bottom: 0, right: 10),
                          size: .init(width: 0, height: 40))
    eventTextField.addTarget(self, action: #selector(TextEventDetailViewController.textFieldDidChanged(_:)), for: .editingChanged)
    
    textColorDropDownButton.anchor(top: eventTextField.bottomAnchor,
                                   leading: self.view.leadingAnchor,
                                   bottom: nil,
                                   trailing: backgroundColorDropDownButton.leadingAnchor,
                                   padding: .init(top: 10, left: 10, bottom: 0, right: 5),
                                   size: .init(width: (self.view.frame.width - 30) / 2, height: 40))
    backgroundColorDropDownButton.anchor(top: eventTextField.bottomAnchor,
                                         leading: textColorDropDownButton.trailingAnchor,
                                         bottom: nil,
                                         trailing: self.view.trailingAnchor,
                                         padding: .init(top: 10, left: 5, bottom: 0, right: 5),
                                         size: .init(width: (self.view.frame.width - 30) / 2, height: 40))
    
    //Set the drop down menu's options
    textColorDropDownButton.dropView.dropDownOptions = constantNames.colorsNamesList
    backgroundColorDropDownButton.dropView.dropDownOptions = constantNames.colorsNamesList

    let dropDownButtons = [textColorDropDownButton,
                           backgroundColorDropDownButton]
    
    dropDownButtons.forEach{$0.backgroundColor = Colors.lightBlue}
    dropDownButtons.forEach{$0.roundIt()}
    
    // set the dropdown delegation for all buttons
    self.textColorDropDownButton.dropView.dropDownSelectionDelegate = self
    self.backgroundColorDropDownButton.dropView.dropDownSelectionDelegate = self
  }
  
  
  func didSelectItem(changedFieldName: String, itemName: String) {
    switch changedFieldName {
    case constantNames.textColorButtonTitle:
      self.eventDetail.textcolor = itemName
    case constantNames.backgroungButtonTitle:
      self.eventDetail.backgroundcolor = itemName
    default:
      break
    }
    updatePreviewEventViewController()
  }
  
  @objc func rightBarButtonPressed (_ sender: UIBarButtonItem!) {
    checkAllFields()
  }
  
    // check that all fields are filled properlly then call saveEvent to complete creating the event
    func checkAllFields() {
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
        
        saveEvent()
    }
    
  // Text Event
  func saveEvent() {
    
    self.ShowSpinner()
    
    eventViewModel.addEvent(event: self.event) { (result) in
      switch result {
        
      case .Failure(let error):
        print(error)
        self.infoView(message: "Failed to save the event", color: Colors.smoothRed)
        
      case .Success(let code):
        
        self.eventDetail.code = code
        self.event.eventCode = code
        
        self.eventDetailViewModel.addEventDetail(event: self.event, eventdetail: self.eventDetail, completion: { (result) in
          switch result {
            
          case .Failure(let error):
            print(error)
            self.infoView(message: "Failed to save the event", color: Colors.smoothRed)
            // ***** we should go back and remove the event if we can
            
          case .Success():
            
            self.infoView(message: "Event Created Successfully ", color: Colors.lightGreen)
            self.completeCreateEvent(event: self.event, eventDetail: self.eventDetail)
            self.showPlayEventViewController(event: self.event, eventDetail: self.eventDetail)
          }
        })
      }
    }
    self.HideSpinner()
    
  }
}

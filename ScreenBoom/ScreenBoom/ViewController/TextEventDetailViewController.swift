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
  
  func updatePreviewEventViewController () {
    let playEventViewModel = PlayEventViewModel(event: self.event, eventDetail: self.eventDetail)
    if let playEventVC = self.playPreviewEventViewController {
      playEventVC.configureWithPreviewPlayViewModel(playViewModel: playEventViewModel)
    }
  }
  
  // text event
  var eventTextField: UITextField = UITextField() {
    didSet {
      // if we have text from the event detail object
      // we want the default text to be set to that
      eventTextField.text = self.eventDetail.text
    }
  }
  
  var textColorDropDownButton: dropDownBtn = dropDownBtn() {
    didSet {
      textColorDropDownButton.setTitle(self.eventDetail.textcolor, for: .normal)
    }
  }
  
  var backgroundColorDropDownButton: dropDownBtn = dropDownBtn() {
    didSet {
      backgroundColorDropDownButton.setTitle(self.eventDetail.backgroundcolor, for: .normal)
    }
  }
  var animationNameDropDownButton: dropDownBtn = dropDownBtn() {
    didSet {
      animationNameDropDownButton.setTitle(self.eventDetail.animationName, for: .normal)
    }
  }
  var fontNameDropDownButton: dropDownBtn = dropDownBtn() {
    didSet {
      fontNameDropDownButton.setTitle(self.eventDetail.font, for: .normal)
    }
  }
  var fontsizeDropDownButton: dropDownBtn = dropDownBtn() {
    didSet {
      fontsizeDropDownButton.setTitle(String(describing: self.eventDetail.fontsize), for: .normal)
    }
  }
  
  //Delegate
  var dropDownSelectionDelegate:DropDownSelectionDelegate!
  
  init(event:Event, eventDetail: TextEventDetail) {
    self.eventDetail = eventDetail
    
    super.init(event: event)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.eventTextField.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupViews()

  }
  
  @objc func textFieldDidChanged(_ textField : UITextField) {
    self.eventDetail.text = textField.text
    
    updatePreviewEventViewController()
  }
  
  // Text
  func setupViews() {
    // create Navigation bar right buttom (Send)
    let sendRightBarButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(TextEventDetailViewController.rightBarButtonPressed(_:)))
    navigationItem.rightBarButtonItem = sendRightBarButton
    
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
    
    // add text input field
    self.view.addSubview(eventTextField)
    eventTextField.anchor(top: playEventPreviewContainerView.bottomAnchor,
                          leading: self.view.leadingAnchor,
                          bottom: nil,
                          trailing: self.view.trailingAnchor,
                          padding: .init(top: 10, left: 10, bottom: 0, right: 10),
                          size: .init(width: 0, height: 40))
    eventTextField.backgroundColor = UIColor.blue
    eventTextField.addTarget(self, action: #selector(TextEventDetailViewController.textFieldDidChanged(_:)), for: .editingChanged)
    //add textColorDropDown
    //Configure the button
    textColorDropDownButton = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    textColorDropDownButton.setTitle(constantNames.textColorButtonTitle, for: .normal)
    backgroundColorDropDownButton = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    backgroundColorDropDownButton.setTitle(constantNames.backgroungButtonTitle, for: .normal)
    animationNameDropDownButton = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    animationNameDropDownButton.setTitle(constantNames.animationButtonTitle, for: .normal)
    fontNameDropDownButton = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fontNameDropDownButton.setTitle(constantNames.fontButtonTitle, for: .normal)
    fontsizeDropDownButton = dropDownBtn.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    fontsizeDropDownButton.setTitle(constantNames.fontSizeButtonTitle, for: .normal)
    //Add Button to the View Controller
    self.view.addSubview(fontNameDropDownButton)
    self.view.addSubview(fontsizeDropDownButton)
    self.view.addSubview(textColorDropDownButton)
    self.view.addSubview(backgroundColorDropDownButton)
    self.view.addSubview(animationNameDropDownButton)
    
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
                                         trailing: animationNameDropDownButton.leadingAnchor,
                                         padding: .init(top: 10, left: 5, bottom: 0, right: 5),
                                         size: .init(width: (self.view.frame.width - 30) / 3, height: 40))
    animationNameDropDownButton.anchor(top: eventTextField.bottomAnchor,
                                       leading: backgroundColorDropDownButton.trailingAnchor,
                                       bottom: nil,
                                       trailing: self.view.trailingAnchor,
                                       padding: .init(top: 10, left: 5, bottom: 0, right: 10),
                                       size: .init(width: (self.view.frame.width - 30) / 3, height: 40))
    fontNameDropDownButton.anchor(top: textColorDropDownButton.bottomAnchor,
                                  leading: textColorDropDownButton.leadingAnchor,
                                  bottom: nil,
                                  trailing: textColorDropDownButton.trailingAnchor,
                                  padding: .init(top: 10, left: 0, bottom: 0, right: 0),
                                  size: .init(width: 0, height: 40))
    fontsizeDropDownButton.anchor(top: backgroundColorDropDownButton.bottomAnchor,
                                  leading: backgroundColorDropDownButton.leadingAnchor,
                                  bottom: nil,
                                  trailing: backgroundColorDropDownButton.trailingAnchor,
                                  padding: .init(top: 10, left: 0, bottom: 0, right: 0),
                                  size: .init(width: 0, height: 40))
    
    //Set the drop down menu's options
    textColorDropDownButton.dropView.dropDownOptions = constantNames.colorsNamesList
    backgroundColorDropDownButton.dropView.dropDownOptions = constantNames.colorsNamesList
    animationNameDropDownButton.dropView.dropDownOptions = constantNames.animationNamesArray
    fontNameDropDownButton.dropView.dropDownOptions = constantNames.fontNames
    fontsizeDropDownButton.dropView.dropDownOptions = Array([0...50]).map({ String(describing: $0) })
    
    // set dropDownButtonTitle in the dropDown
    textColorDropDownButton.dropView.dropDownButtonTitle = constantNames.textColorButtonTitle
    backgroundColorDropDownButton.dropView.dropDownButtonTitle = constantNames.backgroungButtonTitle
    animationNameDropDownButton.dropView.dropDownButtonTitle = constantNames.animationButtonTitle
    fontNameDropDownButton.dropView.dropDownButtonTitle = constantNames.fontButtonTitle
    fontsizeDropDownButton.dropView.dropDownButtonTitle = constantNames.fontSizeButtonTitle
    
    
    
    let dropDownButtons = [textColorDropDownButton,
                           backgroundColorDropDownButton,
                           animationNameDropDownButton,
                           fontNameDropDownButton,
                           fontsizeDropDownButton]
    dropDownButtons.forEach{$0.layer.borderWidth = 2}
    dropDownButtons.forEach{$0.layer.cornerRadius = 5}
    dropDownButtons.forEach{$0.layer.borderColor = UIColor.orange.cgColor}
    dropDownButtons.forEach{$0.titleLabel?.textColor = UIColor.orange}
    dropDownButtons.forEach{$0.backgroundColor = UIColor.clear}
    
    // set the dropdown delegation for all buttons
    self.textColorDropDownButton.dropView.dropDownSelectionDelegate = self
    self.backgroundColorDropDownButton.dropView.dropDownSelectionDelegate = self
    self.animationNameDropDownButton.dropView.dropDownSelectionDelegate = self
    self.fontNameDropDownButton.dropView.dropDownSelectionDelegate = self
    self.fontsizeDropDownButton.dropView.dropDownSelectionDelegate = self
  }
  
  
  func didSelectItem(changedFieldName: String, itemName: String) {
    switch changedFieldName {
    case constantNames.textColorButtonTitle:
      self.eventDetail.textcolor = itemName
    case constantNames.backgroungButtonTitle:
      self.eventDetail.backgroundcolor = itemName
    case constantNames.animationButtonTitle:
      self.eventDetail.animationName = itemName
    case constantNames.fontButtonTitle:
      self.eventDetail.font = itemName
    case constantNames.fontSizeButtonTitle:
      self.eventDetail.fontsize = Double(itemName)
    default:
      break
    }
    updatePreviewEventViewController()
  }
  
  @objc func rightBarButtonPressed (_ sender: UIBarButtonItem!) {
    saveEvent()
  }
  
  // Text Event
  func saveEvent() {
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
        print(error)
        self.infoView(message: "Failed to save the event", color: Colors.smoothRed)
        
      case .Success(let code):
        
        self.eventDetail.code = code
        
        self.eventDetailViewModel.addEventDetail(event: self.event, eventdetail: self.eventDetail, completion: { (result) in
          switch result {
            
          case .Failure(let error):
            print(error)
            self.infoView(message: "Failed to save the event", color: Colors.smoothRed)
            
          case .Success():
            
            self.infoView(message: "Event Created Successfully ", color: Colors.lightGreen)
            
            self.showPlayEventViewController(event: self.event, eventDetail: self.eventDetail)
          }
        })
      }
    }
    self.HideSpinner()
    
  }
}

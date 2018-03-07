//
//  EventDetailViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class EventDetailViewController: BaseViewController, DropDownSelectionDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  func didSelectItem(changedFieldName: String, itemName: String) {
    
    switch changedFieldName {
    case firebaseNodeNames.eventDetailTextColorChild:
      self.eventDetail.textcolor = itemName
    case firebaseNodeNames.eventDetailBackGroundColorChild:
      self.eventDetail.backgroundcolor = itemName
    case firebaseNodeNames.eventDetailAnimationNameChild:
      self.eventDetail.animationName = itemName
    default:
      break
    }
    updatePreviewEventViewController()
  }
  
  func updatePreviewEventViewController () {
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
  var eventTypeContainerView = UIView()
  // text event
  let eventTextField: UITextField = UITextField()
  var textColorDropDownButton: dropDownBtn = dropDownBtn()
  var backgroundColorDropDownButton: dropDownBtn = dropDownBtn()
  var animationNameColorDropDownButton: dropDownBtn = dropDownBtn()
  // photo event
  var selectImageFromGallaryButton: UIButton = UIButton()
  var selectImageFromCameraButton :UIButton = UIButton()
  let imagePicker = UIImagePickerController()
  var imageUploadManager: ImageUploadManager?
  // playPreviewEventViewController
  var playPreviewEventViewController: PlayPreviewEventViewController?
  //Delegate
  var dropDownSelectionDelegate:DropDownSelectionDelegate!
  
  
  //  convenience init() {
  //    self.init(eventName: "")
  //  }
  init(event:Event) {
    self.event = event
    self.eventDetail = EventDetail(animationName: "", photoname: "Place holder", backgroundcolor: "Blue", textcolor: "White", speed: "", text: "Your Text", code: "")
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor.white
    self.navigationItem.title = self.event.eventName
    imagePicker.delegate = self
    eventTextField.delegate = self
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
    playEventPreviewContainerView.frame = CGRect(x: 20,
                                                 y: 84,
                                                 width: self.view.frame.width - 40,
                                                 height: 300)
    playEventPreviewContainerView.backgroundColor = UIColor.green
    
    switch event.eventType {
    case .Text:
        [selectImageFromGallaryButton, selectImageFromCameraButton].forEach{$0.removeFromSuperview()}
        setupTextEventViews()
      break
    case .Photo: [eventTextField,textColorDropDownButton,textColorDropDownButton.dropView,backgroundColorDropDownButton, backgroundColorDropDownButton.dropView,animationNameColorDropDownButton, animationNameColorDropDownButton.dropView].forEach{$0.removeFromSuperview()}
        setupPhotoEventViews()
      break
    case .Animation:[eventTextField,textColorDropDownButton,textColorDropDownButton.dropView,backgroundColorDropDownButton, backgroundColorDropDownButton.dropView,animationNameColorDropDownButton, animationNameColorDropDownButton.dropView].forEach{$0.removeFromSuperview()}
        setupAnimationEventViews()
      break
    default:
      for view in self.view.subviews {
        view.removeFromSuperview()
      }
      break
    }
    playPreviewEventViewController = PlayPreviewEventViewController(event: self.event,
                                                                    eventDetail: self.eventDetail, isPreviewInDetailEventViewController: true)
    
    if let playEventVC = playPreviewEventViewController {
      self.addChildViewController(playEventVC)
      playEventPreviewContainerView.addSubview(playEventVC.view)
      playEventVC.view.frame = self.playEventPreviewContainerView.bounds
      playEventVC.didMove(toParentViewController: self)
    }
  }
  // show text, photo and animation views set up
  //Animation
  func setupAnimationEventViews() {
    
  }
  
  // photo
  func setupPhotoEventViews() {
    
    selectImageFromGallaryButton.setTitle("Photos", for: .normal)
    selectImageFromGallaryButton.backgroundColor = UIColor.blue
    selectImageFromCameraButton.setTitle("Camera", for: .normal)
    selectImageFromCameraButton.backgroundColor = UIColor.blue
    // add views
    self.view.addSubview(selectImageFromGallaryButton)
    self.view.addSubview(selectImageFromCameraButton)
    
    selectImageFromGallaryButton.anchor(top: playEventPreviewContainerView.bottomAnchor,
                                        leading: self.view.leadingAnchor,
                                        bottom: nil,
                                        trailing: self.view.trailingAnchor,
                                        padding: .init(top: 30, left: 20, bottom: 0, right: 20),
                                        size: .init(width: 0, height: 40))
    selectImageFromCameraButton.anchor(top: selectImageFromGallaryButton.bottomAnchor,
                                       leading: self.view.leadingAnchor,
                                       bottom: nil,
                                       trailing: self.view.trailingAnchor,
                                       padding: .init(top: 30, left: 20, bottom: 0, right: 20),
                                       size: .init(width: 0, height: 40))
    selectImageFromGallaryButton.addTarget(self, action: #selector(SelectImage(_:)), for: .touchUpInside)
    selectImageFromCameraButton.addTarget(self, action: #selector(SelectImage(_:)), for: .touchUpInside)
  }
  
  @objc func SelectImage(_ sender: UIButton) {
    imagePicker.allowsEditing = true
    
    if sender.currentTitle == "Photos" {
      self.imagePicker.sourceType = .photoLibrary
    } else if  sender.currentTitle == "Camera" {
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
        self.imagePicker.sourceType = .camera
      } else {
        infoView(message: "Camera is not available", color: Colors.smoothRed)
      }
    }
    present(imagePicker, animated: true, completion: nil)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    var selectedImageFromPicker : UIImage?
    
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      selectedImageFromPicker = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      selectedImageFromPicker = originalImage
    }
    if let selectedImage = selectedImageFromPicker {
      
      let imageData: NSData = UIImagePNGRepresentation(selectedImage)! as NSData
      UserDefaults.standard.set(imageData, forKey: userDefaultKeyNames.savedImageCodeKey)
      self.eventDetail.photoname = userDefaultKeyNames.savedImageCodeKey
      updatePreviewEventViewController()
    }
    dismiss(animated: true, completion: nil)
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  // Text
  func setupTextEventViews() {
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
    textColorDropDownButton.dropView.dropDownOptions = ["Blue", "Green", "Magenta", "White", "Black", "Purple"]
    textColorDropDownButton.dropView.dropDownButtonTitle = firebaseNodeNames.eventDetailTextColorChild
    backgroundColorDropDownButton.dropView.dropDownOptions = ["Blue", "Green", "Magenta", "White", "Black", "Purple"]
    backgroundColorDropDownButton.dropView.dropDownButtonTitle = firebaseNodeNames.eventDetailBackGroundColorChild
    animationNameColorDropDownButton.dropView.dropDownOptions = ["Shake", "Zoom", "Magenta", "White", "Black", "Purple"]
    animationNameColorDropDownButton.dropView.dropDownButtonTitle = firebaseNodeNames.eventDetailAnimationNameChild
    
    // set the dropdown delegation for all buttons
    self.textColorDropDownButton.dropView.dropDownSelectionDelegate = self
    self.backgroundColorDropDownButton.dropView.dropDownSelectionDelegate = self
    self.animationNameColorDropDownButton.dropView.dropDownSelectionDelegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setupViews()
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
    
    switch event.eventType {
    case .Text:
      saveTextEvent()
      break
    case .Photo:
      savePhotoEvent()
      break
    case .Animation:
      setupAnimationEventViews()
      
      break
    default:
      break
    }
  }
  
  // Save Event to firebase DataBAse
  
  // Photo Event
  func savePhotoEvent() {
    guard self.eventDetail.photoname == userDefaultKeyNames.savedImageCodeKey else {
      infoView(message: "No photo Selected", color: Colors.smoothRed)
      return
    }
    let data = UserDefaults.standard.object(forKey: userDefaultKeyNames.savedImageCodeKey) as! NSData
    guard let imageToUpload = UIImage(data: data as Data) else {return}
    imageUploadManager = ImageUploadManager()
    imageUploadManager?.uploadImage(event: self.event, imageToUpload, progressBlock: { (percentage) in
      print(percentage)
    }, completionBlock: { [weak self] (URL, error) in
      guard let strongSelf = self else { return }
      guard error == nil else { self?.infoView(message: "error", color: Colors.smoothRed)
        return }
      guard let url = URL else {self?.infoView(message: "Photo upload faild!", color: Colors.smoothRed)
        return }
      
      strongSelf.eventDetail.photoname = url.absoluteString
      strongSelf.saveEventAndEventDetail()
    })
  }
  
  // Text Event
  func saveTextEvent() {
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
    saveEventAndEventDetail()
    
  }
  
  func saveEventAndEventDetail() {
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
            self.showPlayEventViewController(event: self.event, eventDetail: self.eventDetail)
          }
        })
      }
    }
    self.HideSpinner()
  }
  // Push PlayEventViewController
  func showPlayEventViewController(event: Event, eventDetail: EventDetail) {
    let PlayViewController = PlayEventViewController(event: event, eventDetail:eventDetail, isPreviewInDetailEventViewController: false)
    self.navigationController?.pushViewController(PlayViewController, animated: true)
  }
/// End of EventDetailViewController
}

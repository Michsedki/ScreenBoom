//
//  PhotoEventDetailViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/22/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class PhotoEventDetailViewController: EventDetailViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var rightBarButton = UIBarButtonItem()
    
    let selectImageFromGallaryButton : UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.textColor = UIColor.white
        view.setTitle("Photos", for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.backgroundColor = .blue
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 40)
        view.roundIt()
        return view
    }()
    
    let selectImageFromCameraButton : UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.textColor = UIColor.white
        view.setTitle("Camera", for: .normal)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        view.backgroundColor = .blue
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
    
  // photo event
  let imagePicker = UIImagePickerController()
  var imageUploadManager: ImageUploadManager?
  var eventDetail: PhotoEventDetail
  
  func updatePreviewEventViewController () {
    let playEventViewModel = PlayEventViewModel(event: self.event, eventDetail: self.eventDetail)
    if let playEventVC = self.playPreviewEventViewController {
      playEventVC.configureWithPreviewPlayViewModel(playViewModel: playEventViewModel)
    }
  }
  
  init(event:Event, eventDetail: PhotoEventDetail) {
    self.eventDetail = eventDetail
    
    super.init(event: event)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    self.imagePicker.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.rightBarButton.isEnabled = true
    
    prepareForViewWillAppearWithForcedPortrait()
    
  }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        prepareForViewWillDisapear()
    }
  
  func setupViews() {
    
     rightBarButton = UIBarButtonItem(title: "Create", style: .plain, target: self, action: #selector(PhotoEventDetailViewController.rightBarButtonPressed(_:)))
    
    navigationItem.rightBarButtonItem = rightBarButton
    
    // create container view to hold the play event preview
    self.view.addSubview(playEventPreviewContainerView)
    playEventPreviewContainerView.frame = CGRect(x: 20,
                                                 y: 84,
                                                 width: self.view.frame.width - 40,
                                                 height: 300)
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
    
    // add views
    view.addSubview(bottunStackView)
    bottunStackView.addArrangedSubview(selectImageFromGallaryButton)
    bottunStackView.addArrangedSubview(selectImageFromCameraButton)
        
    bottunStackView.anchor(top: playEventPreviewContainerView.bottomAnchor,
                                        leading: self.view.leadingAnchor,
                                        bottom: nil,
                                        trailing: self.view.trailingAnchor,
                                        padding: .init(top: 30, left: 20, bottom: 0, right: 20),
                                        size: .init(width: 0 , height: 50))
    
    
    selectImageFromGallaryButton.addTarget(self, action: #selector(SelectImage(_:)), for: .touchUpInside)
    selectImageFromCameraButton.addTarget(self, action: #selector(SelectImage(_:)), for: .touchUpInside)
  }
  
  @objc func SelectImage(_ sender: UIButton) {
    
    if sender.currentTitle == "Photos" {
        imagePicker.allowsEditing = true

      // if the photo button was pressed, we want to present the user
      // with their photo library
      self.imagePicker.sourceType = .photoLibrary
        
        imagePicker.modalPresentationStyle = .popover
        let popper = imagePicker.popoverPresentationController
        // returns a UIPopoverPresentationController
        popper?.sourceView = sender 

    } else if sender.currentTitle == "Camera" {
        imagePicker.allowsEditing = true

      // if the camera button was pressed, we need to ensure we have the
      // camera as an available source and then we present the user with
      // the camera
      guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
        self.infoView(message: "Camera is not available", color: Colors.smoothRed)
        
        return
      }
      
      self.imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .fullScreen

    } else {
      
      // if we have an unrecognized selector, we escape scope
      return
    }
    
    present(imagePicker, animated: true, completion: nil)
    
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    var selectedImageFromPicker : UIImage?
    
    // we want to see if the user has edited an image or simply selected the original
    // from their phot library.
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      selectedImageFromPicker = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      selectedImageFromPicker = originalImage
    }
    
    guard let selectedImage = selectedImageFromPicker  else {
      self.infoView(message: "No Image Was Selected", color: Colors.smoothRed)
      
      dismiss(animated: true, completion: nil)
      return
    }
    
    // now that we have an image we want to update our event detail object with the selected
    // image and propogate it to our preview view
    self.eventDetail.configureWithPhoto(photo: selectedImage)
    
    // TODO:(MT) Add functionality to remove folder for UserID before new image upload
    updatePreviewEventViewController()
    dismiss(animated: true, completion: nil)
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func rightBarButtonPressed (_ sender: UIBarButtonItem!) {
    
    rightBarButton.isEnabled = false
    
    guard let uploadImage = eventDetail.photo else {
        rightBarButton.isEnabled = true
      self.infoView(message: "No image selected", color: Colors.smoothRed)
      return
    }
    
    self.ShowSpinner()
    
    let imageUploadManager = ImageUploadManager()
    
    imageUploadManager.uploadImage(event: event, uploadImage, progressBlock: { (percentage) in
//      print(percentage)
    }, completionBlock: { [weak self] (URL, error) in
        
      guard let strongSelf = self else {return}
      
      guard error == nil, let url = URL
        else {
            strongSelf.rightBarButton.isEnabled = true
          strongSelf.infoView(message: "Failed to save the event", color: Colors.smoothRed)
          return
        }
      
      strongSelf.eventDetail.photoname = url.absoluteString
      
      strongSelf.saveEvent()
    })
    
     self.HideSpinner()
   
  }
  
  func saveEvent() {
    
    self.ShowSpinner()
    
    eventViewModel.addEvent(event: self.event) { (result) in
      switch result {
        
      case .Failure(let error):
        print(error)
        self.rightBarButton.isEnabled = true
        self.infoView(message: "Failed to save the event", color: Colors.smoothRed)
        
      case .Success(let code):
        
        self.event.eventCode = code
        self.eventDetail.code = code
        
        self.eventDetailViewModel.addEventDetail(event: self.event, eventdetail: self.eventDetail, completion: { (result) in
          switch result {
            
          case .Failure(let error):
            print(error)
            self.rightBarButton.isEnabled = true
            self.infoView(message: "Failed to save the event", color: Colors.smoothRed)
            
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



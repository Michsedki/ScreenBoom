//
//  PhotoEventDetailViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/22/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class PhotoEventDetailViewController: EventDetailViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // photo event
  var selectImageFromGallaryButton: UIButton = UIButton()
  var selectImageFromCameraButton :UIButton = UIButton()
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
    
    self.imagePicker.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupViews()
  }
  
  func setupViews() {
    // create Navigation bar right buttom (Send)
    let sendRightBarButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(PhotoEventDetailViewController.rightBarButtonPressed(_:)))
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
      
     // send the image to photoplaypreviewevntdetail
      
      //      let imageData: NSData = UIImagePNGRepresentation(selectedImage)! as NSData
      //      UserDefaults.standard.set(imageData, forKey: userDefaultKeyNames.savedImageCodeKey)
      if (self.eventDetail.photoname != userDefaultKeyNames.savedImageCodeKey && self.eventDetail.photoname != "placeHolder" ) {
        let imageUploadManager = ImageUploadManager()
        imageUploadManager.deleteImage(eventDetail: self.eventDetail, completion: { (result) in
          switch result {
          case.Failure( _):
            print("couldn't remove the Image")
            break
          case .Success():
            print("Image removed successsfully")
            break
          }
        })
        
      }
      self.eventDetail.photoname = userDefaultKeyNames.savedImageCodeKey
      updatePreviewEventViewController()
    }
    dismiss(animated: true, completion: nil)
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  @objc func rightBarButtonPressed (_ sender: UIBarButtonItem!) {
//    saveEvent()
  }
  
//  func saveEvent() {
//
//    if self.eventDetail.photoname == "PlaceHolder" {
//      infoView(message: "No photo Selected", color: Colors.smoothRed)
//    } else if self.eventDetail.photoname == userDefaultKeyNames.savedImageCodeKey {
//      let data = UserDefaults.standard.object(forKey: userDefaultKeyNames.savedImageCodeKey) as! NSData
//      guard let imageToUpload = UIImage(data: data as Data) else {return}
//      imageUploadManager = ImageUploadManager()
//      imageUploadManager?.uploadImage(event: self.event, imageToUpload, progressBlock: { (percentage) in
//        print(percentage)
//      }, completionBlock: { [weak self] (URL, error) in
//        guard let strongSelf = self else { return }
//        guard error == nil else { self?.infoView(message: "error", color: Colors.smoothRed)
//          return }
//        guard let url = URL else {self?.infoView(message: "Photo upload faild!", color: Colors.smoothRed)
//          return }
//        strongSelf.eventDetail.photoname = url.absoluteString
//        strongSelf.prepareForSavingEventAndEventDetail()
//      })
//
//    } else {
//      self.prepareForSavingEventAndEventDetail()
//    }
//  }
  
}



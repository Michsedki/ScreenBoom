//
//  AnimationEventDetailViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/22/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class AnimationEventDetailViewController: EventDetailViewController {
  
    var animationCollectionViewData = [[String:String]]()
    var animationImages = [UIImage]()
    
    let searchTextField : UITextField = {
       let view = UITextField()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
        view.roundIt()
        view.backgroundColor = .white
        // Create a padding view for padding on left
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: view.frame.height))
        view.leftViewMode = .always
        return view
    }()
    
    let searchButton : UIButton = {
       let view = UIButton()
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 30)
        view.titleLabel?.numberOfLines = 0
        view.titleLabel?.sizeToFit()
        view.setTitle("Search", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = Colors.lightBlue
        view.roundIt()
        return view
    }()
    
  var animationCollectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.backgroundColor = UIColor.lightGray
    return view
  }()
    
  let animationCollectionViewCellIdentifier = "animationCollectionView"
  var eventDetail: AnimationEventDetail
  
  func updatePreviewEventViewController () {
    let playEventViewModel = PlayEventViewModel(event: self.event, eventDetail: self.eventDetail)
    if let playEventVC = self.playPreviewEventViewController {
      playEventVC.configureWithPreviewPlayViewModel(playViewModel: playEventViewModel)
    }
  }
  
  init(event:Event, eventDetail: AnimationEventDetail) {
    self.eventDetail = eventDetail
    
    super.init(event: event)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionViewDelegateAndDataSourceAndCellRegister()
    
    setupViews()
    
    loadCollectionViewDataSource()

  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let value = UIInterfaceOrientation.portrait.rawValue
    UIDevice.current.setValue(value, forKey: "orientation")
    
    // disaple Rotation for this view controller
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.enableAllOrientation = false
    
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        // allow rotation for other viewControllers
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = true
    }
  
  // show text, photo and animation views set up
  //Animation
  func setupViews() {
    // create Navigation bar right buttom (Send)
    let sendRightBarButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(AnimationEventDetailViewController.rightBarButtonPressed(_:)))
    navigationItem.rightBarButtonItem = sendRightBarButton
    
    self.view.addSubview(searchTextField)
    self.view.addSubview(searchButton)
    searchTextField.anchor(top: nil,
                           leading: self.view.leadingAnchor,
                           bottom: self.view.bottomAnchor,
                           trailing: searchButton.leadingAnchor,
                           padding: .init(top: 0, left: 5, bottom: 5, right: 5),
                           size: .init(width: 0, height: 30))
    searchButton.anchor(top: nil,
                        leading: searchTextField.trailingAnchor,
                        bottom: self.view.bottomAnchor,
                        trailing: self.view.trailingAnchor,
                        padding: .init(top: 0, left: 5, bottom: 5, right: 5),
                        size: .init(width: 70, height: 30))
    searchButton.addTarget(self, action: #selector(searchButtonPressed(_:)), for: .touchUpInside)
    
    
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
    
    setupCollectionView()
   
  }
  
    @objc func searchButtonPressed(_ sender: UIButton) {
        
    guard let searchtext = self.searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
          !searchtext.isEmpty else {
            return
        }
        self.ShowSpinner()
        GIFGiphyMAnager.sharedInstance.getGIFSearch(searchWord: searchtext) { (result) in
            switch result {
            case .Failure(let error):
                print(error)
                break
            case .Success(let gifImagesDic):
                DispatchQueue.main.async {
                self.animationCollectionViewData = gifImagesDic
                self.eventDetail.animationStringURL =  self.animationCollectionViewData[0]["originalURL"]
                if let imageURL = self.animationCollectionViewData[0]["previewURL"],
                    let image = UIImage.gif(url: imageURL) {
                    self.eventDetail.configureWithPhoto(photo: image)
                    self.updatePreviewEventViewController()
                }
                self.animationCollectionView.reloadData()
            }
                break
            }
            DispatchQueue.main.async {
            self.HideSpinner()
            }
        }
    }
    
    
  @objc func rightBarButtonPressed (_ sender: UIBarButtonItem!) {
    saveEvent()
  }
  
  func saveEvent() {
    guard !(eventDetail.animationStringURL?.isEmpty)! else {print("Photo not Empty")
      return}
  
    self.ShowSpinner()
    
    eventViewModel.addEvent(event: self.event) { (result) in
      switch result {
        
      case .Failure(let error):
        print(error)
        self.infoView(message: "Failed to save the event", color: Colors.smoothRed)
        
      case .Success(let code):
        
        self.event.eventCode = code
        self.eventDetail.code = code
        
        self.eventDetailViewModel.addEventDetail(event: self.event, eventdetail: self.eventDetail, completion: { (result) in
          switch result {
            
          case .Failure(let error):
            print(error)
            self.infoView(message: "Failed to save the event", color: Colors.smoothRed)
            
          case .Success():
            
            self.infoView(message: "Event Created Successfully ", color: Colors.lightGreen)
            self.completeCreateEvent(event: self.event, eventDetail: self.eventDetail)
            self.showPlayEventViewController(event: self.event, eventDetail: self.eventDetail)
          }
            self.HideSpinner()
        })
        self.HideSpinner()
      }
    }
  }
}

// extension conform to UICollectionView
extension AnimationEventDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionViewDelegateAndDataSourceAndCellRegister() {
        animationCollectionView.delegate = self
        animationCollectionView.dataSource = self
        animationCollectionView.register(AnimationCollectionViewCell.self, forCellWithReuseIdentifier: "AnimationCollectionViewCell")
    }
    
    func setupCollectionView() {
        self.view.addSubview(animationCollectionView)
        // Anchor for animationCollectionView
        animationCollectionView.anchor(top: playEventPreviewContainerView.bottomAnchor,
                                       leading: self.view.leadingAnchor,
                                       bottom: self.view.bottomAnchor,
                                       trailing: self.view.trailingAnchor,
                                       padding: .init(top: 5, left: 20, bottom: 50, right: 20))
    }
    
    func loadCollectionViewDataSource() {
        self.ShowSpinner()
        GIFGiphyMAnager.sharedInstance.getGIFTrending { (result) in
            switch result {
            case .Failure(let error):
                // ****** we need to update the collection view with sample
                print(error)
                break
            case .Success(let gifImagesDic):
                DispatchQueue.main.async {
                self.animationCollectionViewData = gifImagesDic
                self.eventDetail.animationStringURL =  self.animationCollectionViewData[0]["originalURL"]
                if let imageURL = self.animationCollectionViewData[0]["previewURL"],
                    let image = UIImage.gif(url: imageURL) {
                    self.eventDetail.configureWithPhoto(photo: image)
                    self.updatePreviewEventViewController()
                }
                    self.animationCollectionView.reloadData()
                }
                break
            }
            DispatchQueue.main.async {
                self.HideSpinner()
            }
        }
    }
    
 
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return animationCollectionViewData.count
  }
    
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = animationCollectionView.dequeueReusableCell(withReuseIdentifier: "AnimationCollectionViewCell", for: indexPath) as? AnimationCollectionViewCell {
        
            cell.configureCell(imageURLDic: self.animationCollectionViewData[indexPath.row])
        
        return cell
    }
    
    return UICollectionViewCell()
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.frame.width - 30) / 3, height: (collectionView.frame.width - 30) / 3)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(10, 5, 10, 5)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    // now that we have an image we want to update our event detail object with the selected
    // image and propogate it to our preview view
    
    self.eventDetail.animationStringURL = self.animationCollectionViewData[indexPath.row]["originalURL"]
    
    
    if let cell = animationCollectionView.cellForItem(at: indexPath) as? AnimationCollectionViewCell {
        self.eventDetail.configureWithPhoto(photo: cell.animationImageView.image!)
    }
    updatePreviewEventViewController()
    
    
  }
  
}


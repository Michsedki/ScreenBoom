//
//  AnimationEventDetailViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/22/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class AnimationEventDetailViewController: EventDetailViewController {
  
  var animationCollectionViewData = [String]()
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
    
    self.animationCollectionView.delegate = self
    self.animationCollectionView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setupViews()
  }
  
  // show text, photo and animation views set up
  //Animation
  func setupViews() {
    // create Navigation bar right buttom (Send)
    let sendRightBarButton = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(AnimationEventDetailViewController.rightBarButtonPressed(_:)))
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
    
    animationCollectionViewData = constantNames.gifAnimationNamesArray
    animationCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: animationCollectionViewCellIdentifier)
    self.view.addSubview(animationCollectionView)
    // Anchor for animationCollectionView
    animationCollectionView.anchor(top: playEventPreviewContainerView.bottomAnchor,
                                   leading: self.view.leadingAnchor,
                                   bottom: self.view.bottomAnchor,
                                   trailing: self.view.trailingAnchor,
                                   padding: .init(top: 20, left: 20, bottom: 20, right: 20)
    )
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



// extension conform to UICollectionView
extension AnimationEventDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return animationCollectionViewData.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = animationCollectionView.dequeueReusableCell(withReuseIdentifier: animationCollectionViewCellIdentifier, for: indexPath)
    
    for view in cell.subviews {
      view.removeFromSuperview()
    }
    
    cell.backgroundColor = UIColor.blue
    
    let animationImage : UIImageView = {
      let view = UIImageView()
      view.backgroundColor = UIColor.orange
      return view
    }()
    
    cell.addSubview(animationImage)
    
    animationImage.anchor(top: cell.topAnchor,
                          leading: cell.leadingAnchor,
                          bottom: cell.bottomAnchor,
                          trailing: cell.trailingAnchor,
                          padding: .zero)
    
    animationImage.loadGif(name: animationCollectionViewData[indexPath.row])
    
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: (collectionView.frame.width - 30) / 3, height: (collectionView.frame.width - 30) / 3)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsetsMake(10, 5, 10, 5)
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.eventDetail.animationStringURL = animationCollectionViewData[indexPath.row]
    updatePreviewEventViewController()
  }
  
}


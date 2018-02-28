//
//  FinalTestEventDetailsViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/27/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class FinalTestEventDetailsViewController: BaseViewController {

  
  // Variables
  
  var eventToCreateDetail : Event!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()

      
      
      
      // Setup Views useing EventDetailView
     
      eventToCreateDetail = Event(eventName: "detail", eventIsLive: "no", eventType: .Animation)
       setupViews()
    }
  
  
  
  
  
  

  func setupViews() {
    
    
  
    
    // views declaration
    let safeAreaView: UIView = {
      let view = UIView()
      view.backgroundColor = UIColor.lightGray
      return view
    }()
    
    let previewView: UIView = {
      let view = UIView()
      view.backgroundColor = UIColor.blue
      return view
    }()
    let previewLabel: UILabel = {
      let view = UILabel()
      view.backgroundColor = UIColor.yellow
      return view
    }()
    let previewImage: UIImageView = {
      let view = UIImageView()
      view.backgroundColor = UIColor.purple
      return view
    }()
    let previewAnimation: UIImageView = {
      let view = UIImageView()
      view.backgroundColor = UIColor.orange
      return view
    }()
    
    let previewDefault: UILabel = {
      let view = UILabel()
      view.text = "Type Unknown"
      view.backgroundColor = UIColor.yellow
      return view
    }()
    // views Adding to the view
    
    view.addSubview(safeAreaView)
    [previewView].forEach{safeAreaView.addSubview($0)}
    
    switch self.eventToCreateDetail.eventType {
    case .Text:
      previewView.addSubview(previewLabel)
    case .Photo:
      previewView.addSubview(previewImage)
    case .Animation:
      previewView.addSubview(previewAnimation)
    case .Unknown:
      previewView.addSubview(previewDefault)
      
    }
    
    
    // views Anchor
    safeAreaView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top:  100, left: 16, bottom: 0, right: 16))
    
    previewView.anchor(top: safeAreaView.topAnchor, leading: safeAreaView.leadingAnchor, bottom: nil, trailing: safeAreaView.trailingAnchor, padding: .init(top: 10, left: 10, bottom: 0, right: 10), size: .init(width: 0, height: view.frame.height / 3))
    [previewImage,previewLabel,previewAnimation,previewDefault].forEach{$0.fillSuperView()}
   
    
  }
  

}

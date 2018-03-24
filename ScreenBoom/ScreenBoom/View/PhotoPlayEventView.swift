//
//  PhotoPlayEventView.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/23/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit


class PhotoPlayEventView : PlayEventView {
  
  let photoEventImageView : UIImageView = {
    let view = UIImageView()
    
    view.contentMode = .scaleAspectFit // OR .scaleAspectFill
    view.clipsToBounds = true
    return view
  }()
  
  
  override func configure(viewModel: PlayEventViewModel) {
    super.configure(viewModel: viewModel)
    
    guard let photoEventDetail = viewModel.eventDetail as? PhotoEventDetail else { return}
    
    
    if photoEventDetail.photoname == "placeHolder" {
      
      //Place Holder
      photoEventImageView.image = UIImage(named: "placeHolder")
    }
    
//    else {
////      if let photoName = eventDetail.photoname, let url = URL(string : photoName) {
////        photoEventImageView.sd_setShowActivityIndicatorView(true)
////        photoEventImageView.sd_setIndicatorStyle(.gray)
////        photoEventImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeHolder"), options: [.continueInBackground, .progressiveDownload])
////
////      } else {
////        //Place Holder
////        photoEventImageView.image = UIImage(named: "placeHolder")
////      }
//    }
    
    if let image = photoEventDetail.photo {
      photoEventImageView.image = image
    }
    
    addSubview(photoEventImageView)
    photoEventImageView.anchor(top: self.topAnchor,
                               leading: self.leadingAnchor,
                               bottom: self.bottomAnchor,
                               trailing: self.trailingAnchor,
                               padding: .zero)
    
  }
}

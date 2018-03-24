//
//  AnimationPlayEventView.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/23/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import UIKit

class AnimationPlayEventView : PlayEventView {
  
  let photoEventImageView : UIImageView = {
    let view = UIImageView()
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
    view.contentMode = .scaleAspectFit // OR .scaleAspectFill
    view.clipsToBounds = true
    return view
  }()
  
  override func configure(viewModel: PlayEventViewModel) {
    super.configure(viewModel: viewModel)
    
    let eventDetail = viewModel.eventDetail
    
    guard let animationEventDetail = eventDetail as? AnimationEventDetail else { return }
  
  if let animationStringURL = animationEventDetail.animationStringURL {
    photoEventImageView.loadGif(name: animationStringURL)
  } else {
  // Place Holder Emage
  photoEventImageView.image = UIImage(named: "placeHolder")
  }
  addSubview(photoEventImageView)
  photoEventImageView.anchor(top: self.topAnchor,
  leading: self.leadingAnchor,
  bottom: self.bottomAnchor,
  trailing: self.trailingAnchor,
  padding: .zero)
  
}

}

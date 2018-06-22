//
//  PlayPreviewEventViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/5/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class PlayPreviewEventViewController: PlayEventViewController {
    
  override func viewDidLoad() {
    
    setupViews()
  
    self.configureWithPreviewPlayViewModel(playViewModel: PlayEventViewModel(event: self.event, eventDetail: self.eventDetail))
    
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    self.playEventViewModelSource?.removeObserver(observer: self)
  }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
  
  override func viewWillAppear(_ animated: Bool) {
    
    setupConstraints()
  }
  
  func configureWithPreviewPlayViewModel(playViewModel: PlayEventViewModel) {
    self.playEventView?.configure(viewModel: playViewModel)
  }

}

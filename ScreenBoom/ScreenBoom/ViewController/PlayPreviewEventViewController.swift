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
      super.viewDidLoad()
      
      // setup observation.
      self.playEventViewModelSource = PlayEventViewModelSource(event: self.event, eventDetail: eventDetail)
      self.playEventViewModelSource?.addObserver(observer: self)
    }

  override func viewWillAppear(_ animated: Bool) {
    setupViews()
    addSwipGuestureRecognizers()
  }
  
  func configureWithPreviewPlayViewModel(playViewModel: PlayEventViewModel) {
    self.playEventView?.configure(viewModel: playViewModel)
  }

}

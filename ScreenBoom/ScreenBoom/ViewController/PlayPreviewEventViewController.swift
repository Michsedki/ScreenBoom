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

        // Do any additional setup after loading the view.
    }


  func configureWithPreviewPlayViewModel(playViewModel: PlayEventViewModel) {
    self.playEventView?.configure(viewModel: playViewModel)
  }


  

}

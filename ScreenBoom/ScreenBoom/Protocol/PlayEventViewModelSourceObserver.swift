//
//  PlayEventViewModelSourceObserver.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/21/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

protocol PlayEventViewModelSourceObserver: AnyObject {
  
  func update(viewModel: PlayEventViewModel )
}

//class PlayEventViewModelSourceObserverObject {
//  weak var value: PlayEventViewModelSourceObserver?
//
//  init(value: PlayEventViewModelSourceObserver) {
//    self.value = value
//  }
//}


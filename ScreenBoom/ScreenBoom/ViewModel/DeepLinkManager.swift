//
//  DeepLinkManager.swift
//  ScreenBoom
//
//  Created by Apple on 5/30/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class DeepLinkManager {
    static let sharedInstance = DeepLinkManager()

    
    
    func shareMyDeepLinkURL(eventName: String, eventCode: String) -> String {
        // useing Email or SMS
        let eventNameWithoutSpace = eventName.replacingOccurrences(of: " ", with: "::")
        let deepLinkURL = "sbdl://screenBoomEvent/joinDL/\(eventNameWithoutSpace)/\(eventCode)"
        return deepLinkURL
    }
    
    
}

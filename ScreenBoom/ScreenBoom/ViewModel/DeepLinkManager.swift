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
        let deepLinkURL = "ScreenBoom share events \n\n Download app: https://itunes.apple.com/us/app/screenboom/id1402456093?mt=8 \n\n Press here to join the event:  sbdl://screenBoomEvent/joinDL/\(eventNameWithoutSpace)/\(eventCode)"
        return deepLinkURL
    }
    
    
}

//
//  AnimationEventDetail.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/22/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation

class AnimationEventDetail: EventDetail {
    
    var animationStringURL: String?
    var animationPreviewURL: String?
    var photo: UIImage?
    
    init(animationStringURL: String?, code: String?, photo:UIImage? = nil, animationPreviewURL: String?){
        
        super.init(code: code)
        self.animationStringURL = animationStringURL
        self.animationPreviewURL = animationPreviewURL
        self.photo = photo
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    func configureWithPhoto(photo: UIImage) {
        self.photo = photo
    }
}

//
//  AnimationCollectionViewCell.swift
//  ScreenBoom
//
//  Created by Apple on 6/6/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class AnimationCollectionViewCell: UICollectionViewCell {
    // we need to custmize the cell
    
    let imageCache = NSCache<NSString , UIImage>()

    
    let animationImageView : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor.blue
        return view
    }()
   
    func configureCell (imageURLDic: [String:String]) {
        
        contentView.backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 5
        animationImageView.image = nil
    
        if let urlString = imageURLDic["previewURL"]
           {
            if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
                animationImageView.image = imageFromCache
            } else if let image = UIImage.gif(url: urlString) {
                animationImageView.image = image
                imageCache.setObject(image, forKey: urlString as NSString)
            }

        }
        
        contentView.addSubview(animationImageView)
    
        animationImageView.anchor(top: contentView.topAnchor,
                              leading: contentView.leadingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: contentView.trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 0),
                              size: .init(width: 0, height: 0))
        
    }
}











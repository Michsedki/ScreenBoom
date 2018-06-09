//
//  CreatedEventsTableViewCell.swift
//  ScreenBoom
//
//  Created by Apple on 5/29/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class CreatedEventsTableViewCell: UITableViewCell {

   // we need to custmize the cell
    
    let placeHolderView : UIView = {
       let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.roundIt()
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    let eventTypeLabel : UILabel = {
       let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.layer.masksToBounds = true
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 35)
        view.roundIt()
        view.backgroundColor = Colors.lightBlue
        return view
    }()
    
    let eventImageView : UIImageView = {
       let view = UIImageView()
        view.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.roundIt()
        return view
    }()
    
    let eventNameLabel : UILabel = {
    let view = UILabel()
        view.textColor = Colors.lightBlue
        view.font = UIFont.boldSystemFont(ofSize: 18)
        return view
    }()
    let eventCodeLabel : UILabel = {
        let view = UILabel()
        view.textColor = Colors.lightBlue
        view.font = UIFont.boldSystemFont(ofSize: 18)
        return view
    }()
    let eventShareButton : UIButton = {
        let view = UIButton()
         view.setImage(UIImage(named: "share"), for: .normal)
        return view
    }()
    
    let imageCache = NSCache<NSString, UIImage>()

   
    
    func configureCell (eventInfoDic: [String:String]) {
        eventImageView.image = nil
        
        eventNameLabel.text = eventInfoDic["eventName"]
        eventCodeLabel.text = eventInfoDic["eventCode"]
        if eventInfoDic["eventType"] == "photo" || eventInfoDic["eventType"] == "animation" {
            
            if let url = eventInfoDic["eventPhotoURL"] {
                
                if let imageFromCache = imageCache.object(forKey: url as
                    NSString) {
                    eventImageView.image = imageFromCache
                } else if let image = UIImage.gif(url: url) {
                    eventImageView.image = image
                    imageCache.setObject(image, forKey: url as NSString)
                } else {
                    eventImageView.image = UIImage(named: "placeHolder")
                }
                
            } else {
                eventImageView.image = UIImage(named: "placeHolder")
            }
            placeHolderView.addSubview(eventImageView)
            eventImageView.anchor(top: placeHolderView.topAnchor,
                                  leading: placeHolderView.leadingAnchor,
                                  bottom: placeHolderView.bottomAnchor,
                                  trailing: placeHolderView.trailingAnchor,
                                  padding: .zero)
        } else {
            eventTypeLabel.text = String((eventInfoDic["eventType"]?.uppercased().first!)!)
            placeHolderView.addSubview(eventTypeLabel)
            eventTypeLabel.anchor(top: placeHolderView.topAnchor,
                                  leading: placeHolderView.leadingAnchor,
                                  bottom: placeHolderView.bottomAnchor,
                                  trailing: placeHolderView.trailingAnchor,
                                  padding: .zero)
        }
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(placeHolderView)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(eventCodeLabel)
        contentView.addSubview(eventShareButton)
        
        
        placeHolderView.anchor(top: contentView.topAnchor,
                              leading: contentView.leadingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: nil,
                              padding: .init(top: 10, left: 5, bottom: 10, right: 0),
                              size: .init(width: 80, height: 80))
        
        eventShareButton.anchor(top: contentView.topAnchor,
                                leading: nil,
                                bottom: contentView.bottomAnchor,
                                trailing: contentView.trailingAnchor,
                                padding: .init(top: 25, left: 0, bottom: 25, right: 5),
                                size: .init(width: 50, height: 50))
        
        eventNameLabel.anchor(top: contentView.topAnchor,
                              leading: placeHolderView.trailingAnchor,
                              bottom: nil,
                              trailing: eventShareButton.leadingAnchor,
                              padding: .init(top: 15, left: 15, bottom: 0, right: 10),
                              size: .init(width: 0, height: 30))
        
        eventCodeLabel.anchor(top: eventNameLabel.bottomAnchor,
                              leading: placeHolderView.trailingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: eventShareButton.leadingAnchor,
                              padding: .init(top: 5, left: 20, bottom: 15, right: 10),
                              size: .init(width: 0, height: 30))
        
    }
    

}

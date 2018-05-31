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
    
    let eventTypeLabel : UILabel = {
       let view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.layer.masksToBounds = true
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 35)
        view.roundIt()
        view.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1)
        return view
    }()
    let eventNameLabel : UILabel = {
    let view = UILabel()
        view.textColor = .blue
        view.font = UIFont.boldSystemFont(ofSize: 18)
        return view
    }()
    let eventCodeLabel : UILabel = {
        let view = UILabel()
        view.textColor = .blue
        view.font = UIFont.boldSystemFont(ofSize: 18)
        return view
    }()
    let eventShareButton : UIButton = {
        let view = UIButton()
         view.setImage(UIImage(named: "share"), for: .normal)
        return view
    }()
    
   
    
    func configureCell (eventName: String, eventCode : String, eventType: String) {
        
        eventNameLabel.text = eventName
        eventCodeLabel.text = eventCode
        eventTypeLabel.text = String(eventType.uppercased().first!)
        
        selectionStyle = .none
        contentView.backgroundColor = UIColor.white
        
        contentView.addSubview(eventTypeLabel)
        contentView.addSubview(eventNameLabel)
        contentView.addSubview(eventCodeLabel)
        contentView.addSubview(eventShareButton)
        
        
        eventTypeLabel.anchor(top: contentView.topAnchor,
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
                              leading: eventTypeLabel.trailingAnchor,
                              bottom: nil,
                              trailing: eventShareButton.leadingAnchor,
                              padding: .init(top: 15, left: 15, bottom: 0, right: 10),
                              size: .init(width: 0, height: 30))
        
        eventCodeLabel.anchor(top: eventNameLabel.bottomAnchor,
                              leading: eventTypeLabel.trailingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: eventShareButton.leadingAnchor,
                              padding: .init(top: 5, left: 20, bottom: 15, right: 10),
                              size: .init(width: 0, height: 30))
        
    }
    

}

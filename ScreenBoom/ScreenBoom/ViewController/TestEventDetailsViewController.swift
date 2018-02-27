//
//  TestEventDetailsViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/26/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class TestEventDetailsViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
 
  
  // constants
  struct Constant {
    static let previewViewDestanceFromNavBar: CGFloat = 30
    
  }
  
  // variables
  var previewView = UIView()
  let colors = ["White","Yellow","Green","Blue","Red","Orange"]
  let currentEvent = Event(eventName: "wedding", eventIsLive: "no", eventType: EventType.Text)

    override func viewDidLoad() {
        super.viewDidLoad()

      
      configureWithEvent(event: currentEvent)
        // Do any additional setup after loading the view.
    }

  // PickerView Protocol Conform
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 2
  }
  
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return colors.count
  }
  
//  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//    return colors[row]
//  }
  func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
    let pickerViewLabel = UILabel()
    pickerViewLabel.text = colors[row]
    pickerViewLabel.backgroundColor = colors[row].stringToUIColor()
    pickerViewLabel.textAlignment = .center
    pickerViewLabel.layer.borderWidth = 1.5
    pickerViewLabel.layer.cornerRadius = 5
    pickerViewLabel.layer.borderColor = UIColor.black.cgColor
    return pickerViewLabel
  }
  func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
    return pickerView.layer.frame.width / 3
  }
  
  func configureWithEvent(event: Event) {
    
    
    
    // Preview View
    previewView.frame = CGRect(x: view.frame.midX - 100, y:  (navigationController?.navigationBar.bounds.height)! + Constant.previewViewDestanceFromNavBar , width: 200, height: 200)
    previewView.backgroundColor = UIColor.gray
   
    
    view.addSubview(previewView)
    
    switch event.eventType {
    case .Text:
      configureTextView()
    case .Photo:
      configurePhotoView()
    case.Animation:
      configureAnimationView()
      
    default:
      infoView(message: "Can't find event type", color: Colors.smoothRed)
    }
    
    
    
    
  }
  
  func configureTextView() {
    
    // Stack View
    let stack = UIStackView()
    stack.backgroundColor = UIColor.blue
    stack.frame = CGRect(x: view.frame.minX + 10, y: previewView.frame.maxY + 20, width: view.frame.maxX - 20, height: 100)
    stack.alignment = .fill
    stack.distribution = .fillEqually
    stack.axis = .horizontal
    
    let textColorLabel = UILabel()
    textColorLabel.frame = CGRect(x: stack.leftAnchor + 5, y: stack.topAnchor + 5, width: stack.widthAnchor - 20, height: stack.heightAnchor - 10)
    textColorLabel.text = "Text Color"
    textColorLabel.backgroundColor = UIColor.lightGray
    
    let backgroundColorLabel = UILabel()
    backgroundColorLabel.text = "Background Color"
    backgroundColorLabel.backgroundColor = UIColor.lightGray
    
    stack.addSubview(textColorLabel)
    stack.addSubview(backgroundColorLabel)
    view.addSubview(stack)
    
    
    
    
    let textColorPickerView = UIPickerView()
    textColorPickerView.frame = CGRect(x: view.frame.minX + 10, y: previewView.frame.maxY + 100, width: view.frame.maxX - 20, height: 200)
    textColorPickerView.dataSource = self
    textColorPickerView.delegate = self
    view.addSubview(textColorPickerView)
    
    
    
    
    
    
  }
  
  
  
  func configurePhotoView(){
    
  }
  func configureAnimationView(){
    
  }

}


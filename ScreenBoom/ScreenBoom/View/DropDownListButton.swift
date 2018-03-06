//
//  DropDownListButton.swift
//  sdafjkbslib
//
//  Created by Michael Tanious on 3/5/18.
//  Copyright © 2018 Archetapp. All rights reserved.
//

import UIKit


protocol dropDownProtocol {
  func dropDownPressed(string : String, color: UIColor?)
}

class dropDownBtn: UIButton, dropDownProtocol {
  
  func dropDownPressed(string: String, color: UIColor?) {
    self.setTitle(string, for: .normal)
    if let color = color {
      self.backgroundColor = color
    }
    self.dismissDropDown()
  }
  
  var dropView = dropDownView()
  var height = NSLayoutConstraint()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.lightGray
    dropView = dropDownView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    dropView.delegate = self
    dropView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func didMoveToSuperview() {
    self.superview?.addSubview(dropView)
    self.superview?.bringSubview(toFront: dropView)
    dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    height = dropView.heightAnchor.constraint(equalToConstant: 0)
  }
  
  var isOpen = false
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if isOpen == false {
      
      isOpen = true
      
      NSLayoutConstraint.deactivate([self.height])
      
      if self.dropView.tableView.contentSize.height > 150 {
        self.height.constant = 150
      } else {
        self.height.constant = self.dropView.tableView.contentSize.height
      }
      
      NSLayoutConstraint.activate([self.height])
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
        self.dropView.layoutIfNeeded()
        self.dropView.center.y += self.dropView.frame.height / 2
      }, completion: nil)
      
    } else {
      isOpen = false
      
      NSLayoutConstraint.deactivate([self.height])
      self.height.constant = 0
      NSLayoutConstraint.activate([self.height])
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
        self.dropView.center.y -= self.dropView.frame.height / 2
        self.dropView.layoutIfNeeded()
      }, completion: nil)
      
    }
  }
  
  func dismissDropDown() {
    isOpen = false
    NSLayoutConstraint.deactivate([self.height])
    self.height.constant = 0
    NSLayoutConstraint.activate([self.height])
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
      self.dropView.center.y -= self.dropView.frame.height / 2
      self.dropView.layoutIfNeeded()
    }, completion: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class dropDownView: UIView, UITableViewDelegate, UITableViewDataSource  {
  
  var delegate : dropDownProtocol!
  var dropDownSelectionDelegate : DropDownSelectionDelegate!
  
  
  var dropDownOptions = [String]()
  var dropDownButtonTitle : String?
  
  var tableView = UITableView()
  
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    self.addSubview(tableView)
    tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
    tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dropDownOptions.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    cell.textLabel?.text = dropDownOptions[indexPath.row]
    cell.textLabel?.textAlignment = .center
    if dropDownOptions[indexPath.row].stringToUIColor() != nil
    {
      // check if the strings can be casted to UIColors
     cell.backgroundColor = dropDownOptions[indexPath.row].stringToUIColor()
      if dropDownOptions[indexPath.row].stringToUIColor() == UIColor.white {
        // if the cell background color is white let the text color be black
        cell.textLabel?.textColor = UIColor.black
      } else {
        // for any other color for cell background let the text color be white
        cell.textLabel?.textColor = UIColor.white
      }
    } else {
      // if the strings can not be casted to UIColors let the background color light gray
      cell.backgroundColor = UIColor.lightGray
    }
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let dropDownButtonTitle = dropDownButtonTitle {
      self.dropDownSelectionDelegate.didSelectItem(changedFieldName: dropDownButtonTitle, itemName: dropDownOptions[indexPath.row])
    }
    self.delegate.dropDownPressed(string: dropDownOptions[indexPath.row], color: tableView.cellForRow(at: indexPath)?.backgroundColor)
    self.tableView.deselectRow(at: indexPath, animated: true)
  }
  
}


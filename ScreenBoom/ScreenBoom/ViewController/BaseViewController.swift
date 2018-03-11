//
//  BaseViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

      
        // Do any additional setup after loading the view.
    }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
    
    
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true;
  }
  
  // Constants
  // Firebase
  let firebaseNodeNames = FirebaseNodeNames()
  let userDefaultKeyNames = UserDefaultKeyNames()
  
  
  let fontSize12 = UIScreen.main.bounds.width / 31
  
  let spinner = UIActivityIndicatorView()

  // boolean to check if errorView is currently showing or not
  var infoViewIsShowing = false
  
  // error view on top
  
  func infoView( message:String, color: UIColor) {
    
    //if errorView is not showing
    if infoViewIsShowing == false {
      
      // cast as errorview is currently showing
      infoViewIsShowing = true
      
      // errorView - red background creation
      let infoView_Hieght = self.view.bounds.height / 14.2
      let infoView_Y = 0 - infoView_Hieght
      
      let infoView = UIView()
      infoView.frame = CGRect(x: 0, y: infoView_Y, width: self.view.bounds.width, height: infoView_Hieght)
      
      
      infoView.backgroundColor = color
      self.view.addSubview(infoView)
      if let navController = self.navigationController {
        navController.view.addSubview(infoView)
      } else {
        self.view.addSubview(infoView)
      }
      
      // errorLabel - label to show error text
      let infoLabel_Width = infoView.bounds.width
      let infoLabel_Hieght = infoView.bounds.height + UIApplication.shared.statusBarFrame.height / 2
      
      let infoLabel = UILabel()
      infoLabel.frame.size.width = infoLabel_Width
      infoLabel.frame.size.height = infoLabel_Hieght
      infoLabel.numberOfLines = 0
      infoLabel.text = message
      infoLabel.font = UIFont(name: "HelveticaNeue", size: fontSize12)
      infoLabel.textColor = UIColor.white
      infoLabel.textAlignment = .center
      infoView.addSubview(infoLabel)
      self.view.bringSubview(toFront: infoView)
      
      // animate error view
      
      UIView.animate(withDuration: 0.3, animations: {
        // move down error view
        infoView.frame.origin.y = 0
        
        // if animation did finish
      }, completion: { (finished : Bool) in
        // if it is true
        if (finished) {
          
          UIView.animate(withDuration: 0.3, delay: 1, options: .curveLinear, animations: {
            
            // move up error view
            infoView.frame.origin.y = infoView_Y
            
            // if finished all animations
          }, completion: { (finished: Bool) in
            if finished {
              
              
              infoView.removeFromSuperview()
              infoLabel.removeFromSuperview()
              self.infoViewIsShowing = false
            }
          })
          
          
        }
      })
      
    }
  }
  
  func ShowSpinner() {
    
    spinner.color = UIColor.black
    spinner.hidesWhenStopped = true
    spinner.frame = CGRect(x: self.view.center.x - 50,
                           y: self.view.center.y - 50,
                           width: 100,
                           height: 100)
    self.view.addSubview(spinner)
    spinner.startAnimating()
    
  }
  func HideSpinner() {
    spinner.stopAnimating()
    
  }

}



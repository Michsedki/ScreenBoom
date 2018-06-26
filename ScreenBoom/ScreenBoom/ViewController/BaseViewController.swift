//
//  BaseViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 2/10/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import FirebaseDatabase

class BaseViewController: UIViewController, UITextFieldDelegate {
    
    var firebaseDatabaseReference: DatabaseReference!
    
    // Constants
    // Firebase
    let firebaseNodeNames = FirebaseNodeNames()
    let userDefaultKeyNames = UserDefaultKeyNames()
    let imageNames = ImageNames()
    let fontSize12 = UIScreen.main.bounds.width / 31
    let spinner = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseDatabaseReference = Database.database().reference()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    
    
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
        self.view.bringSubview(toFront: spinner)
        spinner.startAnimating()
        
    }
    func HideSpinner() {
        spinner.stopAnimating()
        
    }
    
    // here we alow change of the orientation
    // and set the transition of the view controller when it dismiss to flip
    func prepareForViewWillDisapear() {
        
        // allow rotation for other viewControllers
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = true
        
        if self.isMovingFromParentViewController {
            changeTransition(direction: "backword")
        }
    }
    
    // here we prevent any change of transition
    // and force portrait orientation
    func prepareForViewWillAppearWithForcedPortrait() {
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        // disaple Rotation for this view controller
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = false
        
    }
    
    func prepareForViewWillAppear() {
        // disaple Rotation for this view controller
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.enableAllOrientation = false
        
    }
    
    func changeTransition(direction:String)  {
        let transition = CATransition()
        transition.duration = 0.7
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //transition.type = kCATransitionPush
        transition.type = "flip"
        if direction == "forword" {
            transition.subtype = kCATransitionFromLeft
        } else {
            transition.subtype = kCATransitionFromRight
        }
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        
    }
    
    func goToMap()  {
        // for pushing
        changeTransition(direction: "forword")
        //        navigationController?.pushViewController(settingsVC, animated: false)
    }
    func backToList()  {
        // for dismiss
        changeTransition(direction: "forword")
        navigationController?.popViewController(animated: false)
        dismiss(animated: true, completion: nil)
        
    }
    
}



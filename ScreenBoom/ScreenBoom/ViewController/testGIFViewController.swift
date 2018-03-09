//
//  testGIFViewController.swift
//  ScreenBoom
//
//  Created by Michael Tanious on 3/7/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import SDWebImage

class testGIFViewController: BaseViewController {

  
  @IBOutlet weak var gifImage: UIImageView!
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      let storage = Storage.storage()
      let storageReference = storage.reference()
      let urlString = "https://firebasestorage.googleapis.com/v0/b/screenboom-806ad.appspot.com/o/AnimationImages%2Ffirework.gif?alt=media&token=cf27c81a-823c-43e3-8fd1-e49802581c4d"
      let url = URL(string: urlString)

      gifImage.loadGif(name: "candle")
      
      
//      gifImage.sd_setShowActivityIndicatorView(true)
//      gifImage.sd_setIndicatorStyle(.whiteLarge)
//
//      gifImage.sd_setAnimationImages(with: [url!])
//      gifImage.startAnimating()
      
     
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

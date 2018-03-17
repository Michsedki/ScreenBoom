//
//  ImageUploadManager.swift
//  GridLayout
//
//  Created by Sztanyi Szabolcs on 2017. 06. 20..
//  Copyright © 2017. Sabminder. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase




class ImageUploadManager: NSObject {

  let firebaseNodeNames = FirebaseNodeNames()
  let storageReference = Storage.storage().reference()
  
  func uploadImage(event: Event,_ image: UIImage, progressBlock: @escaping (_ percentage: Double) -> Void, completionBlock: @escaping (_ url: URL?, _ errorMessage: String?) -> Void) {
        // storage/Datefrom1970/_eventName.jpg
        let imageName = "\(Date().timeIntervalSince1970)_\(event.eventName).jpg"
        let imagesReference = storageReference.child(firebaseNodeNames.eventImagesFolderName).child(imageName)
        if let imageData = UIImageJPEGRepresentation(image, 0.8) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            let uploadTask = imagesReference.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBlock(metadata.downloadURL(), nil)
                } else {
                    completionBlock(nil, error?.localizedDescription)
                }
            })
            uploadTask.observe(.progress, handler: { (snapshot) in
                guard let progress = snapshot.progress else {
                    return
                }

                let percentage = (Double(progress.completedUnitCount) / Double(progress.totalUnitCount)) * 100
                progressBlock(percentage)
            })
        } else {
            completionBlock(nil, "Image couldn't be converted to Data.")
        }
    }
  
  // Delete Image from firebase storage
  func deleteImage(eventDetail: EventDetail, completion: (@escaping(Result<Void>) -> Void )) {
    let imagesReference = storageReference.child(firebaseNodeNames.eventImagesFolderName).child(eventDetail.photoname!)
    let delteteImageReference = Storage.storage().reference(forURL: eventDetail.photoname!)
    delteteImageReference.delete { (error) in
      if let error = error {
        completion(Result.Failure(error.localizedDescription))
      } else {
        completion(Result.Success(()))
      }
    }
  }
}












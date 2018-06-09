//
//  GIFGiphyManager.swift
//  ScreenBoom
//
//  Created by Apple on 6/6/18.
//  Copyright © 2018 WMWiOS. All rights reserved.
//

import Foundation
import GiphyCoreSDK

class GIFGiphyMAnager {
     static let sharedInstance = GIFGiphyMAnager()
    
    
    func getGIFTrending(completion: (@escaping(Result<[[String:String]]>) -> Void)) {
        // Trending GIFs
        GiphyCore.shared.trending() { (response, error) in
            
            guard error == nil,
                let response = response,
                let data = response.data else {
                    completion(Result.Failure(error?.localizedDescription ?? "No Giphy Response"))
                    return
            }
            
            var gifDic = [[String:String]]()
            
            for gifImageData in data {
                if let gifImagePreviewURL = gifImageData.images?.fixedWidthDownsampled?.gifUrl,
                    let gifImageLargeURL = gifImageData.images?.downsizedLarge?.gifUrl,
                    let downsizedStill = gifImageData.images?.downsizedStill?.gifUrl {
                    
                    let gifImageinfoDic = ["previewURL":gifImagePreviewURL,
                                           "originalURL":gifImageLargeURL,
                                           "downsizedStill": downsizedStill]
                    gifDic.append(gifImageinfoDic)
                }
            }
            if gifDic.count == data.count && gifDic.count > 0 {
                completion(Result.Success(gifDic))
            } else {
                completion(Result.Failure("No GIF Image To Show"))
            }
            
        }
        
    }
   
    func getGIFSearch(searchWord:String, completion: (@escaping(Result<[[String:String]]>) -> Void)) {
        
        GiphyCore.shared.search(searchWord) { (response, error) in
            
            guard error == nil,
                let response = response,
                let data = response.data else {
                    completion(Result.Failure(error?.localizedDescription ?? "No Giphy Response"))
                    return
            }
            
            var gifDic = [[String:String]]()
            
            for gifImageData in data {
                if let gifImagePreviewURL = gifImageData.images?.fixedWidthDownsampled?.gifUrl,
                    let gifImageLargeURL = gifImageData.images?.downsizedLarge?.gifUrl,
                let downsizedStill = gifImageData.images?.downsizedStill?.gifUrl {
                    
                    let gifImageinfoDic = ["previewURL":gifImagePreviewURL,
                                           "originalURL":gifImageLargeURL,
                                           "downsizedStill": downsizedStill]
                    
                    gifDic.append(gifImageinfoDic)
                }
            }
            if gifDic.count == data.count && gifDic.count > 0 {
                completion(Result.Success(gifDic))
            } else {
                completion(Result.Failure("No GIF Image To Show"))
            }
            
        }
    
    
    
    }
    
    // **** we didin't use this yet
    func getGIFImageFromURL(gifURL: String, completion: (@escaping(Result<UIImage>) -> Void)) {
        if let image = UIImage.gif(url: gifURL) {
            completion(Result.Success(image))
        } else {
            completion(Result.Failure("Couldm't git gif image"))
        }
        
    }
}

//
//  LibraryController.swift
//  Camera
//
//  Created by Vitor Oliveira on 2/27/16.
//
//

import UIKit
import Photos

public class LibraryController {
    
    public let screenWidth = UIScreen.mainScreen().bounds.size.width
    public let screenHeight = UIScreen.mainScreen().bounds.size.height
    public let sectionInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    public var photosAsset: PHFetchResult!
    
    public func requestAuth(){
        PHPhotoLibrary.requestAuthorization {
            [weak self](status: PHAuthorizationStatus) in
            
            dispatch_async(dispatch_get_main_queue(), {
                switch status{
                case .Authorized:
                    self!.retrieveNewestImage()
                default:
                    print("Not authorized")
                }
            })
            
        }
    }
    
    private func retrieveNewestImage() {
        
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
        let assetResults = PHAsset.fetchAssetsWithMediaType(.Image, options: options)
        
        photosAsset = assetResults
        
    }
    
}
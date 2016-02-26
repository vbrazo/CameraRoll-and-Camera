//
//  Library.swift
//  Camera
//
//  Created by Vitor Oliveira on 2/24/16.
//
//

import UIKit
import Photos

class Library: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let library = LibraryController()
    
    var assetThumbnailSize : CGSize!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: self.library.screenWidth/2, height: self.library.screenWidth/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        if let layout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            let cellSize = layout.itemSize
            self.assetThumbnailSize = CGSizeMake(cellSize.width, cellSize.height)
        }
        
        self.library.requestAuth()
        collectionView.reloadData()
        
    }

    @IBAction func btnPhotoClick(sender: AnyObject) {
        let view = self.storyboard!.instantiateViewControllerWithIdentifier("CameraID")
        self.presentViewController(view, animated: false, completion: nil)
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        var count: Int = 0
        if(self.library.photosAsset != nil){
            count = self.library.photosAsset.count
        }
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Photo", forIndexPath: indexPath) as! Album
        let asset: PHAsset = self.library.photosAsset[indexPath.item] as! PHAsset
        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: self.assetThumbnailSize, contentMode: .AspectFill, options: nil, resultHandler: {(result, info)in
            if let image = result {
                cell.setImage(image)
            }
        })
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let asset: PHAsset = self.library.photosAsset[indexPath.item] as! PHAsset
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: self.assetThumbnailSize, contentMode: .AspectFit, options: nil, resultHandler: {(result, info) in
            if (info![PHImageResultIsDegradedKey]! as! NSObject==0) {
                if let image = result {
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PreviewID") as! Preview
                    vc.newMediaImage = UIImageView(image: image)
                    self.presentViewController(vc, animated: false, completion: nil)
                }
            }
        })
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.library.screenWidth/3, height: (self.library.screenWidth/2)/(540/420))
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return self.library.sectionInsets
    }
    
}
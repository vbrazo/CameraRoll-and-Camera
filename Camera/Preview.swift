//
//  Preview.swift
//  Camera
//
//  Created by Vitor Oliveira on 2/24/16.
//
//

import UIKit

class Preview: UIViewController {

    let global = Global()
    
    var newMediaImage : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newMediaImage.frame = CGRectMake(0, 67, self.global.screenWidth, self.global.screenHeight-59)
        self.view.addSubview(newMediaImage)
        self.view.sendSubviewToBack(newMediaImage)
    
    }
    
    @IBAction func btnBackButton(sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("CameraID") as! Camera
        self.presentViewController(vc, animated: false, completion: nil)
    }
    
}
//
//  Preview.swift
//  Camera
//
//  Created by Vitor Oliveira on 2/24/16.
//
//

import UIKit

class Preview: UIViewController {
    
    var newMediaImage : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let screenHeight = UIScreen.mainScreen().bounds.size.height
        
        newMediaImage.frame = CGRectMake(0, 67, screenWidth, screenHeight-59)
        self.view.addSubview(newMediaImage)
        self.view.sendSubviewToBack(newMediaImage)
    
    }
    
}
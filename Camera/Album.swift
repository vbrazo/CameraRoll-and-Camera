//
//  Album.swift
//  Camera
//
//  Created by Vitor Oliveira on 2/24/16.
//
//

import UIKit

class Album: UICollectionViewCell {
    
    @IBOutlet weak var albumPhoto: UIImageView!
    
    func setImage(image: UIImage){
        self.albumPhoto.image = image
    }
    
}
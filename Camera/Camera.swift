//
//  Camera.swift
//  Camera
//
//  Created by Vitor Oliveira on 2/24/16.
//
//

import UIKit

class Camera : UIViewController {
    
    @IBOutlet weak var cameraOptionsView: UIView!
    
    let camera = CameraController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start camera and set initial configuration
        camera.startCamera(self.view)
        camera.cameraQuality = .High
        camera.savePhotoToLibrary = true
        
        self.view.bringSubviewToFront(cameraOptionsView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        camera.touchesBegan(touches, withEvent: event, view: self.view)
    }
    
    @IBAction func btnTakePictureClick(sender: AnyObject) {
        camera.takePicture(self.view, imageGenerated: { (image, error) -> Void in
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PreviewID") as! Preview
            vc.newMediaImage = image
            self.presentViewController(vc, animated: false, completion: nil)
        })
    }

    @IBAction func changeCameraPosition(sender: AnyObject) {
        camera.changeCameraPosition()
    }
        
    @IBAction func btnLibraryClick(sender: AnyObject) {
        let view = self.storyboard!.instantiateViewControllerWithIdentifier("LibraryID")
        self.presentViewController(view, animated: false, completion: nil)
    }
    
}

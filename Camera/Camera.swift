//
//  Camera.swift
//  Camera
//
//  Created by Vitor Oliveira on 2/24/16.
//
//

import UIKit

class Camera : UIViewController {
    
    @IBOutlet weak var cameraOptionsTopView: UIView!
    @IBOutlet weak var cameraOptionsView: UIView!
    @IBOutlet weak var flashIcon: UIButton!
    
    let camera = CameraController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start camera and set initial configuration
        camera.startCamera(self.view)
        camera.cameraQuality = .High
        camera.savePhotoToLibrary = false
        camera.flashMode = .No
        camera.flashStatus(flashIcon)
        
        self.view.bringSubviewToFront(cameraOptionsView)
        self.view.bringSubviewToFront(cameraOptionsTopView)
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
    
    @IBAction func changeFlashMode(sender: AnyObject) {
        camera.flashStatus(flashIcon)
    }

    @IBAction func changeCameraPosition(sender: AnyObject) {
        camera.changeCameraPosition()
    }
    
    @IBAction func btnLibraryClick(sender: AnyObject) {
        let view = self.storyboard!.instantiateViewControllerWithIdentifier("LibraryID")
        self.presentViewController(view, animated: false, completion: nil)
    }
    
}

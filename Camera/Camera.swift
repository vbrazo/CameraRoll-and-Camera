//
//  ViewController.swift
//  Camera
//
//  Created by Vitor Oliveira on 2/24/16.
//
//

import UIKit
import MobileCoreServices
import AVFoundation

class Camera: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    let stillImageOutput = AVCaptureStillImageOutput()
    
    var photo : UIImageView!
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.sessionPreset = AVCaptureSessionPreset1280x720
        
        let devices = AVCaptureDevice.devices()
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        do {
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        } catch {
                            print("Error")
                        }
                        
                        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                        
                        if captureSession.canAddOutput(stillImageOutput) {
                            captureSession.addOutput(stillImageOutput)
                        }
                        
                        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                        self.view.layer.addSublayer(previewLayer!)
                        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                        previewLayer?.frame = CGRectMake(0, 0, self.screenWidth, self.screenHeight-59)
                        
                        captureSession.startRunning()
                        
                    }
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDeviceSettings(focusValue : Float, isoValue : Float) {
        if let device = captureDevice {
            device.focusMode = AVCaptureFocusMode.ContinuousAutoFocus
            device.unlockForConfiguration()
        }
    }
    
    @IBAction func btnTakePictureClick(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue(), {
            if let videoConnection = self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo){
                self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                    (sampleBuffer, error) in
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault )
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x:0, y:0, width:self.view.frame.width/2, height:self.view.frame.height/2)
                    
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                    self.photo = imageView
                    
                    self.captureSession.stopRunning()
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("transPreviewPhoto", sender: nil)
                    }
    
                })
            }
        })
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender:AnyObject?){
        if (segue.identifier=="transPreviewPhoto"){
            let vc = segue.destinationViewController as! Preview
            vc.newMediaImage = self.photo
        }
    }
    
}


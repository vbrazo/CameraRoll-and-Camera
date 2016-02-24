//
//  Camera.swift
//  Camera
//
//  Created by Vitor Oliveira on 2/24/16.
//
//

import UIKit
import MobileCoreServices
import AVFoundation

class Camera: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let global = Global()
    var photo : UIImageView!
    
    let devices = AVCaptureDevice.devices()
    var captureDevice : AVCaptureDevice?
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    let stillImageOutput = AVCaptureStillImageOutput()
    var cameraPosition = AVCaptureDevicePosition.Back
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        if device(AVCaptureDevicePosition.Back) {
            startCamera()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startCamera(){
        
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer?.frame = CGRectMake(0, 0, self.global.screenWidth, self.global.screenHeight-100)
        
        self.view.layer.addSublayer(previewLayer!)
        
        captureSession.startRunning()

    }
    
    func device(type: AVCaptureDevicePosition) -> Bool {
        
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if(device.position == type) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        do {
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        } catch {
                            print("Error")
                        }
                    }
                }
            }
        }
        
        return captureDevice != nil
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let focusX = touches.first!.locationInView(self.view).x / self.global.screenWidth
        let focusY = touches.first!.locationInView(self.view).y / self.global.screenHeight

        if cameraPosition == .Back {
            if let device = captureDevice {
                do {
                    try device.lockForConfiguration()
                    device.focusPointOfInterest = CGPointMake(focusX, focusY)
                    device.focusMode = AVCaptureFocusMode.AutoFocus
                    device.exposurePointOfInterest = CGPointMake(focusX, focusY)
                    device.exposureMode = AVCaptureExposureMode.ContinuousAutoExposure
                    device.unlockForConfiguration()
                } catch let error as NSError {
                    print(error.code)
                }
            }
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
                    
                    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PreviewID") as! Preview
                    vc.newMediaImage = imageView
                    self.presentViewController(vc, animated: false, completion: nil)
                    
                })
            }
        })
        
    }

    @IBAction func changeCameraPosition(sender: AnyObject) {
        
        let currentInput = captureSession.inputs[0] as! AVCaptureInput
        captureSession.removeInput(currentInput)
        
        cameraPosition = cameraPosition == .Back ? .Front : .Back
        self.device(cameraPosition)
       
    }
        
    @IBAction func btnLibraryClick(sender: AnyObject) {
        let view = self.storyboard!.instantiateViewControllerWithIdentifier("LibraryID")
        self.presentViewController(view, animated: false, completion: nil)
    }
    
}

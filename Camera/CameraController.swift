//
//  CameraController.swift
//  CameraController
//
//  Created by Vitor Oliveira on 2/26/16.
//
//

import UIKit
import MobileCoreServices
import AVFoundation

public enum CameraQuality: Int {
    case Low, Medium, High, PresetPhoto
}

public class CameraController {
    
    private let global = Global()

    private let devices = AVCaptureDevice.devices()
    private var captureDevice : AVCaptureDevice?
    private let captureSession = AVCaptureSession()
    private var previewLayer : AVCaptureVideoPreviewLayer?
    private let stillImageOutput = AVCaptureStillImageOutput()
    private var cameraPosition = AVCaptureDevicePosition.Back
    
    public var cameraQuality = CameraQuality.High {
        didSet {
            var sessionPreset = AVCaptureSessionPresetLow
            switch (cameraQuality) {
                case CameraQuality.Low:
                    sessionPreset = AVCaptureSessionPresetLow
                case CameraQuality.Medium:
                    sessionPreset = AVCaptureSessionPresetMedium
                case CameraQuality.High:
                    sessionPreset = AVCaptureSessionPresetHigh
                case CameraQuality.PresetPhoto:
                    sessionPreset = AVCaptureSessionPresetPhoto
            }
            if captureSession.canSetSessionPreset(sessionPreset) {
                captureSession.beginConfiguration()
                captureSession.sessionPreset = sessionPreset
                captureSession.commitConfiguration()
            }
        }
    }
    
    public func startCamera(view: UIView){
        
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        if device(AVCaptureDevicePosition.Back) {
            if captureSession.canAddOutput(stillImageOutput) {
                captureSession.addOutput(stillImageOutput)
            }
        
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewLayer?.frame = CGRectMake(0, 0, self.global.screenWidth, self.global.screenHeight-45)
        
            view.layer.addSublayer(previewLayer!)
        
            captureSession.startRunning()
        }
        
    }
    
    public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?, view: UIView) {
        
        let focusX = touches.first!.locationInView(view).x / self.global.screenWidth
        let focusY = touches.first!.locationInView(view).y / self.global.screenHeight
        
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
    
    public func takePicture(view: UIView, imageGenerated: (UIImageView?, NSError?) -> Void) {
        dispatch_async(dispatch_get_main_queue(), {
            if let videoConnection = self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo){
                self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                    (sampleBuffer, error) in
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProviderCreateWithCFData(imageData)
                    let cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, CGColorRenderingIntent.RenderingIntentDefault )
                    let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.Right)
                    
                    let imageView = UIImageView(image: image)
                    imageView.frame = CGRect(x:0, y:0, width:view.frame.width/2, height:view.frame.height/2)
                    
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                    self.captureSession.stopRunning()
                    
                    imageGenerated(imageView, nil)
                })
            }
        })
    }
    
    public func changeCameraPosition() {
        let currentInput = captureSession.inputs[0] as! AVCaptureInput
        captureSession.removeInput(currentInput)
        
        cameraPosition = cameraPosition == .Back ? .Front : .Back
        self.device(cameraPosition)
    }
    
    private func device(type: AVCaptureDevicePosition) -> Bool {
        
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
    
}

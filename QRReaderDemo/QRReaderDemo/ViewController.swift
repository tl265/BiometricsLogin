//
//  ViewController.swift
//  QRReaderDemo
//
//  Created by Simon Ng on 23/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation
import LocalAuthentication

class ViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate    {
    
    @IBOutlet weak var messageLabel:UILabel!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    
    func authenticateUser(websiteName: String) {
        // Get the local authentication context.
        let context : LAContext = LAContext()
        
        // Declare a NSError variable.
        var error: NSError?
        // Set the reason string that will appear on the authentication alert.
        var reasonString = "Authentication is needed to access "
        reasonString += websiteName
        
        var url:NSURL = NSURL(string: "http://xxx.xxx.xxx.xxx/receiver.php")!	// replace with real URL or IP address when compiling
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        var bodyData = ""
        
        // Check if the device can evalutate the policy.
        if context.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &error){
            [context.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { (success: Bool, evalPolicyError: NSError?)->Void in
                if success {
                    dispatch_async(dispatch_get_main_queue()){
                        self.messageLabel.text = "timestamp " + websiteName + " deviceid " + UIDevice.currentDevice().identifierForVendor.UUIDString
                    }
                    bodyData = "timestamp=" + websiteName + "&deviceid=" + UIDevice.currentDevice().identifierForVendor.UUIDString
                    
                    request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
                        {
                            (response, data, error) in
                            println(response)
                    }
                    
                    println("success")
                }
                else{
                    // If authentication failed then show a message to the console with a short description.
                    // In case that the error is a user fallback, then show the password alert view.
                    
                    println(evalPolicyError?.localizedDescription)
                    
                    switch evalPolicyError!.code {
                        
                    case LAError.SystemCancel.rawValue:
                        dispatch_async(dispatch_get_main_queue()){
                            self.messageLabel.text = "Authentication cancelled by the system"
                        }
                    case LAError.UserCancel.rawValue:
                        dispatch_async(dispatch_get_main_queue()){
                            self.messageLabel.text = "Authentication cancelled by the user"
                        }
                    case LAError.UserFallback.rawValue:
                        dispatch_async(dispatch_get_main_queue()){
                            self.messageLabel.text = "Custom password not allowed"
                        }
                        return
                        
                    default:
                        dispatch_async(dispatch_get_main_queue()){
                            self.messageLabel.text = "Authentication failed"
                        }
                    }
                }
            })]
        }
        else{
            // If the security policy cannot be evaluated then show a short message depending on the error.
            switch error!.code{
                
            case LAError.TouchIDNotEnrolled.rawValue:
                dispatch_async(dispatch_get_main_queue()){
                    self.messageLabel.text = "TouchID is not enrolled"
                }
            case LAError.PasscodeNotSet.rawValue:
                dispatch_async(dispatch_get_main_queue()){
                    self.messageLabel.text = "A passcode has not been set"
                }
            default:
                // The LAErr or.TouchIDNotAvailable case.
                dispatch_async(dispatch_get_main_queue()){
                    self.messageLabel.text = "TouchID not available"
                }
            }
            
            
        }
    }
    
    
    override func viewDidLoad() {
        // super.viewDidLoad()
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        var error:NSError?
        let input: AnyObject! = AVCaptureDeviceInput.deviceInputWithDevice(captureDevice, error: &error)
        
        if (error != nil) {
            // If any error occurs, simply log the description of it and don't continue any more.
            println("\(error?.localizedDescription)")
            return
        }
        
        // Initialize the captureSession object.
        captureSession = AVCaptureSession()
        // Set the input device on the capture session.
        captureSession?.addInput(input as! AVCaptureInput)
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer)
        
        // Start video capture.
        captureSession?.startRunning()
        
        // Move the message label to the top view
        view.bringSubviewToFront(messageLabel)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        qrCodeFrameView?.layer.borderColor = UIColor.greenColor().CGColor
        qrCodeFrameView?.layer.borderWidth = 2
        qrCodeFrameView?.frame = CGRect(x: 375.0/2-100, y: 667.0/2-100, width: 200.0, height: 200.0)
        
        view.addSubview(qrCodeFrameView!)
        view.bringSubviewToFront(qrCodeFrameView!)
        
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        captureSession?.stopRunning()
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            self.messageLabel.text = "Some other codes are detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            messageLabel.text = metadataObj.stringValue
            self.authenticateUser(metadataObj.stringValue)
            
        }
        
        captureSession?.startRunning()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


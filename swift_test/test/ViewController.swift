//  ViewController.swift
//  test
//  Created by Masayoshi Iwasa on 11/9/19.
//  Copyright © 2019 Masayoshi Iwasa. All rights reserved.
//
import UIKit


class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource
{
    
    
    @IBOutlet var cameraView : UIImageView!
    
    @IBOutlet weak var mylabel: UILabel?
//    Dropdown menu for document types
    @IBOutlet weak var documentType: UIPickerView?
    
    var pickerData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mylabel?.text = "Tap the Scan Document to scan scan a ducment"
        // Connect data:
        documentType?.delegate = self
        documentType?.dataSource = self
        
        // Input the data into the array
        pickerData = ["Application for Criminal Complaint (Court)", "Application for Criminal Complaint (Justice Department)", "Police Department Arrest Booking Form", "Arrest Report", "Offense/Incident Report", "Supplemental Report", "Criminal Complaint", "Incident Report", "Court Activity Record Information"]
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        return pickerData[row]
        return NSAttributedString(string: pickerData[row], attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 30.0)!,NSAttributedString.Key.foregroundColor:UIColor.groupTableViewBackground])
    }
    
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//
//        return NSAttributedString(string: "Your Text", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
//    }
    
    // Open camera
    @IBAction func startCamera(_ sender : AnyObject) {
        
        let sourceType:UIImagePickerController.SourceType =
            UIImagePickerController.SourceType.camera
        // check if camera is available
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.camera){
            // initiate camera picker
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
        else{
            mylabel?.text = "error"
            
        }
    }
    
    //　call this after taking a photo
    func imagePickerController(_ imagePicker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let pickedImage = info[.originalImage]
            as? UIImage {
            
            
            // get screen Size
            let screenWidth = self.view.bounds.width
            let screenHeight = self.view.bounds.height
            
            
            
            // image width and height
            let width = cameraView.bounds.size.width
            let height = cameraView.bounds.size.height
            
            
            // adjust image size to the screen size
            let scale = screenWidth / width
            
//            let original_orientation = UIImage.Orientation.self
            
            let rect:CGRect = CGRect(x:0, y:0, width:width*scale, height:height*scale)
            
            // fit cameraView frame to CGRect
            cameraView.frame = rect;
            
            
            // centering the image
            cameraView.center = CGPoint(x:screenWidth/2, y:screenHeight/3)
            
            cameraView.image = pickedImage
        }

        //closing
        imagePicker.dismiss(animated: true, completion: nil)
        mylabel?.text = "Tap the [Save] to save a picture"
        
    }
    
    
    // Call this when cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        mylabel?.text = "Canceled"
    }
    
    
    // Save images
    @IBAction func savePicture(_ sender : AnyObject) {
        let image:UIImage! = cameraView.image
        
        if image != nil {
            UIImageWriteToSavedPhotosAlbum(
                image,
                self,
                #selector(ViewController.image(_:didFinishSavingWithError:contextInfo:)),
                nil)
        }
        else{
            mylabel?.text = "image Failed !"
        }
    }
    
    
    
    
    // result of writting image
    @objc func image(_ image: UIImage,
                     didFinishSavingWithError error: NSError!,
                     contextInfo: UnsafeMutableRawPointer) {
        
        if error != nil {
            print(error.code)
            mylabel?.text = "Save Failed !"
        }
        else{
            mylabel?.text = "Save Succeeded"
        }
    }
    
    
    // show album
    @IBAction func showAlbum(_ sender : AnyObject) {
        let sourceType:UIImagePickerController.SourceType =
            UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerController.SourceType.photoLibrary){
            // initiate camera picker
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
            mylabel?.text = "Tap the [Start] to save a document"
        }
        else{
            mylabel?.text = "error"
            
        }
        
    }
    
    
    @IBAction func upload(sender: AnyObject) {
        if let image = self.cameraView.image {
            let imageData = image.jpegData(compressionQuality: 1.0)

            let urlString = "YOUR_URL_HERE"
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let mutableURLRequest = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
            
            mutableURLRequest.httpMethod = "POST"
            
            let boundaryConstant = "----------------12345";
            let contentType = "multipart/form-data;boundary=" + boundaryConstant
            mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
            
            // create upload data to send
            let uploadData = NSMutableData()
            
            // add image
            uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Disposition: form-data; name=\"picture\"; filename=\"file.png\"\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
            uploadData.append(imageData!)
            uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
            
            mutableURLRequest.httpBody = uploadData as Data
            
            
            let task = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    // Image uploaded
                }
            })
            
            task.resume()
            
        }
    }
}

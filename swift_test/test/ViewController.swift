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
//            let screenWidth = self.view.bounds.width
//            let screenHeight = self.view.bounds.height
//
//
//
//            // image width and height
//            let width = cameraView.bounds.size.width
//            let height = cameraView.bounds.size.height
//
//
//            // adjust image size to the screen size
//            let scale = screenWidth / width
//
////            let original_orientation = UIImage.Orientation.self
//
//            let rect:CGRect = CGRect(x:0, y:0, width:width*scale, height:height*scale)
//
//            // fit cameraView frame to CGRect
//            cameraView.frame = rect;
//
//
//            // centering the image
//            cameraView.center = CGPoint(x:screenWidth/2, y:screenHeight/3)
//
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
            mylabel?.text = "Scan Failed !"
        }
        else{
            mylabel?.text = "Scan Sent"
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
        
        // the image in UIImage type
        guard let image = cameraView.image else { return  }

        let filename = "file.png"

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let fieldName = "reqtype"
        let fieldValue = "fileupload"

        let fieldName2 = "userhash"
        let fieldValue2 = "caa3dce4fcb36cfdf9258ad9c"

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: URL(string: "http://172.20.10.8:5000/CC")!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()

        // Add the reqtype field and its value to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue)".data(using: .utf8)!)

        // Add the userhash field and its value to the raw http reqyest data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(fieldName2)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(fieldValue2)".data(using: .utf8)!)

        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"fileToUpload\"; file=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)

        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            
            if(error != nil){
                print("\(error!.localizedDescription)")
            }
            
            guard let responseData = responseData else {
                print("no response data")
                return
            }
            
            if let responseString = String(data: responseData, encoding: .utf8) {
                print("uploaded to: \(responseString)")
            }
        }).resume()

//    if let image = self.cameraView.image {
//        let imageData = image.jpegData(compressionQuality: 1.0)
//
//        let urlString = "http://172.20.10.8:5000/CC"
//        let session = URLSession(configuration: URLSessionConfiguration.default)
//
//        let mutableURLRequest = NSMutableURLRequest(url: NSURL(string: urlString)! as URL)
//
//        mutableURLRequest.httpMethod = "POST"
//
//        let boundaryConstant = UUID().uuidString;
//        let contentType = "multipart/form-data;boundary=" + boundaryConstant
//        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
//
//        // create upload data to send
//        let uploadData = NSMutableData()
//
//        // add image
//        uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
//        uploadData.append("Content-Disposition: form-data; name=\"picture\"; file=\"file.jpeg\"\r\n".data(using: String.Encoding.utf8)!)
//        uploadData.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
//        uploadData.append(imageData!)
//        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
//
//        mutableURLRequest.httpBody = uploadData as Data
//
//
//        let task = session.dataTask(with: mutableURLRequest as URLRequest, completionHandler: { (data, response, error) -> Void in
//            if error == nil {
//                // Image uploaded
//                print("SUCCESS")
//            }
//        })
//
//        task.resume()
//
//    }
    
    
    }
}

//
//  ViewController.swift
//  test
//  Created by Masayoshi Iwasa on 11/9/19.
//  Copyright © 2019 Masayoshi Iwasa. All rights reserved.
//

import UIKit

//class ViewController: UIViewController,
//    UIImagePickerControllerDelegate, UINavigationControllerDelegate{
//    // ctr drag from button, we can ad log in function as the action of the button
////    @IBOutlet weak var login: UIButton!
////    @IBOutlet weak var imagePicked: UIImageView!
//    @IBOutlet weak var imagePicked: UIImageView!
//
//    @IBAction func openCameraButton(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            let imagePicker = UIImagePickerController()
//                   imagePicker.delegate = self
//                   imagePicker.sourceType = .camera;
//                   imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//               }
//    }
//
//
//    @IBAction func openPhotoLibraryButton(_ sender: Any) {
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = .photoLibrary;
//            imagePicker.allowsEditing = true
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
//
//    internal func imagePickerController(_ picker: UIImagePickerController,
//       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
//           imagePicked.image = image
//
//        dismiss(animated:true, completion: nil)
//        guard (info[.originalImage] as? UIImage) != nil else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//    }
////     Save and getdocument using this article : https://www.hackingwithswift.com/example-code/media/how-to-save-a-uiimage-to-a-file-using-jpegdata-and-pngdata
//
////    func getDocumentsDirectory() -> URL {
////        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
////        return paths[0]
////    }
//
//    @IBAction func saveButt(sender: AnyObject) {
//
//        if let image = UIImage(image) {
//            if let data = image.pngData() {
//                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
//                try? data.write(to: filename)
//            }
//        }
//    }
//
//
//
//
//}
//


class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    @IBOutlet var cameraView : UIImageView!
    
    @IBOutlet weak var mylabel: UILabel?
        
    //    @IBOutlet weakvar mylabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mylabel?.text = "Tap the Scan Document to scan scan a ducment"
        
    }
    
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
            
            cameraView.contentMode = .scaleAspectFit
            cameraView.image = pickedImage
            
        }

        //closing
        imagePicker.dismiss(animated: true, completion: nil)
        mylabel?.text = "Tap the [Save] to save a picture"
        
    }
    
    // call this when cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        mylabel?.text = "Canceled"
    }
    
    
    // 写真を保存
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
            
            mylabel?.text = "Tap the [Start] to save a picture"
        }
        else{
            mylabel?.text = "error"
            
        }
        
    }

}

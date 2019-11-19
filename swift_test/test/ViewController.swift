//
//  ViewController.swift
//  test
//  Created by Masayoshi Iwasa on 11/9/19.
//  Copyright © 2019 Masayoshi Iwasa. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    // ctr drag from button, we can ad log in function as the action of the button
//    @IBOutlet weak var login: UIButton!
//    @IBOutlet weak var imagePicked: UIImageView!
//    @IBOutlet weak var imagePicked: UIImageView!

    @IBAction func openCameraButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
                   imagePicker.delegate = self
                   imagePicker.sourceType = .camera;
                   imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
               }
    }
    
    
    @IBAction func openPhotoLibraryButton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController,
       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard (info[.originalImage] as? UIImage) != nil else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    @IBAction func saveButt(sender: AnyObject) {
        if let image = UIImage(named: "example.png") {
            if let data = image.pngData() {
                let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
                try? data.write(to: filename)
            }
        }
    }
    
    


}


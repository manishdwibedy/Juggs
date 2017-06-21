//
//  ProfileImage.swift
//  Linq
//
//  Created by Quinton Askew on 6/2/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class ProfileImage: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
  
    @IBOutlet weak var saveButton: UIButton!
    
     var userStorage: StorageReference!
    
    @IBAction func saved(_ sender: Any) {
    
       
        
        
        
        
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.sd_setImage(with: URL(string: "\(String(describing: Globals .sharedInstance.getValueFromUserDefaultsForKey("UserImage")))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.layer.borderWidth = 4
        let blueGreenThemeColor = UIColor.white
        imageView.layer.borderColor = blueGreenThemeColor.cgColor

        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUp.tappedMe))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        saveButton.isEnabled = false
    }

    
    
    /////////   TAP PLACEHOLDER PHOTO TO SELECT AN IMAGE  /////////
    
    func tappedMe() {
        
        // ACTION SHEET FOR PHOTO SELECTION
        
        let alert = UIAlertController(title: "Choose an Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (ACTION) in
            
            let image = UIImagePickerController()
            image.sourceType = .camera
            image.delegate = self
            image.allowsEditing = true
            self.present(image, animated: true, completion: nil)
            print("Camera Pressed")
        })
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { (ACTION) in
            
            let image = UIImagePickerController()
            image.sourceType = .photoLibrary
            image.delegate = self
            image.allowsEditing = true
            self.present(image, animated: true, completion: nil)
            print("Photo Library Pressed")
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (ACTION) in
            print("Canecel Pressed")
        })
        
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion:nil)
        
    }
    
    // This function tells the image where to go after selected
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // Dismisses "Select Photo" View Controller
        
        self.dismiss(animated: true, completion: nil)
        
        // Sets the image as the 1 selected.
        
        imageView.image = image
        
        print("Image Selected")
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss the picker if the user canceled.
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        
        imageView.image = selectedImage
        
        saveButton.isEnabled = true
        // Dismiss the picker.
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

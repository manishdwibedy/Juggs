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
    
     //var userStorage: StorageReference!
    
    @IBAction func saved(_ sender: Any) {
    
        Globals.ShowSpinner(testStr: "")
        let uid = Auth.auth().currentUser!.uid
        
        let check:String? = uid + ".jpg"
        
        // Get a reference to the storage service using the default Firebase App
        let storage = Storage.storage()
        
        // Create a storage reference from our storage service
        var storageRef = storage.reference()
        
        let urlToStorage = "gs://jugg-88ab9.appspot.com/"
        storageRef.storage.reference(forURL: urlToStorage)
        storageRef = storageRef.child("Users")
        
        let imageRef = storageRef.child(check!)
        let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
        
        imageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
            imageRef.downloadURL(completion: { (url, er) in
                if er != nil {
                    print(er!.localizedDescription)
                }
                //Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(url!, key: "urlToImage")
                
                Globals.HideSpinner()
                let alertViewController = UIAlertController(title: "Profile Image Updated.", message: "", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
                
                alertViewController.addAction(okAction)
                let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                alertViewController.view.tintColor = purp
                self.present(alertViewController, animated: true, completion: nil)
            })
        })
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let ImageUrl = Globals .sharedInstance.getValueFromUserDefaultsForKey("urlToImage") as? String!
        imageView.sd_setImage(with: URL(string: ImageUrl!), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.layer.masksToBounds = false
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 4
        imageView.contentMode = UIViewContentMode.scaleAspectFill


        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUp.tappedMe))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        saveButton.isEnabled = false
        saveButton.layer.masksToBounds = true
        saveButton.layer.cornerRadius = 8
        saveButton.backgroundColor = UIColor.clear
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = purp
        
    }

    
    
    /////////   TAP PLACEHOLDER PHOTO TO SELECT AN IMAGE  /////////
    
    func tappedMe() {
        
        // ACTION SHEET FOR PHOTO SELECTION
        
        var alert = UIAlertController(title: "Choose an Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert = UIAlertController(title: "Choose an Image", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        }
        
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
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
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
        
        let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
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


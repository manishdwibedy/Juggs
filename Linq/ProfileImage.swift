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
    
       // Needs to update profile image in Firebase
    
    }

   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUp.tappedMe))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        saveButton.isHidden = true
    }


   /* func fetchCurrentUserInfo() {
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("Users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
              /*  let firstName = dict["First Name"] as? String!
                let lastName = dict["Last Name"] as? String!
                let fullName = firstName! + " " + lastName!
                self.title = fullName
                let age = dict["Age"] as? String!
                self.ageLabel.text = age
                let gender = dict["Gender"] as? String!
                self.genderLabel.text = gender
                let city = dict["City"] as? String!
                let state = dict["State"] as? String!
                let from = city! + ", " + state!
                self.fromLabel.text = from
                let bio = dict["Bio"] as? String!
                self.bioTV.text = bio
                 */
                
                if let profilePicURL = dict["urlToImage"] as? String {
                    
                    let url = URL(string: profilePicURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error!)
                            return
                            
                        }
                        
                        DispatchQueue.main.sync {
                            self.imageView.image = UIImage(data: data!)
                            
                        }
                        
                    }).resume()
                }
                
            }
            
            
        })
        ref.removeAllObservers()
        
    } */
    
    
    
    
    
    
    
    
    

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
        
        // Dismiss the picker.
        
        dismiss(animated: true, completion: nil)
        
        saveButton.isHidden = false
        
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

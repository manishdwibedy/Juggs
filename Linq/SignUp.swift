//
//  SignUp.swift
//  Linq
//
//  Created by Quinton Askew on 5/23/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class SignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
  
    @IBOutlet weak var usernameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!


    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
   
    
    @IBAction func signedUp(_ sender: Any) {
        self.view.endEditing(true)
        newValidation()
    }
    
    @IBAction func logIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    
    
    }
    
    func doneAction() {
        self.view.endEditing(true)
    }
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let storageRef = Storage.storage().reference()
        let urlToStorage = "gs://jugg-88ab9.appspot.com/"
        storageRef.storage.reference(forURL: urlToStorage)
        userStorage = storageRef.child("Users")
        ref = Database.database().reference()
        visuals()
        delegate()
        
    }
    
    
    
    func visuals() {
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        signInBtn.isEnabled = false
        ////// TAP GESTURE FOR 'imageView'  /////
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUp.tappedMe))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = imageView.frame.size.width/2
        imageView.clipsToBounds = true
//        imageView.layer.borderWidth = 6
//        imageView.layer.borderColor = purp.cgColor
        
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
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        imageView.image = selectedImage
        
        // Dismiss the picker.
        
        dismiss(animated: true, completion: nil)
        

        signInBtn.isEnabled = true
        
    }
    
 
//    func validation() {
//
//        guard let remail = emailTF.text?.trim(),let rpassword = pwTF.text?.trim(),let rfirstName = firstNameTF.text?.trim(), let rlastName = lastNameTF.text?.trim(), let rage = ageTF.text?.trim(), let rbio = bioTV.text?.trim(), let rcity = cityTF.text?.trim(), let rstate = stateTF.text else {
//            print(" Form isnt valid")
//
//            return
//        }
//
//        if rpassword == confirmPWTF.text {
//            Globals.ShowSpinner(testStr: "")
//            Auth.auth().createUser(withEmail: remail, password: rpassword, completion: {(user,error)in
//
//                if let error = error {
//                    print(error.localizedDescription)
//                    let alertViewController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
//
//                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
//                    }
//
//                    alertViewController.addAction(okAction)
//                    let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
//                    alertViewController.view.tintColor = purp
//                    self.present(alertViewController, animated: true, completion: nil)
//
//                    Globals.HideSpinner()
//                }
//
//                if let user = user {
//                    let rgender = self.genderTF.text
//                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
//                    changeRequest.commitChanges(completion: nil)
//                    let imageRef = self.userStorage.child("\(user.uid).jpg")
//                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
//                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
//                        imageRef.downloadURL(completion: { (url, er) in
//                            if er != nil {
//                                print(er!.localizedDescription)
//
//                            }
//
//                            if let url = url {
//
//                                let userInfo: [String : Any] = ["UID" : user.uid,
//                                                                "FirstName" : rfirstName,
//                                                                "LastName" : rlastName,
//                                                                "Age" : rage,
//                                                                "Bio" : rbio,
//                                                                "City" : rcity,
//                                                                "Gender" : rgender ?? "Rather Not",
//                                                                "State" : rstate,
//                                                                "urlToImage" : url.absoluteString,
//
//                                                                ]
//
//                                self.ref.child("Users").child(user.uid).setValue(userInfo)
//
//                                let juggTeamRef = self.ref.child("Users").child(user.uid).child("Following")
//                                let followUs = ["Q" : "BZqQBnmgWkbMxFZ2yqlFcG3bKB82", "JuggTeam" : "Qr37LzryqIZIxPoymnwgVoSpCqq1"]
//                                juggTeamRef.setValue(followUs)
//
//
//
//                                if let token = Messaging.messaging().fcmToken {
//                                    let refchild = self.ref.child("Users").child(user.uid).child("fcmToken")
//                                    refchild.setValue(token)
//                                }
//
//                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
//                                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(true, key: "IS_LOGIN")
//                                Globals.HideSpinner()
//                                self.present(vc, animated: true, completion: nil)
//                            }
//
//                        })
//
//                    })
//                    uploadTask.resume()
//                }
//            })
//
//        }else{
//        }
//
//    }
    
    
    
    
    func delegate() {
        usernameTF.delegate = self
        emailTF.delegate = self
        pwTF.delegate = self
    }
    
    
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTF.resignFirstResponder
        emailTF.resignFirstResponder()
        pwTF.resignFirstResponder()
       
        return true
        
    }
    
    
    func dismissKeyboard(){
        usernameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        pwTF.resignFirstResponder()
       
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if (text == "\n") {
//            bioTV.resignFirstResponder()
//        }
//        return true
//    }
//
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let startingLength = textFieldToChange.text?.characters.count ?? 0
        
        if textFieldToChange == usernameTF {
            
            let characterCountLimit = 25;
            
            let lengthToAdd = string.characters.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
        }
        
        return true
    }
    
    func newValidation() {
        
        guard let username = usernameTF.text?.trim(), let remail = emailTF.text?.trim(), let rpassword = pwTF.text?.trim() else {
            print(" Form isnt valid")
            
            return
        }
        
        
        
        Auth.auth().createUser(withEmail: remail, password: rpassword, completion: {(user,error)in
            
            if let error = error {
                print(error.localizedDescription)
                let alertViewController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                }
                
                alertViewController.addAction(okAction)
                let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                alertViewController.view.tintColor = purp
                self.present(alertViewController, animated: true, completion: nil)
            }
            
            
            
            if let user = user {
                let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                changeRequest.commitChanges(completion: nil)
                let imageRef = self.userStorage.child("\(user.uid).jpg")
                let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, error) in
                    imageRef.downloadURL(completion: { (url, er) in
                        if er != nil {
                            print(er!.localizedDescription)
                            
                        }
                        
                        if let url = url {
                            
                            let userInfo: [String : Any] = ["UID" : user.uid,
                                                            "Username" : username,
                                                            "urlToImage" : url.absoluteString,
                                                            
                                                            ]
                            
                            self.ref.child("AllUsers").child(user.uid).setValue(userInfo)
                            self.ref.child("Usernames").childByAutoId().setValue(username)
                            
                            let juggTeamRef = self.ref.child("AllUsers").child(user.uid).child("Following")
                            let followUs = ["Q" : "BZqQBnmgWkbMxFZ2yqlFcG3bKB82", "JuggTeam" : "Qr37LzryqIZIxPoymnwgVoSpCqq1"]
                            juggTeamRef.setValue(followUs)
                            
                            
                            if let token = Messaging.messaging().fcmToken {
                                let refchild = self.ref.child("AllUsers").child(user.uid).child("fcmToken")
                                refchild.setValue(token)
                            }
                            
                            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
                            Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(true, key: "IS_LOGIN")
                            Globals.HideSpinner()
                            self.present(vc, animated: true, completion: nil)
                        }
                        
                    })
                    
                })
                uploadTask.resume()
                
            }
        })
        
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

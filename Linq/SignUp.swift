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

class SignUp: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    @IBOutlet weak var confirmPWTF: UITextField!
    @IBOutlet weak var bioTV: UITextView!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    
    @IBAction func signedUp(_ sender: Any) {
        self.view.endEditing(true)
        
        validation()
        
    }
    
    @IBAction func logIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    var userStorage: StorageReference!
    var ref: DatabaseReference!
    
    
    var stateList = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN","IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND",  "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    var genderList = ["Female", "Male"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signInBtn.isEnabled = false
        ////// TAP GESTURE FOR 'imageView'  /////
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUp.tappedMe))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        
        let storageRef = Storage.storage().reference()
        let urlToStorage = "gs://jugg-88ab9.appspot.com/"
        storageRef.storage.reference(forURL: urlToStorage)
        userStorage = storageRef.child("Users")
        ref = Database.database().reference()
        
        delegate()
        pickerViews()
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
        
        // Dismiss the picker.
        
        dismiss(animated: true, completion: nil)
        
        signInBtn.isEnabled = true
        
    }
    
    
    func validation() {
        
        guard let remail = emailTF.text,let rpassword = pwTF.text,var rfirstName = firstNameTF.text, let rlastName = lastNameTF.text, let rage = ageTF.text, let rbio = bioTV.text, let rcity = cityTF.text, let rstate = stateTF.text, let rgender = genderTF.text else {
            print(" Form isnt valid")
            
            return
        }
        
        if rpassword == confirmPWTF.text {
            Globals.ShowSpinner(testStr: "")
            Auth.auth().createUser(withEmail: remail, password: rpassword, completion: {(user,error)in
                
                if let error = error {
                    print(error.localizedDescription)
                    let alertViewController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                    }
                    
                    alertViewController.addAction(okAction)
                    
                    self.present(alertViewController, animated: true, completion: nil)
                    
                    Globals.HideSpinner()
                }
                
                if let user = user {
                    
                    let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                    rfirstName = rfirstName + " "
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
                                                                "First Name" : rfirstName,
                                                                "Last Name" : rlastName,
                                                                "Age" : rage,
                                                                "Bio" : rbio,
                                                                "Website" : "",
                                                                "City" : rcity,
                                                                "Gender" : rgender,
                                                                "State" : rstate,
                                                                "urlToImage" : url.absoluteString,
                                                                
                                                                ]
                                
                                self.ref.child("Users").child(user.uid).setValue(userInfo)
                                
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
            
        }else{
        }
        
    }
    
    
    
    func delegate() {
        
        ageTF.delegate = self
        firstNameTF.delegate = self
        lastNameTF.delegate = self
        emailTF.delegate = self
        pwTF.delegate = self
        confirmPWTF.delegate = self
        bioTV.delegate = self
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        ageTF.resignFirstResponder()
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        pwTF.resignFirstResponder()
        confirmPWTF.resignFirstResponder()
        
        return true
        
    }
    
    
    func dismissKeyboard(){
        
        ageTF.resignFirstResponder()
        firstNameTF.resignFirstResponder()
        lastNameTF.resignFirstResponder()
        emailTF.resignFirstResponder()
        pwTF.resignFirstResponder()
        confirmPWTF.resignFirstResponder()
        bioTV.resignFirstResponder()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            bioTV.resignFirstResponder()
        }
        return true
    }
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        let startingLength = textFieldToChange.text?.characters.count ?? 0
        
        if textFieldToChange == ageTF {
            
            let characterCountLimit = 2;
            
            let lengthToAdd = string.characters.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
            
            
        }else if textFieldToChange == cityTF {
            
            let characterCountLimit = 21;
            
            let lengthToAdd = string.characters.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
            
            
        }else if textFieldToChange == firstNameTF {
            
            let characterCountLimit = 20;
            
            let lengthToAdd = string.characters.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
            
        }else if textFieldToChange == lastNameTF {
            
            let characterCountLimit = 20;
            
            let lengthToAdd = string.characters.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
            
        }
        
        return true
    }
    
    
    func pickerViews() {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        //pickerView.backgroundColor = UIColor.white
        pickerView.tag = 0
        pickerView.showsSelectionIndicator = true
        pickerView.backgroundColor = UIColor.clear
        
        stateTF.inputView = pickerView
        
        
        let pickerView2 = UIPickerView()
        
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView.backgroundColor = UIColor.clear
        pickerView2.tag = 1
        pickerView2.showsSelectionIndicator = true
        genderTF.inputView = pickerView2
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if(pickerView.tag == 0) {
            return stateList.count
        }else if(pickerView.tag == 1) {
            return genderList.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0) {
            return stateList[row]
        }else if(pickerView.tag == 1) {
            return genderList[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            stateTF.text = stateList[row]
        }else if(pickerView.tag == 1) {
            genderTF.text = genderList[row]
        }
        self.view.endEditing(true)
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

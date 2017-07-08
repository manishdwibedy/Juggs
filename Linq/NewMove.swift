
//
//  NewMove.swift
//  Linq
//
//  Created by Quinton Askew on 5/23/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class NewMove: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var flyer: UIImageView!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var amfmTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var streetAddyTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var usTF: UITextField!
    @IBOutlet weak var zipTF: UITextField!
    @IBOutlet weak var capacityTF: UITextField!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var invitationSwitch: UISwitch!
    @IBOutlet weak var invitationLabel: UILabel!
    @IBOutlet weak var nameOfMoveTF: UITextField!
    @IBAction func dateTFormat(_ sender: Any) {
     
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        dateTF.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(NewMove.datePickerValueChanged), for: UIControlEvents.valueChanged)
    
    
    }
    
   
    @IBOutlet weak var submitBtn: UIButton!
    
    
    @IBAction func switchChanged(_ sender: Any) {
        if (invitationSwitch.isOn == true){
            invitationLabel.text = "Private"
           
        }else{
            
            invitationLabel.text = "Public"
            capacityTF.text = "0"
            
        }

    }
   
    @IBAction func moveSubmitted(_ sender: Any) {
        Globals.ShowSpinner(testStr: "")
        
        if timeTF.text == "" || amfmTF.text == "" || dateTF.text == "" || timeTF.text == "" || streetAddyTF.text == "" || cityTF.text == "" || stateTF.text == "" || zipTF.text == "" || capacityTF.text == "" || descriptionTV.text == "" {
            
            emptyFieldsAlert()
            
        }else{
        
        
        
        
        
        guard let time = timeTF.text,let ampm = amfmTF.text, let date = dateTF.text, let street = streetAddyTF.text, let city = cityTF.text, let state = stateTF.text, let zip = zipTF.text, let capacity = capacityTF.text, let descriptionForMove = descriptionTV.text, let nameOfMove = nameOfMoveTF.text else{
            print(" Form isnt valid")
            
            return
        }
        
            if capacity == "0" {
                invitationSwitch.isOn = false
            }
        let address = street + ", " + city + ", "  + state + ", " + zip
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let storage = Storage.storage().reference(forURL: "gs://jugg-88ab9.appspot.com")
        
        let key = ref.child("Flyers").childByAutoId().key
        
        let flyerRef = storage.child("Flyers").child(uid!).child("\(key).jpg")
       // let userImage = ref.child("Users").child(uid!).child("urlToImage")
        
        let data = UIImageJPEGRepresentation(flyer.image!, 0.6)
        
        let uploadTask = flyerRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
             //   AppDelegate.instance().dismissActivityIndicatos()
                return
            }
       
        flyerRef.downloadURL(completion: { (url, error) in
            if let uid = Auth.auth().currentUser?.uid {
                
                Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let user = snapshot.value as? [String : AnyObject]
            if let url = url {
                let feed = ["UserID" : uid,
                            "NameOfMove" : nameOfMove,
                            "PathToImage" : url.absoluteString, // Flyer for Jugg.
                            "Time" : time,
                            "AP" : ampm,
                            "Date" : date,
                            "City" : city,
                            "State" : state,
                            "Address" : address,
                            "Capacity" : Int(capacity)!,
                            "Likes" : 0,
                            "FlameCount" : 0,
                            "Private" : self.forSwitch(),
                            "Description" : descriptionForMove,
                            "Author" : Auth.auth().currentUser!.displayName!,
                            "userImageUrl" : user?["urlToImage"] ?? "",
                            "PostID" : key] as [String : Any]
                
                let postFeed = ["\(key)" : feed]
                ref.child("Flyers").updateChildValues(postFeed)
              
                
                self.dismiss(animated: true, completion: nil)
                Globals.HideSpinner()
            }
            
        })
        
        
        
            }else {
                
            }
            
        })
    
            }
        
        
        uploadTask.resume()
        
        
    }
    
}
    
    
    func forSwitch() -> Bool {
        if (invitationSwitch.isOn == true){
            invitationLabel.text = "Private"
            return true
        
        }else{
            
            invitationLabel.text = "Public"
            return false
        }
    }
    
    
    var stateList = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN","IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND",  "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
    
    var timeList = ["1:00", "2:00", "3:00", "4:00", "5:00", "6:00", "7:00", "8:00", "9:00", "10:00", "11:00", "12:00"]
    
    var amPMList = ["AM","PM"]
    
    var capacity = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "30", "40", "50", "60", "70", "80", "90", "100", "125", "150", "175", "200", "250", "300", "400", "500", "600", "700", "800", "900", "1000", "2000", "3000"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // TAP GESTURE FOR FLYER
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewMove.tappedMe))
        flyer.addGestureRecognizer(tap)
        flyer.isUserInteractionEnabled = true
        pickerViews()
        delegate()
        
        // Designs
        descriptionTV.layer.masksToBounds = true
        descriptionTV.layer.cornerRadius = 8
        flyer.layer.cornerRadius = 8
        flyer.layer.masksToBounds = true
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 8
        invitationSwitch.isOn = true
        
        
        
    
    }

  
    func tappedMe() {
        
        // ACTION SHEET FOR PHOTO SELECTION
        
        let alert = UIAlertController(title: "Select a Flyer", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
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
        
        flyer.image = image
        
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
        
        flyer.image = selectedImage
        
        // Dismiss the picker.
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func delegate() {
        
        timeTF.delegate = self
        amfmTF.delegate = self
        dateTF.delegate = self
        streetAddyTF.delegate = self
        cityTF.delegate = self
        stateTF.delegate = self
        zipTF.delegate = self
        capacityTF.delegate = self
        descriptionTV.delegate = self
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        timeTF.resignFirstResponder()
        amfmTF.resignFirstResponder()
        dateTF.resignFirstResponder()
        streetAddyTF.resignFirstResponder()
        cityTF.resignFirstResponder()
        stateTF.resignFirstResponder()
        zipTF.resignFirstResponder()
        capacityTF.resignFirstResponder()
       
        return true
        
    }
    
    
    func dismissKeyboard(){
        
        timeTF.resignFirstResponder()
        amfmTF.resignFirstResponder()
        dateTF.resignFirstResponder()
        streetAddyTF.resignFirstResponder()
        cityTF.resignFirstResponder()
        stateTF.resignFirstResponder()
        zipTF.resignFirstResponder()
        capacityTF.resignFirstResponder()
    
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            descriptionTV.resignFirstResponder()
        }
        return true
    }

    
    func pickerViews() {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        pickerView.tag = 0
        pickerView.showsSelectionIndicator = true
        stateTF.inputView = pickerView
        
        let pickerView2 = UIPickerView()
        
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView2.backgroundColor = UIColor.white
        pickerView2.tag = 1
        pickerView2.showsSelectionIndicator = true
        timeTF.inputView = pickerView2
        
        let pickerView3 = UIPickerView()
        
        pickerView3.delegate = self
        pickerView3.dataSource = self
        pickerView3.backgroundColor = UIColor.white
        pickerView3.tag = 2
        pickerView3.showsSelectionIndicator = true
        amfmTF.inputView = pickerView3
        
        let pickerView4 = UIPickerView()
        
        pickerView4.delegate = self
        pickerView4.dataSource = self
        pickerView4.backgroundColor = UIColor.white
        pickerView4.tag = 3
        pickerView4.showsSelectionIndicator = true
        capacityTF.inputView = pickerView4
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       
        if(pickerView.tag == 0) {
         return stateList.count
        }else if(pickerView.tag == 1) {
         return timeList.count
        }else if(pickerView.tag == 2) {
            return amPMList.count
        }else if(pickerView.tag == 3) {
            return capacity.count
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.tag == 0) {
            return stateList[row]
        }else if(pickerView.tag == 1) {
            return timeList[row]
        }else if(pickerView.tag == 2) {
            return amPMList[row]
        }else if(pickerView.tag == 3) {
            return capacity[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0) {
            stateTF.text = stateList[row]
        }else if(pickerView.tag == 1) {
        timeTF.text = timeList[row]
        }else if(pickerView.tag == 2) {
            amfmTF.text = amPMList[row]
        } else if(pickerView.tag == 3) {
            capacityTF.text = capacity[row]
        }
    
        self.view.endEditing(true)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        
        dateFormatter.dateFormat = "MMMM dd yyyy"
        
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        dateTF.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    func emptyFieldsAlert() {
        
        
        let alert = UIAlertController(title: nil, message: "All fields require action.", preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        
        alert.addAction(OK)
        self.present(alert, animated: true, completion:nil)
        
    }
    
    
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        let startingLength = textFieldToChange.text?.characters.count ?? 0
        
    if textFieldToChange == streetAddyTF {
            
            let characterCountLimit = 40;
            
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
            
            
            
        }else if textFieldToChange == zipTF {
            
            let characterCountLimit = 5;
            
            let lengthToAdd = string.characters.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
            
        }else if textFieldToChange == nameOfMoveTF {
            
            let characterCountLimit = 24;
            
            let lengthToAdd = string.characters.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
            
        }
        
        return true
    }
  
    
    
    
    
    
    
    @IBAction func canceled(_ sender: Any) {
        performSegue(withIdentifier: "unwindToHome", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    

}

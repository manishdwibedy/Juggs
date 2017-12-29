
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
import KVNProgress
import CoreLocation

var addressFromAutoComplete = String()

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
    
    var uploadedImage = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // TAP GESTURE FOR FLYER
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewMove.selectFlyer))
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
        
//        amfmTF.setCustomDoneTarget(self, action: #selector(doneAction))
//        timeTF.setCustomDoneTarget(self, action: #selector(doneAction))
//        capacityTF.setCustomDoneTarget(self, action: #selector(doneAction))

    }
    
    func doneAction() {
        self.view.endEditing(true)
    }
    
    @IBAction func actionAutoComplete(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController =
            storyboard.instantiateViewController(withIdentifier: "SearchViewController") as!
        SearchViewController
        
        self.present(viewController, animated: true) {
            
        }
        
    }
    
    func dateTFormat() {
        
        let datePickerView: UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.minimumDate = Date()
        
        let daysToAdd = 90
        
        let newDate = Calendar.current.date(byAdding: .day, value: daysToAdd, to: Date())
        
        datePickerView.maximumDate = newDate
        
        
        dateTF.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(NewMove.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    @IBOutlet weak var submitBtn: UIButton!
    
    
    @IBAction func switchChanged(_ sender: Any) {
        if (invitationSwitch.isOn == true){
            invitationLabel.text = (NSLocalizedString("private", comment: ""))
            
        }else{
            
            invitationLabel.text = (NSLocalizedString("public", comment: ""))
            capacityTF.text = "0"
            
        }
        
    }
    
    @IBAction func moveSubmitted(_ sender: Any) {
        
        if !uploadedImage {
            
            let alert = UIAlertController(title: nil, message: (NSLocalizedString("flyr", comment: "")), preferredStyle: .alert)
            
            let OK = UIAlertAction(title: (NSLocalizedString("ok", comment: "")), style: .default) { (action) in
                
            }
            
            alert.addAction(OK)
            self.present(alert, animated: true, completion:nil)
            
            return
        }
        
        if timeTF.text == "" || amfmTF.text == "" || dateTF.text == "" || timeTF.text == "" || streetAddyTF.text == "" || capacityTF.text == "" || descriptionTV.text == "" {
            
            emptyFieldsAlert()
            
        } else {
            
            
            guard let time = timeTF.text,let ampm = amfmTF.text, let date = dateTF.text, let street = streetAddyTF.text,let capacity = capacityTF.text, let descriptionForMove = descriptionTV.text?.trim(), let nameOfMove = nameOfMoveTF.text?.trim() else{
                print(" Form isnt valid")
                
                return
            }
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
            let dateTime = "\(date) \(time) \(ampm)"
            let postdate =  dateFormatter.date(from: dateTime)
            
            if postdate != nil {
                let elapsed = Date().timeIntervalSince(postdate!)
                let diff = self.stringFromTimeInterval(interval: elapsed)
                print(diff)
                if diff.intValue >= 1
                {
                    let alert = UIAlertController(title: nil, message:(NSLocalizedString("future", comment: "")) , preferredStyle: .alert)
                    
                    let OK = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) in
                        
                    }
                    
                    alert.addAction(OK)
                    self.present(alert, animated: true, completion:nil)
                    
                    return;
                }
            }
            
            if capacity == "0" {
                
                invitationSwitch.isOn = false
            }
            
            //     Globals.ShowSpinner(testStr: "")
            KVNProgress .show(0.50, status: "Uploading..")
            //        let address = street + ", " + city + ", "  + state + ", " + zip
            
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            let storage = Storage.storage().reference(forURL: "gs://jugg-88ab9.appspot.com")
            
            let key = ref.child("Flyers").childByAutoId().key
            
            let flyerRef = storage.child("Flyers").child(uid!).child("\(key).jpg")
            
            let data = UIImageJPEGRepresentation(flyer.image!, 0.6)
            
            let uploadTask = flyerRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil {
                    KVNProgress.showError()
                    print(error!.localizedDescription)
                    //   AppDelegate.instance().dismissActivityIndicatos()
                    return
                } else {
                }
                
                flyerRef.downloadURL(completion: { (url, error) in
                    if let uid = Auth.auth().currentUser?.uid {
                        
                        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let user = snapshot.value as? [String : AnyObject]
                            if let url = url {
                                
                                let geocoder = CLGeocoder()
                                geocoder.geocodeAddressString(street, completionHandler: { (placemarks, error ) in
                                    
                                    let placemark = placemarks?.first
                                    let lat = placemark?.location!.coordinate.latitude
                                    let lon = placemark?.location!.coordinate.longitude
                                    
                                    let feed = ["UserID" : uid,
                                                "NameOfMove" : nameOfMove,
                                                "PathToImage" : url.absoluteString, // Flyer for Jugg.
                                        "Time" : time,
                                        "AP" : ampm,
                                        "Date" : date,
                                        //                            "City" : city,
                                        //                            "State" : state,
                                        "Address" : street,
                                        "Capacity" : Int(capacity)!,
                                        "CapacityCount" : 0,
                                        "Likes" : 0,
                                        "FlameCount" : 0,
                                        "Private" : self.forSwitch(),
                                        "latitude" : lat ?? 0.00,
                                        "longitude" : lon ?? 0.00,
                                        "Description" : descriptionForMove,
                                        "Author" : "\(user?["FirstName"] ?? "" as AnyObject) \(user?["LastName"] ?? "" as AnyObject)",
                                        "userImageUrl" : user?["urlToImage"] ?? "",
                                        "PostID" : key] as [String : Any]
                                    
                                    let postFeed = ["\(key)" : feed]
                                    ref.child("Flyers").updateChildValues(postFeed)
                                    
                                    KVNProgress.showSuccess()
                                    self.dismiss(animated: true, completion: nil)
                                    
                                })
                                // "Author" : Auth.auth().currentUser!.displayName!
                                
                                //Globals.HideSpinner()
                            } else{
                                KVNProgress.showError()
                            }
                            
                        })
                        
                        
                        
                    }else {
                        KVNProgress.showError()
                    }
                    
                })
                
            }
            
            
            uploadTask.resume()
            
            
        }
        
    }
    
    //   MARK: - Time Differences
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        return NSString(format: "%0.2d",ti)
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
    
    var timeList = ["1:00", "1:15", "1:30", "1:45", "2:00", "2:15", "2:30", "2:45", "3:00", "3:15", "3:30", "3:45", "4:00", "4:15", "4:30", "4:45", "5:00", "5:15", "5:30", "5:45", "6:00", "6:15", "6:30", "6:45","7:00", "7:15", "7:30", "7:45", "8:00", "8:15", "8:30", "8:45", "9:00", "9:15", "9:30", "9:45", "10:00", "10:15", "10:30", "10:45","11:00", "11:15", "11:30", "11:45", "12:00", "12:15", "12:30", "12:45"]
    
    var amPMList = ["AM","PM"]
    
    var capacity = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "30", "40", "50", "60", "70", "80", "90", "100", "125", "150", "175", "200", "250", "300", "400", "500", "600", "700", "800", "900", "1000", "2000", "3000"]
    
    
    override func viewWillAppear(_ animated: Bool) {
        streetAddyTF.text = addressFromAutoComplete
    }
    
    
    
    func selectFlyer() {
        
        // ACTION SHEET FOR PHOTO SELECTION
        
        var alert = UIAlertController(title:(NSLocalizedString("slf", comment: "")), message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
           alert = UIAlertController(title:(NSLocalizedString("slf", comment: "")), message: nil, preferredStyle: UIAlertControllerStyle.alert)
        }
        
        let camera = UIAlertAction(title:(NSLocalizedString("cm", comment: "")), style: .default, handler: { (ACTION) in
            
            let image = UIImagePickerController()
            image.sourceType = .camera
            image.delegate = self
            image.allowsEditing = true
            self.present(image, animated: true, completion: nil)
            print("Camera Pressed")
        })
        
        let photoLibrary = UIAlertAction(title:(NSLocalizedString("pl", comment: "")), style: .default, handler: { (ACTION) in
            
            let image = UIImagePickerController()
            image.sourceType = .photoLibrary
            image.delegate = self
            image.allowsEditing = true
            self.present(image, animated: true, completion: nil)
            print("Photo Library Pressed")
            
        })
        
        let cancel = UIAlertAction(title:(NSLocalizedString("cancel", comment: "")), style: .cancel, handler: { (ACTION) in
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
        
        flyer.image = image
        
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
        
        flyer.image = selectedImage
        uploadedImage = true
        // Dismiss the picker.
        
        dismiss(animated: true, completion: nil)
        
        
        
    }
    
    func delegate() {
        
        timeTF.delegate = self
        amfmTF.delegate = self
        dateTF.delegate = self
        streetAddyTF.delegate = self
        //        cityTF.delegate = self
        //        stateTF.delegate = self
        //        zipTF.delegate = self
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
//        if (text == "\n") {
//            descriptionTV.resignFirstResponder()
//        }
        return true
    }
    
    func pickerViews() {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = UIColor.white
        pickerView.tag = 0
        pickerView.showsSelectionIndicator = true
        //        stateTF.inputView = pickerView
        
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
        
        dateTFormat()
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
        
        //        self.view.endEditing(true)
    }
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        //        dateFormatter.timeStyle = DateFormatter.Style.none
        dateTF.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    func emptyFieldsAlert() {
        
        
        let alert = UIAlertController(title: nil, message:(NSLocalizedString("req", comment: "")), preferredStyle: .alert)
        
        let OK = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) in
            
        }
        
        alert.addAction(OK)
        self.present(alert, animated: true, completion:nil)
        
    }
    
    
    
    func textField(_ textFieldToChange: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        let startingLength = textFieldToChange.text?.count ?? 0
        
        if textFieldToChange == streetAddyTF {
            
            let characterCountLimit = 40;
            
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
            
            
        }else if textFieldToChange == cityTF {
            
            let characterCountLimit = 21;
            
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
            
            
        }else if textFieldToChange == zipTF {
            
            let characterCountLimit = 5;
            
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
            
        }else if textFieldToChange == nameOfMoveTF {
            
            let characterCountLimit = 24;
            
            let lengthToAdd = string.count
            let lengthToReplace = range.length
            
            let newLength = startingLength + lengthToAdd - lengthToReplace
            
            return newLength <= characterCountLimit
            
            
        }
        
        return true
    }
    
    
    
    
    
    @IBOutlet weak var cancel: UIButton!
    
    
    @IBAction func canceled(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
}
extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}

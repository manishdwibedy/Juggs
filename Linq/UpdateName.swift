//
//  UpdateAccount.swift
//  Linq
//
//  Created by Quinton Askew on 6/2/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class UpdateName: UIViewController, UITextFieldDelegate {

    
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var saveNameBtn: UIButton!
    @IBAction func saveName(_ sender: Any) {
    
        let uid = Auth.auth().currentUser?.uid
        
        let Ref = "Users/" + uid!
        Database.database().reference().root.child(Ref).updateChildValues(["First Name": self.firstNameTF.text!,"Last Name": self.lastNameTF.text!])
        
        let alertViewController = UIAlertController(title: "Named Changed Successfully!", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: nil)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTF.delegate = self
        visuals()
        
    }
    
    func visuals() {
        self.title = "Name"
        self.instructionsLabel.text = "Update your first and last name."
        
       
        // Loading Names.....
        firstNameTF.text = Globals .sharedInstance.getValueFromUserDefaultsForKey("FName") as? String
        lastNameTF.text = Globals .sharedInstance.getValueFromUserDefaultsForKey("LName") as? String
        
        // Beautiful TextFields and Button
        firstNameTF.layer.masksToBounds = true
        firstNameTF.layer.borderWidth = 1
        firstNameTF.layer.cornerRadius = 6
        firstNameTF.layer.borderColor = UIColor.black.cgColor
        lastNameTF.layer.masksToBounds = true
        lastNameTF.layer.borderWidth = 1
        lastNameTF.layer.cornerRadius = 6
        lastNameTF.layer.borderColor = UIColor.black.cgColor
        saveNameBtn.layer.masksToBounds = true
        saveNameBtn.layer.cornerRadius = 8
        
        // Disable Save Button
        self.saveNameBtn.isEnabled = false

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveNameBtn.isEnabled = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

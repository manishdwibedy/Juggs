//
//  UpdatePassword.swift
//  Linq
//
//  Created by Quinton Askew on 6/18/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase


class UpdatePassword: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!  // Current Password
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var submitBtn: UIButton!        // Save Btn
    @IBAction func passwordUpdated(_ sender: Any) {
   
        if passwordTF.text == nil || newPasswordTF.text == nil || confirmPassword.text == nil {
            return
        }
        let oldPass = Globals .sharedInstance.getValueFromUserDefaultsForKey("Password") as? String
        
        if oldPass == passwordTF.text{
            if newPasswordTF.text == confirmPassword.text {
                Globals.ShowSpinner(testStr: "")
                
                Auth.auth().currentUser?.updatePassword(to: self.passwordTF.text!) { (error) in
                    
                    Globals.HideSpinner()
                    // ...
                    let alertViewController = UIAlertController(title: "Password Updated Successfully!", message: "", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alertViewController.addAction(okAction)
                    
                    self.present(alertViewController, animated: true, completion: nil)
                }
            }else{
                let alertViewController = UIAlertController(title: "Your Password is miss matched.", message: "", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                }
                
                alertViewController.addAction(okAction)
                
                self.present(alertViewController, animated: true, completion: nil)
                
            }
        }else{
            let alertViewController = UIAlertController(title: "Current Password is not matching", message: "", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            }
            
            alertViewController.addAction(okAction)
            
            self.present(alertViewController, animated: true, completion: nil)
            
        }
    
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visuals()
    }
    
   
    
    
    
    func visuals() {
        self.title = "Password"
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 8
        submitBtn.isEnabled = false
        
        passwordTF.layer.masksToBounds = true
        passwordTF.layer.cornerRadius = 6
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.borderColor = UIColor.black.cgColor
        
        newPasswordTF.layer.masksToBounds = true
        newPasswordTF.layer.cornerRadius = 6
        newPasswordTF.layer.borderWidth = 1
        newPasswordTF.layer.borderColor = UIColor.black.cgColor
        
        confirmPassword.layer.masksToBounds = true
        confirmPassword.layer.cornerRadius = 6
        confirmPassword.layer.borderWidth = 1
        confirmPassword.layer.borderColor = UIColor.black.cgColor
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

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
                    let alertViewController = UIAlertController(title: (NSLocalizedString("pus", comment: "")), message: "", preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) -> Void in
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    alertViewController.addAction(okAction)
                    let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                    alertViewController.view.tintColor = purp
                    self.present(alertViewController, animated: true, completion: nil)
                }
            }else{
                let alertViewController = UIAlertController(title: (NSLocalizedString("pds", comment: "")), message: "", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) -> Void in
                }
                
                alertViewController.addAction(okAction)
                let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                alertViewController.view.tintColor = purp
                self.present(alertViewController, animated: true, completion: nil)
                
            }
        }else{
            let alertViewController = UIAlertController(title: (NSLocalizedString("cpdm", comment: "")), message: "", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) -> Void in
            }
            
            alertViewController.addAction(okAction)
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            alertViewController.view.tintColor = purp
            self.present(alertViewController, animated: true, completion: nil)
            
        }
    
        
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visuals()
    }
    
   
    
    
    
    func visuals() {
        self.title = (NSLocalizedString("updatepword", comment: ""))
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 8
        submitBtn.isEnabled = false
        submitBtn.layer.borderWidth = 2
        submitBtn.layer.borderColor = purp
        
        passwordTF.layer.masksToBounds = true
        passwordTF.layer.cornerRadius = 6
        passwordTF.layer.borderWidth = 1
        passwordTF.layer.borderColor = purp
        
        newPasswordTF.layer.masksToBounds = true
        newPasswordTF.layer.cornerRadius = 6
        newPasswordTF.layer.borderWidth = 1
        newPasswordTF.layer.borderColor = purp
        
        confirmPassword.layer.masksToBounds = true
        confirmPassword.layer.cornerRadius = 6
        confirmPassword.layer.borderWidth = 1
        confirmPassword.layer.borderColor = purp
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

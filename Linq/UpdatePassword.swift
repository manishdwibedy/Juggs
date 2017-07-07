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

    @IBOutlet weak var passwordTF: UITextField!
     @IBOutlet weak var OldpasswordTF: UITextField!
     @IBOutlet weak var ConfirmpasswordTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visuals()
    }
    
    @IBAction func saveName(_ sender: Any) {
        
        if OldpasswordTF.text == nil || passwordTF.text == nil || ConfirmpasswordTF.text == nil {
            return
        }
     let oldPass = Globals .sharedInstance.getValueFromUserDefaultsForKey("Password") as? String
        
        if oldPass == OldpasswordTF.text{
            if passwordTF.text == ConfirmpasswordTF.text {
                Globals.ShowSpinner(testStr: "")
                
                Auth.auth().currentUser?.updatePassword(to: self.passwordTF.text!) { (error) in
                    
                    Globals.HideSpinner()
                    // ...
                    let alertViewController = UIAlertController(title: "Record Successfully Updated.", message: "", preferredStyle: .alert)
                    
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
    
    
    
    func visuals() {
        self.title = "Password"
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 8
        
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

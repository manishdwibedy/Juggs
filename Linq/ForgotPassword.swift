//
//  ForgotPassword.swift
//  Linq
//
//  Created by Quinton Askew on 6/5/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class ForgotPassword: UIViewController {

    
    
    @IBOutlet weak var forgotPasswordTF: UITextField!
    
    @IBAction func resetPassword(_ sender: Any) {
   
        let email = forgotPasswordTF.text
        resetPassword(email: email)
    
    }
    
 
   
    @IBAction func LogIn(_ sender: Any) {
 
        self.performSegue(withIdentifier: "unwindToLogin", sender: self)
    
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.forgotPasswordTF.isHidden = false
        
    }
 
    
    
    func resetPassword(email: String!) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                
            print(error)
            }else{
                self.successAlert()
            }
        }
    }
    
    
    func successAlert() {
        
        let alert = UIAlertController(title: nil, message: "Follow the Linq to reset your password.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            
            self.performSegue(withIdentifier: "unwindToLogin", sender: self)
        }
        
        alert.addAction(ok)
        
        self.present(alert, animated: true)
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

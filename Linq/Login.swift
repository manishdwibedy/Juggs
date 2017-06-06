//
//  Login.swift
//  Linq
//
//  Created by Quinton Askew on 5/23/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class Login: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBAction func loggedIn(_ sender: Any) {
    
        guard emailTF.text != "", pwTF.text! != "" else {return}
        Auth.auth().signIn(withEmail: emailTF.text!, password: pwTF.text!) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if user != nil {
                
                let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
                self.present(homeVC, animated: true, completion: nil)
                
            }
            
            
        }
        
        
        
        
    
    }
   
    @IBAction func signUp(_ sender: Any) {
    }
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) { }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

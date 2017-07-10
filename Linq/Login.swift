//
//  Login.swift
//  Linq
//
//  Created by Quinton Askew on 5/23/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class Login: UIViewController {

    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var pwTF: UITextField!
    @IBOutlet weak var logInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBAction func loggedIn(_ sender: Any) {
        
        self.view.endEditing(true)
        
        Globals.ShowSpinner(testStr: "")
        guard emailTF.text != "", pwTF.text! != "" else {return}
        Auth.auth().signIn(withEmail: emailTF.text!, password: pwTF.text!) { (user, error) in
            
            if let error = error {
                print(error.localizedDescription)
                let alertViewController = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                }
                
                alertViewController.addAction(okAction)
                
                self.present(alertViewController, animated: true, completion: nil)
                
                Globals.HideSpinner()
            }
            
            if user != nil {
                
                self.fetchProfile()
                
            }
        }
    }
    func fetchProfile() {
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        if uid == nil {
            Globals.HideSpinner()
            return
        }
        ref.child("Users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let firstName = dict["First Name"] as? String!
                let lastName = dict["Last Name"] as? String!
                let fullName = firstName! + " " + lastName!
                
                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(firstName!, key: "FName")

                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(lastName!, key: "LName")

                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(fullName, key: "UserName")
                
                let age = dict["Age"] as? String!
                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(age!, key: "Age")
                
                let gender = dict["Gender"] as? String!
                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(gender!, key: "Gender")
                
                let city = dict["City"] as? String!
                
                let state = dict["State"] as? String!
                
                let from = city! + ", " + state!
                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(from, key: "Address")
                
                let bio = dict["Bio"] as? String!
                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(bio!, key: "Bio")
                
                
                
//                if let profilePicURL = dict["urlToImage"] as? String {
//                    
//                        
//                        let url = URL(string: profilePicURL)
//                        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
//                            
//                            if error != nil {
//                                print(error!)
//                                return
//                                
//                            }
//                            
//                            DispatchQueue.main.sync {
//                                
//                                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(UIImage(data: data!)!, key: "UserImage")
//                                
//                            }
//                            
//                        }).resume()
//                }
            }
            Globals.HideSpinner()

            let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC")
            Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(true, key: "IS_LOGIN")
            
            self.present(homeVC, animated: true, completion: nil)

        })
        
        ref.removeAllObservers()
        

        
    }
    @IBAction func signUp(_ sender: Any) {
    }
    
    @IBAction func unwindToLogin(segue:UIStoryboardSegue) { }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        let ISLOGIN :Bool? = Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("IS_LOGIN") as? Bool
        if ISLOGIN! {
             Globals.ShowSpinner(testStr: "")
            fetchProfile()
        }
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

//
//  SecondViewController.swift
//  Linq
//
//  Created by Quinton Askew on 5/22/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class MyProfile: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var BackprofilePic: UIImageView!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var bioTV: UITextView!
    
    @IBOutlet weak var webTV: UITextView!
    
    @IBAction func showRelationships(_ sender: Any) {
        
        performSegue(withIdentifier: "showRelationship", sender: self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
            Globals.ShowSpinner(testStr: "")
            fetchProfile()
    }

    override func viewDidAppear(_ animated: Bool) {
         self.tabBarController?.tabBar.isHidden = false
    }
    
    func visuals()  {
        self.tabBarController?.tabBar.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        self.profilePic.clipsToBounds = true
        self.profilePic.layer.cornerRadius = profilePic.frame.size.width/2
        self.profilePic.layer.borderWidth = 4
        let blueGreenThemeColor = UIColor.white
        self.profilePic.layer.borderColor = blueGreenThemeColor.cgColor
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
    }
    
    func fetchProfile() {
        visuals()
    
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("Users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
           
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let firstName = dict["First Name"] as? String!
                let lastName = dict["Last Name"] as? String!
                let fullName = firstName! + " " + lastName!
                self.title = fullName
                let age = dict["Age"] as? String!
                self.ageLabel.text = age
                let gender = dict["Gender"] as? String!
                self.genderLabel.text = gender
                let city = dict["City"] as? String!
                let state = dict["State"] as? String!
                let from = city! + ", " + state!
                self.fromLabel.text = from
                let bio = dict["Bio"] as? String!
                self.bioTV.text = bio
                
                
                if let profilePicURL = dict["urlToImage"] as? String {
                    
                    let url = URL(string: profilePicURL)
                    URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                        
                        if error != nil {
                            print(error!)
                            return
                            
                        }
                        
                        DispatchQueue.main.sync {
                            self.profilePic.image = UIImage(data: data!)
                            
                        }
                        
                    }).resume()
                }
                
            }
            
        })
        
        ref.removeAllObservers()
        Globals.HideSpinner()
    
    }
    
    func logout() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "login")
        present(loginVC, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
}


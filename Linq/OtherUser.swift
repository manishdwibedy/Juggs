//
//  OtherUser.swift
//  Linq
//
//  Created by Quinton Askew on 6/3/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class OtherUser: UIViewController {

  
    
    var otherUserName = ""
    var age = ""
    var city = ""
    var gender = ""
    var state = ""
    var bio = ""
    var pathToImage = "https://firebasestorage.googleapis.com/v0/b/linq-506fb.appspot.com/o/Flyers%2FVzETPu4ANea2HurETO2DwIaMoT73%2F-KlPsr9smklsXVQyAj_p.jpg?alt=media&token=e0af9830-e606-43ae-b888-864f14e7e719"
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    @IBOutlet weak var webTV: UITextView!
    
    @IBOutlet weak var bioTV: UITextView!
    
    @IBAction func unwind(_ sender: Any) {
        performSegue(withIdentifier: "unwindToDiscover", sender: self)
    }
  
    @IBAction func settingsTapped(_ sender: Any) {
       
        
        let settingsActionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let messageAction = UIAlertAction(title: "Message", style: .default) { (action) in
            // Send go to message controller and prepare the message thread for this user.
            print("I want to send this user a message")
        }
        
        let block = UIAlertAction(title: "Block", style: .default) { (action) in
            print("I want to block this user")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
            
        }
        
        settingsActionSheet.addAction(messageAction)
        settingsActionSheet.addAction(block)
        settingsActionSheet.addAction(cancel)
        
        let blueGreenThemeColor = UIColor(red: 93/255, green: 241/255, blue: 180/255, alpha: 1.0)
        
        settingsActionSheet.view.tintColor = blueGreenThemeColor
        
        
        self.navigationController!.present(settingsActionSheet, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupProfile()
    }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfile() {
        visuals()
        profileImageView.downloadImage(from: pathToImage) // not working
        ageLabel.text = age
        let from = city + ", " + state
        fromLabel.text = from
        genderLabel.text = gender
        bioTV.text = bio
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        
    }

    func visuals() {
        self.navigationItem.title = otherUserName
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2.5
        self.profileImageView.layer.borderWidth = 6
        let blueGreenThemeColor = UIColor(red: 93/255, green: 241/255, blue: 180/255, alpha: 1.0)
        self.profileImageView.layer.borderColor = blueGreenThemeColor.cgColor
        
        
        
        
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

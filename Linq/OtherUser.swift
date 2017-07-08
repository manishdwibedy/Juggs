//
//  OtherUser.swift
//  Linq
//
//  Created by Quinton Askew on 6/3/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class OtherUser: UIViewController {

    
  
    var firstName = ""
    var lastName = ""
    var age = ""
    var city = ""
    var gender = ""
    var state = ""
    var bioTextForOtherUser = ""
    var urlTextForOtherUser = ""
    var pathToImage = ""
    
    
    @IBOutlet weak var containerForData: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var BackprofileImageView: UIImageView!

    
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var fromLabel: UILabel!
    
    
    
    @IBOutlet var messageSwipe: UISwipeGestureRecognizer!
    @IBAction func swiped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMessages", sender: self)
    }
    
    @IBOutlet var discoverSwipe: UISwipeGestureRecognizer!
    @IBAction func swipeToDiscover(_ sender: Any) {
        performSegue(withIdentifier: "unwindToDiscover", sender: self)
    }
    
    @IBOutlet var followingSwipe: UISwipeGestureRecognizer!
    @IBAction func swipeToFollowing(_ sender: Any) {
        performSegue(withIdentifier: "unwindToFollowing", sender: self)
    }
    
    @IBOutlet var followersSwipe: UISwipeGestureRecognizer!
    @IBAction func swipeToFollowers(_ sender: Any) {
        performSegue(withIdentifier: "unwindToFollowers", sender: self)
    }
    
    @IBAction func seeRelationships(_ sender: Any) {
        
        
        
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
        
        
        
        let invite = UIAlertAction(title: "Invite", style: .default) { (action) in
            
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
                }
        
        settingsActionSheet.addAction(messageAction)
        settingsActionSheet.addAction(block)
        settingsActionSheet.addAction(invite)
        settingsActionSheet.addAction(cancel)
        
        
        
        settingsActionSheet.view.tintColor = UIColor.black
        
        
        self.navigationController!.present(settingsActionSheet, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visuals()
        
    }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupProfile() {
        
        
        profileImageView.sd_setImage(with: URL(string: "\(String(describing: pathToImage))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        let firstName = self.firstName
        let lastName = self.lastName
        let fullName = firstName + lastName
        self.navigationItem.title = fullName
        ageLabel.text = age + ","
        let from = city + ", " + state
        fromLabel.text = from
        genderLabel.text = gender
        let otherUserPV: OtherUserPageView = storyboard?.instantiateViewController(withIdentifier: "OtherUserPageView") as! OtherUserPageView
        self.view.addSubview(otherUserPV.view)
        self.addChildViewController(otherUserPV)
       // let otherUserBio: OtherUserBio = storyboard?.instantiateViewController(withIdentifier: "OtherUserBio") as! OtherUserBio
       // otherUserPV.addChildViewController(otherUserBio)
     //   otherUserBio.bioTV.text = bioTextForOtherUser
      //  otherUserBio.urlTV.text = urlTextForOtherUser
        
        
    }

    func visuals() {
        
        setupProfile()
        
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        self.profileImageView.layer.borderWidth = 4
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        
    }
    
       
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "seeRelations" {
            if segue.destination is Relations {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
            }
        }
        
        
    }
    

}

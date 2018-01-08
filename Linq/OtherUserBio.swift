//
//  OtherUserBio.swift
//  Linq
//
//  Created by Quinton Askew on 6/30/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import SafariServices
import Firebase

class OtherUserBio: UIViewController {
    
    let ref = Database.database().reference()
    var name: String! 
    

    
    
    @IBOutlet weak var otherUserBioTV: UITextView!
    @IBOutlet weak var faceBookBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    @IBOutlet weak var igBtn: UIButton!
    @IBOutlet weak var youtubeBtn: UIButton!
    @IBOutlet weak var snapchatBtn: UIButton!
    
    @IBAction func goToFacebook(_ sender: Any)
    {
        ref.child("Users").child(UserID).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let facebookUID = dict["Facebook"] as? String
                if facebookUID == nil
                {
                  self.mediaStatusAlert(socialNetworkName: "Facebook")
                }
                else
                {
                    let profileLink = "https://www.facebook.com/" + facebookUID!
                    self.showMedia(profileLink)
                }
                
                
            }
            
        })
        
        ref.removeAllObservers()
        
        
    }
    
    
    @IBAction func goToTwitter(_ sender: Any)
    {
        ref.child("Users").child(UserID).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let twitterUID = dict["Twitter"] as? String
                if twitterUID == nil
                {
                   self.mediaStatusAlert(socialNetworkName: "Twitter")
                }
                else
                {
                    let profileLink = "https://twitter.com/" + twitterUID!
                    self.showMedia(profileLink)
                }
                
                
            }
            
        })
        
        ref.removeAllObservers()
        
    }
    
    
    @IBAction func goToIG(_ sender: Any)
    {
        ref.child("Users").child(UserID).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let igUID = dict["Instagram"] as? String
                if igUID == nil
                {
                    self.mediaStatusAlert(socialNetworkName: "Instagram")
                }
                else
                {
                    let profileLink = "https://www.instagram.com/" + igUID!
                    self.showMedia(profileLink)
                }
                
                
            }
            
        })
        
        ref.removeAllObservers()
        
        
    }
    
    
    @IBAction func copySnapName(_ sender: Any)
    {
        ref.child("Users").child(UserID).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let snapName = dict["Snapchat"] as? String
                if snapName == nil
                {
                    self.mediaStatusAlert(socialNetworkName: "Snapchat")
                }
                else
                {
                    let profileLink = "https://www.snapchat.com/add/" + snapName!
                    self.showMedia(profileLink)
                }
                
                
            }
            
        })
        
        ref.removeAllObservers()
        
    }
    
    
    @IBAction func goToYoutube(_ sender: Any)
    {
        ref.child("Users").child(UserID).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let googleUID = dict["Google"] as? String
                if googleUID == nil
                {
                   self.mediaStatusAlert(socialNetworkName: "Google")
                }
                else
                {
                    let googlePlus = "https://plus.google.com/"
                    let linkToProfile = googlePlus + googleUID!
                    self.showMedia(linkToProfile)
                }
                
                
            }
            
        })
        
        ref.removeAllObservers()
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visuals()
    }
    
    // Presents User's URL
    func showMedia(_ website: String) {
        if let url = URL(string: website) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    
    // Visuals
    
    func visuals()
    {
        faceBookBtn.clipsToBounds = true
        faceBookBtn.layer.cornerRadius = faceBookBtn.frame.size.width / 2
        faceBookBtn.layer.borderWidth = 3.5
        faceBookBtn.layer.borderColor = UIColor.white.cgColor
        
        
        twitterBtn.clipsToBounds = true
        twitterBtn.layer.cornerRadius = twitterBtn.frame.size.width / 2
        twitterBtn.layer.borderWidth = 3.5
        twitterBtn.layer.borderColor = UIColor.white.cgColor
        
        igBtn.clipsToBounds = true
        igBtn.layer.cornerRadius = igBtn.frame.size.width / 2
        igBtn.layer.borderWidth = 3.5
        igBtn.layer.borderColor = UIColor.white.cgColor
        
        
        snapchatBtn.clipsToBounds = true
        snapchatBtn.layer.cornerRadius = snapchatBtn.frame.size.width / 2
        snapchatBtn.layer.borderWidth = 3.5
        snapchatBtn.layer.borderColor = UIColor.white.cgColor
        
        youtubeBtn.clipsToBounds = true
        youtubeBtn.layer.cornerRadius = youtubeBtn.frame.size.width / 2
        youtubeBtn.layer.borderWidth = 3.5
        youtubeBtn.layer.borderColor = UIColor.white.cgColor
        
        fetchBio()
        checkIfLoggedInSocialMedia()
    }
    
    
    func fetchBio()
    {
        
        ref.child("Users").child(UserID).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let bio = dict["Bio"] as? String
                
                self.otherUserBioTV.text = bio
                self.otherUserBioTV.isUserInteractionEnabled = false
            }
            
        })
        
        ref.removeAllObservers()
        
    }
    
    
    func checkIfLoggedInSocialMedia() {
        ref.child("Users").child(UserID).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let websites = snapshot.value as? [String : AnyObject] {
                
                let facebookUID = websites["Facebook"] as? String
                let twitterUID = websites["Twitter"] as? String
                let instagramUID = websites["Instagram"] as? String
                let snapUID = websites["Snapchat"] as? String
                let googleUID = websites["Google"] as? String
                
                
                // Facebook
                if facebookUID == nil {
                    let facebookPic = UIImage(named: "NoFacebook")
                    self.faceBookBtn.setImage(facebookPic, for: .normal)
                } else {
                     // if logged in
                        let facebookPic = UIImage(named: "Facebook")
                        self.faceBookBtn.setImage(facebookPic, for: .normal)
                        //  let manager = FBSDKLoginManager()
                        //   manager.logOut()
                }
                
                
                if googleUID == nil {
                    let googlePic = UIImage(named: "NoGoogle")
                    self.youtubeBtn.setImage(googlePic, for: .normal)
                } else {
                    // GIDSignIn.sharedInstance().hasAuthInKeychain() causes users to have to visit Websites page before button changes.
                    // if logged in
                    let googlePic = UIImage(named: "Google")
                    self.youtubeBtn.setImage(googlePic, for: .normal)
                }
                
                
                
                // Snapchat
                
                if(snapUID == nil )
                {
                    let snapPic = UIImage(named: "NoSnapchat")
                    self.snapchatBtn.setImage(snapPic, for: .normal)
                }
                else
                {
                    let snapPic = UIImage(named: "Snapchat")
                    self.snapchatBtn.setImage(snapPic, for: .normal)
                }
                
                // Instagram
                
                if(instagramUID == nil)
                {
                    let instaPic = UIImage(named: "NoInstagram")
                    self.igBtn.setImage(instaPic, for: .normal)
                }
                else
                {
                    let instaPic = UIImage(named: "Instagram")
                    self.igBtn.setImage(instaPic, for: .normal)
                }
                
                // Twitter
                
                if(twitterUID == nil)
                {
                    let twitterPic = UIImage(named: "NoTwitter")
                    self.twitterBtn.setImage(twitterPic, for: .normal)
                    //  let manager = FBSDKLoginManager()
                    //   manager.logOut()
                }
                else
                {
                    let noTwitterPic = UIImage(named: "Twitter")
                    self.twitterBtn.setImage(noTwitterPic, for: .normal)
                    
                }
                
                
            } else {
                // show alert
            }
        })
        
        ref.removeAllObservers()
    }
    
    
    func mediaStatusAlert(socialNetworkName: String) {
        
        ref.child("Users").child(UserID).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            if let dict = snapshot.value as? [String: AnyObject] {
                let userName = dict["FirstName"] as? String
                let failedMessage =  "\(userName!) isn't verified with \(socialNetworkName)."
                let alert =  UIAlertController(title: "Oops!", message: failedMessage, preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (void) in
                    
                }
                alert.addAction(ok)
                let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                alert.view.tintColor = purp
                self.present(alert, animated: true, completion: nil)

            }
            
        })
        
        ref.removeAllObservers()
        
        
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

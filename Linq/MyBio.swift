//
//  MyBio.swift
//  Linq
//
//  Created by Quinton Askew on 7/2/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SafariServices
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit
import TwitterCore
import InstagramSimpleOAuth

struct INSTAGRAM_IDS {
    
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    
    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
    
    static let INSTAGRAM_CLIENT_ID  = "85256ce4d325435795ab9464bdcc910d"
    
    static let INSTAGRAM_CLIENTSERCRET = "fdd4f23e2b4f42a485780617aefaae9d"
    
    static let INSTAGRAM_REDIRECT_URI = "http://www.instagram.com"
    
    static let INSTAGRAM_ACCESS_TOKEN =  "access_token"
    
    static let INSTAGRAM_SCOPE = "likes+comments+relationships"
    
}


var facebookIsSignedIn: Bool? = nil
var googleIsSignedIn: Bool? = nil
var igSignedIn: Bool? = nil


class MyBio: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate  {
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    let oops = "Identify yourself!"
    
    let websiteDict = [0 : "Facebook",
                       1 : "Twitter",
                       2 : "Instagram",
                       3 : "Snapchat",
                       4 : "Google+"
    ]
    
    
    
    @IBOutlet weak var biographyTextView: UITextView!
    @IBOutlet weak var facebookBtn: UIButton!
    @IBAction func goToMyFacebook(_ sender: Any)
    {
        ref.child("Users").child(uid!).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
           
            // If user has a Facebook child in database.
            if snapshot.hasChild("Facebook") {
               
                self.ref.child("Users").child(self.uid!).child("Websites").child("Facebook").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                    
                    if let dict = snapshot.value as? [String : AnyObject] {
                        let facebookUID = dict["Facebook"] as? String
                        let profileLink = "https://www.facebook.com/" + facebookUID!
                        self.showMedia(profileLink)
              
                    }
                
                })
                self.ref.removeAllObservers()
            }else{
                // If user doesn't
                self.addFacebookAlert()
                
            }
            
        })
        
    }
    
    @IBOutlet weak var twitterBtn: UIButton!
    @IBAction func goToMyTwitter(_ sender: Any)
    {
        
        ref.child("Users").child(uid!).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            // If user has a Twitter child in database.
            if snapshot.hasChild("Twitter") {
                
                self.ref.child("Users").child(self.uid!).child("Websites").child("Twitter").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                    
                    if let dict = snapshot.value as? [String : AnyObject] {
                        let twitterUID = dict["Twitter"] as? String
                        let profileLink = "https://twitter.com/" + twitterUID!
                        self.showMedia(profileLink)
                        
                    }
                    
                })
                self.ref.removeAllObservers()
            }else{
                // If user doesn't
                self.addTwitterAlert()
                
            }
            
        })
    
    }
    
    
    
    
    @IBOutlet weak var igBtn: UIButton!
    @IBAction func goToMyIG(_ sender: Any)
    {
        ref.child("Users").child(uid!).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            // If user has a Instagram child in database.
            if snapshot.hasChild("Instagram") {
                
                self.ref.child("Users").child(self.uid!).child("Websites").child("Instagram").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                    
                    if let dict = snapshot.value as? [String : AnyObject] {
                        let igUID = dict["Instagram"] as? String
                        let profileLink = "https://www.instagram.com/" + igUID!
                        self.showMedia(profileLink)
                        
                    }
                    
                })
                self.ref.removeAllObservers()
            }else{
                // If user doesn't
                self.addInstagramAlert()
                
            }
            
        })
        
    }
    
    
    
    @IBOutlet weak var snapBtn: UIButton!
    @IBAction func unhideSnapName(_ sender: Any)
    {        
        ref.child("Users").child(uid!).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            // If user has a Snapchat child in database.
            if snapshot.hasChild("Snapchat") {
                
                self.ref.child("Users").child(self.uid!).child("Websites").child("Snapchat").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                    
                    if let dict = snapshot.value as? [String : AnyObject] {
                        let snapName = dict["Snapchat"] as? String
                        let profileLink = "https://www.snapchat.com/add/" + snapName!
                        self.showMedia(profileLink)
                        
                    }
                    
                })
                self.ref.removeAllObservers()
            }else{
                // If user doesn't
                self.snapChatAlert()
                
            }
            
        })
        
        
    }
    
    
    @IBOutlet weak var youtubeBtn: UIButton! // Google
    @IBAction func goToMyYoutube(_ sender: Any) // goToGoogle+
    {
        
        ref.child("Users").child(uid!).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            // If user has a Google+ child in database.
            if snapshot.hasChild("Google") {
                
                self.ref.child("Users").child(self.uid!).child("Websites").child("Google").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snap) in
                    
                    if let dict = snapshot.value as? [String : AnyObject] {
                        let googleUID = dict["Google"] as? String
                        let googlePlus = "https://plus.google.com/"
                        let linkToProfile = googlePlus + googleUID!
                        self.showMedia(linkToProfile)
                        
                    }
                    
                })
                self.ref.removeAllObservers()
            }else{
                // If user doesn't
                self.addGoogleAlert()
                
            }
            
        })
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchBio()
        visuals()
        var error: NSError?
//        GGLContext.sharedInstance().configureWithError(&error)
//        if error != nil {
//            print(error!)
//            return
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkIfLoggedInSocialMedia()
    }
    
    
    func fetchBio()
    {
        
        ref.child("Users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let bio = dict["Bio"] as? String!
                
                self.biographyTextView.text = bio!
            }
            
        })
        
        ref.removeAllObservers()
        
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
        checkIfLoggedInSocialMedia()
        
        facebookBtn.clipsToBounds = true
        facebookBtn.layer.cornerRadius = facebookBtn.frame.size.width / 2
        facebookBtn.layer.borderWidth = 3.5
        facebookBtn.layer.borderColor = UIColor.white.cgColor
        
        twitterBtn.clipsToBounds = true
        twitterBtn.layer.cornerRadius = twitterBtn.frame.size.width / 2
        twitterBtn.layer.borderWidth = 3.5
        twitterBtn.layer.borderColor = UIColor.white.cgColor
        
        igBtn.clipsToBounds = true
        igBtn.layer.cornerRadius = igBtn.frame.size.width / 2
        igBtn.layer.borderWidth = 3.5
        igBtn.layer.borderColor = UIColor.white.cgColor
        
        
        snapBtn.clipsToBounds = true
        snapBtn.layer.cornerRadius = snapBtn.frame.size.width / 2
        snapBtn.layer.borderWidth = 3.5
        snapBtn.layer.borderColor = UIColor.white.cgColor
        
        youtubeBtn.clipsToBounds = true
        youtubeBtn.layer.cornerRadius = youtubeBtn.frame.size.width / 2
        youtubeBtn.layer.borderWidth = 3.5
        youtubeBtn.layer.borderColor = UIColor.white.cgColor
        
    }
    
    
    func mediaStatusAlert(title: String, website: String) {
        
        let message = "Authenticating your \(website) account will help you attend more Juggs."
        let alert =  UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (void) in
            
        }
        alert.addAction(ok)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func checkIfLoggedInSocialMedia() {
        ref.child("Users").child(uid!).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let websites = snapshot.value as? [String : AnyObject] {
                
                let facebookUID = websites["Facebook"] as? String
                let twitterUID = websites["Twitter"] as? String
                let instagramUID = websites["Instagram"] as? String
                let snapUID = websites["Snapchat"] as? String
                let googleUID = websites["Google"] as? String
                
                    if(FBSDKAccessToken.current() != nil) || (facebookUID != "") || facebookUID != nil
                    {
                        // If logged in
                        let facebookPic = UIImage(named: "Facebook")
                        self.facebookBtn.setImage(facebookPic, for: .normal)
                        
                    }
                    else
                    {
                        let facebookPic = UIImage(named: "NoFacebook")
                        self.facebookBtn.setImage(facebookPic, for: .normal)
                        
                    }
                
        
                
                if googleUID == nil || googleUID == "" {
                    let googlePic = UIImage(named: "NoGoogle")
                    self.youtubeBtn.setImage(googlePic, for: .normal)
                } else {
                    // GIDSignIn.sharedInstance().hasAuthInKeychain() causes users to have to visit Websites page before button changes.
                    // If logged in
                    let googlePic = UIImage(named: "Google")
                    self.youtubeBtn.setImage(googlePic, for: .normal)
                }
                
                
                
                // Snapchat
                
                if(snapUID == nil )
                {
                    let snapPic = UIImage(named: "NoSnapchat")
                    self.snapBtn.setImage(snapPic, for: .normal)
                }
                else
                {
                    let snapPic = UIImage(named: "Snapchat")
                    self.snapBtn.setImage(snapPic, for: .normal)
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
    
    /////////////////////// SOCIAL MEDIA METHODS BELOW ///////////////////////
    
    // MARK: - Facebook Methods
    
    // Facebook
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!)
    {
        if error != nil {
            print(error)
            return
        }
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let keyToWebsites = ref.child("Users").child(uid!).child("Websites")
        
        // Gets user's Facebook UID
        guard let userFacebookUID = FBSDKAccessToken.current().userID else { return }
        
        // Save user's Facebook UID to Firebase.
        keyToWebsites.updateChildValues(["Facebook" : userFacebookUID])
        
        facebookIsSignedIn = true
        
        print("Successfully saved facebook.")
        
        
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!)
    {
        facebookIsSignedIn = false
        print("Successfully Logged Out of FB.")
    }
    
    func handleFacebookLogin() {
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email","public_profile"], from: self) { (result, err) in
            if err != nil {
                print("Custom FB Login failed:", err!)
                return
            }
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            let keyToWebsites = ref.child("Users").child(uid!).child("Websites")
            
            // Gets user's Facebook UID
            guard let userFacebookUID = FBSDKAccessToken.current().userID else { return }
            
            // Save user's Facebook UID to Firebase.
            keyToWebsites.updateChildValues(["Facebook" : userFacebookUID])
            
            facebookIsSignedIn = true
        }
    }
    
//    func handleFacebookLogOut() {
//        
//        FBSDKLoginManager().logOut()
//        
//        
//        ref.child("Users").child(uid!).child("Websites").child("Facebook").removeValue()
//        fbBtn.setTitle("Continue with Facebook", for: .normal)
//        fbBtn.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
//        
//        
//        
//    }
//    
    
    func addFacebookAlert()
    {
       
        let alert =  UIAlertController(title: "Link your Facebook account?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let continueBtn = UIAlertAction(title: "Continue", style: .default) { (void) in
            self.handleFacebookLogin()
        }
        alert.addAction(cancel)
        alert.addAction(continueBtn)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
    
    }
    
    
    
    
    
    // Mark: - Twitter Methods
    
    // Twitter
    @objc fileprivate func handleTwitterLogin() {
        
        Twitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName ?? "")");
                
                let uid = Auth.auth().currentUser?.uid
                let ref = Database.database().reference()
                let keyToWebsites = ref.child("Users").child(uid!).child("Websites")
                keyToWebsites.updateChildValues(["Twitter" : session?.userName as Any])
                
            } else {
                print("error: \(error?.localizedDescription ?? "")");
            }
        })
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    
    func addTwitterAlert()
    {
        
        let alert =  UIAlertController(title: "Link your Twitter account?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let continueBtn = UIAlertAction(title: "Continue", style: .default) { (void) in
            self.handleTwitterLogin()
        }
        alert.addAction(cancel)
        alert.addAction(continueBtn)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // Mark: - Instagram Methods
    
    //Instagram
    
    func signInWithIG() {
        
        let controller =  InstagramSimpleOAuthViewController.init(clientID: INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID, clientSecret: INSTAGRAM_IDS.INSTAGRAM_CLIENTSERCRET, callbackURL: URL.init(string: INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI)) { (response, error) in
            
            //            print(response?.accessToken)
            //            print(response?.user.userID)
            //            print(response?.user.username)
            
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            let keyToWebsites = ref.child("Users").child(uid!).child("Websites")
            keyToWebsites.updateChildValues(["Instagram" : response?.user.username as Any])
            
        }
        
        controller?.shouldShowErrorAlert = true
        controller?.permissionScope = ["basic", "comments","relationships","likes"]
        self.navigationController?.pushViewController(controller!, animated: true)
        
    }
    
    
    func signOut () {
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                NSLog("\(cookie)")
            }
        }
        
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies! {
            storage.deleteCookie(cookie)
        }
        
        ref.child("Users").child(uid!).child("Websites").child("Instagram").removeValue()
        
        
       // igBtn.addTarget(self, action: #selector(signInWithIG), for: .touchUpInside)
        
    }
    
    func addInstagramAlert()
    {
        
        let alert =  UIAlertController(title: "Link your Instagram account?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let continueBtn = UIAlertAction(title: "Continue", style: .default) { (void) in
            self.signInWithIG()
        }
        alert.addAction(cancel)
        alert.addAction(continueBtn)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    // Mark: - Snapchat
    
    func snapChatAlert() {
        
        let alertController = UIAlertController(title: "Snapchat", message: (NSLocalizedString("un", comment: "")), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title:(NSLocalizedString("cancel", comment: "")), style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title:(NSLocalizedString("save", comment: "")), style: .default, handler: {
            alert -> Void in
            let textField = alertController.textFields![0] as UITextField
            if textField.text != "" {
                Globals.ShowSpinner(testStr: "")
                let mySnapLink = textField.text
                let uid = Auth.auth().currentUser?.uid
                let Ref = "Users/" + uid!
                Database.database().reference().root.child(Ref).child("Websites").updateChildValues(["Snapchat" : mySnapLink ?? ""])
                Globals.HideSpinner()
            }
            else
            {
                return
            }
            
        }))
        
        
        alertController.addTextField(configurationHandler: {(textField : UITextField!) -> Void in
            
            
            let ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
            ref.child("Users").child(uid!).child("Websites").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                
                if let dict = snapshot.value as? [String : AnyObject] {
                    
                    let snapName = dict["Snapchat"] as? String
                    if snapName != nil
                    {
                        textField.placeholder = snapName
                    }
                    else
                    {
                        textField.placeholder = (NSLocalizedString("scum", comment: ""))
                        
                    }
                    
                    
                }
                
            })
            
            ref.removeAllObservers()
            
        })
        
        
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alertController.view.tintColor = purp
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Mark: - Google+ Methods
    
    //Google
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if error != nil{
            print(error)
            return
        }
        
        let idToken = user.authentication.idToken
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let keyToWebsites = ref.child("Users").child(uid!).child("Websites")
        keyToWebsites.updateChildValues(["Google" : idToken!])
        googleIsSignedIn = true
        
        
        
    }
    
    func handleGoogleLogin() {
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func handleGoogleLogOut() {
        
        GIDSignIn.sharedInstance().signOut()
        ref.child("Users").child(uid!).child("Websites").child("Google").removeValue()
        
       
       // gmailBtn.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
    }
    
    func addGoogleAlert()
    {
        
        let alert =  UIAlertController(title: "Link your Google+ account?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let continueBtn = UIAlertAction(title: "Continue", style: .default) { (void) in
            self.handleGoogleLogin()
        }
        alert.addAction(cancel)
        alert.addAction(continueBtn)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
        
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

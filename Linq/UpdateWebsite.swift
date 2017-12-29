//
//  UpdateWebsite.swift
//  Linq
//
//  Created by Quinton Askew on 6/18/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
import TwitterKit
//import InstagramSimpleOAuth
//
//struct INSTAGRAM_IDS {
//
//    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
//
//    static let INSTAGRAM_APIURl  = "https://api.instagram.com/v1/users/"
//
//    static let INSTAGRAM_CLIENT_ID  = "85256ce4d325435795ab9464bdcc910d"
//
//    static let INSTAGRAM_CLIENTSERCRET = "fdd4f23e2b4f42a485780617aefaae9d"
//
//    static let INSTAGRAM_REDIRECT_URI = "http://www.instagram.com"
//
//    static let INSTAGRAM_ACCESS_TOKEN =  "access_token"
//
//    static let INSTAGRAM_SCOPE = "likes+comments+relationships"
//
//}


class UpdateWebsite: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    

    var  fbBtn = UIButton()
    var  tweetBtn = UIButton()
    var  igBtn = UIButton()
    var  snapBtn = UIButton()
    var  gmailBtn = UIButton()
    
    let ref = Database.database().reference()
    let uid = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (NSLocalizedString("websites", comment: ""))
        createMediaButtons()
        
    }
    
   
    func createMediaButtons() {
        let purpUI = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        
        // Facebook
//                let fbLoginBtn = FBSDKLoginButton()
//                fbLoginBtn.frame = CGRect(x: 16, y: 120, width: view.frame.width - 32, height: 50)
//                view.addSubview(fbLoginBtn)
//                fbLoginBtn.delegate = self
        
        fbBtn = UIButton(type: .system)
        fbBtn.frame = CGRect(x: 16, y: 120, width: view.frame.width - 32, height: 50)
        fbBtn.backgroundColor = UIColor.clear
        fbBtn.tintColor = purpUI
        fbBtn.setTitle((NSLocalizedString("cf", comment: "")), for: .normal)
        fbBtn.layer.cornerRadius = 8
        fbBtn.layer.borderWidth = 2
        fbBtn.layer.borderColor = purp
        fbBtn.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
        view.addSubview(fbBtn)

        
        
        // Twitter
        tweetBtn = UIButton(type: .system)
        tweetBtn.frame = CGRect(x: 16, y: 200, width: view.frame.width - 32, height: 50)
        tweetBtn.backgroundColor = UIColor.clear
        tweetBtn.tintColor = purpUI
        tweetBtn.setTitle((NSLocalizedString("ct", comment: "")), for: .normal)
        tweetBtn.layer.cornerRadius = 8
        tweetBtn.layer.borderWidth = 2
        tweetBtn.layer.borderColor = purp
        tweetBtn.addTarget(self, action: #selector(handleTwitterLogin), for: .touchUpInside)
        view.addSubview(tweetBtn)
        
        
        
        
        // Instagram
        igBtn = UIButton(type: .system)
        igBtn.frame = CGRect(x: 16, y: 280, width: view.frame.width - 32, height: 50)
        igBtn.backgroundColor = UIColor.clear
        igBtn.tintColor = purpUI
        igBtn.setTitle((NSLocalizedString((NSLocalizedString("ci", comment: "")), comment: "")), for: .normal)
        igBtn.layer.cornerRadius = 8
        igBtn.layer.borderWidth = 2
        igBtn.layer.borderColor = purp
     //   igBtn.addTarget(self, action: #selector(signInWithIG), for: .touchUpInside)
        view.addSubview(igBtn)

        
        // Snapchat
        snapBtn = UIButton(type: .system)
        snapBtn.frame = CGRect(x: 16, y: 360, width: view.frame.width - 32 , height: 50)
        snapBtn.backgroundColor = UIColor.clear
        snapBtn.tintColor = purpUI
        snapBtn.setTitle((NSLocalizedString("cs", comment: "")), for: .normal)
        snapBtn.layer.cornerRadius = 8
        snapBtn.layer.borderWidth = 2
        snapBtn.layer.borderColor = purp
        snapBtn.addTarget(self, action: #selector(snapChatAlert), for: .touchUpInside)
        view.addSubview(snapBtn)
        
        
        // Google+
        
//         let googleLoginBtn = GIDSignInButton()
//         googleLoginBtn.frame = CGRect(x: 16, y: 180, width: view.frame.width - 32, height: 50)
//         GIDSignIn.sharedInstance().uiDelegate = self
//         view.addSubview(googleLoginBtn)
        
        gmailBtn = UIButton(type: .system)
        gmailBtn.frame = CGRect(x: 16, y: 440, width: view.frame.width - 32, height: 50)
        gmailBtn.backgroundColor = UIColor.clear
        gmailBtn.tintColor = purpUI
        gmailBtn.setTitle((NSLocalizedString("cg", comment: "")), for: .normal)
        gmailBtn.layer.cornerRadius = 8
        gmailBtn.layer.borderWidth = 2
        gmailBtn.layer.borderColor = purp
     //   gmailBtn.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
        view.addSubview(gmailBtn)
        
        checkIfLoggedInSocialMedia()
        
//        var error: NSError?
//        GGLContext.sharedInstance().configureWithError(&error)
//        if error != nil {
//            print(error!)
//            return
//        }
        
       
      
        
    }
    
    
    func checkIfLoggedInSocialMedia() {
        
        ref.child("Users").child(uid!).child("Websites").queryOrderedByKey().observe(.value, with: { snapshot in
            
            if let websites = snapshot.value as? [String : AnyObject] {
                
                let facebookUID = websites["Facebook"] as? String
                let twitterUID = websites["Twitter"] as? String
                let instagramUID = websites["Instagram"] as? String
                let snapUID = websites["Snapchat"] as? String
                let googleUID = websites["Google"] as? String
                
                
                // Facebook
                if facebookUID == nil {
                    
                } else {
                    
                    self.fbBtn.setTitle((NSLocalizedString("lof", comment: "")), for: .normal)
                    self.fbBtn.addTarget(self, action: #selector(self.handleFacebookLogOut), for: .touchUpInside)
                    
                    // if logged in
                    
                    //  let manager = FBSDKLoginManager()
                    //   manager.logOut()
                }
                
                
                if googleUID == nil {
                    
                } else {
                    self.gmailBtn.setTitle((NSLocalizedString("log", comment: "")), for: .normal)
                    self.gmailBtn.addTarget(self, action: #selector(self.handleGoogleLogOut), for: .touchUpInside)
                    // GIDSignIn.sharedInstance().hasAuthInKeychain() causes users to have to visit Websites page before button changes.
                    // if logged in
                   
                }
                
                
                
                // Snapchat
                
                if(snapUID == nil )
                {
                   
                }
                else
                {
                    
                }
                
                // Instagram
                
                if(instagramUID == nil)
                {
                    
                }
                else
                {
                    self.igBtn.setTitle((NSLocalizedString("loi", comment: "")), for: .normal)
                   // self.igBtn.addTarget(self, action: #selector(self.signOut), for: .touchUpInside)
                }
                
                // Twitter
                
                if(twitterUID == nil)
                {
                   
                    //  let manager = FBSDKLoginManager()
                    //   manager.logOut()
                }
                else
                {
                  self.tweetBtn.setTitle((NSLocalizedString("lot", comment: "")), for: .normal)
                    self.tweetBtn.addTarget(self, action: #selector(self.handleTwitterLogOut), for: .touchUpInside)
                }
                
                
            } else {
                // show alert
            }
        })
        
//        ref.removeAllObservers()
    }
    
    
    // MARK: - Social Media Delegates
    

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
    
    func handleFacebookLogOut() {
        
        FBSDKLoginManager().logOut()
        
       
        ref.child("Users").child(uid!).child("Websites").child("Facebook").removeValue()
        fbBtn.setTitle("Continue with Facebook", for: .normal)
        fbBtn.addTarget(self, action: #selector(handleFacebookLogin), for: .touchUpInside)
        
       
        
        
    }

   
    func handleTwitterLogOut() {
        
        
        if let userID =  Twitter.sharedInstance().sessionStore.session()?.userID {
            
            Twitter.sharedInstance().sessionStore.logOutUserID(userID)
            ref.child("Users").child(uid!).child("Websites").child("Twitter").removeValue()
            
            tweetBtn.setTitle("Continue with Twitter", for: .normal)
            tweetBtn.addTarget(self, action: #selector(handleTwitterLogin), for: .touchUpInside)
        }
        
        
    }
    
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

    
    
    
    // Instagram 
//    func signInWithIG() {
//
//        let controller =  InstagramSimpleOAuthViewController.init(clientID: INSTAGRAM_IDS.INSTAGRAM_CLIENT_ID, clientSecret: INSTAGRAM_IDS.INSTAGRAM_CLIENTSERCRET, callbackURL: URL.init(string: INSTAGRAM_IDS.INSTAGRAM_REDIRECT_URI)) { (response, error) in
//
////            print(response?.accessToken)
////            print(response?.user.userID)
////            print(response?.user.username)
//
//            let uid = Auth.auth().currentUser?.uid
//            let ref = Database.database().reference()
//            let keyToWebsites = ref.child("Users").child(uid!).child("Websites")
//            keyToWebsites.updateChildValues(["Instagram" : response?.user.username as Any])
//
//        }
//
//        controller?.shouldShowErrorAlert = true
//        controller?.permissionScope = ["basic", "comments","relationships","likes"]
//        self.navigationController?.pushViewController(controller!, animated: true)
//
//    }
//
//
//    func signOut () {
//
//        if let cookies = HTTPCookieStorage.shared.cookies {
//            for cookie in cookies {
//                NSLog("\(cookie)")
//            }
//        }
//
//        let storage = HTTPCookieStorage.shared
//        for cookie in storage.cookies! {
//            storage.deleteCookie(cookie)
//        }
//
//        ref.child("Users").child(uid!).child("Websites").child("Instagram").removeValue()
//
//        igBtn.setTitle((NSLocalizedString("ci", comment: "")), for: .normal)
//        igBtn.addTarget(self, action: #selector(signInWithIG), for: .touchUpInside)
//
//    }
    
    // Snapchat
        
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
    
    
    // Google
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
    
    func handleGoogleLogOut() {
        
        GIDSignIn.sharedInstance().signOut()
        ref.child("Users").child(uid!).child("Websites").child("Google").removeValue()
        
        gmailBtn.setTitle("Continue with Google+", for: .normal)
      //  gmailBtn.addTarget(self, action: #selector(handleGoogleLogin), for: .touchUpInside)
    }
    
//    func handleGoogleLogin() {
//        GIDSignIn.sharedInstance().signIn()
//        
//    }
    

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

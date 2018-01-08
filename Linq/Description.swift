//
//  Description.swift
//  Linq
//
//  Created by Quinton Askew on 5/28/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import UserNotifications

class Description: UIViewController, UITextViewDelegate {
    
    var userid = ""
    var userName = ""
    var moveid = ""
    var moveName = ""
    var date = ""
    var amOrPM = ""
    var time = ""
    var privateOrPublic = Bool()
    var descriptionText = ""
    var pathToImage = ""
    var userImage = ""
    var reported = Bool()
    var requestArray = [Request]()
    
    let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    
    @IBOutlet weak var moveTitle: UILabel!
    @IBOutlet weak var flyerImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var requestBtn: UIButton!
    
    @IBAction func request(_ sender: Any) {
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        if uid == userid {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "AttendeesTable")
            attendPostID = moveid
            
            controller.title = "Guest List"
            
            let dateTime = "\(date) \(time) \(self.amOrPM)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
            
            let postdate =  dateFormatter.date(from: dateTime)
            
            if postdate != nil {
                let elapsed = Date().timeIntervalSince(postdate!)
                let diff = self.stringFromTimeInterval(interval: elapsed)
                
                if diff.intValue >= 1 {
                    controller.title = "Attendance"
                } else {
                    controller.title = "Guest List"
                }
            }
            
            self.navigationController?.pushViewController(controller, animated: true)
            
            return
        }
        
        let keyToPost = ref.child("Users").child(uid)
        let commentsRef = keyToPost.child("Requests").childByAutoId()
        
        let invite = [
            
            "fromuserImagePath" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("urlToImage"),
            "flyerImagePath" : pathToImage,
            "from" : uid,
            "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName"),
            "touserID" : userid,
            "touserName" : userName,
            "touserImagePath" : userImage,
            "eventName" : moveName,
            "postID" : moveid,
            "status" : "0",
            "postDate": "\(date) \(time) \(self.amOrPM)"
            
            ] as [String : Any]
        
        commentsRef.setValue(invite)
        
        let keyToPost1 = ref.child("Flyers").child(moveid)
        let commentsRef1 = keyToPost1.child("Requests").childByAutoId()
        
        let invite1 = [
            "fromuserImagePath" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("urlToImage"),
            "flyerImagePath" : pathToImage,
            "from" : uid,
            "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName"),
            "touserID" : userid,
            "touserName" : userName,
            "touserImagePath" : userImage,
            "eventName" : moveName,
            "postID" : moveid,
            "status" : "0",
            "postDate": "\(date) \(time) \(self.amOrPM)"
            
            ] as [String : Any]
        
        commentsRef1.setValue(invite1)
        
        let notification = UNMutableNotificationContent()
        notification.title = "Request"
        notification.subtitle = "You have received a request to join!"
        notification.body = "Open Jugg now to respond."
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        let alert = UIAlertController(title: "Your request to attend: \"\(moveName)\" has been sent.", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(confirm)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var publicLabel: UILabel!
    
    @IBAction func share(_ sender: Any)
    {
        moreActionSheet()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTV.delegate = self
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        newLine()
        return false
    }
    
    func newLine()
    {
        descriptionTV.text = descriptionTV.text + "\n"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        visuals()
        getPostData()
        initNotificationSetupCheck()
    }
    
    func moreActionSheet()
    {
        let uid = Auth.auth().currentUser?.uid
        var actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        }
        let share = UIAlertAction(title: NSLocalizedString("share", comment: ""), style: .default) { (action) in
            
            // text to share
            let message = "Hey, you should check out \(self.moveName) on the Jugg app! \(self.descriptionText) \(self.pathToImage) "
            
            // set up activity view controller
            let itemsToShare = [message]
            let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
            
        }
        
        let report = UIAlertAction(title: "Report", style: .default)
        { (action) in
            let titleForAlert = "Warning!"
            let messageForAlert = "You are reporting \"\(self.moveName)\" as abusive or harmful content."
            self.alert(title: titleForAlert, message: messageForAlert)
        }
        
        if uid != userid
        {
            if !self.reported {
               actionSheet.addAction(report)
            }
        }
        
        
        let delete = UIAlertAction(title: NSLocalizedString("deleteJugg", comment: ""), style: .destructive, handler: { (action) in
            // Remove Post
            let ref = Database.database().reference()
            
            ref.child("Flyers").child(self.moveid).removeValue { error in
                if error != nil {
                    print("error \(error)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
        
        if uid == userid
        {
            actionSheet.addAction(delete)
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel) { (void) in
       
        }
        
        actionSheet.addAction(share)
        actionSheet.addAction(cancel)
        actionSheet.view.tintColor = purp
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    func initNotificationSetupCheck()
    {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
    
    
    
    func getPostData()
    {
        
        self.title = moveName
        
        flyerImageView.downloadImage(from: pathToImage)
        flyerImageView.sd_setImage(with: URL(string: "\(String(describing: pathToImage))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        
        let timePlusAMPM = time + " " + amOrPM
        timeLabel.text = timePlusAMPM
        dateLabel.text = date
        
        descriptionTV.text = descriptionText
        
    }
    
    
    func alert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "Continue", style: .default) { (action) in
            // Handle Report
            let ref = Database.database().reference()
            let keyToPost = ref.child("Flyers").childByAutoId().key

            ref.child("Flyers").child(self.moveid).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.value as? [String : AnyObject]) != nil {
                    let updateLikes: [String : Any] = ["peopleWhoReported/\(keyToPost)" : Auth.auth().currentUser!.uid]
                    ref.child("Flyers").child(self.moveid).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                        
                        self.reported = true
                        
                        if error == nil {
                            ref.child("Flyers").child(self.moveid).observeSingleEvent(of: .value, with: { (snap) in
                                if let properties = snap.value as? [String : AnyObject] {
                                    if let reported = properties["peopleWhoReported"] as? [String : AnyObject] {
                                        
                                        let count = reported.count
                                       
                                        let alertThanks = UIAlertController(title: "Jugg Reported!", message: "Thank you for reporting the content you found as disturbing. We will advise.", preferredStyle: .alert)
                                        
                                        let cancelThanks = UIAlertAction(title: "Ok", style: .cancel) { (void) in
                                            
                                        }
                                        
                                        alertThanks.addAction(cancelThanks)
                                        
                                        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                                        alertThanks.view.tintColor = purp
                                        self.present(alertThanks, animated: true, completion: nil)
                                        
                                        if count >= 25 {
                                            
                                        }
                                    }
                                }
                            })
                        }
                    })
                }
            })
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (void) in
      
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
    }
    
    func visuals()
    {
        
        if !privateOrPublic {
            requestBtn.isHidden = true
            publicLabel.isHidden = false
        } else {
            requestBtn.isHidden = false
            publicLabel.isHidden = true
        }
        
        flyerImageView.layer.masksToBounds = true
        requestBtn.layer.cornerRadius = 8
        publicLabel.layer.cornerRadius = 8
        publicLabel.layer.masksToBounds = true
        flyerImageView.layer.cornerRadius = 8
        
        let uid = Auth.auth().currentUser!.uid
        
        if uid == userid {
            requestBtn.isHidden = false
            requestBtn.isEnabled = true
            self.reported = true
            
            self.requestBtn.setTitle("Guest List", for: .normal)
            let dateTime = "\(date) \(time) \(self.amOrPM)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
    
            let postdate =  dateFormatter.date(from: dateTime)
            
            if postdate != nil {
                let elapsed = Date().timeIntervalSince(postdate!)
                let diff = self.stringFromTimeInterval(interval: elapsed)
                
                if diff.intValue > 0 {
                    self.requestBtn.setTitle("Attendance", for: .normal)
                } else {
                    self.requestBtn.setTitle("Guest List", for: .normal)
                }
            }
        } else {
            
            let ref = Database.database().reference()
            
            Globals.ShowSpinner(testStr: "")
            
            ref.child("Flyers").child(moveid).observe(DataEventType.value, with: { (snapshot) in
            
                let posts = snapshot.value as! [String : AnyObject]

                if let reportArray = posts["peopleWhoReported"] as? [String:AnyObject] {
                    
                    for(_,value) in reportArray  {
                        if value as! String == uid  {
                            self.reported = true
                        }
                    }
                }

                let requests = posts["Requests"] as? [String: AnyObject]
                
                if requests != nil {
                    for(_,values) in requests! {
                        let sentby =  values["from"] as! String
                        if sentby == uid {
                            
                            self.requestBtn.isEnabled = true
                            
                            let status = values["status"] as! String
                            
                            if status == "0" {
                                self.requestBtn.setTitle("Pending...", for: .normal)
                                self.requestBtn.isEnabled = false
                            } else if status == "1" {
                                self.requestBtn.setTitle("Accepted", for: .normal)
                                self.requestBtn.isEnabled = false
                            } else {
                                self.requestBtn.setTitle("Rejected", for: .normal)
                                self.requestBtn.isEnabled = false
                            }
                            
                            break;
                        }
                    }
                }
                
                
                let invites = posts["Invites"] as? [String: AnyObject]
                
                if invites != nil {
                    for(_,values) in invites! {
                        let sentTo =  values["touserID"] as! String
                        if sentTo == uid {
                            
                            self.requestBtn.isEnabled = true
                            
                            let status = values["status"] as! String
                            
                            if status == "0" {
                                self.requestBtn.setTitle("Pending...", for: .normal)
                                self.requestBtn.isEnabled = false
                            } else if status == "1" {
                                self.requestBtn.setTitle("Accepted", for: .normal)
                                self.requestBtn.isEnabled = false
                            } else {
                                self.requestBtn.setTitle("Rejected", for: .normal)
                                self.requestBtn.isEnabled = false
                            }
                            
                            break;
                        }
                    }
                }
                
                
                Globals.HideSpinner()
            })
            
            ref.removeAllObservers()

            
        }
        
        
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
//        let seconds = (ti / 3600)
        return NSString(format: "%0.2d",ti)
    }
    
    
    @IBAction func imageTapped(_ sender: UIButton) {
//        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: flyerImageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        newImageView.isUserInteractionEnabled = true
        
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
    
    
    
    
}

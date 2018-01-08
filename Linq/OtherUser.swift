//
//  OtherUser.swift
//  Linq
//
//  Created by Quinton Askew on 6/3/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
// \(NSLocalizedString("", comment: ""))

import UIKit
import Firebase

var UserID = ""

class OtherUser: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    var firstName = ""
    var lastName = ""
    var age = ""
    var city = ""
    var gender = ""
    var state = ""
    var bioTextForOtherUser = ""
    var urlTextForOtherUser = ""
    var pathToImage = ""
    
    var arrayPosts = [Post]()
    var reported = Bool()
    var isPrivate = Bool()
    var isBlocked = Bool()
    
    @IBOutlet weak var blurBlocked: UIVisualEffectView!
    
    @IBOutlet weak var toolbarPickerView: UIView!
    @IBOutlet weak var viewBlurred: UIVisualEffectView!
    @IBOutlet weak var pickerview: UIPickerView!
    @IBOutlet weak var containerForData: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var BackprofileImageView: UIImageView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBAction func followUser(_ sender: Any)
    {
        Follow()
    }
    @IBOutlet weak var unfollowBtn: UIButton!
    @IBAction func unfollowUser(_ sender: Any)
    {
        UnFollow()
    }
    
    
    func Follow()
    {
        
        if self.isPrivate {
           
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
           
            let keyToPost = ref.child("Users").child(UserID)
            let commentsRef = keyToPost.child("FriendRequest").childByAutoId()
            
            let friendRequest = [
                "FromUserImage" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("urlToImage"),
                "fromUser" : uid,
                "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName")
                ] as [String : Any]
            
            commentsRef.setValue(friendRequest)

            self.followBtn.isEnabled = false
            self.followBtn.isHidden = true
            self.unfollowBtn.isHidden = false
            self.unfollowBtn.isEnabled = true
            
        } else {
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            let userId = UserID
            let keyToPost = ref.child("Users").child(uid)
            let commentsRef = keyToPost.child("Following").childByAutoId()
            commentsRef.setValue(userId)
            
            let post = ref.child("Users").child(userId)
            post.child("Followers").childByAutoId().setValue(uid)
            self.followBtn.isEnabled = false
            self.followBtn.isHidden = true
            self.unfollowBtn.isHidden = false
            self.unfollowBtn.isEnabled = true
        }
        
        
    }
    
    func UnFollow()
    {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        let profile = ref.child("Users").child(uid).child("Following")
        profile.observeSingleEvent(of : .value, with: { (snapshot) -> Void in
            
            let posts = snapshot.value as? [String : AnyObject]
            
            if posts != nil {
                for(key ,value) in posts! {
                    
                    if value as! String == UserID{
                        profile.child(key).removeValue()
                        
                        let profile1 = ref.child("Users").child(UserID).child("Followers")
                        
                        profile1.observeSingleEvent(of : .value, with: { (snapshot) -> Void in
                            
                            let posts1 = snapshot.value as? [String : AnyObject]
                            
                            if posts1 != nil {
                                for(key1,value1) in posts1! {
                                    
                                    if value1 as! String == uid {
                                        profile1.child(key1).removeValue()
                                        
                                        self.unfollowBtn.isEnabled = false
                                        self.unfollowBtn.isHidden = true
                                        self.followBtn.isHidden = false
                                        self.followBtn.isEnabled = true
                                    }
                                    
                                }
                                
                                profile.removeAllObservers()
                                profile1.removeAllObservers()
                                
                            } else {
                            }
                        })
                    } else  {
                    }
                }
            } else {
            }
        })
        
    }
    
    
    @IBOutlet var messageSwipe: UISwipeGestureRecognizer!
    @IBAction func swiped(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMessages", sender: self)
    }
    
    @IBOutlet var discoverSwipe: UISwipeGestureRecognizer!
    @IBAction func swipeToDiscover(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var followingSwipe: UISwipeGestureRecognizer!
    @IBAction func swipeToFollowing(_ sender: Any) {
        performSegue(withIdentifier: "unwindToFollowing", sender: self)
    }
    
    @IBOutlet var followersSwipe: UISwipeGestureRecognizer!
    @IBAction func swipeToFollowers(_ sender: Any) {
        performSegue(withIdentifier: "unwindToFollowers", sender: self)
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
       
        var settings = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            settings = UIAlertController(title: nil, message: nil, preferredStyle:.alert)
        }
        
        let messageAction = UIAlertAction(title:(NSLocalizedString("message", comment: "")), style: .default) { (action) in
            // Send go to message controller and prepare the message thread for this user.
            print("I want to send this user a message")
            
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
            chatLogController.navigationController?.navigationBar.barTintColor = UIColor.clear
            let user = User(dictionary: ["id": UserID as AnyObject, "name":self.firstName as AnyObject, "profileImageUrl" : self.pathToImage as AnyObject])
            chatLogController.user = user
            
            chatLogController.title = self.firstName + " " + self.lastName
            let backItem = UIBarButtonItem()
            backItem.title = ""
            chatLogController.navigationController?.navigationBar.tintColor = purp
            chatLogController.navigationItem.backBarButtonItem = backItem
            self.navigationController?.pushViewController(chatLogController,    animated: true)

//             self.performSegue(withIdentifier: "chatLog", sender: self)
            
        }
        
        let relations = UIAlertAction(title:(NSLocalizedString("relations", comment: "")), style: .default) { (action) in
            self.performSegue(withIdentifier: "seeRelations", sender: self)
//            print("I want to be nosey")
        }
        
        let report = UIAlertAction(title:(NSLocalizedString("report", comment: "")), style: .default) { (action) in
            // Call actionsheet
            self.reportActionSheet()
        }
        
        let block = UIAlertAction(title:(NSLocalizedString("block", comment: "")), style: .default) { (action) in
//            print("I want to block this user")
            self.blockUser()
        }
        
        let unblock = UIAlertAction(title:(NSLocalizedString("unblock", comment: "")), style: .default) { (action) in
            //            print("I want to unblock this user")
            self.unblockUser()
        }
        
        let invite = UIAlertAction(title:(NSLocalizedString("invite", comment: "")), style: .default) { (action) in
//            print("Would you like to attend your Jugg!")
            
            let ref = Database.database().reference()
            let uid = Auth.auth().currentUser?.uid
            
            self.pickerview.isHidden = false
            self.toolbarPickerView.isHidden = false
            
            ref.child("Flyers").queryOrderedByKey().observe( DataEventType.value, with: { snapshot in
                
                let posts = snapshot.value as! [String : AnyObject]
                self.arrayPosts.removeAll()
                for (_,value) in posts {
                    if let user = value["UserID"] as? String {
                        if uid == user {
                            
                            let newPost = Post()
                            
                            let capacity = value["Capacity"] as? Int
                            let date = value["Date"] as? String
                            let postID = value["PostID"] as? String
                            let movePrivate = value["Private"] as? Bool
                            let titleForEvent = value["NameOfMove"] as? String
                            let invites = value["Invites"]
                            let requests = value["Requests"]
                            let pathToImage = value["PathToImage"] as? String
                            let pathToUserImage = value["userImageUrl"] as? String
                            let AP = value["AP"] as? String
                            let time = value["Time"] as? String
                            
                            newPost.pathToImage = pathToImage
                            newPost.pathToUserImage = pathToUserImage
                            newPost.capacity = capacity
                            newPost.date = date
                            newPost.postID = postID
                            newPost.movePrivate = movePrivate
                            newPost.nameOfEvent = titleForEvent
                            newPost.userID = uid
                            newPost.invites = invites as? [String : Any]
                            newPost.requests = requests as? [String : Any]
                            newPost.AP = AP
                            newPost.time = time
                            
                            if newPost.capacity != 0 {
                                
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                                let dateTime = "\(newPost.date ?? "") \(newPost.time ?? "") \(newPost.AP ?? "")"
                                let postdate =  dateFormatter.date(from: dateTime)
                                
                                if postdate != nil {
                                    let elapsed = Date().timeIntervalSince(postdate!)
                                    let diff = self.stringFromTimeInterval(interval: elapsed)
                                    
                                    if diff.intValue <= 24
                                    {
                                        self.arrayPosts.append(newPost)
                                    }
                                }
                               
                            }
                        }
                    }
                }
                
                self.showPosts()
                
            });
            
            ref.removeAllObservers()

        }
    
        
        let cancel = UIAlertAction(title:(NSLocalizedString("cancel", comment: "")), style: .cancel) { (action) in
            print("Nevermind...")
        }
        
        settings.addAction(messageAction)
        settings.addAction(relations)
        
        if !self.reported {
            settings.addAction(report)
        }
        
        if self.isBlocked {
           settings.addAction(unblock)
        } else {
           settings.addAction(block)
        }
        
        settings.addAction(invite)
        settings.addAction(cancel)
        
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        settings.view.tintColor = purp
        self.navigationController!.present(settings, animated: true, completion: nil)

      
        
    }
//    [textField setCustomDoneTarget:self action:@selector(doneAction:)];
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let hours = (ti / 3600)
        return NSString(format: "%0.2d",hours)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let toolbar = UIToolbar()
//        toolbar.sizeToFit()
//        let done = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneSelecting(_:)))
//        toolbar.setItems([done], animated: false)
//        pickerview.addSubview(toolbar)
//        done.isEnabled = true
        pickerview.isHidden = true
        toolbarPickerView.isHidden = true
        
        blurBlocked.isHidden = true

        visuals()
    }

    
    
    
    func showPosts()
    {
        if (self.arrayPosts.count < 1) {
            // No posts are here
            self.pickerview.isHidden = true
            self.toolbarPickerView.isHidden = true
            let alert = UIAlertController(title: "Create a Private Jugg to Invite others.", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            let newJugg = UIAlertAction(title: "Create", style: .default) { (action) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newJugg = storyboard.instantiateViewController(withIdentifier: "NewMove") as? NewMove
                self.present(newJugg!, animated: true,
                                           completion: nil)
                
            }
            
            alert.addAction(cancel)
            alert.addAction(newJugg)
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            alert.view.tintColor = purp
            self.navigationController!.present(alert, animated: true, completion: nil)
        
            
        } else {
//            self.view.bringSubview(toFront: pickerview)
            pickerview.reloadComponent(0)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func setupProfile()
    {
        profileImageView.sd_setImage(with: URL(string: "\(String(describing: pathToImage))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        profileImage.sd_setImage(with: URL(string: "\(String(describing: pathToImage))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        
        let firstName = self.firstName
        let lastName = self.lastName
        let fullName = firstName + " " + lastName
        self.navigationItem.title = fullName
        ageLabel.text = age + ","
        let from = city + ", " + state
        fromLabel.text = from
        genderLabel.text = (NSLocalizedString(gender, comment: ""))
    
    }
    
    func visuals()
    {
        
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0).cgColor
        setupProfile()
        pickerview.isHidden = true
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = profileImageView.frame.size.width/2
        self.profileImageView.layer.borderWidth = 4
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        
        self.profileImage.clipsToBounds = true
        self.profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        self.profileImage.layer.borderWidth = 4
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.followBtn.layer.masksToBounds = true
        self.followBtn.layer.borderWidth = 2
        self.followBtn.layer.borderColor = purp
        self.followBtn.layer.cornerRadius = 8
       
        self.unfollowBtn.layer.masksToBounds = true
        self.unfollowBtn.layer.borderWidth = 2
        self.unfollowBtn.layer.borderColor = purp
        self.unfollowBtn.layer.cornerRadius = 8
        self.unfollowBtn.isHidden = true
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        ref.child("Users").child(uid).child("Block").observe(DataEventType.value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String : AnyObject]
            {
                for (_,value) in dictionary {
                    if value as! String == UserID {
                        self.isBlocked = true
                        return;
                    }
                }
            }
        })
        
        let childRef = ref.child("Users").child(UserID)
        
        if UserID == uid {
            self.followBtn.isHidden = true
            self.unfollowBtn.isHidden = true
        }
        
        childRef.observe(DataEventType.value, with: { (snapshot) in
          
            self.isPrivate = false
            self.followBtn.isHidden = false
            self.unfollowBtn.isHidden = true
            self.viewBlurred.isHidden = true
            self.unfollowBtn.isEnabled = true
            self.blurBlocked.isHidden = true
            
            if let dictionary = snapshot.value as? [String : AnyObject]
            {
                if let publicUser = dictionary["UserPrivate"] {
                    if publicUser as! Int == 1 {
                        self.viewBlurred.isHidden = false
                        self.isPrivate = true
                    }
                }
                
                if let reportArray = dictionary["peopleWhoReported"] as? [String:AnyObject] {
                    
                    for(_,value) in reportArray  {
                        if value as! String == uid  {
                            self.reported = true
                        }
                    }
                }
                
                if let reportArray = dictionary["FriendRequest"] as? [String:AnyObject] {
                    
                    for(_,value) in reportArray  {
                        if value["fromUser"] as! String == uid  {
                            self.followBtn.isHidden = true
                            self.unfollowBtn.isHidden = false
                            self.unfollowBtn.setTitle("Pending", for: .normal)
                            self.unfollowBtn.isEnabled = false
                        }
                    }
                }
                
                if let blockArray = dictionary["Block"] as? [String:AnyObject] {
                    
                    for(_,value) in blockArray  {
                        if value as! String == uid  {
                            self.blurBlocked.isHidden =  false
                            self.navigationItem.rightBarButtonItem = nil
                            return
                        }
                    }
                }
            }
            
            childRef.child("Followers").observe(DataEventType.value, with: { (snapshot1) in
                if let followingUsers = snapshot1.value as? [String : AnyObject] {
                    
                    let arrayValues = Array(followingUsers.values) as! [String]
                    
                    if arrayValues.contains(uid) {
                        self.followBtn.isHidden = true
                        self.unfollowBtn.isHidden = false
                        self.viewBlurred.isHidden = true
                    }
                }
            });
            
            if UserID == uid {
                self.followBtn.isHidden = true
                self.unfollowBtn.isHidden = true
            }
            
            
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
    
        return self.arrayPosts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        return self.arrayPosts[row].nameOfEvent
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = self.arrayPosts[row].nameOfEvent
        return NSAttributedString(string: str!, attributes: [NSForegroundColorAttributeName:UIColor(cgColor: purp)])
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        
        pickerview.isHidden = true
        toolbarPickerView.isHidden = true
    }
    
    @IBAction func actionDone(_ sender: Any) {
        pickerview.isHidden = true
        toolbarPickerView.isHidden = true
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        if self.arrayPosts[pickerview.selectedRow(inComponent: 0)].requests == nil {
            
        } else {
            let dict : [String:AnyObject] =  self.arrayPosts[pickerview.selectedRow(inComponent: 0)].requests! as [String : AnyObject]
            
            var exist : Bool = false
            for (_,value) in dict {
                print(value)
                let user = value.value(forKey: "touserID") as! String
                if user == uid {
                    if UserID == value.value(forKey: "from") as! String {
                        if self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID == value.value(forKey: "postID") as! String {
                            exist = true
                            
                            break
                        }
                    }
                    
                }
            }
            
            if exist {
                
                let event = self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent
                let alert = UIAlertController(title: "\(firstName)\(NSLocalizedString("requestAlready", comment: ""))\(event!).", message: nil, preferredStyle: .alert)
                let confirm = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) in
                }
                
                alert.addAction(confirm)
                let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                alert.view.tintColor = purp
                self.navigationController!.present(alert, animated: true, completion: nil)
                return;
                
            }
        }
        
        if self.arrayPosts[pickerview.selectedRow(inComponent: 0)].invites == nil {
            let keyToPost = ref.child("Users").child(UserID)
            let commentsRef = keyToPost.child("Invites").childByAutoId()
            let invite = [
                "fromuserImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToUserImage!,
                "flyerImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToImage!,
                "from" : uid,
                "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName"),
                "touserID" : UserID,
                "touserName" : "\(firstName) \(lastName)",
                "touserImagePath" : pathToImage,
                "eventName" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent,
                "postID" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID,
                "status" : "0",
                "postDate": "\(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].date ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].time ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].AP ?? "")"
                
                ] as [String : Any]
            
            commentsRef.setValue(invite)
            
            let keyToPost1 = ref.child("Flyers").child(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID)
            let commentsRef1 = keyToPost1.child("Invites").childByAutoId()
            
            let invite1 = [
                "fromuserImagePath" :self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToUserImage!,
                "flyerImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToImage!,
                "from" : uid,
                "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName"),
                "touserID" : UserID,
                "touserName" : "\(firstName) \(lastName)",
                "touserImagePath" : pathToImage,
                "eventName" :self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent,
                "postID" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID,
                "status" : "0",
                "postDate": "\(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].date ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].time ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].AP ?? "")"
                
                ] as [String : Any]
            
            commentsRef1.setValue(invite1)
            
            let event = self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent
            let alert = UIAlertController(title: "\(NSLocalizedString("inviteSent1", comment: ""))\(event!)\(NSLocalizedString("inviteSent2", comment: ""))", message: nil, preferredStyle: .alert)
            let confirm = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) in
                // self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(confirm)
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            alert.view.tintColor = purp
            self.navigationController!.present(alert, animated: true, completion: nil)
            
        } else {
            // print(self.arrayPosts[row].requests)
            
            let dict : [String:AnyObject] = self.arrayPosts[pickerview.selectedRow(inComponent: 0)].invites! as [String : AnyObject]
            
            var exist : Bool = false
            for (_,value) in dict {
                print(value)
                let user = value.value(forKey: "from") as! String
                if user == uid {
                    if UserID == value.value(forKey: "touserID") as! String {
                        if self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID == value.value(forKey: "postID") as! String {
                            exist = true
                            
                            break
                        }
                    }
                    
                }
            }
            
            if exist {
                
                let event = self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent
                let alert = UIAlertController(title: "\(NSLocalizedString("inviteAlready1", comment: ""))\(event!)\(NSLocalizedString("inviteAlready2", comment: ""))", message: nil, preferredStyle: .alert)
                let confirm = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) in
                }
                
                alert.addAction(confirm)
                let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                alert.view.tintColor = purp
                self.navigationController!.present(alert, animated: true, completion: nil)
                
            } else {
                let keyToPost = ref.child("Users").child(UserID)
                let commentsRef = keyToPost.child("Invites").childByAutoId()
                let invite = [
                    "fromuserImagePath" :self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToUserImage!,
                    "flyerImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToImage!,
                    "from" : uid,
                    "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName"),
                    "touserID" : UserID,
                    "touserName" : "\(firstName) \(lastName)",
                    "touserImagePath" : pathToImage,
                    "eventName" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent,
                    "postID" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID,
                    "status" : "0",
                    "postDate": "\(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].date ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].time ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].AP ?? "")"
                    ] as [String : Any]
                
                commentsRef.setValue(invite)
                
                let keyToPost1 = ref.child("Flyers").child(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID)
                let commentsRef1 = keyToPost1.child("Invites").childByAutoId()
                
                let invite1 = [
                    "fromuserImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToUserImage!,
                    "flyerImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToImage!,
                    "from" : uid,
                    "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName"),
                    "touserID" : UserID,
                    "touserName" : "\(firstName) \(lastName)",
                    "touserImagePath" : pathToImage,
                    "eventName" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent,
                    "postID" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID,
                    "status" : "0",
                    "postDate": "\(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].date ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].time ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].AP ?? "")"
                    ] as [String : Any]
                
                commentsRef1.setValue(invite1)
                let event = self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent
                let alert = UIAlertController(title: "\(NSLocalizedString("inviteSent1", comment: ""))\(event!)\(NSLocalizedString("inviteSent2", comment: ""))", message: nil, preferredStyle: .alert)
                let confirm = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) in
                    // self.navigationController?.popViewController(animated: true)
                }
                
                alert.addAction(confirm)
                let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                alert.view.tintColor = purp
                self.navigationController!.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    @IBAction func imageTapped(_ sender: UITapGestureRecognizer)
    {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
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
    
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer)
    {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }

    func unblockUser() {
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        let keyToPost = ref.child("Users").child(uid).child("Block")
       
        keyToPost.observeSingleEvent(of: .value, with: { (snapShot) in
            if let dictionary = snapShot.value as? [String : AnyObject]
            {
                for (key,value) in dictionary {
                    
                    if value as? String == UserID {
                        ref.child("Users").child(uid).child("Block").child(key).removeValue()
                        self.isBlocked = false
                    }
                }
            }
        })
        
    }
    
    func blockUser() {
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        let keyToPost = ref.child("Users").child(uid)
        let commentsRef = keyToPost.child("Block").childByAutoId()
        commentsRef.setValue(UserID)
        self.isBlocked = true
        
        ref.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let followings = dict["Following"] as? [String:AnyObject]
                let followers = dict["Followers"] as? [String:AnyObject]
                
                if followings != nil {
                    for (key , value) in followings! {
                        if value as! String == UserID {
                            ref.child("Users").child(uid).child("Following").child(key).removeValue()
                            
                            let profile1 = ref.child("Users").child(UserID).child("Followers")
                            profile1.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                                let posts1 = snapshot.value as? [String : AnyObject]
                                
                                if posts1 != nil {
                                    for(key1,value1) in posts1! {
                                        
                                        if value1 as! String == uid {
                                            profile1.child(key1).removeValue()
                                        }
                                        
                                    }
                                }

                            })
                        }
                    }
                }
                
                if followers != nil {
                    for (key , value) in followers! {
                        if value as! String == UserID {
                            ref.child("Users").child(uid).child("Followers").child(key).removeValue()
                            
                            let profile1 = ref.child("Users").child(UserID).child("Following")
                            profile1.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                                let posts1 = snapshot.value as? [String : AnyObject]
                                
                                if posts1 != nil {
                                    for(key1,value1) in posts1! {
                                        
                                        if value1 as! String == uid {
                                            profile1.child(key1).removeValue()
                                        }
                                        
                                    }
                                }
                                
                            })
                            
                        }
                    }
                }
            }
            
        })
        
    }
    
    func reportActionSheet() {
        let reportActionSheet = UIAlertController(title: "Report", message: nil, preferredStyle: .actionSheet)
        let spam = UIAlertAction(title: "Spam", style: .default) { (action) in
            
            let ref = Database.database().reference()
            let keyToPost = ref.child("Users").childByAutoId().key
            
            ref.child("Users").child(UserID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.value as? [String : AnyObject]) != nil {
                    let updateLikes: [String : Any] = ["peopleWhoReported/\(keyToPost)" : Auth.auth().currentUser!.uid]
                    ref.child("Users").child(UserID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                        
                        self.reported = true
                        
                        if error == nil {
                            ref.child("Users").child(UserID).observeSingleEvent(of: .value, with: { (snap) in
                                if let properties = snap.value as? [String : AnyObject] {
                                    if let reported = properties["peopleWhoReported"] as? [String : AnyObject] {
                                        
                                        let count = reported.count
                                        
                                        let alertThanks = UIAlertController(title: "User Reported!", message: "Thank you for reporting the user you found as spam. We will advise.", preferredStyle: .alert)
                                        
                                        let cancelThanks = UIAlertAction(title: "Ok", style: .cancel) { (void) in
                                            
                                        }
                                        
                                        alertThanks.addAction(cancelThanks)
                                        
                                        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                                        alertThanks.view.tintColor = purp
                                        self.present(alertThanks, animated: true, completion: nil)
                                        
                                        if count >= 50 {
                                            
                                        }
                                    }
                                }
                            })
                        }
                    })
                }
            })
            
        }
        
        let inappropriate = UIAlertAction(title: "Inappropriate", style: .default) { (action) in
            
            // Add inaproppropriate
            let ref = Database.database().reference()
            let keyToPost = ref.child("Users").childByAutoId().key
            
            ref.child("Users").child(UserID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.value as? [String : AnyObject]) != nil {
                    let updateLikes: [String : Any] = ["peopleWhoReported/\(keyToPost)" : Auth.auth().currentUser!.uid]
                    ref.child("Users").child(UserID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                        
                        self.reported = true
                        
                        if error == nil {
                            ref.child("Users").child(UserID).observeSingleEvent(of: .value, with: { (snap) in
                                if let properties = snap.value as? [String : AnyObject] {
                                    if let reported = properties["peopleWhoReported"] as? [String : AnyObject] {
                                        
                                        let count = reported.count
                                        
                                        let alertThanks = UIAlertController(title: "User Reported!", message: "Thank you for reporting the user you found as spam. We will advise.", preferredStyle: .alert)
                                        
                                        let cancelThanks = UIAlertAction(title: "Ok", style: .cancel) { (void) in
                                            
                                        }
                                        
                                        alertThanks.addAction(cancelThanks)
                                        
                                        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                                        alertThanks.view.tintColor = purp
                                        self.present(alertThanks, animated: true, completion: nil)
                                        
                                        if count >= 50 {
                                            
                                        }
                                    }
                                }
                            })
                        }
                    })
                }
            })
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
    
        reportActionSheet.addAction(spam)
        reportActionSheet.addAction(inappropriate)
        reportActionSheet.addAction(cancel)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        reportActionSheet.view.tintColor = purp
        self.navigationController!.present(reportActionSheet, animated: true, completion: nil)
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
        if segue.identifier == "seeRelations" {
            if segue.destination is Relations {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                UserIdRelations = UserID
                navigationItem.backBarButtonItem = backItem
            }
        }
        
        
//        if segue.identifier == "chatLog" {
//            if segue.destination is ChatLogController {
//                
//                let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
//                let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
//                chatLogController.navigationController?.navigationBar.barTintColor = UIColor.clear
//                let user = User(dictionary: ["id": UserID as AnyObject, "name":self.firstName as AnyObject, "profileImageUrl" : self.pathToImage as AnyObject])
//                chatLogController.user = user
//                
//                chatLogController.title = self.firstName + " " + self.lastName
//                let backItem = UIBarButtonItem()
//                backItem.title = ""
//                navigationController?.navigationBar.tintColor = purp
//                navigationItem.backBarButtonItem = backItem
//            }
//        }

        
        
        
//
//        //            let nav = UINavigationController.init(rootViewController: chatLogController)
//        
//        chatLogController.navigationController?.navigationBar.tintColor = purp
//        //            nav.navigationController?.navigationBar.tintColor = purp
        
//        //            nav.navigationController?.isNavigationBarHidden = false
//        //            self.present(nav , animated: true, completion: nil)
//        
//        
//        chatLogController.navigationItem.backBarButtonItem = backItem
//        self.navigationController?.pushViewController(chatLogController, animated: true)
        
        
    }
    

}

//
//  DiscoverTable.swift
//  Linq
//
//  Created by Quinton Askew on 5/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import GoogleMobileAds
import MapKit
import KVNProgress
import CoreLocation

class DiscoverTable: UITableViewController, UIGestureRecognizerDelegate, GADNativeExpressAdViewDelegate, MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate {
    
    var users = [AnyObject]()
    var locationArray = [CLLocationCoordinate2D]()
    
    var userDistance = Double()
    var adInterval = 8 // How Often To Display Ad **** 8 on release *****
    var adViewWidth = CGFloat()
    var adViewHieght = CGFloat()

    var locationManager = CLLocationManager()
    
        var userLats : CLLocationDegrees = 0.00
    var userLong : CLLocationDegrees = 0.00
    
    // Mani
    @IBOutlet weak var searchUsersBar: UISearchBar!
    var loadTableView = "feedListing"
    var usersListForSearch = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cellHeightForDevice()
        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isHidden = true
        
        self.tableView.allowsSelection = false
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Users...")
        refreshControl?.addTarget(self, action: #selector(DiscoverTable.retrieveUsers), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!) // not required when using UITableViewController
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        locationManager.delegate = (self as CLLocationManagerDelegate)
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        userDistance = 100
        
         self.perform(#selector(self.retrieveUsers), with: nil, afterDelay: 0.8)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(recognizer:)))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.tableView.addGestureRecognizer(tap)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.tableView.addGestureRecognizer(swipeRight)
        
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadTableView = "feedListing"
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadTableView = "feedListing"
        self.view.endEditing(true)
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        if  (searchBar.text?.count)! > 0 {
            
            usersListForSearch = self.users.filter() {
                if let type = $0 as? User {
                    return type.firstName.localizedCaseInsensitiveContains(searchBar.text!)
                } else {
                    return false
                }
            }
            
            loadTableView = "searchUser"
            self.tableView.reloadData()
            
        }
        
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        usersListForSearch = self.users.filter() {
            if let type = $0 as? User {
                return type.firstName.localizedCaseInsensitiveContains(searchText)
            } else {
                return false
            }
        }
        loadTableView = "searchUser"
        self.tableView.reloadData()
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        loadTableView = "feedListing"
        self.tableView.reloadData()
        self.view.endEditing(true)
    }

    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                if gesture.state == UIGestureRecognizerState.ended {
                    
                    let tapLocation = gesture.location(in: self.tableView)
                    if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                        if (self.tableView.cellForRow(at: tapIndexPath) as? CellForDiscover) != nil {
                            
                            //do what you want to cell here
                            let uid = Auth.auth().currentUser!.uid
                            let ref = Database.database().reference()
                            
                            
                            //                    KVNProgress.show(0.50, status: "Updating..")
                            
                            
                            if let userItem = self.users[tapIndexPath.row] as? User {
                                
                                if let value = userItem.privateUser {
                                    if value == true {
                                        if userItem.friendrequest == nil {
                                            let uid = Auth.auth().currentUser!.uid
                                            let ref = Database.database().reference()
                                            
                                            let keyToPost = ref.child("Users").child(userItem.userID!)
                                            let commentsRef = keyToPost.child("FriendRequest").childByAutoId()
                                            
                                            let friendRequest = [
                                                "FromUserImage" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("urlToImage"),
                                                "fromUser" : uid,
                                                "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName")
                                                ] as [String : Any]
                                            
                                            commentsRef.setValue(friendRequest)
                                           
                                            self.retrieveUsers()
                                            
                                        } else {
                                            let reportArray  : [String:AnyObject] =  userItem.friendrequest
                                            
                                            for(_,value) in reportArray  {
                                                if value["fromUser"] as! String == uid  {
                                                    let alert = UIAlertController(title: "You have requested to follow \(userItem.firstName ?? "")", message: nil, preferredStyle: .alert)
                                                    let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
                                                        
                                                    }
                                                    
                                                    alert.addAction(confirm)
                                                    let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                                                    alert.view.tintColor = purp
                                                    self.navigationController!.present(alert, animated: true, completion: nil)
                                                    return;
                                                }
                                            }
                                            
                                            
                                            let uid = Auth.auth().currentUser!.uid
                                            let ref = Database.database().reference()
                                            
                                            let keyToPost = ref.child("Users").child(userItem.userID!)
                                            let commentsRef = keyToPost.child("FriendRequest").childByAutoId()
                                            
                                            let friendRequest = [
                                                "FromUserImage" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("urlToImage"),
                                                "fromUser" : uid,
                                                "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName")
                                                ] as [String : Any]
                                            
                                            commentsRef.setValue(friendRequest)
                                            self.retrieveUsers()
                                        }
                                        
                                    }
                                    else {
                                        if ((userItem.follower) != nil) {
                                            let dict  : [String:AnyObject] =  userItem.follower
                                            
                                            let values = Array(dict.values) as! [String]
                                            
                                            //cellForDiscover.followBtn.tag = indexPath.row
                                            
                                            if values.contains(uid) {
                                                //                            let uid = Auth.auth().currentUser!.uid
                                                //                            let ref = Database.database().reference()
                                                let userId = userItem.userID
                                                
                                                let profile = ref.child("Users").child(uid).child("Following")
                                                profile.observe(.value, with: { (snapshot) -> Void in
                                                    
                                                    let posts = snapshot.value as? [String : AnyObject]
                                                    
                                                    if posts != nil {
                                                        for(key ,value) in posts! {
                                                            
                                                            if value as! String == userId!{
                                                                profile.child(key).removeValue()
                                                                
                                                                let profile1 = ref.child("Users").child(userId!).child("Followers")
                                                                
                                                                profile1.observe(.value, with: { (snapshot) -> Void in
                                                                    
                                                                    let posts1 = snapshot.value as? [String : AnyObject]
                                                                    
                                                                    if posts1 != nil {
                                                                        for(key1,value1) in posts1! {
                                                                            
                                                                            if value1 as! String == uid {
                                                                                profile1.child(key1).removeValue()
                                                                            }
                                                                        }
                                                                        
                                                                        //                     KVNProgress.showSuccess()
                                                                        
                                                                        profile.removeAllObservers()
                                                                        profile1.removeAllObservers()
                                                                        
                                                                        self.retrieveUsers()
                                                                    } else {
                                                                        //                                                        KVNProgress.showError()
                                                                    }
                                                                })
                                                            }
                                                        }
                                                    } else {
                                                        //                                        KVNProgress.showError()
                                                    }
                                                })
                                            } else {
                                                let userId = userItem.userID
                                                
                                                let keyToPost = ref.child("Users").child(uid)
                                                
                                                let commentsRef = keyToPost.child("Following").childByAutoId()
                                                
                                                commentsRef.setValue(userId as Any)
                                                
                                                let post = ref.child("Users").child(userId!)
                                                post.child("Followers").childByAutoId().setValue(uid)
                                                //                                KVNProgress.showSuccess()
                                                
                                                retrieveUsers()
                                            }
                                        } else {
                                            let userId = userItem.userID
                                            
                                            let keyToPost = ref.child("Users").child(uid)
                                            
                                            let commentsRef = keyToPost.child("Following").childByAutoId()
                                            
                                            commentsRef.setValue(userId as Any)
                                            
                                            let post = ref.child("Users").child(userId!)
                                            post.child("Followers").childByAutoId().setValue(uid)
                                            retrieveUsers()
                                        }
                                    }
                                    
                                } else {
                                    if ((userItem.follower) != nil) {
                                        let dict  : [String:AnyObject] =  userItem.follower
                                        
                                        let values = Array(dict.values) as! [String]
                                        
                                        //cellForDiscover.followBtn.tag = indexPath.row
                                        
                                        if values.contains(uid) {
                                            //                            let uid = Auth.auth().currentUser!.uid
                                            //                            let ref = Database.database().reference()
                                            let userId = userItem.userID
                                            
                                            let profile = ref.child("Users").child(uid).child("Following")
                                            profile.observe(.value, with: { (snapshot) -> Void in
                                                
                                                let posts = snapshot.value as? [String : AnyObject]
                                                
                                                if posts != nil {
                                                    for(key ,value) in posts! {
                                                        
                                                        if value as! String == userId!{
                                                            profile.child(key).removeValue()
                                                            
                                                            let profile1 = ref.child("Users").child(userId!).child("Followers")
                                                            
                                                            profile1.observe(.value, with: { (snapshot) -> Void in
                                                                
                                                                let posts1 = snapshot.value as? [String : AnyObject]
                                                                
                                                                if posts1 != nil {
                                                                    for(key1,value1) in posts1! {
                                                                        
                                                                        if value1 as! String == uid {
                                                                            profile1.child(key1).removeValue()
                                                                        }
                                                                    }
                                                                    
                                                                    //                                                        KVNProgress.showSuccess()
                                                                    profile.removeAllObservers()
                                                                    profile1.removeAllObservers()
                                                                    
                                                                    self.retrieveUsers()
                                                                } else {
                                                                    //                                                        KVNProgress.showError()
                                                                }
                                                            })
                                                        }
                                                    }
                                                } else {
                                                    //                                        KVNProgress.showError()
                                                }
                                            })
                                        } else {
                                            let userId = userItem.userID
                                            
                                            let keyToPost = ref.child("Users").child(uid)
                                            
                                            let commentsRef = keyToPost.child("Following").childByAutoId()
                                            
                                            commentsRef.setValue(userId as Any)
                                            
                                            let post = ref.child("Users").child(userId!)
                                            post.child("Followers").childByAutoId().setValue(uid)
                                            //                                KVNProgress.showSuccess()
                                            retrieveUsers()
                                        }
                                    } else {
                                        let userId = userItem.userID
                                        
                                        let keyToPost = ref.child("Users").child(uid)
                                        
                                        let commentsRef = keyToPost.child("Following").childByAutoId()
                                        
                                        commentsRef.setValue(userId as Any)
                                        
                                        let post = ref.child("Users").child(userId!)
                                        post.child("Followers").childByAutoId().setValue(uid)
                                        retrieveUsers()
                                    }
                                }
                            } else {
                                //                        KVNProgress.showError()
                            }
                            
                            
                            
                            
                            
                            
                        }
                    }
                }
                
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    func doubleTapped(recognizer: UITapGestureRecognizer) {

        if recognizer.state == UIGestureRecognizerState.ended {
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                if (self.tableView.cellForRow(at: tapIndexPath) as? CellForDiscover) != nil {
                    let selectUser = self.users[tapIndexPath.row] as! User
                    showUsersProfile(selectUser)
                }
                else{
                    if (self.tableView.cellForRow(at: tapIndexPath)) != nil {
                        if loadTableView == "searchUser" {
                            let selectUser = self.usersListForSearch[tapIndexPath.row] as! User
                            showUsersProfile(selectUser)
                        }
                    }
                }
            }
        }

    }
    
    
    
    func retrieveUsers() {
        
        Globals.ShowSpinner(testStr: "")
       
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        ref.child("Users").child(uid).child("Distance_Discover").observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
            
            if let distance = snapShot.value as? String {
                self.userDistance = Double(distance)!
            } else {
                self.userDistance = 100.00
            }
            
        })
        ref.child("Users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            self.users.removeAll()
            self.locationArray.removeAll()
            for(_, value) in users {
                
                if let uid = value["UID"] as? String {
                    if uid != Auth.auth().currentUser!.uid {
                        let dict = [String : AnyObject]()
                        let userToShow = User(dictionary:dict)
                        if let userID = value["UID"] as? String {
                            
                            let firstName = value["FirstName"] as? String
                            let lastName = value["LastName"] as? String
                            let age = value["Age"] as? String
                            let city = value["City"] as? String
                            let gender = value["Gender"] as? String
                            let state = value["State"] as? String
                            let bio = value["Bio"] as? String
                            let followers = value["Followers"] as? [String: AnyObject]
                            let following = value["Following"] as? [String: AnyObject]
                            let friendRequest = value["FriendRequest"] as? [String:AnyObject]
                            let imagePath = value["urlToImage"] as? String
                            let userPrivate = value["UserPrivate"] as? Bool
                            
                            let location = value["Location"] as? [String:CLLocationDegrees]
                            
                            userToShow.userID = userID
                            userToShow.firstName = firstName
                            userToShow.lastName = lastName
                            userToShow.age = age
                            userToShow.bio = bio
                            userToShow.city = city
                            userToShow.gender = gender
                            userToShow.state = state
                            userToShow.imagePath = imagePath
                            userToShow.follower = followers
                            userToShow.following = following
                            userToShow.friendrequest = friendRequest
                            userToShow.privateUser = userPrivate
                            
                            if location != nil {
                                let newLatitude =  location?["Latitude"]
                                let newLongitude = location?["Longitude"]
                                
                                let eventLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(newLatitude ?? 0.00, newLongitude ?? 0.00)
                                let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.userLats, longitude: self.userLong)
                                
                                let farway = self.getDistance(from: location, to: eventLocation) * 0.000621371192
                                if farway <= self.userDistance {
                                    self.users.append(userToShow)
                                }
                                
                            }
                            
                            
                        }
                    }
                
                }
            }
            
            Globals.HideSpinner()
            self.users.shuffle()
            self.addAdsToDiscoverTable()
            self.tableView.reloadData()
        })
        ref.removeAllObservers()
        
        self.refreshControl?.endRefreshing()
        self.refreshControl?.isUserInteractionEnabled = true
    }
    
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
    func addAdsToDiscoverTable()
    {
        var index = 0
        let size = GADAdSizeFromCGSize(CGSize(width: adViewWidth, height: adViewHieght))
        while index < users.count {
            let adView = GADNativeExpressAdView(adSize: size)
            adView?.adUnitID = "ca-app-pub-2288924893490965/9283283023"
            // Real Ad: "ca-app-pub-3940256099942544/8897359316"
            adView?.rootViewController = self
            adView?.delegate = self
            adView?.load(GADRequest())
            users.insert(adView!, at: index)
            index += adInterval
            
        }
    }
    

    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        userLats = (manager.location?.coordinate.latitude)!
        userLong = (manager.location?.coordinate.longitude)!
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if loadTableView == "feedListing" {
            return users.count
        }else{
            return usersListForSearch.count
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if loadTableView == "searchUser" {
            return 40.00
        }else{
            return 573.00
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if loadTableView == "feedListing" {
            if let userItem = users[indexPath.row] as? User {
                
                let cellForDiscover = tableView.dequeueReusableCell(withIdentifier: "cellForDiscover", for: indexPath) as! CellForDiscover
                
                cellForDiscover.nameLabel.text = userItem.firstName + " " + userItem.lastName
                
                cellForDiscover.fromLabel.text = userItem.city + ", " + userItem.state
                
                cellForDiscover.userID = userItem.userID
                
                cellForDiscover.profilePic.sd_setImage(with: URL(string: "\(String(describing: userItem.imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
                
                cellForDiscover.tag = indexPath.row
                
                let uid = Auth.auth().currentUser!.uid
                
                if ((userItem.follower) != nil) {
                    let dict  : [String:AnyObject] =  userItem.follower
                    
                    let values = Array(dict.values) as! [String]
                    
                    //cellForDiscover.followBtn.tag = indexPath.row
                    
                    if values.contains(uid) {
                        cellForDiscover.followingTrueImageView.isHidden = false
                    } else {
                        cellForDiscover.followingTrueImageView.isHidden = true
                    }
                } else {
                    cellForDiscover.followingTrueImageView.isHidden = true
                }
                
                if (userItem.following != nil) {
                    let dict  : [String:AnyObject] =  userItem.following
                    
                    let values = Array(dict.values) as! [String]
                    
                    //cellForDiscover.followBtn.tag = indexPath.row
                    
                    if values.contains(uid) {
                        cellForDiscover.followMeTrueImageView.isHidden = false
                    } else {
                        cellForDiscover.followMeTrueImageView.isHidden = true
                    }
                } else {
                    cellForDiscover.followMeTrueImageView.isHidden = true
                }
                
                return cellForDiscover
                
            } else {
                
                let adView = users[indexPath.row] as? GADNativeExpressAdView
                
                let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: "DiscoverNativeAd", for: indexPath)
                
                for subview in reusableAdCell.contentView.subviews {
                    subview.removeFromSuperview()
                }
                
                reusableAdCell.contentView.addSubview(adView!)
                adView?.center = reusableAdCell.contentView.center
                return reusableAdCell
            }
        }
        else{
            let searchResult = usersListForSearch[indexPath.row] as! User
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            let fn = searchResult.firstName
            let ln = searchResult.lastName
            let fullName = fn! + " " + ln!
            let city = searchResult.city
            let state = searchResult.state
            let from = city! + ", " + state!
            cell.textLabel?.text = fullName
            cell.detailTextLabel?.text = from
            return cell
        }
        
    }
    
    
  
    
    ////// SETUP FOLLOWING ANG FOLLOWERS IMAGES IN CELL WITH FOLLOW USER FUNCTION. (DOUBLE TAP TO FOLLOW) //////
    ////// SINGLE TAP - 12/13/17 3:20 A.M
    
    
    func showUsersProfile(_ userItem : User) {
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
        let navController = UINavigationController(rootViewController: vc)
        
            UserID = userItem.userID!
            let firstName = userItem.firstName
            let lastName = userItem.lastName
            vc.firstName = firstName!
            vc.lastName = lastName!
            vc.age = userItem.age
            vc.city = userItem.city
            vc.state = userItem.state
            vc.gender = userItem.gender
            vc.pathToImage = userItem.imagePath
            vc.bioTextForOtherUser = userItem.bio
            
            vc.urlTextForOtherUser = "No URL Available."
            vc.discoverSwipe.isEnabled = true
            vc.followersSwipe.isEnabled = false
            vc.followingSwipe.isEnabled = false
            self.present(navController, animated: true, completion: nil)
        
    }
    

    
    @IBAction func unwindToDiscover(segue:UIStoryboardSegue) { }
    
    
    func alertForFollowStatus(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func cellHeightForDevice() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.tableView.rowHeight = 800
            self.adViewWidth = 500
            self.adViewHieght = 800
        }
        else {
            self.tableView.rowHeight = 573
            self.adViewWidth = 375
            self.adViewHieght = 573
        }
    }
    
    
    
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    //}
    
}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: (URL(string: imgURL))!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}



extension MutableCollection where Index == Int {
    mutating func shuffle() {
        if count < 1 { return }
        for i in startIndex ..< endIndex - 1 {
            let j = Int(arc4random_uniform(UInt32(endIndex - i))) + i
            if i != j {
                swap(&self[i],&self[j])
            }
        }
    }
}



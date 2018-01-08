//
//  MovesTable.swift
//  Linq
//
//  Created by Quinton Askew on 5/26/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import GoogleMobileAds
import CoreLocation

let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0).cgColor

var postToArchive = [Post]()

var timeAsString: String!

class MovesTable: UITableViewController, GADNativeExpressAdViewDelegate,CLLocationManagerDelegate {
    
  

    var followers = [String]()
    var blocked = [String]()
    var locationManager = CLLocationManager()
    var userLats : CLLocationDegrees = 0.00
    var userLong : CLLocationDegrees = 0.00
    
    var commentsAray = [CommentObj]()
    var posts = [AnyObject]()
    
    var postsArchive = [Post]()
    var following = [String]()
    var adsToLoad = [GADNativeExpressAdView]()
    var adInterval = 6 // How Often To Display Ad **** 6 on release *****
    let adViewWidth = CGFloat(375)
    let adViewHieght = CGFloat(553)
    
    override func viewWillDisappear(_ animated: Bool) {
        addressFromAutoComplete = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Globals.ShowSpinner(testStr: "")
        fetchFollowers()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager.delegate = (self as CLLocationManagerDelegate)
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()

        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = UIColor.clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("JUGGS", for: .normal)
        button.addTarget(self, action: #selector(self.topOfTableView), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        
      
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Finding Juggs")
        refreshControl?.addTarget(self, action: #selector(MovesTable.fetchFollowers), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!) // not required when using UITableViewController
        
    }
    
    
    
    
    func addAdsToJuggTable()
    {
        var index = 0
        let size = GADAdSizeFromCGSize(CGSize(width: adViewWidth, height: adViewHieght))
        while index < posts.count {
            let adView = GADNativeExpressAdView(adSize: size)
            adView?.adUnitID = "ca-app-pub-2288924893490965/4004300565"
            //  Test ad: "ca-app-pub-3940256099942544/8897359316"
            adView?.rootViewController = self
            adView?.delegate = self
            adView?.load(GADRequest())
            posts.insert(adView!, at: index)
            index += adInterval
            
        }
    }
    
    func fetchFollowers() {
        
        let ref = Database.database().reference()
        let userID : String = (Auth.auth().currentUser?.uid)!
        
        let childRef = ref.child("Users").child(userID)
        
        childRef.child("Following").observeSingleEvent(of: .value, with: { (snapshot) in
            if let followingUsers = snapshot.value as? [String : AnyObject] {
                for(_, value) in followingUsers {
                    self.followers.append(value as! String)
                }
            }
            childRef.child("Block").observeSingleEvent(of: .value, with: { (snap) in
                if let blockedUsers = snap.value as? [String : AnyObject] {
                    for(_, value) in blockedUsers {
                        self.blocked.append(value as! String)
                    }
                }
//                self.fetchPosts()
                self.perform(#selector(self.fetchPosts), with: nil, afterDelay: 1.5)
            })
            
        })
        
    }
    
  
    func fetchPosts() {
        refreshControl?.isUserInteractionEnabled = false
        let ref = Database.database().reference()
        
        ref.child("Flyers").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let posts = snapshot.value as! [String : AnyObject]
            self.posts.removeAll()
            
            for(_,value) in posts {
                if let userID = value["UserID"] as? String {
                    //  for each in self.following {
                    // if each == userID {
                    if self.blocked.contains(userID) {
                        continue
                    }
                
                    let newPost = Post()
                    let AP = value["AP"] as? String
                    let address = value["Address"] as? String
                    let author = value["Author"] as? String
                    let capacity = value["Capacity"] as? Int!
                    let CapacityCount = value["CapacityCount"] as? Int!
                    let date = value["Date"] as? String
                    let description = value["Description"] as? String
                    let likes = value["Likes"] as? Int!
                    let flameCount = value["FlameCount"] as? Int!
                    let pathToImage = value["PathToImage"] as? String
                    let postID = value["PostID"] as? String
                    let movePrivate = value["Private"] as? Bool
                    let time = value["Time"] as? String
                    let latitude = value["latitude"] as? Double
                    let longitude = value["longitude"] as? Double
                    let titleForEvent = value["NameOfMove"] as? String
                    let pathToUserImage = value["userImageUrl"] as? String
                    
                    let liked = value["peopleWhoLiked"] as? [String:AnyObject]

                    var likedArray = [String]()
                    
                    if liked != nil {
                        
                        for(_,value) in liked! {
                            likedArray.append(value as! String)
                        }
                    }
                    
                    
                    let juggs = value["peopleWhoLinqed"] as? [String:AnyObject]
                    
                    var juggsArray = [String]()
                    
                    if juggs != nil {
                        
                        for(_,value) in juggs! {
                            juggsArray.append(value as! String)
                        }
                    }
                    
                    let comments = value["post-comments"] as? [String:AnyObject]
                    self.commentsAray.removeAll()
                    if comments != nil {
                        for(_,value) in comments! {
                            
                            let Comments = CommentObj()
                            let UserName = value["UserName"] as? String
                            let comment = value["text"] as? String
                            let url = value["ImageUrl"] as? String
                            let timestamp = value["timestamp"] as? Double
                           
                            Comments.timestamp = timestamp
                            Comments.UserName = UserName
                            Comments.Cotent = comment
                            Comments.UserImageUrl = url
                            
                            self.commentsAray.append(Comments)
                        }
                        
                        if self.commentsAray.count > 0 {
                            
                            self.commentsAray.sort(by: { (obj1, obj2) -> Bool in
                                print(obj1.timestamp)
                                print(obj2.timestamp)
                                return  obj1.timestamp < obj2.timestamp
                            })
                        }
                    }
                    
                    newPost.AP = AP
                    newPost.address = address
                    newPost.author = author
                    newPost.capacity = capacity
                    newPost.CapacityCount = CapacityCount ?? 0
                    newPost.date = date
                    newPost.moveDesc = description
                    newPost.likes = likes
                    newPost.juggCount = flameCount
                    newPost.pathToImage = pathToImage
                    newPost.postID = postID
                    newPost.movePrivate = movePrivate
                    newPost.time = time
                    newPost.pathToUserImage = pathToUserImage
                    newPost.commentsForPost = self.commentsAray
                    newPost.nameOfEvent = titleForEvent
                    newPost.userID = userID
                    newPost.peopleWhoLiked = likedArray
                    newPost.peopleWhoLinked = juggsArray
                    newPost.latitudePost = latitude
                    newPost.longitudePost = longitude
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                    let dateTime = "\(newPost.date ?? "") \(newPost.time ?? "") \(newPost.AP ?? "")"
                    let postdate =  dateFormatter.date(from: dateTime)
                    
                    if postdate != nil {
                        let elapsed = Date().timeIntervalSince(postdate!)
                        let diff = HomeUtil.Instance.homeUtil.stringFromTimeInterval(interval: elapsed)
                            //self.stringFromTimeInterval(interval: elapsed)
                        
                        if diff.intValue <= 24
                        {
                            if newPost.latitudePost == nil {
                                continue;
                            }
                            
                            let eventLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(newPost.latitudePost ?? 0.00, newPost.longitudePost ?? 0.00)
                            let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.userLats, longitude: self.userLong)
                            
                            //let farway = self.getDistance(from: location, to: eventLocation) * 0.000621371192
                            let distance = self.getDistance(from: location, to: eventLocation)
                            let farway = distance * 0.000621371192
                            newPost.distance = NSString(format: "%.2f", farway) as String
                            newPost.distanceKM = String(format: "%.01f", distance / 1000)
                            if farway < 100 {
                                self.posts.append(newPost)
                            } else {
                                if self.followers.contains(newPost.userID) {
                                    self.posts.append(newPost)
                                }
                            }
                        }
                    }
                }
            }
            
            
//            Globals.HideSpinner()
//            self.addAdsToJuggTable()
//            self.tableView.reloadData()
            
            HomeUtil.Instance.homePostList.removeAll()
            if let postList = self.posts as? [Post]{
                HomeUtil.Instance.homePostList = postList
            }
            var ready = [AnyObject]()
            if HomeUtil.Instance.homeUtil.getKMorMilesSettings() == "Miles" {
                ready = HomeUtil.Instance.homePostList.sorted(by: { $0.distance.floatValue < $1.distance.floatValue})
            }else{
                ready = HomeUtil.Instance.homePostList.sorted(by: { $0.distanceKM.floatValue < $1.distanceKM.floatValue})
            }
            self.posts.removeAll()
            self.posts = ready
            self.addAdsToJuggTable()
            DispatchQueue.main.async {
                self.tableView.reloadData()
                Globals.HideSpinner()
            }
        })

        ref.removeAllObservers()
        
        
        self.refreshControl?.endRefreshing()
        self.refreshControl?.isUserInteractionEnabled = true

    }
    
    
    // Move Jugg to Archive after 24 Hrs
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let hours = (ti / 3600)
        return NSString(format: "%0.2d",hours)
    }
    
    func moreActionSheet()
    {
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        }
        
        let report = UIAlertAction(title: "Report", style: .default) { (action) in
            self.areYouSureAlert()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (void) in
            
        }
        alert.addAction(report)
        alert.addAction(cancel)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager = manager
        userLats = (manager.location?.coordinate.latitude)!
        userLong = (manager.location?.coordinate.longitude)!
        
        let uID : String = (Auth.auth().currentUser?.uid)!
    Database.database().reference().child("AllUsers").child(uID).child("Location").setValue(["Latitude": locationManager.location?.coordinate.latitude, "Longitude": locationManager.location?.coordinate.longitude])
        
        
    }

    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if posts[indexPath.row] as? GADNativeExpressAdView != nil {
            return adViewHieght
        }
        return 553
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let postItem = posts[indexPath.row] as? Post {
            
            //            print(postItem)
            let moveCell = tableView.dequeueReusableCell(withIdentifier: "moveCell", for: indexPath) as! MovesTableViewCell
            
            // Post ID
            moveCell.postID = postItem.postID
            
            // User Image
            moveCell.userImageView.sd_setImage(with: URL(string: "\(String(describing: postItem.pathToUserImage!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
            moveCell.userImageView.isUserInteractionEnabled = true
            moveCell.userImageView.tag = indexPath.row
            
            // User Name
            moveCell.nameLabel.text = postItem.author //Make this @Username
            
            // Event Category
            // Fetch event category here
            
//            // Capacity (Deprecated)
//            let capacityCount = postItem.capacity
//            if capacityCount == 0 {
//                moveCell.capacityLabel.text = "\(NSLocalizedString("capacity", comment: "")): \(NSLocalizedString("public", comment: ""))"
//            }
//            else
//            {
//                moveCell.capacityLabel.text = "\(NSLocalizedString("capacity", comment: "")): \(postItem.CapacityCount ?? 0) \(NSLocalizedString("of", comment: "")) \(postItem.capacity!)"
//            }
            
            // Distance
            moveCell.distanceAwayLabel.text = postItem.distance + " \(NSLocalizedString("miles", comment: ""))"

            
            // Title Label
            moveCell.titleLabel.text = postItem.nameOfEvent
            
            
            // Flyer Image
            moveCell.flyerImage.sd_setImage(with: URL(string: "\(String(describing: postItem.pathToImage!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
            
            // User image button
            moveCell.btnProfile.tag = indexPath.row
            moveCell.btnProfile.addTarget(self, action: #selector(MovesTable.buttonProfile(_:)), for: UIControlEvents.touchUpInside)
            
            // Comments
            moveCell.commentBtn.tag = indexPath.row
            moveCell.commentBtn.addTarget(self, action: #selector(MovesTable.buttonTapped(_:)), for: UIControlEvents.touchUpInside)
            if (postItem.commentsForPost?.count)! > 0 {
                
                if (postItem.commentsForPost?.count)! > 1 {
                    

                    
                    let commet : CommentObj = (postItem.commentsForPost?.last as? CommentObj)!
                    let strComment = "\(commet.UserName ?? "")\n\(commet.Cotent ?? "")\n\(NSLocalizedString("viewAll", comment: "")) \(postItem.commentsForPost?.count ?? 0) \(NSLocalizedString("comments", comment: ""))"
                    moveCell.comments.text = strComment
                } else {
                    let commet : CommentObj = (postItem.commentsForPost?.last as? CommentObj)!
                    let strComment = "\(commet.UserName ?? "")\n\(commet.Cotent ?? "")"
                    moveCell.comments.text = strComment
                }
                
                
                
            } else {
                moveCell.comments.text = ""
            }
            
            moveCell.commentViewBtn.tag = indexPath.row
            moveCell.commentViewBtn.addTarget(self, action: #selector(MovesTable.buttonTapped(_:)), for: UIControlEvents.touchUpInside)
            
            // Reponsive Labels (Likes, Comments, Juggs)
            moveCell.likeCountLabel.text = "\(postItem.likes!) \(NSLocalizedString("likes", comment: ""))"
            moveCell.commentCount.text = "\(postItem.commentsForPost?.count ?? 0) \(NSLocalizedString("comments", comment: ""))"
            moveCell.flameCountLabel.text = "\(postItem.juggCount ?? 0) \(NSLocalizedString("juggs", comment: ""))"
            
            let userID : String = (Auth.auth().currentUser?.uid)!
            
            if postItem.peopleWhoLiked.contains(userID) {
                moveCell.likeButton.isHidden = true
                moveCell.unlikeBtn.isHidden = false
                moveCell.unlikeBtn.isEnabled = true
                
            } else {
                moveCell.likeButton.isHidden = false
                moveCell.unlikeBtn.isHidden = true
                moveCell.unlikeBtn.isEnabled = false
            }
            
            if  postItem.peopleWhoLinked.contains(userID) {
                moveCell.flameButton.isEnabled = false
                moveCell.flameButton.isHidden = true
                moveCell.flamedBtn.isHidden = false
                moveCell.flamedBtn.isEnabled = false
            } else {
                moveCell.flameButton.isEnabled = true
                moveCell.flameButton.isHidden = false
                moveCell.flamedBtn.isHidden = true
                moveCell.flamedBtn.isEnabled = true
            }
            
            
            return moveCell
            
        }else{
            
            let adView = posts[indexPath.row] as? GADNativeExpressAdView
            
            let reusableAdCell = tableView.dequeueReusableCell(withIdentifier: "JuggNativeAd", for: indexPath)
            
            for subview in reusableAdCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            reusableAdCell.contentView.addSubview(adView!)
            adView?.center = reusableAdCell.contentView.center
            return reusableAdCell
            
        }
        
    }
    
    
    func buttonTapped(_ sender:UIButton!) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Comments")
        
        if let postItem = posts[sender.tag] as? Post {
            postCID = postItem.postID
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        }
    
   
    func areYouSureAlert()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let report = UIAlertAction(title: "Report", style: .default) { (action) in
            
            // Increment Reports
            
            // Remove Jugg after 25 reports
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (void) in
            
        }
        alert.addAction(report)
        alert.addAction(cancel)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDesc", sender: self)
    }
    
    func topOfTableView()
    {
        fetchFollowers()
        
        if self.posts.count > 0 {
            self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: true)
        }
        

    }
    
    func buttonProfile(_ sender: UIButton) {
        
        if let postItem = posts[sender.tag] as? Post {
            UserID = postItem.userID
            let uID : String = (Auth.auth().currentUser?.uid)!
            
            if  UserID == uID  {
                self.navigationController?.tabBarController?.selectedIndex = 3
            } else {
                let ref = Database.database().reference()
                
                ref.child("Users").child(UserID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                    
                    let users = snapshot.value as! [String : AnyObject]
                    
                    let  firstName = users["FirstName"] as? String
                    let lastName = users["LastName"] as? String
                    let age = users["Age"] as? String
                    let city = users["City"] as? String
                    let gender = users["Gender"] as? String
                    let state = users["State"] as? String
                    let bio = users["Bio"] as? String
                    // let followers = users["Followers"] as? [String: AnyObject]
                    // let following = users["Following"] as? [String: AnyObject]
                    let imagePath = users["urlToImage"] as? String
                    
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
                    
                    let navController = UINavigationController(rootViewController: vc)
                    
                    vc.firstName = firstName!
                    vc.lastName = lastName!
                    vc.age = age!
                    vc.city = city!
                    vc.state = state!
                    vc.gender = gender!
                    vc.pathToImage = imagePath!
                    vc.bioTextForOtherUser = bio!
                    
                    vc.urlTextForOtherUser = "No URL Available."
                    vc.discoverSwipe.isEnabled = true
                    vc.followersSwipe.isEnabled = false
                    vc.followingSwipe.isEnabled = false
                    
                    self.present(navController, animated: true, completion: nil)
                })
            }
            
            
        }
    }

    
    
    
    @IBAction func feedOrderAction(_ sender: Any) {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
            print("Cancel")
        }
        actionSheetController.addAction(cancelActionButton)
        
        
        let mi = UIAlertAction(title: "Miles", style: .default) { action -> Void in
            Globals.ShowSpinner(testStr: "")
            HomeUtil.Instance.homeUtil.storeKMorMilesSettings(value: "Miles")
           
           
            self.tableView.reloadData()
            Globals.HideSpinner()
            
        }
        actionSheetController.addAction(mi)
        
        let km = UIAlertAction(title: "Kilometers", style: .default) { action -> Void in
            Globals.ShowSpinner(testStr: "")
            HomeUtil.Instance.homeUtil.storeKMorMilesSettings(value: "KM")
         
          
            self.tableView.reloadData()
            Globals.HideSpinner()
        }
        actionSheetController.addAction(km)
       
        
        let saveActionButton = UIAlertAction(title: "Closest", style: .default) { action -> Void in
            Globals.ShowSpinner(testStr: "")
            var ready = [AnyObject]()
            if HomeUtil.Instance.homeUtil.getKMorMilesSettings() == "Miles" {
                ready = HomeUtil.Instance.homePostList.sorted(by: { $0.distance.floatValue < $1.distance.floatValue})
            }else{
                ready = HomeUtil.Instance.homePostList.sorted(by: { $0.distanceKM.floatValue < $1.distanceKM.floatValue})
            }
            self.posts.removeAll()
            self.posts = ready
            self.addAdsToJuggTable()
            self.tableView.reloadData()
            Globals.HideSpinner()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Furthest", style: .default) { action -> Void in
            Globals.ShowSpinner(testStr: "")
            var ready = [AnyObject]()
            if HomeUtil.Instance.homeUtil.getKMorMilesSettings() == "Miles" {
                ready = HomeUtil.Instance.homePostList.sorted(by: { $0.distance.floatValue > $1.distance.floatValue})
            }else{
                ready = HomeUtil.Instance.homePostList.sorted(by: { $0.distanceKM.floatValue > $1.distanceKM.floatValue})
            }
            self.posts.removeAll()
            self.posts = ready
            self.addAdsToJuggTable()
            self.tableView.reloadData()
            Globals.HideSpinner()
        }
        actionSheetController.addAction(deleteActionButton)
        
  
        
        self.present(actionSheetController, animated: true, completion: nil)

    }
    
    
    
    
    
    
    
  
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
    // MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDesc" {
            if let destination = segue.destination as? Description {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                
                if let postItem = posts[(self.tableView.indexPathForSelectedRow?.row)!] as? Post {
                    
                    destination.moveid = postItem.postID
                    destination.moveName = postItem.nameOfEvent;
                    destination.userid = postItem.userID
                    destination.userName = postItem.author
                    destination.userImage = postItem.pathToUserImage
                    destination.pathToImage = postItem.pathToImage
                    destination.date = postItem.date
                    destination.amOrPM = postItem.AP
                    destination.time = postItem.time
                    destination.descriptionText = postItem.moveDesc
                    destination.privateOrPublic = postItem.movePrivate
                }
                
                
            }
            
        }else{
            if segue.identifier == "showArchive" {
                if segue.destination is ArchiveTable {
                    let backItem = UIBarButtonItem()
                    backItem.title = ""
                    navigationItem.backBarButtonItem = backItem
                    
                }
                
            }
            
            
        }
        
        
        
        
        
    } // End of Prepare for Segue
    
    
    
    
} // End of class






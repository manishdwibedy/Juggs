//
//  DiscoverCollection.swift
//  Linq
//
//  Created by Quinton Askew on 1/1/18.
//  Copyright © 2018 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import GoogleMobileAds
import MapKit
import KVNProgress
import CoreLocation

private let reuseIdentifier = "Cell"

class DiscoverCollection: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    var users = [AnyObject]()
    var locationArray = [CLLocationCoordinate2D]()
    var userDistance = Double()
    var locationManager = CLLocationManager()
    var userLats : CLLocationDegrees = 0.00
    var userLong : CLLocationDegrees = 0.00
    
    //var adInterval = 8 // How Often To Display Ad **** 8 on release *****
    //var adViewWidth = CGFloat()
    //var adViewHieght = CGFloat()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let numberOfCellsPerRow: CGFloat = 2
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        locationManager.delegate = (self as CLLocationManagerDelegate)
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingLocation()
        
        userDistance = 500
        
        self.perform(#selector(self.retrieveUsers), with: nil, afterDelay: 0.8)
        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped(recognizer:)))
//        tap.numberOfTapsRequired = 1
//        tap.delegate = self
//        self.collectionView.addGestureRecognizer(tap)
//
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture(gesture:)))
//        swipeRight.direction = UISwipeGestureRecognizerDirection.right
//        self.collectionView.addGestureRecognizer(swipeRight)
        
    }

    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DiscoverCell
        if let userItem = users[indexPath.row] as? User {
       
            cell.usernameLabel.text = userItem.firstName! + " " + userItem.lastName!
            
            cell.fromLabel.text = userItem.city! + ", " + userItem.state!
            
            cell.userID = userItem.userID
            
            cell.profileImageView.clipsToBounds = true
            
            cell.profileImageView.sd_setImage(with: URL(string: "\(String(describing: userItem.imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
            
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width/2
            
            cell.tag = indexPath.row
            

             return cell
        }
       return cell
    }
    
    
    
    
    func retrieveUsers() {
        
        Globals.ShowSpinner(testStr: "")
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        ref.child("Users").child(uid).child("Distance_Discover").observeSingleEvent(of: DataEventType.value, with: { (snapShot) in
            
            if let distance = snapShot.value as? String {
                self.userDistance = Double(distance)!
            } else {
                self.userDistance = 500.00
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
           // self.addAdsToDiscoverTable()
            self.collectionView.reloadData()
        })
        ref.removeAllObservers()
        
//        self.refreshControl?.endRefreshing()
//        self.refreshControl?.isUserInteractionEnabled = true
    }
    
    func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return from.distance(from: to)
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    //    func addAdsToDiscoverTable()
    //    {
    //        var index = 0
    //        let size = GADAdSizeFromCGSize(CGSize(width: adViewWidth, height: adViewHieght))
    //        while index < users.count {
    //            let adView = GADNativeExpressAdView(adSize: size)
    //            adView?.adUnitID = "ca-app-pub-2288924893490965/9283283023"
    //            // Real Ad: "ca-app-pub-3940256099942544/8897359316"
    //            adView?.rootViewController = self
    //            adView?.delegate = self
    //            adView?.load(GADRequest())
    //            users.insert(adView!, at: index)
    //            index += adInterval
    //
    //        }
    //    }
    //


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

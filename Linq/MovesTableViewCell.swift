//
//  MovesTableViewCell.swift
//  Linq
//
//  Created by Quinton Askew on 5/26/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
var addressAfterConversion = ""
class MovesTableViewCell: UITableViewCell, CLLocationManagerDelegate {

    @IBOutlet weak var flyerImage: UIImageView!
    @IBOutlet weak var topGradientView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bottomGradientView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var unlikeBtn: UIButton!
    @IBOutlet weak var flameButton: UIButton!
    @IBOutlet weak var flameCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var flamedBtn: UIButton!
    @IBOutlet weak var distanceAwayLabel: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    
    @IBOutlet weak var comments: UITextView!
    @IBOutlet weak var commentCount: UILabel!
    var postID: String!
    var locationManager:CLLocationManager!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       // retrieveAddress()
        startUp()
        
    }

    
    @IBAction func moveLiked(_ sender: Any) {
    
        self.likeButton.isEnabled = false
        let ref = Database.database().reference()
        let keyToPost = ref.child("Flyers").childByAutoId().key
        
        ref.child("Flyers").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if (snapshot.value as? [String : AnyObject]) != nil {
                let updateLikes: [String : Any] = ["peopleWhoLiked/\(keyToPost)" : Auth.auth().currentUser!.uid]
                ref.child("Flyers").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("Flyers").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let likes = properties["peopleWhoLiked"] as? [String : AnyObject] {
                                    let count = likes.count
                                    self.likeCountLabel.text = "\(count) Likes"
                                    
                                    let update = ["Likes" : count]
                                    ref.child("Flyers").child(self.postID).updateChildValues(update)
                                    
                                    self.likeButton.isHidden = true
                                    self.unlikeBtn.isHidden = false
                                    self.likeButton.isEnabled = true
                                }
                            }
                        })
                    }
                })
            }
            
            
        })
        
        ref.removeAllObservers()
        
    }
    
    @IBAction func moveUnliked(_ sender: Any) {

    
        self.unlikeBtn.isEnabled = false

        let ref = Database.database().reference()
        
        ref.child("Flyers").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String : AnyObject] {
                if let peopleWhoLiked = properties["peopleWhoLiked"] as? [String : AnyObject] {
                    for(id, person) in peopleWhoLiked {
                        if person as? String == Auth.auth().currentUser?.uid {
                            ref.child("Flyers").child(self.postID).child("peopleWhoLiked").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    
                                    ref.child("Flyers").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        
                                        if let prop = snap.value as? [String : AnyObject] {
                                            if let likes = prop["peopleWhoLiked"] as? [String : AnyObject] {
                                                let count = likes.count
                                                self.likeCountLabel.text = "\(count) Likes"
                                                ref.child("Flyers").child(self.postID).updateChildValues(["Likes" : count])
                                                
                                                
                                            }else{
                                                
                                                self.likeCountLabel.text = "0 Likes"
                                                ref.child("Flyers").child(self.postID).updateChildValues(["Likes" : 0])
                                            }
                                            
                                        }
                                        
                                    })
                                }
                            })
                        
                        
                        self.likeButton.isHidden = false
                        self.unlikeBtn.isHidden = true
                        self.unlikeBtn.isEnabled = true
                        break
                        
                        
                        }
                        
                    }
                }
                
            }
            
        })
        ref.removeAllObservers()
        
    }
   
    
    @IBAction func moveFlamed(_ sender: Any) {
        
        let ref = Database.database().reference()
        let keyToPost = ref.child("Flyers").childByAutoId().key
        
        ref.child("Flyers").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.value as? [String : AnyObject]) != nil {
                let updateLinqed: [String : Any] = ["peopleWhoLinqed/\(keyToPost)" : Auth.auth().currentUser!.uid]
                ref.child("Flyers").child(self.postID).updateChildValues(updateLinqed, withCompletionBlock: { (error, reff) in
                    
                    if error == nil {
                        ref.child("Flyers").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                            if let properties = snap.value as? [String : AnyObject] {
                                if let linqs = properties["peopleWhoLinqed"] as? [String : AnyObject] {
                                    let count = linqs.count
                                    self.flameCountLabel.text = "\(count)"
                                    
                                    let update = ["FlameCount" : count]
                                    ref.child("Flyers").child(self.postID).updateChildValues(update)
                                    
                                    self.flameButton.isEnabled = false
                                    self.flameButton.isHidden = true
                                    self.flamedBtn.isHidden = false
                                    self.flamedBtn.isEnabled = false
                                    
                                }
                            }
                            
                        })
                        
                    } // End of updat linq completion block
                    
                })
                
            } //End Of "If let posts"
            
        }) //End of observingSingleEvent
        
    
    }
    
    @IBAction func commented(_ sender: Any) {

    }
    
    
    
    func retrieveAddress() {
        
      
      let ref = Database.database().reference()
       
        ref.child("Flyers").child("Address").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let address = snapshot.value as? String {
                
                addressAfterConversion = address
                
            }
            
            
        })
        
        ref.removeAllObservers()
        
    }
    
    func determineMyCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            //locationManager.startUpdatingHeading()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
       // let mylat = userLocation.coordinate.latitude
        //let mylon = userLocation.coordinate.longitude
        retrieveAddress()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressAfterConversion) {
            placemarks, error in
            let placemark = placemarks?.first
            let lat = placemark!.location!.coordinate.latitude
            let lon = placemark!.location!.coordinate.longitude
            
            let moveLocation = CLLocation(latitude: lat, longitude: lon)
            //Measuring my distance in km
            let distanceInKM = userLocation.distance(from: moveLocation) / 1000
            
            let distanceInMeters = distanceInKM * 1000
            
            let milesAway = distanceInMeters * 0.000621371
            
            self.distanceAwayLabel.text = "\(milesAway)mi"
            
            
            
        }
        

        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }


    func startUp() {
        self.unlikeBtn.isHidden = true
        self.flamedBtn.isHidden = true
        
        comments.layer.masksToBounds = true
        comments.layer.cornerRadius = 8
        comments.layer.borderWidth = 2.5
        comments.layer.borderColor = UIColor.white.cgColor
        
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

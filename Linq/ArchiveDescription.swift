//
//  ArchiveDescription.swift
//  Linq
//
//  Created by Quinton Askew on 6/4/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class ArchiveDescription: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var flyerImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var capacityLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var juggBtn: UIButton!
    @IBOutlet weak var descriptionToJugg: UITextView!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var juggCountLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    
    @IBOutlet weak var commetTextField: UITextView!
    @IBOutlet weak var unlikeBtn: UIButton!
    @IBOutlet weak var juggedImageView: UIImageView!
    
    @IBOutlet weak var btnProfile: UIButton!
    @IBAction func liked(_ sender: Any) {
        likeJugg()
    }
    
    @IBAction func buttonProfile(_ sender: Any) {
        
        UserID = postAuthorID
        let uID : String = (Auth.auth().currentUser?.uid)!
        
        if  postAuthorID == uID  {
            self.navigationController?.tabBarController?.selectedIndex = 3
        } else {
            let ref = Database.database().reference()
            
            ref.child("Users").child(postAuthorID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                let users = snapshot.value as! [String : AnyObject]
                
                let firstName = users["FirstName"] as? String
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
    
    @IBAction func jugged(_ sender: Any) {
        juggTheJugg()
        
    }
    
    
    @IBAction func unlikeJugg(_ sender: Any) {
        unlikeJugg()
    }
    
    @IBAction func btnActionComments(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Comments")
        
        postCID = postID
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    var postID = ""
    var juggName = ""
    var userImagePath = ""
    var author = ""
    var juggDate = ""
    var juggTime = ""
    var amOrPm = ""
    var postAuthorID = ""
    var flyerImagePath = ""
    var descriptionForJugg = ""
    var capacity = 0
    var likes = 0
    var juggs = 0
    var commentsForPost = [CommentObj]()
    var likedPosts = [String]()
    var JuggsPosts = [String]()
    
    var segueName = ""
    
    var swipeDown: UISwipeGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visualsAndProperties()
        swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissDescription))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        visualsAndProperties()
    }
    
    func dismissDescription(gestureRecognizer: UIGestureRecognizer) {
        performSegue(withIdentifier: self.segueName, sender: self)
    }
    
    func visualsAndProperties() {
        
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0).cgColor
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.title = juggName // Jugg Name
        self.flyerImageView.sd_setImage(with: URL(string: flyerImagePath)) // Flyer For Jugg
        self.userImageView.sd_setImage(with: URL(string: userImagePath)) // User Image
        self.userNameLabel.text = author // User Name
        self.dateLabel.text = juggDate // Jugg Date
        self.timeLabel.text = "\(juggTime) \(amOrPm)" // Jugg Time
        self.descriptionToJugg.text = descriptionForJugg // Jugg Description
        self.capacityLabel.text = String(capacity) //Jugg Capacity
        
        
        let ref = Database.database().reference()
        
        ref.child("Flyers").child(postID).observe(.value, with: { (snapshot) in
            let posts = snapshot.value as? [String : AnyObject]
            
            if posts != nil {
                //                for(_,value) in posts! {
                
                //                    let likes = value["Likes"] as? Int!
                
                let liked = posts?["peopleWhoLiked"] as? [String:AnyObject]
                
                //                    var likedArray = [String]()
                
                self.likedPosts.removeAll()
                if liked != nil {
                    
                    for(_,value) in liked! {
                        self.likedPosts.append(value as! String)
                    }
                }
                
                let juggs = posts?["peopleWhoLinqed"] as? [String:AnyObject]
                
                self.JuggsPosts.removeAll()
                
                if juggs != nil {
                    
                    for(_,value) in juggs! {
                        self.JuggsPosts.append(value as! String)
                    }
                }
                
                let comments = posts?["post-comments"] as? [String:AnyObject]
                
                self.commentsForPost.removeAll()
                
                if comments != nil {
                    for(_,value) in comments! {
                        
                        let Comments = CommentObj()
                        let UserName = value["UserName"] as? String
                        let comment = value["text"] as? String
                        let url = value["ImageUrl"] as? String
                        
                        Comments.UserName = UserName
                        Comments.Cotent = comment
                        Comments.UserImageUrl = url
                        
                        self.commentsForPost.append(Comments)
                    }
                }
                
                if (self.commentsForPost.count) > 0 {
                    if (self.commentsForPost.count) < 4 {
                        var strComment = ""
                        
                        for element in self.commentsForPost {
                            strComment.append("\(element.UserName ?? "")\n\(element.Cotent ?? "")\n")
                        }
    
                        self.commetTextField.text = strComment
                    } else {
                        var strComment = ""
                        
                        for element in self.commentsForPost {
                            strComment.append("\(element.UserName ?? "")\n\(element.Cotent ?? "")\n")
                        }
                        self.commetTextField.text = strComment
//                        strComment.append("View all \(self.commentsForPost.count) comments")
                        self.commetTextField.text = strComment
                    }
                } else {
                    self.commetTextField.text = ""
                }
                
                
                self.likeCountLabel.text = "\(self.likedPosts.count) \(NSLocalizedString("likes", comment: ""))" // Jugg Likes
                self.juggCountLabel.text = "\(self.JuggsPosts.count) \(NSLocalizedString("juggs", comment: ""))" // Jugg Juggs
                
                let userID : String = (Auth.auth().currentUser?.uid)!
                
                if self.likedPosts.contains(userID) {
                    self.likeBtn.isHidden = true
                    self.unlikeBtn.isHidden = false
                } else {
                    self.likeBtn.isHidden = false
                    self.unlikeBtn.isHidden = true
                }
                
                if  self.JuggsPosts.contains(userID) {
                    self.juggBtn.isEnabled = false
                    self.juggBtn.isHidden = true
                    self.juggedImageView.isHidden = false
                } else {
                    self.juggBtn.isEnabled = true
                    self.juggBtn.isHidden = false
                    self.juggedImageView.isHidden = true
                }
                
                self.commentCountLabel.text = "\(self.commentsForPost.count ) \(NSLocalizedString("comments", comment: ""))"
                
                
            }
            //            }
            
        })
        
        // Need Comments
        
        // Visuals
        self.userImageView.clipsToBounds = true
        self.userImageView.layer.cornerRadius = userImageView.frame.size.width/2
        //        self.unlikeBtn.isHidden = true
        //        self.juggedImageView.isHidden = true
        self.descriptionToJugg.layer.borderWidth = 1
        self.descriptionToJugg.layer.cornerRadius = 8
        self.descriptionToJugg.layer.borderColor = purp
        
        
        
        
    }
    
    func likeJugg() {
        
        self.likeBtn.isEnabled = false
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
                                    
                                    self.likeBtn.isHidden = true
                                    self.unlikeBtn.isHidden = false
                                    self.likeBtn.isEnabled = true
                                }
                            }
                        })
                    }
                })
            }
            
            
        })
        
        ref.removeAllObservers()
        
    }
    
    
    func unlikeJugg() {
        
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
                            
                            
                            self.likeBtn.isHidden = false
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
    
    func juggTheJugg() {
        
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
                                    self.juggCountLabel.text = "\(count) Juggs"
                                    
                                    let update = ["FlameCount" : count]
                                    ref.child("Flyers").child(self.postID).updateChildValues(update)
                                    
                                    self.juggBtn.isEnabled = false
                                    self.juggBtn.isHidden = true
                                    self.juggedImageView.isHidden = false
                                    
                                }
                            }
                            
                        })
                        
                    } // End of update linq completion block
                    
                })
                
            } //End Of "If let posts"
            
        }) //End of observingSingleEvent
    }
    
    /*  func buttonTapped(_ sender:UIButton!){
     let storyboard = UIStoryboard(name: "Main", bundle: nil)
     let controller = storyboard.instantiateViewController(withIdentifier: "Comments")
     selectedPost = posts[(sender.tag)]
     
     self.navigationController?.pushViewController(controller, animated: true)
     
     //        self.performSegue(withIdentifier: "addComment", sender: sender)
     }
     */
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

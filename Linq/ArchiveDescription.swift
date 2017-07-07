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
    @IBOutlet weak var unlikeBtn: UIButton!
    @IBOutlet weak var juggedImageView: UIImageView!
  
    
    
    
    @IBAction func liked(_ sender: Any) {
        likeJugg()
    }
    
 
    @IBAction func jugged(_ sender: Any) {
        juggTheJugg()
   
    }
    
 
    
    @IBAction func unlikeJugg(_ sender: Any) {
        unlikeJugg()
    }
    
    
    var postID = ""
    var juggName = ""
    var userImagePath = ""
    var author = ""
    var juggDate = ""
    var juggTime = ""
    var amOrPm = ""
    var flyerImagePath = ""
    var descriptionForJugg = ""
    var capacity = 0
    var likes = 0
    var juggs = 0
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visualsAndProperties()
    }


    func visualsAndProperties() {
        
        self.title = juggName
        // Add user image
        self.flyerImageView.sd_setImage(with: URL(string: flyerImagePath))
        self.userNameLabel.text = author
        self.dateLabel.text = juggDate
        self.timeLabel.text = "\(juggTime) \(amOrPm)"
        self.descriptionToJugg.text = descriptionForJugg
        self.capacityLabel.text = String(capacity)
        self.likeCountLabel.text = "\(String(likes)) Likes"
        self.juggCountLabel.text = "\(String(juggs)) Juggs"
        
        self.unlikeBtn.isHidden = true
        self.juggedImageView.isHidden = true
        
        
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
                                    self.juggCountLabel.text = "\(count) Linqs"
                                    
                                    let update = ["FlameCount" : count]
                                    ref.child("Flyers").child(self.postID).updateChildValues(update)
                                    
                                    self.juggBtn.isEnabled = false
                                    self.juggBtn.isHidden = true
                                    self.juggedImageView.isHidden = false
                                    
                                }
                            }
                            
                        })
                        
                    } // End of updat linq completion block
                    
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

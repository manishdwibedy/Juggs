//
//  Comments.swift
//  Linq
//
//  Created by Quinton Askew on 6/19/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

var selectedPost: Post!

class Comments: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
 
    @IBOutlet weak var commentTF: UITextField!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var commentsArray = [CommentObj]()
//    var selectedPost: Post!
   // var message: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComments()
        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

    }

    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        let txtfield  = UITextField()
//        txtfield.text = commentsArray[indexPath.row].Cotent
//        txtfield.font = UIFont.systemFont(ofSize: 14.0)
//        let size : CGSize = txtfield.sizeThatFits(CGSize.init(width: self.view.frame.size.width-74, height: self.view.frame.size.height))
//        
//        print(size.height)
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsCell
        
      //  let diction:DataSnapshot = commentsArray[indexPath.row] as! DataSnapshot
        cell.userLbl.text = commentsArray[indexPath.row].UserName
        cell.commentLbl.text = commentsArray[indexPath.row].Cotent
        cell.userImageView.sd_setImage(with: URL(string: "\(String(describing: commentsArray[(indexPath.row)].UserImageUrl!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))

        return cell
    }
    

    @IBAction func commented(_ sender: Any) {
        
        if self.commentTF.text != nil {
            
            Globals.ShowSpinner(testStr: "")
            
            let ref = Database.database().reference()
            let keyToPost = ref.child("Flyers").child(selectedPost.postID)
            let commentsRef = keyToPost.child("post-comments").childByAutoId()
            
            if let uid = Auth.auth().currentUser?.uid {
                
                Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let commentField = self.commentTF.text, let user = snapshot.value as? [String : AnyObject] {
                        
                        let comment = [
                            "uid": uid,
                            "UserName" : Globals .sharedInstance.getValueFromUserDefaultsForKey("UserName"),
                            "ImageUrl" : user["urlToImage"] ?? "",
                            "text": commentField
                        ]
                        
                        commentsRef.setValue(comment)
                        self.commentTF.text = ""
                        Globals.HideSpinner()
                    } else {
                        Globals.HideSpinner()
                    }
                })
            } else {
                Globals.HideSpinner()
            }
            
        }

        
    }

    func fetchComments() {
        
        let ref = Database.database().reference()
        
        let keyToPost = ref.child("Flyers").child(selectedPost.postID)
        
        keyToPost.child("post-comments").observe(DataEventType.value, with: { (snapshot) in
            
            let posts = snapshot.value as? [String : AnyObject]
            self.commentsArray.removeAll()
            
            if posts != nil {
                for(_,value) in posts! {
                    
                    let Comments = CommentObj()
                    let UserName = value["UserName"] as? String
                    let comment = value["text"] as? String
                    let url = value["ImageUrl"] as? String
                    
                    Comments.UserName = UserName
                    Comments.Cotent = comment
                    Comments.UserImageUrl = url
                    
                    self.commentsArray.append(Comments)
                }
            }
            
            self.tableView.reloadData()
        })
        
        //        commentsRef.observe(.value, with: { (snapshot) in
        //
        //
        //        }, withCancel: nil)
        //        commentsRef.removeAllObservers()
        
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

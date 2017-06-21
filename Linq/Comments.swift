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

class Comments: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
 
    @IBOutlet weak var commentTF: UITextField!
    
    @IBOutlet weak var shareBtn: UIButton!
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var commentsArray = [Comment]()
    var selectedPost: Post!
   // var message: String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // fetchComments()
        
    }

    
    // MARK: - Table view data source
    
   func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsCell
        
        cell.textLabel?.text = commentsArray[indexPath.row].username
        cell.detailTextLabel?.text = commentsArray[indexPath.row].content
    
    
    storageRef = Storage.storage().reference(forURL: commentsArray[indexPath.row].userImageStringUrl)
    storageRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
        
        if error == nil {
           DispatchQueue.main.async() {
                if let data = data {
                    cell.userImageView.image = UIImage(data: data)
                }
                
            }
            
            
        }else {
            print(error!.localizedDescription)
            
        }
    })

        
        return cell
    }
    

    @IBAction func commented(_ sender: Any) {
        
        let comment = Comment(postId: selectedPost.postID, userImageStringUrl: "", content: self.commentTF.text!, username: Globals .sharedInstance.getValueFromUserDefaultsForKey("UserName") as! String)

        let commentRef = selectedPost.ref.child("Comments").childByAutoId()
        commentRef.setValue(comment.toAnyObject())
    }

    func fetchComments() {
        
        let commentRef = selectedPost.ref!.child("Comments")
        commentRef.observe(.value, with: { (snapshot) in
            
            var newComments = [Comment]()
            
            for item in snapshot.children {
                let newComment = Comment(snapshot: item as! DataSnapshot)
                newComments.insert(newComment, at: 0)
            }
            self.commentsArray = newComments
            self.tableView.reloadData()
            
            
        }, withCancel: nil)
        commentRef.removeAllObservers()
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

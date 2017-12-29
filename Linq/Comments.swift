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

var postCID = ""

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
        
        let txtfield  = UITextView()
        txtfield.text = commentsArray[indexPath.row].Cotent
        txtfield.font = UIFont.systemFont(ofSize: 14.0)
        let size : CGSize = txtfield.sizeThatFits(CGSize.init(width: self.view.frame.size.width-74, height: CGFloat(MAXFLOAT) ))
    
        if size.height > 35 {
            return size.height+35
        } else {
            return 70
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return commentsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsCell

        cell.userLbl.text = commentsArray[indexPath.row].UserName
        cell.commentLbl.text = commentsArray[indexPath.row].Cotent
        cell.userImageView.sd_setImage(with: URL(string: "\(String(describing: commentsArray[(indexPath.row)].UserImageUrl!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))

        let date = Date(timeIntervalSince1970: commentsArray[indexPath.row].timestamp)
//        print(date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss a"
        cell.dateLbl.text = dateFormatter.string(from: date)
        
//        let calendar = Calendar.current
//        
//        let day = calendar.component(.day, from: date)
//        let hour = calendar.component(.hour, from: date)
//        let minutes = calendar.component(.minute, from: date)
//        let seconds = calendar.component(.second, from: date)
//        
//        print(day,hour,minutes,seconds)
        
        let size : CGSize = cell.commentLbl.sizeThatFits(CGSize.init(width: self.view.frame.size.width-74, height: CGFloat(MAXFLOAT) ))
        cell.heightConstraint.constant = size.height
        return cell
    }
    

    @IBAction func commented(_ sender: Any) {
        if self.commentTF.text != nil {
            
            Globals.ShowSpinner(testStr: "")
            
            let ref = Database.database().reference()
            let keyToPost = ref.child("Flyers").child(postCID)
            let commentsRef = keyToPost.child("post-comments").childByAutoId()
            
            if let uid = Auth.auth().currentUser?.uid {
                
                ref.child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                   
                  if let commentField = self.commentTF.text, let user = snapshot.value as? [String : AnyObject] {
                        
                        let comment = [
                            "uid": uid,
                            "UserName" : Globals .sharedInstance.getValueFromUserDefaultsForKey("UserName"),
                            "ImageUrl" : user["urlToImage"] ?? "",
                            "text": commentField,
                            "timestamp" : Double(Date().timeIntervalSince1970)
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

    func fetchComments()
    {
        
        let ref = Database.database().reference()
        
        let keyToPost = ref.child("Flyers").child(postCID)
        
        keyToPost.child("post-comments").queryOrderedByKey().observe(DataEventType.value, with: { (snapshot) in
            
            let posts = snapshot.value as? [String : AnyObject]
            self.commentsArray.removeAll()
            
            if posts != nil {
                for(_,value) in posts! {
                    
                    let Comments = CommentObj()
                    let UserName = value["UserName"] as? String
                    let comment = value["text"] as? String
                    let url = value["ImageUrl"] as? String
                    let timestamp = value["timestamp"] as? Double
                    
                    Comments.UserName = UserName
                    Comments.Cotent = comment
                    Comments.UserImageUrl = url
                    Comments.timestamp = timestamp
                    
                    self.commentsArray.append(Comments)
                }
            }
            
            if self.commentsArray.count > 0 {
                
                self.commentsArray.sort(by: { (obj1, obj2) -> Bool in
                    print(obj1.timestamp)
                    print(obj2.timestamp)
                    return  obj1.timestamp < obj2.timestamp
                })
                
                self.tableView.reloadData()
                
                self.tableView.scrollToRow(at: IndexPath.init(row: self.commentsArray.count-1, section: 0), at: .bottom, animated: false)
            }
            
        })
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

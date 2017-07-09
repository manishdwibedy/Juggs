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

var postToArchive = [Post]()
var timeAsString: String!

class MovesTable: UITableViewController {
    
    @IBOutlet weak var archiveBarButtonItem: UIBarButtonItem!
    @IBAction func goingToArchive(_ sender: Any) {
        
    }
    
    var commentsAray = [CommentObj]()
    var posts = [Post]()
    var postsArchive = [Post]()
    var following = [String]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        Globals.ShowSpinner(testStr: "")
        fetchPosts()
        
        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(MovesTable.fetchPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!) // not required when using UITableViewController
        
    }
    
    
    /*Here all Moves are being fetched.
     Pros: On the map, I hid the pins for addresses further than 100 mi.
     Cons: I need this to show the Moves from Users you follow and from Users within 100 mi.
     It needs to pull the host's image and set it in the cell and the flame aka "Linq" count.
     */
    
    func fetchPosts() {
        
        let ref = Database.database().reference()
        //  let userID : String = (Auth.auth().currentUser?.uid)!
        
        ref.child("Flyers") .queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let posts = snapshot.value as! [String : AnyObject]
            self.posts.removeAll()
            
            for(_,value) in posts {
                if let userID = value["UserID"] as? String {
                    //  for each in self.following {
                    // if each == userID {
                    let newPost = Post()
                    let AP = value["AP"] as? String
                    let address = value["Address"] as? String
                    let author = value["Author"] as? String
                    let capacity = value["Capacity"] as? Int!
                    let date = value["Date"] as? String
                    let description = value["Description"] as? String
                    let likes = value["Likes"] as? Int!
                    let flameCount = value["FlameCount"] as? Int!
                    let pathToImage = value["PathToImage"] as? String
                    let postID = value["PostID"] as? String
                    let movePrivate = value["Private"] as? String
                    let time = value["Time"] as? String
                    let titleForEvent = value["NameOfMove"] as? String
                    
//                    print(value["post-comments"] as?  [String : AnyObject])
//                    
//                    for var comment as? CommentObj in value["post-comments"] {
//                        
//                    }
                    let comments = value["post-comments"] as? [String:AnyObject]
                    self.commentsAray.removeAll()
                    if comments != nil {
                        for(_,value) in comments! {
                            
                            let Comments = CommentObj()
                            let UserName = value["UserName"] as? String
                            let comment = value["text"] as? String
                            let url = value["ImageUrl"] as? String
                            
                            Comments.UserName = UserName
                            Comments.Cotent = comment
                            Comments.UserImageUrl = url
                            
                            self.commentsAray.append(Comments)
                        }
                    }
                    
                    newPost.AP = AP
                    newPost.address = address
                    newPost.author = author
                    newPost.capacity = capacity
                    newPost.date = date
                    newPost.moveDesc = description
                    newPost.likes = likes
                    newPost.juggCount = flameCount
                    newPost.pathToImage = pathToImage
                    newPost.postID = postID
                    newPost.movePrivate = movePrivate
                    newPost.time = time
                    
                    newPost.commentsForPost = self.commentsAray
                    newPost.nameOfEvent = titleForEvent
                    newPost.userID = userID
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                    let dateTime = "\(newPost.date ?? "") \(newPost.time ?? "") \(newPost.AP ?? "")"
                    let postdate =  dateFormatter.date(from: dateTime)
                    
                    if postdate != nil {
                        let elapsed = Date().timeIntervalSince(postdate!)
                        let diff = self.stringFromTimeInterval(interval: elapsed)
                        
                        if diff.intValue <= 24
                        {
                            self.posts.append(newPost)
                        }
                    }
                }
                
            }
            
            self.tableView.reloadData()
            
            Globals.HideSpinner()
            //  }
            // }
        })
        self.tableView.reloadData()
        ref.removeAllObservers()
        refreshControl?.endRefreshing()
    }
    
    
    // Move Jugg to Archive after 24 Hrs
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let hours = (ti / 3600)
        return NSString(format: "%0.2d",abs(hours))
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let moveCell = tableView.dequeueReusableCell(withIdentifier: "moveCell", for: indexPath) as! MovesTableViewCell
        moveCell.commentBtn.tag = indexPath.row
        // moveCell.userImageView.sd_setImage(with: URL(string: "\(String(describing: posts[(indexPath.row)].pathToUserImage!))"))
        // moveCell.userImageView.downloadImage(from: pathToUserImage)
        moveCell.nameLabel.text = posts[indexPath.row].author
        moveCell.likeCountLabel.text = "\(posts[indexPath.row].likes!) Likes"
        moveCell.capacityLabel.text = "Capacity: 0 of \(posts[indexPath.row].capacity!)"
        moveCell.flameCountLabel.text = "\(posts[indexPath.row].juggCount!) Juggs"
        moveCell.flyerImage.sd_setImage(with: URL(string: "\(String(describing: posts[(indexPath.row)].pathToImage!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        
        moveCell.postID = posts[indexPath.row].postID
        moveCell.commentBtn.addTarget(self, action: #selector(MovesTable.buttonTapped(_:)), for: UIControlEvents.touchUpInside)
        moveCell.commentCount.text = "\(posts[indexPath.row].commentsForPost?.count ?? 0) Comments"
        if (posts[indexPath.row].commentsForPost?.count)! > 0 {
            let commet : CommentObj = (posts[indexPath.row].commentsForPost?.last as? CommentObj)!
            moveCell.comments.text = commet.Cotent

        }
        
        return moveCell
    }
    
    
    func buttonTapped(_ sender:UIButton!){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "Comments")
        selectedPost = posts[(sender.tag)]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
        //        self.performSegue(withIdentifier: "addComment", sender: sender)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDesc", sender: self)
    }
    
    
    /*
     func removePostAppendArchive() {
     
     // Do something...
     let ref = Database.database().reference()
     ref.child("Flyers").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
     let posts = snapshot.value as! [String : AnyObject]
     self.posts.removeAll()
     for(_,value) in posts {
     let dateStarted = value["Date"] as? String
     let time = value["Time"] as? String
     let amPM = value["AP"] as? String
     
     
     }
     
     
     
     })
     
     
     
     
     print("it works")
     
     }
     
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    @IBAction func unwindToHome(segue:UIStoryboardSegue) { }
    
    // MARK: - Navigation
    // Every thing is woring correctly except the Flyer image and privateOrPublic string won't push
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDesc" {
            if let destination = segue.destination as? Description {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                destination.moveName = posts[(self.tableView.indexPathForSelectedRow?.row)!].nameOfEvent;
                
                destination.pathToImage = posts[(self.tableView.indexPathForSelectedRow?.row)!].pathToImage // Need to send the image
                destination.date = posts[(self.tableView.indexPathForSelectedRow?.row)!].date
                destination.amOrPM = posts[(self.tableView.indexPathForSelectedRow?.row)!].AP
                destination.time = posts[(self.tableView.indexPathForSelectedRow?.row)!].time
                destination.descriptionText = posts[(self.tableView.indexPathForSelectedRow?.row)!].moveDesc
                //   destination.privateOrPublic = posts[(self.tableView.indexPathForSelectedRow?.row)!].movePrivate
                //    destination.privateOrPublic = posts[(self.tableView.indexPathForSelectedRow?.row)!].movePrivate // Need to send the data
                
                
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
    
    /*
     
     //        if segue.identifier == "addComment" {
     //             let button: UIButton = sender as! UIButton
     //            if let destination = segue.destination as? Comments {
     //                let backItem = UIBarButtonItem()
     //                backItem.title = ""
     //                navigationItem.backBarButtonItem = backItem
     //           //     let indexPath = self.tableView.indexPathForSelectedRow
     ////                destination.selectedPost = posts[(button.tag)]
     //            }
     
     //  }
     
     
     
     */
    
    
    
    
    
    
} // End of class






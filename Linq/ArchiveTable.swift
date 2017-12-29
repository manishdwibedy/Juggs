//
//  ArchiveTable.swift
//  Linq
//
//  Created by Quinton Askew on 6/4/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

// This class should display past events that were within 100 miles, and ones you "Jugg'ed"

// Once 24 hours af starting time has ended, Archive the event. (Completed)

class ArchiveTable: UITableViewController {
    
    var archivedArray = [Post]()
    
    var followers = [String]()
    var blocked = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = #imageLiteral(resourceName: "NoArchiveBGD")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        fetchFollowers()
        //        fetchPosts()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Collecting past Juggs...")
        refreshControl?.addTarget(self, action: #selector(MovesTable.fetchPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!) // not required when using UITableViewController
    }
    
    func fetchFollowers() {
        let ref = Database.database().reference()
        let userID : String = (Auth.auth().currentUser?.uid)!
        
        let childRef = ref.child("Users").child(userID)
        
        childRef.child("Following").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let followingUsers = snapshot.value as? [String : AnyObject] {
                for(_, value) in followingUsers {
                    print(value)
                    self.followers.append(value as! String)
                }
            }
            
            childRef.child("Block").observeSingleEvent(of: .value, with: { (snap) in
                if let blockedUsers = snapshot.value as? [String : AnyObject] {
                    for(_, value) in blockedUsers {
                        //                        print(value)
                        self.blocked.append(value as! String)
                    }
                }
                
                self.fetchPosts()
            })
            
            
            
        })
    }
    
    func fetchPosts() {
        
        let ref = Database.database().reference()
        // let userID : String = (Auth.auth().currentUser?.uid)!
        
        ref.child("Flyers") .queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let posts = snapshot.value as! [String : AnyObject]
            self.archivedArray.removeAll()
            
            for(_,value) in posts {
                if let postID = value["PostID"] as? String {
                    let otherUserPost = Post()
                    //                    let city = value["City"] as? String
                    //                    let state = value["State"] as? String
                    let userID = value["UserID"] as? String
                    let pathToImage = value["PathToImage"] as? String
                    let titleForEvent = value["NameOfMove"] as? String
                    let likeCount = value["Likes"] as? Int
                    let juggCount = value["FlameCount"] as? Int
                    let capacity = value["Capacity"] as? Int
                    let author = value["Author"] as? String
                    let date = value["Date"] as? String
                    let descriptions = value["Description"] as? String
                    let amOrPM = value["AP"] as? String
                    let time = value["Time"] as? String
                    let pathToUserImage = value["userImageUrl"] as? String
                    let address = value["Address"] as? String
                    
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
                    
                    var commentsAray = [CommentObj]()
                    
                    if comments != nil {
                        for(_,value) in comments! {
                            
                            let Comments = CommentObj()
                            let UserName = value["UserName"] as? String
                            let comment = value["text"] as? String
                            let url = value["ImageUrl"] as? String
                            
                            Comments.UserName = UserName
                            Comments.Cotent = comment
                            Comments.UserImageUrl = url
                            
                            commentsAray.append(Comments)
                        }
                    }
                    
                    otherUserPost.address = address
                    //                    otherUserPost.city = city
                    //                    otherUserPost.state = state
                    otherUserPost.userID = userID
                    otherUserPost.pathToImage = pathToImage
                    otherUserPost.postID = postID
                    otherUserPost.nameOfEvent = titleForEvent
                    otherUserPost.juggCount = juggCount
                    otherUserPost.likes = likeCount
                    otherUserPost.author = author
                    otherUserPost.capacity = capacity
                    otherUserPost.date = date
                    otherUserPost.moveDesc = descriptions
                    otherUserPost.AP = amOrPM
                    otherUserPost.time = time
                    otherUserPost.pathToUserImage = pathToUserImage
                    
                    otherUserPost.commentsForPost = commentsAray
                    otherUserPost.peopleWhoLiked = likedArray
                    otherUserPost.peopleWhoLinked = juggsArray
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                    let dateTime = "\(otherUserPost.date ?? "") \(otherUserPost.time ?? "") \(otherUserPost.AP ?? "")"
                    let postdate =  dateFormatter.date(from: dateTime)
                    
                    if  postdate != nil {
                        let elapsed = Date().timeIntervalSince(postdate!)
                        let diff = self.stringFromTimeInterval(interval: elapsed)
                        
                        if diff.intValue >= 24
                        {
                            if self.followers.contains(otherUserPost.userID) {
                                self.archivedArray.append(otherUserPost)
                            }
                            
                            
                        }
                    }
                    
                    
                    
                }
                
            }
            
            self.tableView.reloadData()
            
            Globals.HideSpinner()
        })
        self.tableView.reloadData()
        ref.removeAllObservers()
        refreshControl?.endRefreshing()
    }
    
    
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        // let ms = Int((interval .truncatingRemainder(dividingBy: 1)) * 1000)
        // let seconds = ti % 60
        // let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        return NSString(format: "%0.2d",hours)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return archivedArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "archiveCell", for: indexPath) as! ArchiveCell
        cell.eventNameLabel.text = archivedArray[indexPath.row].nameOfEvent
        //        let myMoveCity = archivedArray[indexPath.row].city
        let myMoveState = archivedArray[indexPath.row].address
        //        cell.locationLabel.text = "\(myMoveCity ?? "")" + ", " + "\(myMoveState ?? "")"
        cell.locationLabel.text = "\(myMoveState ?? "")"
        cell.eventNameLabel.textColor = UIColor.white
        cell.locationLabel.textColor = UIColor.white
        cell.flyerImageView.sd_setImage(with: URL(string: "\(String(describing: archivedArray[(indexPath.row)].pathToImage!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        
//        cell.btnProfile.tag = indexPath.row
//        cell.btnProfile.addTarget(self, action: #selector(buttonProfile(_:)), for: .touchUpInside)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showArchiveDesc", sender: self)
    }
    
//    func buttonProfile(_ sender: UIButton) {
//        
//        if let postItem = posts[sender.tag] as? Post {
//            UserID = postItem.userID
//            let uID : String = (Auth.auth().currentUser?.uid)!
//            
//            if  UserID == uID  {
//                self.navigationController?.tabBarController?.selectedIndex = 3
//            } else {
//                let ref = Database.database().reference()
//                
//                ref.child("Users").child(UserID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
//                    
//                    let users = snapshot.value as! [String : AnyObject]
//                    
//                    let  firstName = users["FirstName"] as? String
//                    let lastName = users["LastName"] as? String
//                    let age = users["Age"] as? String
//                    let city = users["City"] as? String
//                    let gender = users["Gender"] as? String
//                    let state = users["State"] as? String
//                    let bio = users["Bio"] as? String
//                    // let followers = users["Followers"] as? [String: AnyObject]
//                    // let following = users["Following"] as? [String: AnyObject]
//                    let imagePath = users["urlToImage"] as? String
//                    
//                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
//                    
//                    let navController = UINavigationController(rootViewController: vc)
//                    
//                    vc.firstName = firstName!
//                    vc.lastName = lastName!
//                    vc.age = age!
//                    vc.city = city!
//                    vc.state = state!
//                    vc.gender = gender!
//                    vc.pathToImage = imagePath!
//                    vc.bioTextForOtherUser = bio!
//                    
//                    vc.urlTextForOtherUser = "No URL Available."
//                    vc.discoverSwipe.isEnabled = true
//                    vc.followersSwipe.isEnabled = false
//                    vc.followingSwipe.isEnabled = false
//                    
//                    
//                    self.present(navController, animated: true, completion: nil)
//                })
//            }
//            
//            
//        }
//    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
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
    
    // MARK: - Navigation
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showArchiveDesc" {
            if let destination = segue.destination as? ArchiveDescription {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
                destination.postID = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].postID
                destination.postAuthorID = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].userID
                
                destination.juggName = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].nameOfEvent
                destination.author = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].author
                destination.flyerImagePath = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].pathToImage
                destination.userImagePath = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].pathToUserImage
                destination.juggTime = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].time
                destination.amOrPm = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].AP
                destination.juggDate = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].date
                destination.descriptionForJugg = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].moveDesc
                destination.capacity = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].capacity
                destination.likes = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].likes
                destination.juggs = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].juggCount
                
                destination.likedPosts = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].peopleWhoLiked
                destination.JuggsPosts = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].peopleWhoLinked
                
                destination.commentsForPost = archivedArray[(self.tableView.indexPathForSelectedRow?.row)!].commentsForPost as! [CommentObj]
                
                destination.view.gestureRecognizers?.removeAll()
                
                
                
                
            }
        }
    }
    
    
}

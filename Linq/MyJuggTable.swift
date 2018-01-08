//
//  MyJuggTable.swift
//  Linq
//
//  Created by Quinton Askew on 7/2/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class MyJuggTable: UITableViewController {

   
    var myJuggs = [Post]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       fetchPosts()
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Searching for my Juggs...")
        refreshControl?.addTarget(self, action: #selector(MovesTable.fetchPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!) // not required when using UITableViewController
        self.tableView.rowHeight = 400
        
    }

    func fetchPosts() {
        
        let ref = Database.database().reference()
        
        let uID : String = (Auth.auth().currentUser?.uid)!
        
        ref.child("Flyers").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let posts = snapshot.value as! [String : AnyObject]
            self.myJuggs.removeAll()
            
            for(_,value) in posts {
                if let postID = value["PostID"] as? String {
                    let otherUserPost = Post()
//                    let city = value["City"] as? String
//                    let state = value["State"] as? String
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
                    let userID = value["UserID"] as? String
                    
//                    otherUserPost.city = city
//                    otherUserPost.state = state
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
                    otherUserPost.userID = userID
                    
                    if otherUserPost.userID == uID {
                        self.myJuggs.append(otherUserPost)
                    }
                    
                    
                    
                    
                }
                
            }
            
            self.tableView.reloadData()
            
            Globals.HideSpinner()
            //      }
            //      }
        })
        self.tableView.reloadData()
        ref.removeAllObservers()
        refreshControl?.endRefreshing()
    }
    
   
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myJuggs.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myJuggCell", for: indexPath) as! MyJuggCell

//        let city = myJuggs[indexPath.row].city
        let state = myJuggs[indexPath.row].address
        cell.juggNameLabel.text = myJuggs[indexPath.row].nameOfEvent
        cell.locationOfJuggLabel.text = "\(state ?? "")"
        
//        cell.locationOfJuggLabel.text = "\(String(describing: city!)), \(String(describing: state!))"
        cell.juggFlyerImageView.sd_setImage(with: URL(string: "\(String(describing: myJuggs[(indexPath.row)].pathToImage!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        

        

        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.performSegue(withIdentifier: "showDescFromMyProfile", sender: self)
    }
    
    @IBAction func unwindToMyJuggs(segue:UIStoryboardSegue) { }

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
        if segue.identifier == "showDescFromMyProfile" {
            if let destination = segue.destination as? ArchiveDescription {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                navigationItem.backBarButtonItem = backItem
        
                destination.postID = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].postID
                destination.juggName = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].nameOfEvent
                destination.author = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].author
                destination.flyerImagePath = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].pathToImage
                destination.userImagePath = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].pathToUserImage
                destination.juggTime = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].time
                destination.amOrPm = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].AP
                destination.juggDate = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].date
                destination.descriptionForJugg = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].moveDesc
                destination.capacity = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].capacity
                destination.likes = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].likes
                destination.juggs = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].juggCount
                destination.likedPosts = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].peopleWhoLiked
                destination.JuggsPosts = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].peopleWhoLinked
              //  destination.commentsForPost = myJuggs[(self.tableView.indexPathForSelectedRow?.row)!].commentsForPost as! [CommentObj]
                
                destination.view.gestureRecognizers?.removeAll()
                
                
                
                
            }
        }

    
    }
    

}

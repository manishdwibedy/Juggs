//
//  OtherUserJuggTable.swift
//  Linq
//
//  Created by Quinton Askew on 6/30/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class OtherUserJuggTable: UITableViewController {

    
    var posts = [Post]()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPosts()

        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Searching for their Juggs...")
        refreshControl?.addTarget(self, action: #selector(MovesTable.fetchPosts), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!) // not required when using UITableViewController

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    
    }
    
    
    
    func fetchPosts() {
        
        let ref = Database.database().reference()
       // let userID : String = (Auth.auth().currentUser?.uid)!
        
        ref.child("Flyers") .queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let posts = snapshot.value as! [String : AnyObject]
            self.posts.removeAll()
            
            for(_,value) in posts {
                if let postID = value["PostID"] as? String {
                   //   for each in self.posts {
                    //   if each == userID {
                    let otherUserPost = Post()
                    let city = value["City"] as? String
                    let state = value["State"] as? String
                    let pathToImage = value["PathToImage"] as? String
                    let titleForEvent = value["NameOfMove"] as? String
                    otherUserPost.city = city
                    otherUserPost.state = state
                    otherUserPost.pathToImage = pathToImage
                    otherUserPost.postID = postID
                    otherUserPost.nameOfEvent = titleForEvent
                    
                    self.posts.append(otherUserPost)
                    
                    
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OtherUserJuggCell
        
        cell.juggTitle.text = posts[indexPath.row].nameOfEvent
        let myMoveCity = posts[indexPath.row].city
        let myMoveState = posts[indexPath.row].state
        cell.locationLabel.text = "\(myMoveCity ?? "")" + "\(myMoveState ?? "")"
        cell.juggTitle.textColor = UIColor.white
        cell.locationLabel.textColor = UIColor.white
        
        cell.otherUserProfileImageView.sd_setImage(with: URL(string: "\(String(describing: posts[(indexPath.row)].pathToImage!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))

        return cell
    }
 

    func showDescription() {
        let myJuggInArchive = self.storyboard!.instantiateViewController(withIdentifier: "ArchiveDescription") as! ArchiveDescription
        let navController = UINavigationController(rootViewController: myJuggInArchive)
        let userIndex = tableView.indexPathForSelectedRow?.row
        myJuggInArchive.juggName = posts[userIndex!].nameOfEvent
        //  myJuggInArchive.author = myJuggs[userIndex!].author
        myJuggInArchive.flyerImagePath = posts[userIndex!].pathToImage
        //  myJuggInArchive.juggTime = myJuggs[userIndex!].time
        //  myJuggInArchive.juggDate = myJuggs[userIndex!].date
        // myJuggInArchive.capacity = myJuggs[userIndex!].capacity
        // myJuggInArchive.likes = myJuggs[userIndex!].likes
        // myJuggInArchive.juggs = myJuggs[userIndex!].juggCount
        // myJuggInArchive.descriptionForJugg = myJuggs[userIndex!].moveDesc
        myJuggInArchive.segueName = "unwindToOtherUserJuggs"
        
        self.present(navController, animated: true, completion: nil)
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDescription()
    }
    
    
    @IBAction func unwindToOtherUserJuggs(segue:UIStoryboardSegue) { }
    
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

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
        
    }

    func fetchPosts() {
        
        let ref = Database.database().reference()
        let UID = Auth.auth().currentUser?.uid
        
        ref.child("Flyers").child("UserID").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            let posts = snapshot.value as! [String : AnyObject]
            self.myJuggs.removeAll()
            
            for(_,value) in posts {
                if let userID = value["UserID"] as? String {
                
                    let otherUserPost = Post()
                    let city = value["City"] as? String
                    let state = value["State"] as? String
                    let pathToImage = value["PathToImage"] as? String
                    let titleForEvent = value["NameOfMove"] as? String
                    let postID = value["PostID"] as? String
                    otherUserPost.city = city
                    otherUserPost.state = state
                    otherUserPost.pathToImage = pathToImage
                    otherUserPost.userID = userID
                    otherUserPost.nameOfEvent = titleForEvent
                    otherUserPost.postID = postID
                    
                    
                    
                    
                    self.myJuggs.append(otherUserPost)
                    
                    
                }
                
            }
            
            self.tableView.reloadData()
            
            Globals.HideSpinner()
            
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "myJuggCell", for: indexPath) as? MyJuggCell
        
        cell?.juggNameLabel.text = "Q"
        cell?.locationOfJuggLabel.text = "Union"
        cell?.juggFlyerImageView.sd_setImage(with: URL(string: "\(String(describing: myJuggs[(indexPath.row)].pathToImage!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
    
        return cell!
    }
    

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

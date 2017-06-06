//
//  MovesTable.swift
//  Linq
//
//  Created by Quinton Askew on 5/26/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class MovesTable: UITableViewController {

   
    
    var posts = [Post]()
    var following = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        self.tabBarController?.tabBar.barTintColor = UIColor.white
        self.tabBarController?.tabBar.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
       self.tableView.reloadData()
       fetchPosts()
       
    }

    
    /*Here all Moves are being fetched.
     Pros: On the map, I hid the pins for addresses further than 100 mi. 
     Cons: I need this to show the Moves from Users you follow and from Users within 100 mi.
     It needs to pull the host's image and set it in the cell and the flame aka "Linq" count.
    */
    
    func fetchPosts() {
        
        let ref = Database.database().reference()
  
                        
        ref.child("Flyers").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
       
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
                                               let capacity = value["Capacity"] as? Int
                                               let date = value["Date"] as? String
                                               let description = value["Description"] as? String
                                               let likes = value["Likes"] as? Int
                                               let flameCount = value["FlameCount"] as? Int
                                               let pathToImage = value["PathToImage"] as? String
                                               let postID = value["PostID"] as? String
                                               let movePrivate = value["Private"] as? String
                                               let time = value["Time"] as? String
                                               let titleForEvent = value["NameOfMove"] as? String
                                                
                                                newPost.AP = AP
                                                newPost.address = address
                                                newPost.author = author
                                                newPost.capacity = capacity
                                                newPost.date = date
                                                newPost.moveDesc = description
                                                newPost.likes = likes
                                                newPost.flameCount = flameCount
                                                newPost.pathToImage = pathToImage
                                                newPost.postID = postID
                                                newPost.movePrivate = movePrivate
                                                newPost.time = time
                                                newPost.nameOfEvent = titleForEvent
                             //Users image                   // let pathToUserImage = flyer["PathToUserImage"] as? String
                                                // let flameCount = flyer["FlameCount"] as? Int,
                             // Linq count
                                                newPost.userID = userID
                                                
                                                // newPost.pathToUserImage = pathToUserImage
                                                
                                                self.posts.append(newPost)
                                            
                                            
                                        }
                                        
                                    }
                                    
                                    self.tableView.reloadData()
                                    
                                    
                             //  }
                          // }
                        })
                          self.tableView.reloadData()
                   // }
                    
               // }
                
           // }
            
        // })
        
        ref.removeAllObservers()
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
        
       // moveCell.userImageView.downloadImage(from: pathToUserImage)
        moveCell.nameLabel.text = posts[indexPath.row].author
        moveCell.likeCountLabel.text = "\(posts[indexPath.row].likes!) Likes"
        moveCell.capacityLabel.text = "\(posts[indexPath.row].capacity) Capacity"
        moveCell.flameCountLabel.text = "\(posts[indexPath.row].flameCount) Would Linq"
        moveCell.flyerImage.downloadImage(from: posts[(indexPath.row)].pathToImage)
        moveCell.postID = posts[indexPath.row].postID
        return moveCell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       performSegue(withIdentifier: "showDesc", sender: self)
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
        //    destination.privateOrPublic = posts[(self.tableView.indexPathForSelectedRow?.row)!].movePrivate // Need to send the data
            
        
                }
        
            }
            
        }
            
   }
    



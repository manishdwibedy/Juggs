//
//  DiscoverTable.swift
//  Linq
//
//  Created by Quinton Askew on 5/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
class DiscoverTable: UITableViewController {

    

    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView

       self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.isHidden = true
        self.tableView.rowHeight = 500
       retrieveUsers()
       
       /* let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap) */
    }
    
    func doubleTapped() {
        
       // followUser()
        
    }
    
    
    
    
    
    func retrieveUsers() {
        Globals.ShowSpinner(testStr: "")
        let ref = Database.database().reference()
        
        ref.child("Users").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            let users = snapshot.value as! [String : AnyObject]
            self.users.removeAll()
            for(_, value) in users {
                
                if let uid = value["UID"] as? String {
                    if uid != Auth.auth().currentUser!.uid {
                        let dict = [String : AnyObject]()
                        let userToShow = User(dictionary:dict)
                        if let userID = value["UID"] as? String,
                            let  firstName = value["First Name"] as? String,
                            let lastName = value["Last Name"] as? String,
                            let age = value["Age"] as? String,
                            let city = value["City"] as? String,
                            let gender = value["Gender"] as? String,
                            let state = value["State"] as? String,
                            let bio = value["Bio"] as? String,
                            let imagePath = value["urlToImage"] as? String {
                            userToShow.userID = userID
                            userToShow.firstName = firstName
                            userToShow.lastName = lastName
                            userToShow.age = age
                            userToShow.bio = bio
                            userToShow.city = city
                            userToShow.gender = gender
                            userToShow.state = state
                            userToShow.imagePath = imagePath
                            self.users.append(userToShow)
                            
                            
                        }
                        
                        
                    }
                    
                }
            }
            Globals.HideSpinner()
            self.tableView.reloadData()
            
        })
        ref.removeAllObservers()
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellForDiscover = tableView.dequeueReusableCell(withIdentifier: "cellForDiscover", for: indexPath) as! CellForDiscover
        
        cellForDiscover.nameLabel.text = users[indexPath.row].firstName + " " + self.users[indexPath.row].lastName
        
        cellForDiscover.fromLabel.text = users[indexPath.row].city + ", " + self.users[indexPath.row].state
        
        cellForDiscover.userID = users[indexPath.row].userID
        
        cellForDiscover.profilePic.sd_setImage(with: URL(string: "\(String(describing: users[(indexPath.row)].imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))

        return cellForDiscover
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // DRAG FROM LEFT TO RIGHT SEGUE
        
        performSegue(withIdentifier: "showUser", sender: self)
        }

    ////// SETUP FOLLOWING ANG FOLLOWERS IMAGES IN CELL WITH FOLLOW USER FUNCTION. (DOUBLE TAP TO FOLLOW) //////
    
    
    /*  func followUser(row: Int) {
            let indexPath = tableView.indexPathForSelectedRow!.row
            
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            let key = ref.child("Users").childByAutoId().key
            
            var isFollower = false
            
            ref.child("Users").child(uid).child("Following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
                
                if let following = snapshot.value as? [String : AnyObject] {
                    for (ke, value) in following {
                        if value as! String == self.users[indexPath.row].userID {
                            isFollower = true
                            
                            ref.child("Users").child(uid).child("Following/\(ke)").removeValue()
                            ref.child("Users").child(self.users[indexPath.row].userID).child("Followers/\(ke)").removeValue()
                            
                            self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                        }
                    }
                }
                if !isFollower {
                    let following = ["Following/\(key)" : self.users[indexPath.row].userID]
                    let followers = ["Followers/\(key)" : uid]
                    
                    ref.child("Users").child(uid).updateChildValues(following as Any as! [AnyHashable : Any])
                    ref.child("Users").child(self.users[indexPath.row].userID).updateChildValues(followers)
                   
                    
                    
                }
            })
            ref.removeAllObservers()
            
        }

        
    } */
     
     
     


/*func checkFollowing(indexPath: IndexPath) {
    let uid = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    
    ref.child("Users").child(uid).child("Following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
        
        if let following = snapshot.value as? [String : AnyObject] {
            for (_, value) in following {
                if value as! String == self.users[indexPath.row].userID {
                    self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                }
            }
        }
    })
    ref.removeAllObservers()
} */

    
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
    
    @IBAction func unwindToDiscover(segue:UIStoryboardSegue) { }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
       if segue.identifier == "showUser" {
            if let destination = segue.destination as? OtherUser {
               destination.firstName = users[(self.tableView.indexPathForSelectedRow?.row)!].firstName
                destination.lastName = users[(self.tableView.indexPathForSelectedRow?.row)!].lastName
                destination.age = users[(self.tableView.indexPathForSelectedRow?.row)!].age
                destination.city = users[(self.tableView.indexPathForSelectedRow?.row)!].city
                destination.state = users[(self.tableView.indexPathForSelectedRow?.row)!].state
                destination.gender = users[(self.tableView.indexPathForSelectedRow?.row)!].gender
                destination.bio = users[(self.tableView.indexPathForSelectedRow!.row)].bio
                destination.pathToImage = users[(self.tableView.indexPathForSelectedRow!.row)].imagePath
                destination.messageSwipe.isEnabled = false
                // Not Working
                
            }
        }
    }

}

extension UIImageView {
    
    func downloadImage(from imgURL: String!) {
       let url = URLRequest(url: (URL(string: imgURL))!)
        
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
        }
        
        task.resume()
    }
}


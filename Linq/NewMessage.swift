//
//  NewMessage.swift
//  Linq
//
//  Created by Quinton Askew on 7/16/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage


class NewMessage: UIViewController , UISearchBarDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var tableView : UITableView!
   
    @IBOutlet weak var toolbarPickerView: UIView!
    
    @IBAction func cancelled(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var pickerview: UIPickerView!
    
    var users = [User]()
    var filteredUsers = [User]()
    var arrayPosts = [Post]()
    var arrayNew = [User]()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        toolbarPickerView.isHidden = true
        pickerview.isHidden = true
        
        if self.title == "New Invitation" {
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            let backItem = UIBarButtonItem()
            backItem.title = "Send"
            
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send", style: .plain, target: self, action: #selector(addTapped))

            navigationController?.navigationBar.tintColor = purp
            
            self.tableView.setEditing(true, animated: true)
            self.tableView.allowsMultipleSelectionDuringEditing = true
         
        }

        definesPresentationContext = true
        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        retrieveUsers()
    }

    func addTapped() {
        
        searchBar.endEditing(true)
        let indexes = tableView.indexPathsForSelectedRows
        
        
        _ = indexes?.filter({ (IndexPath) -> Bool in
            arrayNew.append(filteredUsers[IndexPath.row])
            return true
        })
        

        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        toolbarPickerView.isHidden = false
        pickerview.isHidden = false
        
        ref.child("Flyers").queryOrderedByKey().observe(DataEventType.value, with: { snapshot in
            
            let posts = snapshot.value as! [String : AnyObject]
            self.arrayPosts.removeAll()
            for (_,value) in posts {
                if let user = value["UserID"] as? String {
                    if uid == user {
                        
                        let newPost = Post()
                        
                        let capacity = value["Capacity"] as? Int
                        let date = value["Date"] as? String
                        let postID = value["PostID"] as? String
                        let movePrivate = value["Private"] as? Bool
                        let titleForEvent = value["NameOfMove"] as? String
                        let invites = value["Invites"]
                        let requests = value["Requests"]
                        let pathToImage = value["PathToImage"] as? String
                        let pathToUserImage = value["userImageUrl"] as? String
                        let AP = value["AP"] as? String
                        let time = value["Time"] as? String
                        
                        newPost.pathToImage = pathToImage
                        newPost.pathToUserImage = pathToUserImage
                        newPost.capacity = capacity
                        newPost.date = date
                        newPost.postID = postID
                        newPost.movePrivate = movePrivate
                        newPost.nameOfEvent = titleForEvent
                        newPost.userID = uid
                        newPost.invites = invites as? [String : Any]
                        newPost.requests = requests as? [String : Any]
                        newPost.AP = AP
                        newPost.time = time
                        
                        if newPost.capacity != 0 {
                            
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                            let dateTime = "\(newPost.date ?? "") \(newPost.time ?? "") \(newPost.AP ?? "")"
                            let postdate =  dateFormatter.date(from: dateTime)
                            
                            if postdate != nil {
                                let elapsed = Date().timeIntervalSince(postdate!)
                                let diff = self.stringFromTimeInterval(interval: elapsed)
                                
                                if diff.intValue <= 24
                                {
                                    self.arrayPosts.append(newPost)
                                }
                            }
                            
                        }
                    }
                }
            }
            
            self.showPosts()
            
        });
        
        ref.removeAllObservers()
        
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let hours = (ti / 3600)
        return NSString(format: "%0.2d",hours)
    }
    
    
    func showPosts()
    {
        if (self.arrayPosts.count < 1) {
            // No posts are here
            toolbarPickerView.isHidden = true
            pickerview.isHidden = true
            
            let alert = UIAlertController(title: "Create a Private Jugg to Invite others.", message: nil, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            let newJugg = UIAlertAction(title: "Create", style: .default) { (action) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newJugg = storyboard.instantiateViewController(withIdentifier: "NewMove") as? NewMove
                self.present(newJugg!, animated: true,
                             completion: nil)
                
            }
            
            alert.addAction(cancel)
            alert.addAction(newJugg)
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            alert.view.tintColor = purp
            self.navigationController!.present(alert, animated: true, completion: nil)
            
            
        } else {
            
            pickerview.reloadAllComponents()
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        
        return self.arrayPosts.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
        return self.arrayPosts[row].nameOfEvent
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        
        pickerview.isHidden = true
        toolbarPickerView.isHidden = true
    }
    
    @IBAction func actionDone(_ sender: Any) {
        pickerview.isHidden = true
        toolbarPickerView.isHidden = true
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        
        Globals.ShowSpinner(testStr: "")
        
        for element in arrayNew {
            
            
            if self.arrayPosts[pickerview.selectedRow(inComponent: 0)].requests == nil {
                
            } else {
                let dict : [String:AnyObject] =  self.arrayPosts[pickerview.selectedRow(inComponent: 0)].requests! as [String : AnyObject]
                
                var exist : Bool = false
                for (_,value) in dict {

                    let user = value.value(forKey: "touserID") as! String
                    if user == uid {
                        if UserID == value.value(forKey: "from") as! String {
                            if self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID == value.value(forKey: "postID") as! String {
                                exist = true
                                
                                break
                            }
                        }
                        
                    }
                }
                
                if exist {
                    
                    continue;
                    
                }
            }
            
            
            
            if self.arrayPosts[pickerview.selectedRow(inComponent: 0)].invites == nil {
                let keyToPost = ref.child("Users").child(element.userID!)
                let commentsRef = keyToPost.child("Invites").childByAutoId()
                let invite = [
                    "fromuserImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToUserImage!,
                    "flyerImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToImage!,
                    "from" : uid,
                    "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName"),
                    "touserID" : element.userID as Any,
                    "touserName" : "\(element.firstName ?? "") \(element.lastName ?? "")",
                    "touserImagePath" : element.imagePath,
                    "eventName" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent,
                    "postID" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID,
                    "status" : "0",
                    "postDate": "\(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].date ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].time ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].AP ?? "")"
                    
                    ] as [String : Any]
                
                commentsRef.setValue(invite)
                
                let keyToPost1 = ref.child("Flyers").child(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID)
                let commentsRef1 = keyToPost1.child("Invites").childByAutoId()
                
                let invite1 = [
                    "fromuserImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToUserImage!,
                    "flyerImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToImage!,
                    "from" : uid,
                    "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName"),
                    "touserID" : element.userID as Any,
                    "touserName" : "\(element.firstName ?? "") \(element.lastName ?? "")",
                    "touserImagePath" : element.imagePath,
                    "eventName" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent,
                    "postID" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID,
                    "status" : "0",
                    "postDate": "\(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].date ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].time ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].AP ?? "")"
                    
                    ] as [String : Any]
                
                commentsRef1.setValue(invite1)
                
            } else {
                
                let dict : [String:AnyObject] =  self.arrayPosts[pickerview.selectedRow(inComponent: 0)].invites! as [String : AnyObject]
                
                var exist : Bool = false
                for (_,value) in dict {
                    print(value)
                    let user = value.value(forKey: "from") as! String
                    if user == uid {
                        if element.userID == value.value(forKey: "touserID") as? String {
                            if self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID == value.value(forKey: "postID") as! String {
                                exist = true
                                pickerview.isHidden = true
                                break
                            }
                        }
                        
                    }
                }
                
                if exist {
                  
                    
                } else {
                    let keyToPost = ref.child("Users").child(element.userID!)
                    let commentsRef = keyToPost.child("Invites").childByAutoId()
                    let invite = [
                        "fromuserImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToUserImage!,
                        "flyerImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToImage!,
                        "from" : uid,
                        "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName"),
                        "touserID" : element.userID as Any,
                        "touserName" : "\(element.firstName ?? "") \(element.lastName ?? "")",
                        "touserImagePath" : element.imagePath,
                        "eventName" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent,
                        "postID" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID,
                        "status" : "0",
                        "postDate": "\(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].date ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].time ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].AP ?? "")"
                        
                        ] as [String : Any]
                    
                    commentsRef.setValue(invite)
                    
                    let keyToPost1 = ref.child("Flyers").child(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID)
                    let commentsRef1 = keyToPost1.child("Invites").childByAutoId()
                    
                    let invite1 = [
                        "fromuserImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToUserImage!,
                        "flyerImagePath" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].pathToImage!,
                        "from" : uid,
                        "fromName" : Globals.sharedInstance.getValueFromUserDefaultsForKey_Path("UserName"),
                        "touserID" : element.userID as Any,
                        "touserName" : "\(element.firstName ?? "") \(element.lastName ?? "")",
                        "touserImagePath" : element.imagePath,
                        "eventName" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent,
                        "postID" : self.arrayPosts[pickerview.selectedRow(inComponent: 0)].postID,
                        "status" : "0",
                        "postDate": "\(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].date ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].time ?? "") \(self.arrayPosts[pickerview.selectedRow(inComponent: 0)].AP ?? "")"
                        ] as [String : Any]
                    
                    commentsRef1.setValue(invite1)
                    
                }
            }
        }
        
        
        Globals.HideSpinner()
        
        tableView.reloadData()
        let event = self.arrayPosts[pickerview.selectedRow(inComponent: 0)].nameOfEvent
        let alert = UIAlertController(title: "All invitations for \"\(event!)\" has been sent accordingly.", message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
            
        }
        
        alert.addAction(confirm)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.navigationController!.present(alert, animated: true, completion: nil)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let str = self.arrayPosts[row].nameOfEvent
        return NSAttributedString(string: str!, attributes: [NSForegroundColorAttributeName:UIColor(cgColor: purp)])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        searchBar.endEditing(true)
        
        filteredUsers = self.users.filter() {
            if let type = ($0 as User).firstName {
                return type.localizedCaseInsensitiveContains(searchBar.text!)
            } else {
                return false
            }
        }
        
        self.tableView.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
        
        if searchBar.text == "" {
            
            self.filteredUsers = self.users
            self.tableView.reloadData()
        }
        
    }
    
    func retrieveUsers()
    {
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
                        if let userID = value["UID"] as? String {
                            
                            let  firstName = value["FirstName"] as? String
                            let lastName = value["LastName"] as? String
                            let age = value["Age"] as? String
                            let city = value["City"] as? String
                            let gender = value["Gender"] as? String
                            let state = value["State"] as? String
                            let bio = value["Bio"] as? String
                            let followers = value["Followers"] as? [String: AnyObject]
                            let following = value["Following"] as? [String: AnyObject]
                            let imagePath = value["urlToImage"] as? String
                            
                            userToShow.userID = userID
                            userToShow.firstName = firstName
                            userToShow.lastName = lastName
                            userToShow.age = age
                            userToShow.bio = bio
                            userToShow.city = city
                            userToShow.gender = gender
                            userToShow.state = state
                            userToShow.imagePath = imagePath
                            userToShow.follower = followers
                            userToShow.following = following
                            
                            self.users.append(userToShow)
                            
                        }
                    }
                    
                }
            }
            Globals.HideSpinner()
            self.filteredUsers = self.users
            self.tableView.reloadData()
            
        })
        ref.removeAllObservers()
        
    }
 
    

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nmcell", for: indexPath) as? NewMessageCell
        
        let firstName = filteredUsers[indexPath.row].firstName
        let space = " "
        let lastName = filteredUsers[indexPath.row].lastName
        let city = filteredUsers[indexPath.row].city
        let state = filteredUsers[indexPath.row].state
        
        cell?.nameLabel.text = "\(firstName!)\(space)\(lastName!)"
        cell?.fromLabel.text = "\(city!), \(state!)"
        cell?.userImageView.sd_setImage(with: URL(string: "\(String(describing: filteredUsers[(indexPath.row)].imagePath!))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath as IndexPath)
        cell!.contentView.backgroundColor = .clear
    }
    
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.title == "New Invitation" {

        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            let cell  = tableView.cellForRow(at: indexPath)
            cell!.contentView.backgroundColor = .clear
            
            showChatLogController(user: filteredUsers[indexPath.row])
        }
                
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {

    }
    
    func showChatLogController(user: User) {
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.navigationController?.navigationBar.barTintColor = UIColor.clear
        chatLogController.user = user
        chatLogController.title = user.firstName + " " + user.lastName
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationController?.navigationBar.tintColor = purp
        navigationItem.backBarButtonItem = backItem
        navigationController?.pushViewController(chatLogController, animated: true)
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

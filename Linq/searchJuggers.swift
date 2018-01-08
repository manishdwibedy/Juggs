//
//  searchJuggers.swift
//  Linq
//
//  Created by Quinton Askew on 9/4/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class searchJuggers: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var myJuggIDTF: UITextField!
    @IBOutlet weak var shareBtn: UIButton!
    let UIpurp = UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1.0)
    
    @IBAction func shareMyJuggID(_ sender: Any) {
        actionSheet()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        searchBar.text = "BZqQBnmgWkbMxFZ2yqlFcG3bKB82";
        visuals()
        
    }

    
    func visuals()
    {
        let myJuggID = Auth.auth().currentUser?.uid
        self.myJuggIDTF.text = myJuggID
        self.myJuggIDTF.layer.cornerRadius = 8
        self.myJuggIDTF.layer.borderWidth = 2
        self.myJuggIDTF.layer.borderColor = purp
        self.shareBtn.layer.masksToBounds = true
        self.shareBtn.layer.cornerRadius = 8
        self.shareBtn.layer.borderWidth = 2
        self.shareBtn.layer.borderColor = purp
        
    }
    

    
    func actionSheet()
    {
        var sheet = UIAlertController(title: "Share Jugg ID", message: nil, preferredStyle: .actionSheet)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            sheet = UIAlertController(title: "Share Jugg ID", message: nil, preferredStyle: .alert)
        }
        
       let copy = UIAlertAction(title: "Copy", style: .default) { (action) in
        if let juggUID = self.myJuggIDTF.text {
            let pasteboard = UIPasteboard.general
            pasteboard.string = "\(juggUID)"
            self.copyAlert()
            }
        }
        let share = UIAlertAction(title: "Share", style: .default) { (action) in
            
            // text to share
            let message = "Hey, you should check out my profile on the Jugg app! Search my Jugg ID: \(self.myJuggIDTF.text!) "
            
            // set up activity view controller
            let itemsToShare = [message]
            let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            // present the view controller
            self.present(activityViewController, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in}
        
        sheet.addAction(copy)
        sheet.addAction(share)
        sheet.addAction(cancel)
        sheet.view.tintColor = self.UIpurp
        self.present(sheet, animated: true, completion: nil)
    
    }
    
    func copyAlert()
    {
        let alert = UIAlertController(title: "Success!", message: "Your Jugg ID was copied to your clipboard.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) in })
        alert.addAction(ok)
        alert.view.tintColor = self.UIpurp
        self.present(alert, animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        
        
//        print(searchBar.text as Any)
        
        let uID : String = (Auth.auth().currentUser?.uid)!
        
        if  searchBar.text == uID  {
            let alert = UIAlertController(title: "This is your user id, search for other user id here.", message: nil, preferredStyle: .alert)
            let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
                
            }
            
            alert.addAction(confirm)
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            alert.view.tintColor = purp
            self.navigationController!.present(alert, animated: true, completion: nil)
        } else {
            let ref = Database.database().reference()
            
            ref.child("Users").child(searchBar.text!).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                if let users = snapshot.value as? [String : AnyObject] {
                    UserID = searchBar.text!
                    let  firstName = users["FirstName"] as? String
                    let lastName = users["LastName"] as? String
                    let age = users["Age"] as? String
                    let city = users["City"] as? String
                    let gender = users["Gender"] as? String
                    let state = users["State"] as? String
                    let bio = users["Bio"] as? String
                    // let followers = users["Followers"] as? [String: AnyObject]
                    // let following = users["Following"] as? [String: AnyObject]
                    let imagePath = users["urlToImage"] as? String
                    
                    let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
                    
                    let navController = UINavigationController(rootViewController: vc)
                    
                    vc.firstName = firstName!
                    vc.lastName = lastName!
                    vc.age = age!
                    vc.city = city!
                    vc.state = state!
                    vc.gender = gender!
                    vc.pathToImage = imagePath!
                    vc.bioTextForOtherUser = bio!
                    
                    vc.urlTextForOtherUser = "No URL Available."
                    vc.discoverSwipe.isEnabled = true
                    vc.followersSwipe.isEnabled = false
                    vc.followingSwipe.isEnabled = false
                    
                    self.present(navController, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "No user is available with this id.", message: nil, preferredStyle: .alert)
                    let confirm = UIAlertAction(title: "OK", style: .default) { (action) in
                        
                    }
                    
                    alert.addAction(confirm)
                    let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
                    alert.view.tintColor = purp
                    self.navigationController!.present(alert, animated: true, completion: nil)
                }
                
                
            })
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
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

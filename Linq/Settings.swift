//
//  Settings.swift
//  Linq
//
//  Created by Quinton Askew on 5/23/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

//Account deletes (Auth wise), but user still showing in app.

class Settings: UITableViewController {

  
    
    // Account
    @IBOutlet weak var updateImageCell: UITableViewCell!
    @IBOutlet weak var updateNameCell: UITableViewCell!
    @IBOutlet weak var updateEmailCell: UITableViewCell!
    @IBOutlet weak var updatePWCell: UITableViewCell!
    @IBOutlet weak var updateBioCell: UITableViewCell!
    @IBOutlet weak var updateWebsiteCell: UITableViewCell!
    // About
    @IBOutlet weak var privacyPolicyCell: UITableViewCell!
    @IBOutlet weak var termsOfServiceCell: UITableViewCell!
    @IBOutlet weak var legalCell: UITableViewCell!
    // Actions
    @IBOutlet weak var blockedListCell: UITableViewCell!
    @IBOutlet weak var logOutCell: UITableViewCell!
    @IBOutlet weak var deleteAccountCell: UITableViewCell!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visuals()
        

        
    }

    
    
    func visuals() {
        // Background Image
        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        
        // Nav & Tab Bars
        self.navigationController?.navigationBar.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        self.tabBarController?.tabBar.isHidden = true
        
        // Text Color
        let purpleThemeColor = UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1.0)
        self.updateImageCell.textLabel?.textColor = purpleThemeColor
        self.updateNameCell.textLabel?.textColor = purpleThemeColor
        self.updateEmailCell.textLabel?.textColor = purpleThemeColor
        self.updateEmailCell.tintColor = purpleThemeColor
        self.updatePWCell.textLabel?.textColor = purpleThemeColor
        self.updateBioCell.textLabel?.textColor = purpleThemeColor
        self.updateWebsiteCell.textLabel?.textColor = purpleThemeColor
        // About
        self.privacyPolicyCell.textLabel?.textColor = purpleThemeColor
        self.privacyPolicyCell.tintColor = purpleThemeColor
        self.termsOfServiceCell.textLabel?.textColor = purpleThemeColor
        self.termsOfServiceCell.tintColor = purpleThemeColor
        self.legalCell.textLabel?.textColor = purpleThemeColor
        self.legalCell.tintColor = purpleThemeColor
        // Actions
        self.blockedListCell.textLabel?.textColor = purpleThemeColor
        self.logOutCell.textLabel?.textColor = purpleThemeColor
        self.deleteAccountCell.textLabel?.textColor = purpleThemeColor
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    let numberOfRowsAtSection: [Int] = [6, 3, 3] // ROWS IN A SECTION
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows: Int = 0
        
        if section < numberOfRowsAtSection.count {
            rows = numberOfRowsAtSection[section]
        }
        
        return rows
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40.0 // THICKNESS OF SECTION
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 1 {
            performSegue(withIdentifier: "changeName", sender: self)
        }
        
        if indexPath.section == 0 && indexPath.row == 2 {
            performSegue(withIdentifier: "updateEmail", sender: self)
        }
        
        if indexPath.section == 0 && indexPath.row == 3 {
            performSegue(withIdentifier: "updatePW", sender: self)
        }
        
        if indexPath.section == 0 && indexPath.row == 4 {
            performSegue(withIdentifier: "updateBio", sender: self)
        }
        
        if indexPath.section == 0 && indexPath.row == 5 {
            performSegue(withIdentifier: "updateWebsite", sender: self)
        }
        
        
        
        
        // IF THE 'SIGN OUT' CELL IS TAPPED
        
        if indexPath.section == 2 && indexPath.row == 1 {
            let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            let logout = UIAlertAction(title: "Log Out", style: .default, handler: { (ACTION) in
                self.performSegue(withIdentifier: "signOutFromSettings", sender: self)
                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(false, key: "IS_LOGIN")

                print("Logged Out")
            })
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (ACTION) in
                print("Sign Out Cancelled")
            })
            
            alert.addAction(logout)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion:nil)
            
        }
    
        // Delete account
        
        if indexPath.section == 2 && indexPath.row == 2 {
        
            areYouSureAlert()
            
            
        }
        
    
    }

   
 
    func areYouSureAlert() {
        
        let areYouSure = UIAlertController(title: "Warning", message: "Are you sure you would like to delete your account?", preferredStyle: .alert)
        
        
        let Delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            self.deleteAccount()
            
            
        }
        
        let Cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        areYouSure.addAction(Delete)
        areYouSure.addAction(Cancel)
        self.present(areYouSure, animated: true, completion:nil)
        
        
        
        
        
    }
    
    func errorMessage() {
        let error = UIAlertController(title: "Sorry", message: "There was an error procesing your request.", preferredStyle: .alert)
        
        let errorOK = UIAlertAction(title: "Ok", style: .default) { (action) in
        }
        
        
        error.addAction(errorOK)
        
        
        self.present(error, animated: true, completion:nil)
    }
    
    
    
    func deletedAlert() {
        
        let success = UIAlertController(title: nil, message: "Your account has been deleted.", preferredStyle: .alert)
        
        let OK = UIAlertAction(title: "Ok", style: .default) { (action) in
       
            self.performSegue(withIdentifier: "signOutFromSettings", sender: self)
        }
    
        success.addAction(OK)
        self.present(success, animated: true, completion:nil)
    }
    
    func deleteAccount() {
        
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if error != nil {
                // An error happened.
                self.errorMessage()
            } else {
                // Account deleted.
                self.deletedAlert()
            
            }
        }
        
        
        
    }
    

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
        
    }
   
}

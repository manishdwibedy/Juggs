//
//  Settings.swift
//  Linq
//
//  Created by Quinton Askew on 5/23/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
import SafariServices
//Account deletes (Auth wise), but user still showing in app.

class Settings: UITableViewController {

    // Account
    @IBOutlet weak var updateImageCell: UITableViewCell!
    @IBOutlet weak var updateNameCell: UITableViewCell!
    @IBOutlet weak var updateEmailCell: UITableViewCell!
    @IBOutlet weak var updatePWCell: UITableViewCell!
    @IBOutlet weak var updateBioCell: UITableViewCell!
    @IBOutlet weak var updateWebsiteCell: UITableViewCell!
    @IBOutlet weak var upateDiscoverDistanceCell: UITableViewCell!
    @IBOutlet weak var updatePrivacy: UITableViewCell!
    @IBOutlet weak var searchCell: UITableViewCell!
    
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
        let purp = UIColor(red: 155/255, green: 89/255, blue: 182/255, alpha: 1.0)
        self.updateImageCell.textLabel?.textColor = purp
        self.updateNameCell.textLabel?.textColor = purp
        self.updateEmailCell.textLabel?.textColor = purp
        self.updateEmailCell.tintColor = purp
        self.updatePWCell.textLabel?.textColor = purp
        self.updateBioCell.textLabel?.textColor = purp
        self.updateWebsiteCell.textLabel?.textColor = purp
        self.upateDiscoverDistanceCell.textLabel?.textColor = purp
        self.updatePrivacy.textLabel?.textColor = purp
        self.searchCell.textLabel?.textColor = purp
        // About
        self.privacyPolicyCell.textLabel?.textColor = purp
        self.privacyPolicyCell.tintColor = purp
        self.termsOfServiceCell.textLabel?.textColor = purp
        self.termsOfServiceCell.tintColor = purp
        self.legalCell.textLabel?.textColor = purp
        self.legalCell.tintColor = purp
        // Actions
        self.blockedListCell.textLabel?.textColor = purp
        self.logOutCell.textLabel?.textColor = purp
        self.deleteAccountCell.textLabel?.textColor = purp
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    let numberOfRowsAtSection: [Int] = [9, 3, 3] // ROWS IN A SECTION
    
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
        
        
        
        if indexPath.section == 0 && indexPath.row == 0 {
            performSegue(withIdentifier: "changePic", sender: self)
        }
        
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
        
        if indexPath.section == 0 && indexPath.row == 6 {
            performSegue(withIdentifier: "updateDistance", sender: self)
        }
        
        if indexPath.section == 0 && indexPath.row == 7 {
            performSegue(withIdentifier: "updatePrivacy", sender: self)
        }
        
        if indexPath.section == 0 && indexPath.row == 8 {
            performSegue(withIdentifier: "showSearch", sender: self)            
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            showJuggWebsite("https://jugg-88ab9.firebaseapp.com/privacy.pdf")
        }
        
        if indexPath.section == 1 && indexPath.row == 1 {
            showJuggWebsite("https://jugg-88ab9.firebaseapp.com/JuggTerms.pdf")
        }
        
        if indexPath.section == 1 && indexPath.row == 2 {
            showJuggWebsite("https://jugg-88ab9.firebaseapp.com/disclaimer.pdf")
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "BlockedTable")
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        
        // IF THE 'SIGN OUT' CELL IS TAPPED
        
        if indexPath.section == 2 && indexPath.row == 1 {
            let alert = UIAlertController(title:(NSLocalizedString("areYouSure", comment: "")), message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            let logout = UIAlertAction(title:(NSLocalizedString("logout", comment: "")), style: .default, handler: { (ACTION) in
                self.logMeOut()
                Globals .sharedInstance.saveValuetoUserDefaultsWithKeyandValue(false, key: "IS_LOGIN")

                print("Logged Out")
            })
            let cancel = UIAlertAction(title:(NSLocalizedString("cancel", comment: "")), style: .cancel, handler: { (ACTION) in
                print("Sign Out Cancelled")
            })
            
            alert.addAction(logout)
            alert.addAction(cancel)
            
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            alert.view.tintColor = purp
            
            self.present(alert, animated: true, completion:nil)
            
        }
    
        // Delete account
        
        if indexPath.section == 2 && indexPath.row == 2 {
        
            areYouSureAlert()
            
            
        }
        
    
    }

    
    
    
    func showJuggWebsite(_ website: String) {
        if let url = URL(string: website) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            present(vc, animated: true)
        }
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    
    func areYouSureAlert() {
        
        let areYouSure = UIAlertController(title:(NSLocalizedString("warn", comment: "")), message:(NSLocalizedString("areYouSure2", comment: "")), preferredStyle: .alert)
        
        
        let Delete = UIAlertAction(title:(NSLocalizedString("deleteAcct", comment: "")), style: .destructive) { (action) in
            
            self.deleteAccount()
            
            
        }
        
        let Cancel = UIAlertAction(title:(NSLocalizedString("cancel", comment: "")), style: .cancel) { (action) in
            
        }
        
        areYouSure.addAction(Delete)
        areYouSure.addAction(Cancel)
        
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        areYouSure.view.tintColor = purp
        self.present(areYouSure, animated: true, completion:nil)
        
        
        
        
        
    }
    
    func errorMessage() {
        let error = UIAlertController(title:(NSLocalizedString("sry", comment: "")), message:(NSLocalizedString("sryM", comment: "")), preferredStyle: .alert)
        
        let errorOK = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) in
        }
        
        
        error.addAction(errorOK)
        
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        error.view.tintColor = purp
        self.present(error, animated: true, completion:nil)
    }
    
    
    
    func deletedAlert() {
        
        let success = UIAlertController(title: nil, message:(NSLocalizedString("dsm", comment: "")) , preferredStyle: .alert)
        
        let OK = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) in
       
            self.performSegue(withIdentifier: "signOutFromSettings", sender: self)
        }
    
        success.addAction(OK)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        success.view.tintColor = purp
        self.present(success, animated: true, completion:nil)
    }
    
    func logMeOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "login")
        present(loginVC, animated: true, completion: nil)
    }
    
    
    func deleteAccount() {
        
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if error != nil {
                // An error happened.
                self.errorMessage()
            } else {
                // Account deleted.
                let ref = Database.database().reference()
                let uid = Auth.auth().currentUser?.uid
                ref.child("Users").child(uid!).removeValue()
                
                self.deletedAlert()
            
            }
        }
        
        
        
    }
    


   
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
    if segue.identifier == "changePic"
    {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    if segue.identifier == "changeName"
    {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
            
    }
    
    if segue.identifier == "updateEmail"
    {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
        
    if segue.identifier == "updatePW"
    {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
            
    }
    
    if segue.identifier == "updateBio"
    {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
        
    if segue.identifier == "updateWebsite"
    {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
            
    }
    
        
    if segue.identifier == "updateDistance"
    {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
            
    }
     
        
    if segue.identifier == "updatePrivacy"
    {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
            
    }
    
    if segue.identifier == "showSearch"
    {
      
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        
      
        
    }
        

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
   
}

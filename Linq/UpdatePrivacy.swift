//
//  UpdatePrivacy.swift
//  Linq
//
//  Created by Quinton Askew on 7/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class UpdatePrivacy: UIViewController {
    
    
    let ref = Database.database().reference().child("Users")
    let uid = Auth.auth().currentUser?.uid
    
    
    @IBOutlet weak var privateSwitch: UISwitch!
    var switchState: Bool! = nil
    let switchKey = "switchState"
    @IBAction func switchedOn(_ sender: UISwitch) {
        
        if(privateSwitch.isOn == false)
        {
            self.switchState = false
            let pageNowPublic = (NSLocalizedString("pt", comment: ""))
            let pageNowPublicMessage = (NSLocalizedString("publicMessage", comment: ""))
            alert(title: pageNowPublic, message: pageNowPublicMessage)
            updateSwitchStatus(status: 0)
            hideContainer()
            UserDefaults.standard.set(self.switchState, forKey: "switchState")
        }
        
        if (privateSwitch.isOn == true)
        {
            self.switchState = true
            let pageNowPrivate = (NSLocalizedString("privacyTitle", comment: ""))
            let pageNowPrivateMessage = (NSLocalizedString("privacyMessage", comment: ""))
            alert(title: pageNowPrivate, message: pageNowPrivateMessage)
            updateSwitchStatus(status: 1)
            showContainer()
            UserDefaults.standard.set(self.switchState, forKey: "switchState")
        }
        
        
        
    }
    
    @IBOutlet weak var containerForFRTable: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (NSLocalizedString("privacy", comment: ""))
        // hideContainer()
        self.privateSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
        if privateSwitch.isOn == false {
            hideContainer()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.privateSwitch.isOn = UserDefaults.standard.bool(forKey: "switchState")
    }
    
    func alert(title: String, message: String) {
        
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title:(NSLocalizedString("ok", comment: "")), style: .default) { (action) -> Void in
            
        }
        
        alertViewController.addAction(okAction)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alertViewController.view.tintColor = purp
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    
    func showContainer()
    {
        self.containerForFRTable.isHidden = false
    }
    
    func hideContainer()
    {
        self.containerForFRTable.isHidden = true
    }
    
    func updateSwitchStatus(status: Int)
    {
        ref.child(uid!).updateChildValues(["UserPrivate" : status], withCompletionBlock: { (error, snapshot) in
            if error != nil {
                print(error!)
                return
            }
            print("User is now private.")
            
        })
        
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

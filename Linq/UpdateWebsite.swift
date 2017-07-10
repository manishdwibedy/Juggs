//
//  UpdateWebsite.swift
//  Linq
//
//  Created by Quinton Askew on 6/18/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class UpdateWebsite: UIViewController {

    @IBOutlet weak var websiteTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton! // Save Button
    @IBAction func websiteUpdated(_ sender: Any) {
   
        if websiteTF.text == nil {
            return
        }
        Globals.ShowSpinner(testStr: "")
        
        let uid = Auth.auth().currentUser?.uid
        let Ref = "Users/" + uid!
        Database.database().reference().root.child(Ref).updateChildValues(["Website": websiteTF.text!])
        Globals.HideSpinner()
        
        let alertViewController = UIAlertController(title: "Website Updated Succefully!", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertViewController.addAction(okAction)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alertViewController.view.tintColor = purp
        self.present(alertViewController, animated: true, completion: nil)

    
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        visuals()

    }

    func visuals() {
        self.title = "Website"
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 8
        submitBtn.isEnabled = false
        
        websiteTF.layer.masksToBounds = true
        websiteTF.layer.cornerRadius = 6
        websiteTF.layer.borderWidth = 1
        websiteTF.layer.borderColor = UIColor.black.cgColor
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

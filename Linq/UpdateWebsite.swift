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
    @IBOutlet weak var submitBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        visuals()

    }
    @IBAction func UpdateRecord(_ sender: Any) {
        
        if websiteTF.text == nil {
            return
        }
        Globals.ShowSpinner(testStr: "")

        let uid = Auth.auth().currentUser?.uid
        let Ref = "Users/" + uid!
        Database.database().reference().root.child(Ref).updateChildValues(["Website": websiteTF.text!])
        Globals.HideSpinner()
        
        let alertViewController = UIAlertController(title: "Record Successfully Updated.", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: nil)


    }
    func visuals() {
        self.title = "Website"
        websiteTF.text = Globals .sharedInstance.getValueFromUserDefaultsForKey("Website") as? String

        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 8
        
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

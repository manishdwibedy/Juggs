//
//  UpdateBio.swift
//  Linq
//
//  Created by Quinton Askew on 6/18/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase
class UpdateBio: UIViewController {

    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visuals()
        bioTextView.text = Globals .sharedInstance.getValueFromUserDefaultsForKey("Bio") as? String

    }
    @IBAction func UpdateRecord(_ sender: Any) {
        
        if bioTextView.text == nil {
            return
        }
        Globals.ShowSpinner(testStr: "")
        let uid = Auth.auth().currentUser?.uid
        
        let Ref = "Users/" + uid!
        Database.database().reference().root.child(Ref).updateChildValues(["Bio": bioTextView.text!])
        
        Globals.HideSpinner()
        let alertViewController = UIAlertController(title: "Record Successfully Updated.", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: nil)

        
    }
    func visuals() {
        self.title = "Bio"
        bioTextView.layer.masksToBounds = true
        submitBtn.layer.masksToBounds = true
        bioTextView.layer.cornerRadius = 8
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

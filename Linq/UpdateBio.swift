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
    
    @IBAction func bioUpdated(_ sender: Any) {
        if bioTextView.text == nil {
            return
        }
        Globals.ShowSpinner(testStr: "")
        let uid = Auth.auth().currentUser?.uid
        
        let Ref = "Users/" + uid!
        Database.database().reference().root.child(Ref).updateChildValues(["Bio": bioTextView.text!])
        
        Globals.HideSpinner()
        let alertViewController = UIAlertController(title: "Bio Updated Successfully!", message: "", preferredStyle: .alert)
        
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
        bioTextView.text = Globals .sharedInstance.getValueFromUserDefaultsForKey("Bio") as? String

    }
    
    func visuals() {
        self.title = "Bio"
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 8
        submitBtn.isEnabled = false
        
        
        bioTextView.layer.masksToBounds = true
        bioTextView.layer.cornerRadius = 8
        bioTextView.layer.borderWidth = 1
        bioTextView.layer.borderColor = UIColor.black.cgColor
        
        
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

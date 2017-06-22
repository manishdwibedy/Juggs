//
//  UpdateBio.swift
//  Linq
//
//  Created by Quinton Askew on 6/18/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class UpdateBio: UIViewController {

    @IBOutlet weak var bioTextView: UITextView!
    
    @IBOutlet weak var submitBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visuals()
        bioTextView.text = Globals .sharedInstance.getValueFromUserDefaultsForKey("Bio") as? String

    }
    
    func visuals() {
        self.title = "Bio"
        bioTextView.layer.masksToBounds = true
        submitBtn.layer.masksToBounds = true
        bioTextView.layer.cornerRadius = 8
        submitBtn.layer.cornerRadius = 8
        submitBtn.isEnabled = false
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

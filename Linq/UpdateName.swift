//
//  UpdateAccount.swift
//  Linq
//
//  Created by Quinton Askew on 6/2/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class UpdateName: UIViewController {

    
    
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var saveNameBtn: UIButton!
    @IBAction func saveName(_ sender: Any) {
    
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        visuals()
        
    }
    
    func visuals() {
        self.title = "Name"
        self.instructionsLabel.text = "Update your first and last name."
        self.saveNameBtn.isEnabled = false
        self.saveNameBtn.layer.masksToBounds = true
        self.saveNameBtn.layer.cornerRadius = 8
        
        firstNameTF.text = Globals .sharedInstance.getValueFromUserDefaultsForKey("FName") as? String
        
        lastNameTF.text = Globals .sharedInstance.getValueFromUserDefaultsForKey("LName") as? String

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

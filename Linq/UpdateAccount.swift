//
//  UpdateAccount.swift
//  Linq
//
//  Created by Quinton Askew on 6/2/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class UpdateAccount: UIViewController {

  var fromControllerNamed = ""
  var instructions = ""
    
    @IBOutlet weak var instructionsLabel: UILabel!
    // Name Objects
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var saveNameBtn: UIButton!
    @IBAction func saveName(_ sender: Any) {
    
    
    }
    
    // Email Objects
    @IBOutlet weak var emailLabel: UILabel!
    
    // Bio
    @IBOutlet weak var bioTF: UITextView!
    
    @IBOutlet weak var bioBtn: UIButton!
    
    @IBAction func saveBio(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

       self.navigationItem.title = fromControllerNamed
       instructionsLabel.text = instructions
        
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

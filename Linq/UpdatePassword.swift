//
//  UpdatePassword.swift
//  Linq
//
//  Created by Quinton Askew on 6/18/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase


class UpdatePassword: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visuals()
    }
    
   
    
    
    
    func visuals() {
        self.title = "Password"
        submitBtn.layer.masksToBounds = true
        submitBtn.layer.cornerRadius = 8
        submitBtn.isEnabled = false
        
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

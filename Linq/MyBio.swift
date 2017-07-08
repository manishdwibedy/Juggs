//
//  MyBio.swift
//  Linq
//
//  Created by Quinton Askew on 7/2/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class MyBio: UIViewController {

    @IBOutlet weak var websiteTextView: UITextView!
    @IBOutlet weak var biographyTextView: UITextView!
    
    var biographyText = ""
    var websiteText = ""
    
    
    
    
    func fetchBio() {
        
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("Users").child(uid!).queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let bio = dict["Bio"] as? String!
                
                    self.biographyTextView.text = bio!
            }
            
            
            
        })
        
        ref.removeAllObservers()
        
    }

    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        fetchBio()
        websiteTextView.text = "Edit URL in Settings."
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

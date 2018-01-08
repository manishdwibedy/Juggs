//
//  UpdateDiscoverDistance.swift
//  Linq
//
//  Created by Quinton Askew on 7/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class UpdateDiscoverDistance: UIViewController {

    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBAction func distanceChanged(_ sender: Any) {
        distanceSlider.value = roundf(distanceSlider.value)
        
        self.distanceLbl.text = "\(self.distanceSlider.value) mi"
        let ref = Database.database().reference().child("Users")
        let uid = Auth.auth().currentUser?.uid
        
        ref.child(uid!).updateChildValues(["Distance_Discover" : "\(distanceSlider.value)"], withCompletionBlock: { (error, snapshot) in
            if error != nil {
                print(error!)
                return
            }
            
        })
        
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = (NSLocalizedString("discover", comment: ""))
        self.distanceLbl.text = "100 mi"
        let ref = Database.database().reference().child("Users")
        let uid = Auth.auth().currentUser?.uid
        
        ref.child(uid!).child("Distance_Discover").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            if (snapshot.value as? String) == nil {
                ref.child(uid!).updateChildValues(["Distance_Discover" : "500"], withCompletionBlock: { (error, snapshot) in
                    if error != nil {
                        print(error!)
                        return
                    }
                })

            } else {
                self.distanceSlider.value = Float(snapshot.value as! String)!
                self.distanceLbl.text = "\(self.distanceSlider.value) mi"
            }
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

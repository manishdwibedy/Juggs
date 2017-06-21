//
//  NotificationBox.swift
//  Linq
//
//  Created by Quinton Askew on 5/29/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class NotificationBox: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var inboxView: UIView!
   
    @IBOutlet weak var invitationView: UIView!
    
    @IBAction func pageChanged(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 0 {
            
            inboxView.isHidden = false
            invitationView.isHidden = true
        }else{
            
            
            inboxView.isHidden = true
            invitationView.isHidden = false
        }
    
    
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.selectedSegmentIndex = 1
        self.tabBarController?.tabBar.tintColor = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
     self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.black//UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        segmentedControl.layer.borderWidth = 2
        segmentedControl.layer.borderColor = UIColor.black.cgColor
    }
    
    
    
    
    
}

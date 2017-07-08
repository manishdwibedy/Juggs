//
//  Relations.swift
//  Linq
//
//  Created by Quinton Askew on 6/20/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class Relations: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var followingView: UIView!
    @IBOutlet weak var followersView: UIView!
    @IBAction func segmentChanged(_ sender: Any) {
        
        if(segmentedControl.selectedSegmentIndex == 0) {
            followingView.isHidden = false
            followersView.isHidden = true
        }else{
            followingView.isHidden = true
            followersView.isHidden = false
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl.selectedSegmentIndex = 0
        segmentChanged((Any).self)
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.borderWidth = 2
        segmentedControl.layer.cornerRadius = 15
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        segmentedControl.layer.borderColor = purp.cgColor
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

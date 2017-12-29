//
//  Relations.swift
//  Linq
//
//  Created by Quinton Askew on 6/20/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

var UserIdRelations = ""

class Relations: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var followingView: UIView!
    @IBOutlet weak var followersView: UIView!
    @IBAction func segmentChanged(_ sender: Any) {
        
        if(segmentedControl.selectedSegmentIndex == 0) {
            followingView.isHidden = false
            followersView.isHidden = true
        } else {
            followingView.isHidden = true
            followersView.isHidden = false
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visual()
    }

    
    func folllowersUpdate(_ notification: NSNotification)
    {
        if let followersCount = notification.userInfo?["userCount"] as? Int {
            // do something with your image
            if followersCount == 0 {
                segmentedControl.setTitle((NSLocalizedString("followers", comment: "")), forSegmentAt: 1)
            } else {
                segmentedControl.setTitle("\(NSLocalizedString("followers", comment: ""))(\(followersCount))", forSegmentAt: 1)
            }
            
        } else {
            segmentedControl.setTitle("\(NSLocalizedString("followers", comment: ""))", forSegmentAt: 1)
        }
//        NotificationCenter.default.removeObserver(self)
        
    }
    
    func folllowingUpdate(_ notification: NSNotification)
    {
        if let followingCount = notification.userInfo?["userCount"] as? Int {
            // do something with your image
            if followingCount == 0 {
                segmentedControl.setTitle("\(NSLocalizedString("following", comment: ""))", forSegmentAt: 0)
            } else {
                segmentedControl.setTitle("\(NSLocalizedString("following", comment: ""))(\(followingCount))", forSegmentAt: 0)
            }

        } else {
            segmentedControl.setTitle((NSLocalizedString("following", comment: "")), forSegmentAt: 0)
        }
    }
    
    
    
    func visual()
    {
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        segmentedControl.selectedSegmentIndex = 0
        segmentChanged((Any).self)
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.borderWidth = 2
        segmentedControl.layer.cornerRadius = 15
        segmentedControl.layer.borderColor = purp.cgColor
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.folllowersUpdate(_:)),
            name: NSNotification.Name(rawValue: "followers"),
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.folllowingUpdate(_:)),
            name: NSNotification.Name(rawValue: "following"),
            object: nil)

        
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

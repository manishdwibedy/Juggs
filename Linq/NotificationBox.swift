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
        } else {
            inboxView.isHidden = true
            invitationView.isHidden = false
        }
    
    
    
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        visuals()
        
    }
    
    func visuals() {
       let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        segmentedControl.layer.borderColor = purp.cgColor
        self.tabBarController?.tabBar.tintColor = purp
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.layer.cornerRadius = 15
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.borderWidth = 2
      
        let messageCount = MessagesTable().messages.count
        let invitationsCount = Invitations().invitationsArray.count
        let requestCount = Invitations().requestArray.count
        let countForSegCon = invitationsCount + requestCount
        
        if requestCount == 0 {
            let titleInboxSegment = (NSLocalizedString("inbox", comment: ""))
            segmentedControl.setTitle(titleInboxSegment, forSegmentAt: 0)
        }
        else
        {
            let titleInboxSegment = "\(NSLocalizedString("inbox", comment: "")) (\(messageCount))"
            segmentedControl.setTitle(titleInboxSegment, forSegmentAt: 0)

        }
        
        if countForSegCon == 0 {
            let titleForInviteSegment = (NSLocalizedString("invitations", comment: ""))
            segmentedControl.setTitle(titleForInviteSegment, forSegmentAt: 1)

        }
        else
        {
            let titleForInviteSegment = "\(NSLocalizedString("invitations", comment: "")) (\(countForSegCon))"
            segmentedControl.setTitle(titleForInviteSegment, forSegmentAt: 1)

        }
        
        

    }
    
   
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if event?.subtype == UIEventSubtype.motionShake && segmentedControl.selectedSegmentIndex == 0 {
            let titleForAlert = "\(NSLocalizedString("nm", comment: ""))?"
            let titleForVC = (NSLocalizedString("nm", comment: ""))
            Alert(typeOfAlert: titleForAlert, nameForController: titleForVC)
        } else if event?.subtype == UIEventSubtype.motionShake && segmentedControl.selectedSegmentIndex == 1 {
            let titleForAlert = "\(NSLocalizedString("ni", comment: ""))?"
            let titleForVC = (NSLocalizedString("ni", comment: ""))
            Alert(typeOfAlert: titleForAlert, nameForController: titleForVC)
        }
        
    }
    
    
    
    func Alert(typeOfAlert: String, nameForController: String) {
        
        let alert = UIAlertController(title: typeOfAlert, message: nil, preferredStyle: .alert)
        let confirm = UIAlertAction(title:(NSLocalizedString("confirm", comment: "")), style: .default) { (action) in
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "NewBoxMove")
            let navController = UINavigationController(rootViewController: vc)
            vc.title = nameForController
            vc.navigationController?.navigationBar.barTintColor = UIColor.clear
            self.present(navController, animated: true, completion: nil)
//            print("NewBoxMove Controller")
        }
        
        let cancel = UIAlertAction(title:(NSLocalizedString("cancel", comment: "")), style: .cancel) { (action) in
//            print("Don't Show New Message Controller")
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        alert.view.tintColor = purp
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

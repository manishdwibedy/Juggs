//
//  Description.swift
//  Linq
//
//  Created by Quinton Askew on 5/28/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

import UserNotifications

class Description: UIViewController {
    
    @IBOutlet weak var moveTitle: UILabel!
    @IBOutlet weak var flyerImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var requestBtn: UIButton!
    @IBAction func request(_ sender: Any) {
        
        let notification = UNMutableNotificationContent()
        notification.title = "Request"
        notification.subtitle = "You have recieved a request to join!"
        notification.body = "Open Linq now to respond."
        
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "notification1", content: notification, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    var moveName = ""
    var date = ""
    var amOrPM = ""
    var time = ""
    var privateOrPublic = ""
    var descriptionText = ""
    var pathToImage = ""
    
    
    @IBAction func share(_ sender: Any) {
        
        // image to share
        let image = UIImage(named: pathToImage)
        
        
        // text with it
        // let message = ""
        
        // set up activity view controller
        let imageToShare = [ image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // exclude some activity types from the list (optional)
        //     activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visuals()
        getPostData()
        initNotificationSetupCheck()
    }
    
    
    
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                print("Permission Granted")
            } else {
                print("There was a problem!")
            }
        }
    }
    
    func getPostData() {
        
        self.title = moveName
        // moveTitle.text = moveName
        flyerImageView.downloadImage(from: pathToImage)
        flyerImageView.sd_setImage(with: URL(string: "\(String(describing: pathToImage))"), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
        
        let timePlusAMPM = time + " " + amOrPM
        timeLabel.text = timePlusAMPM
        dateLabel.text = date
        
        descriptionTV.text = descriptionText
        /*     if(privatOrPublic == "true") {
         
         pOpLabel.text = "This Move is Private!"
         
         }else{
         
         pOpLabel.text = "This Move is Public!"
         requestBtn.isHidden = true
         }
         
         descriptionTV.text = descriptionText
         
         }   */
        
        
    }
    
    
    func visuals() {
        
        flyerImageView.layer.masksToBounds = true
        requestBtn.layer.cornerRadius = 8
        flyerImageView.layer.cornerRadius = 8
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
}

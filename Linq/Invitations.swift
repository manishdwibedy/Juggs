//
//  Invitations.swift
//  Linq
//
//  Created by Quinton Askew on 6/3/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import Firebase

class Invitations: UITableViewController {
    
    var invitationsArray = [Invitation]()
    var requestArray = [Request]()
    var sentInvitations = [Invitation]()
    var sentRequest = [Request]()
    
    var keyArrayInvites = [String]()
    var keyArrayRequest = [String]()
    var sentKeyArrayInvites = [String]()
    var sentKeyArrayRequest = [String]()
    
    var InviteDates = [String]()
    var RequestDates = [String]()
    
    let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = #imageLiteral(resourceName: "NoMessageBGD")
        let imageView = UIImageView(image: backgroundImage)
        self.tableView.backgroundView = imageView
        self.tableView.rowHeight = 500
        
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Fetching Invitations & Request...")
        refreshControl?.addTarget(self, action: #selector(Invitations.fetchProfile), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl!) // not required when using UITableViewController
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchProfile()
    }
    
    func fetchProfile() {
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        
        ref.child("Users").child(uid!).observe(DataEventType.value, with: { (snapshot) in
            
            self.requestArray.removeAll()
            self.keyArrayRequest.removeAll()
            self.keyArrayInvites.removeAll()
            self.invitationsArray.removeAll()
            
            self.sentRequest.removeAll()
            self.sentInvitations.removeAll()
            self.sentKeyArrayInvites.removeAll()
            self.sentKeyArrayRequest.removeAll()
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

            
            
            if let dict = snapshot.value as? [String : AnyObject] {
                
                let requests = dict["Requests"] as? [String:AnyObject]
                let invites = dict["Invites"] as? [String:AnyObject]
                
                if requests != nil {
                    
                    for(keys,values) in requests! {
                        
                        let newPost = Request()
                        newPost.from = values["from"] as? String
                        newPost.fromName = values["fromName"] as? String
                        newPost.fromuserImagePath = values["fromuserImagePath"] as? String
                        
                        newPost.touserImagePath = values["touserImagePath"] as? String
                        newPost.touserID = values["touserID"] as? String
                        newPost.touserName = values["touserName"] as? String
                        
                        newPost.eventName = values["eventName"] as? String
                        newPost.postID = values["postID"] as? String
                        newPost.status = values["status"] as? String
                        newPost.flyerImagePath = values["flyerImagePath"] as? String
                        newPost.date = values["postDate"] as? String
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                        
                        let postdate =  dateFormatter.date(from: newPost.date)
                        
                        if postdate != nil {
                            let elapsed = Date().timeIntervalSince(postdate!)
                            let diff = self.stringFromTimeIntervalinHours(interval: elapsed)
                            
                            if diff.intValue <= 24
                            {
                                if newPost.from == uid {
                                    self.sentKeyArrayRequest.append(keys)
                                    self.sentRequest.append(newPost)
                                    
                                } else {
                                    self.keyArrayRequest.append(keys)
                                    self.requestArray.append(newPost)
                                    
                                }
                            }
                        }
                        
                    }
                    
                }
                
                if invites != nil {
                    
                    for(keys,values) in invites! {
                        
                        let newPost = Invitation()
                        newPost.from = values["from"] as? String
                        newPost.fromName = values["fromName"] as? String
                        newPost.fromuserImagePath = values["fromuserImagePath"] as? String
                        newPost.touserImagePath = values["touserImagePath"] as? String
                        newPost.touserID = values["touserID"] as? String
                        newPost.touserName = values["touserName"] as? String
                        newPost.eventName = values["eventName"] as? String
                        newPost.postID = values["postID"] as? String
                        newPost.status = values["status"] as? String
                        newPost.flyerImagePath = values["flyerImagePath"] as? String
                        newPost.date = values["postDate"] as? String
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                        
                        let postdate =  dateFormatter.date(from: newPost.date)
                        
                        if postdate != nil {
                            let elapsed = Date().timeIntervalSince(postdate!)
                            let diff = self.stringFromTimeIntervalinHours(interval: elapsed)
                            
                            if diff.intValue <= 24
                            {
                                if newPost.from == uid {
                                    self.sentKeyArrayInvites.append(keys)
                                    self.sentInvitations.append(newPost)
                                    
                                } else {
                                    self.keyArrayInvites.append(keys)
                                    self.invitationsArray.append(newPost)
                                }
                            }
                        }
                        
                        
                    }
                    
                    
                }
            }
            
            
            ref.child("Flyers").queryOrderedByKey().observeSingleEvent(of:DataEventType.value, with: { snapshot in
                
                let posts = snapshot.value as! [String : AnyObject]
                
                for (_,value) in posts {
                    if let user = value["UserID"] as? String {
                        if uid == user {
                            
                            let requests = value["Requests"] as? [String:AnyObject]
                            let invites = value["Invites"] as? [String:AnyObject]
                            
                            if requests != nil {
                                
                                for(keys,values) in requests! {
                                    
                                    let newPost = Request()
                                    newPost.from = values["from"] as? String
                                    newPost.fromName = values["fromName"] as? String
                                    newPost.fromuserImagePath = values["fromuserImagePath"] as? String
                                    
                                    newPost.touserImagePath = values["touserImagePath"] as? String
                                    newPost.touserID = values["touserID"] as? String
                                    newPost.touserName = values["touserName"] as? String
                                    
                                    newPost.eventName = values["eventName"] as? String
                                    newPost.postID = values["postID"] as? String
                                    newPost.status = values["status"] as? String
                                    newPost.flyerImagePath = values["flyerImagePath"] as? String
                                    newPost.date = values["postDate"] as? String
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                                    
                                    let postdate =  dateFormatter.date(from: newPost.date)
                                    
                                    if postdate != nil {
                                        let elapsed = Date().timeIntervalSince(postdate!)
                                        let diff = self.stringFromTimeIntervalinHours(interval: elapsed)
                                        
                                        if diff.intValue <= 24
                                        {
                                            if newPost.from == uid {
                                                self.sentKeyArrayRequest.append(keys)
                                                self.sentRequest.append(newPost)
                                                
                                            } else {
                                                self.keyArrayRequest.append(keys)
                                                self.requestArray.append(newPost)
                                                
                                            }
                                            
                                            
                                        }
                                    }
                                    
                                }
                                
                            }
                            
                            if invites != nil {
                                
                                for(keys,values) in invites! {
                                    
                                    let newPost = Invitation()
                                    newPost.from = values["from"] as? String
                                    newPost.fromName = values["fromName"] as? String
                                    newPost.fromuserImagePath = values["fromuserImagePath"] as? String
                                    
                                    newPost.touserImagePath = values["touserImagePath"] as? String
                                    newPost.touserID = values["touserID"] as? String
                                    newPost.touserName = values["touserName"] as? String
                                    
                                    newPost.eventName = values["eventName"] as? String
                                    newPost.postID = values["postID"] as? String
                                    newPost.status = values["status"] as? String
                                    newPost.flyerImagePath = values["flyerImagePath"] as? String
                                    newPost.date = values["postDate"] as? String
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
                                    
                                    let postdate =  dateFormatter.date(from: newPost.date)
                                    
                                    if postdate != nil {
                                        let elapsed = Date().timeIntervalSince(postdate!)
                                        let diff = self.stringFromTimeIntervalinHours(interval: elapsed)
                                        
                                        if diff.intValue <= 24
                                        {
                                            if newPost.from == uid {
                                                self.sentKeyArrayInvites.append(keys)
                                                self.sentInvitations.append(newPost)
                                                
                                            } else {
                                                self.keyArrayInvites.append(keys)
                                                self.invitationsArray.append(newPost)
                                            }
                                        }
                                    }
                                }
                                
                            }
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                
            });
            
            ref.removeAllObservers()
            
            
        })
        
        ref.removeAllObservers()
        Globals.HideSpinner()
        self.refreshControl?.endRefreshing()
        self.refreshControl?.isUserInteractionEnabled = true
        
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return (NSLocalizedString("invitations", comment: ""))
        } else if section == 1 {
            return (NSLocalizedString("rq", comment: ""))
            
        } else if section == 2 {
            return (NSLocalizedString("ins", comment: ""))
        } else {
            return (NSLocalizedString("rs", comment: ""))
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0   {
            
            let strStatus =  self.invitationsArray[indexPath.row].status
            if strStatus == "0" || strStatus == "1" || strStatus == "3" {
                return 512
            } else {
                return 446
            }
            
            
        }
        
        if indexPath.section == 1 {
            let strStatus =  self.requestArray[indexPath.row].status
            if strStatus == "0" {
                return 512
            } else {
                return 446
            }
            
        }
        
        if indexPath.section == 2 {
            return 446
        }
        
        
        if indexPath.section == 3 {
            
            let strStatus =  self.sentRequest[indexPath.row].status
            if strStatus == "2" || strStatus == "4" {
                return 446
            } else {
                return 512
            }
        }
        
        
        return 446
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return invitationsArray.count
        }
        
        if section == 1 {
            return requestArray.count
        }
        
        if section == 2 {
            return sentInvitations.count
        }
        
        if section == 3 {
            return sentRequest.count
        }
        
        return 0
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let uid = Auth.auth().currentUser?.uid
        
        if indexPath.section == 0 {
            let inviteCell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath) as! InvitationCell
            
            inviteCell.flyerImageView.sd_setImage(with: URL(string: self.invitationsArray[indexPath.row].flyerImagePath), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
            
//            let invite = invitationsArray[indexPath.row]
            
            let strStatus =  self.invitationsArray[indexPath.row].status
            
            inviteCell.acceptBtn.tag = indexPath.row
            inviteCell.declineBtn.tag = indexPath.row
            inviteCell.speculationBtn.tag = indexPath.row
            
            inviteCell.speculationBtn.isHidden = true
            inviteCell.acceptBtn.isHidden = false
            inviteCell.declineBtn.isHidden = false
            
            inviteCell.titleLabel.text = self.invitationsArray[indexPath.row].eventName
            
            inviteCell.btnProfile.tag = (indexPath.section * 1000) + indexPath.row
            inviteCell.btnProfile.addTarget(self, action: #selector(buttonProfileInvites(_:)), for: .touchUpInside)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
            let dateTime = self.invitationsArray[indexPath.row].date
            let postdate =  dateFormatter.date(from: dateTime!)
            
            if postdate != nil {
                
                let elapsed = Date().timeIntervalSince(postdate!)
                let diff = self.stringFromTimeInterval(interval: elapsed)
                
                if diff.intValue > 0 {
                    inviteCell.speculationBtn.setTitle("Attendance", for: .normal)
                } else {
                    inviteCell.speculationBtn.setTitle("Guest List", for: .normal)
                }
            }
            
            inviteCell.userImageView.sd_setImage(with: URL(string: self.invitationsArray[indexPath.row].fromuserImagePath), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
            inviteCell.messageLabel.text = "\(self.invitationsArray[indexPath.row].fromName ?? "") has invited you to attend!"
            
            if strStatus == "0" {
                
                inviteCell.speculationBtn.isHidden = false
                
                inviteCell.acceptBtn.isHidden = false
                inviteCell.declineBtn.isHidden = false
                inviteCell.acceptBtn.layer.borderColor = UIColor.green.cgColor
                inviteCell.acceptBtn.isEnabled = true
                inviteCell.declineBtn.isEnabled = true
                
                inviteCell.acceptBtn.addTarget(self, action: #selector(invitationAccepted(_:)), for: .touchUpInside)
                inviteCell.declineBtn.addTarget(self, action: #selector(invitationDeclined(_:)), for: .touchUpInside)
                
            } else if strStatus == "1" {
                inviteCell.acceptBtn.isHidden = false
                inviteCell.declineBtn.isHidden = false
                
                inviteCell.acceptBtn.isEnabled = true
                inviteCell.declineBtn.isEnabled = true
                
                inviteCell.speculationBtn.isHidden = false
                
                if postdate != nil {
                    
                    let elapsed = Date().timeIntervalSince(postdate!)
                    let diff = self.stringFromTimeInterval(interval: elapsed)
                    if diff.intValue > 0 {
                        inviteCell.acceptBtn.setTitle("Check In", for: .normal)
                        
                        inviteCell.acceptBtn.addTarget(self, action: #selector(invitationCheckIn(_:)), for: .touchUpInside)
                    } else {
                        inviteCell.acceptBtn.setTitle("Accepted", for: .normal)
                        
                        inviteCell.acceptBtn.isEnabled = false
                    }
                    
                }
                
                inviteCell.declineBtn.setTitle("Opt Out", for: .normal)
                
                
                inviteCell.declineBtn.addTarget(self, action: #selector(invitationOptOut(_:)), for: .touchUpInside)
                
            } else if strStatus == "2" {
                inviteCell.acceptBtn.isHidden = true
                inviteCell.declineBtn.isHidden = false
                inviteCell.declineBtn.setTitle("Declined", for: .normal)
                inviteCell.declineBtn.isEnabled = false
                
            } else if strStatus == "3" {
                
                inviteCell.acceptBtn.isHidden = false
                inviteCell.declineBtn.isHidden = false
                
                inviteCell.acceptBtn.isEnabled = true
                inviteCell.declineBtn.isEnabled = true
                
                inviteCell.speculationBtn.isHidden = false
                
                inviteCell.acceptBtn.setTitle("Checked In", for: .normal)
                inviteCell.declineBtn.setTitle("Opt Out", for: .normal)
                
                inviteCell.declineBtn.addTarget(self, action: #selector(invitationOptOut(_:)), for: .touchUpInside)
                
            } else {
                inviteCell.acceptBtn.isHidden = true
                inviteCell.declineBtn.isHidden = false
                
                inviteCell.declineBtn.setTitle("Opt Out", for: .normal)
                
                inviteCell.declineBtn.isEnabled = false
                
            }
            
            inviteCell.speculationBtn.addTarget(self, action: #selector(actionAttendeesInvites(_:)), for: .touchUpInside)
            
            return inviteCell
        }
        
        if indexPath.section == 1 {
            
            let requestCell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestCell
            requestCell.userImage.sd_setImage(with: URL(string: self.requestArray[indexPath.row].flyerImagePath), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
            
            let strStatus =  self.requestArray[indexPath.row].status
            requestCell.nameLabel.text = self.requestArray[indexPath.row].eventName
            
            requestCell.acceptButton.tag = indexPath.row
            requestCell.declineButton.tag = indexPath.row
            
            requestCell.acceptButton.isHidden = false
            requestCell.declineButton.isHidden = false
            requestCell.speculationBtn.isHidden = true
            
            //     let request = self.requestArray[indexPath.row]
            
            requestCell.btnProfile.tag = (indexPath.section * 1000) + indexPath.row
            requestCell.btnProfile.addTarget(self, action: #selector(buttonProfileRequests(_:)), for: .touchUpInside)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
            let dateTime = self.requestArray[indexPath.row].date
            let postdate =  dateFormatter.date(from: dateTime!)
            
            if postdate != nil {
                
                let elapsed = Date().timeIntervalSince(postdate!)
                let diff = self.stringFromTimeInterval(interval: elapsed)
                
                if diff.intValue > 0 {
                    requestCell.speculationBtn.setTitle("Attendance", for: .normal)
                } else {
                    requestCell.speculationBtn.setTitle("Guest List", for: .normal)
                }
            }
            
            
            requestCell.userImageView.sd_setImage(with: URL(string: self.requestArray[indexPath.row].fromuserImagePath), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
            requestCell.messageLabel.text = "\(self.requestArray[indexPath.row].fromName ?? "") has requested to join!"
            
            requestCell.speculationBtn.isHidden = true
            
            if strStatus == "0" {
                requestCell.acceptButton.isHidden = false
                requestCell.declineButton.isHidden = false
                
                requestCell.acceptButton.isEnabled = true
                requestCell.acceptButton.isEnabled = true
                
                requestCell.acceptButton.addTarget(self, action: #selector(actionAcceptRequest(_:)), for: .touchUpInside)
                requestCell.declineButton.addTarget(self, action: #selector(actionDeclineRequest(_:)), for: .touchUpInside)
                
            } else if strStatus == "1" {
                //348.5
                requestCell.widthDeclineConstraint.constant = self.view.frame.size.width - 16
                requestCell.declineButton.isHidden = true
                requestCell.acceptButton.setTitle("Accepted", for: .normal)
                requestCell.acceptButton.isEnabled = false
            } else if strStatus == "2" {
                requestCell.acceptButton.isHidden = false
                requestCell.declineButton.isHidden = true
                requestCell.acceptButton.isEnabled = false
                requestCell.widthDeclineConstraint.constant = self.view.frame.size.width - 16
                requestCell.acceptButton.setTitle("Declined", for: .normal)
                requestCell.acceptButton.setTitleColor(.red, for: .normal)
                requestCell.acceptButton.layer.borderColor = UIColor.red.cgColor
            } else if strStatus == "3" {
                requestCell.acceptButton.isHidden = false
                requestCell.declineButton.isHidden = true
                requestCell.widthDeclineConstraint.constant = self.view.frame.size.width - 16
                requestCell.acceptButton.isEnabled = false
                requestCell.acceptButton.setTitle("Checked In",  for: .normal)
            } else {
                requestCell.acceptButton.isHidden = false
                requestCell.declineButton.isHidden = true
                requestCell.widthDeclineConstraint.constant = self.view.frame.size.width - 16
                requestCell.acceptButton.isEnabled = false
                requestCell.acceptButton.setTitle("Opt Out", for: .normal)
                
            }
            

            
            return requestCell
            
        }
        
        if indexPath.section == 2 {
            
            let inviteCell = tableView.dequeueReusableCell(withIdentifier: "invitationCell", for: indexPath) as! InvitationCell
            
            inviteCell.flyerImageView.sd_setImage(with: URL(string: self.sentInvitations[indexPath.row].flyerImagePath), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
            

            
            let strStatus =  self.sentInvitations[indexPath.row].status
            
            inviteCell.acceptBtn.tag = indexPath.row
            inviteCell.declineBtn.tag = indexPath.row
            
            inviteCell.speculationBtn.isHidden = true
            inviteCell.acceptBtn.isHidden = false
            inviteCell.declineBtn.isHidden = false
            
            inviteCell.titleLabel.text = self.sentInvitations[indexPath.row].eventName
            
            inviteCell.btnProfile.tag = (indexPath.section * 1000) + indexPath.row
            inviteCell.btnProfile.addTarget(self, action: #selector(buttonProfileInvites(_:)), for: .touchUpInside)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
            let dateTime = self.sentInvitations[indexPath.row].date
            let postdate =  dateFormatter.date(from: dateTime!)
            
            if postdate != nil {
                
                let elapsed = Date().timeIntervalSince(postdate!)
                let diff = self.stringFromTimeInterval(interval: elapsed)
                
                if diff.intValue > 0 {
                    inviteCell.speculationBtn.setTitle("Attendance", for: .normal)
                } else {
                    inviteCell.speculationBtn.setTitle("Guest List", for: .normal)
                }
            }
            
            inviteCell.userImageView.sd_setImage(with: URL(string: self.sentInvitations[indexPath.row].touserImagePath), placeholderImage:#imageLiteral(resourceName: "danceplaceholder"))
            
            let username = self.sentInvitations[indexPath.row].touserName as String
            inviteCell.messageLabel.text = "You have invited \(username) to attend!"
            inviteCell.widthAcceptConstraint.constant = self.view.frame.size.width - 16
            
            inviteCell.acceptBtn.isEnabled = false
            inviteCell.declineBtn.isHidden = true
            
            if strStatus == "0" {
                inviteCell.acceptBtn.setTitle("Pending...", for: .normal)
                inviteCell.acceptBtn.layer.borderColor = purp.cgColor
                inviteCell.acceptBtn.setTitleColor(purp, for: .normal)
            } else if strStatus == "1" {
                inviteCell.acceptBtn.setTitle("Accepted", for: .normal)
            } else if strStatus == "2" {
                inviteCell.acceptBtn.setTitle("Declined", for: .normal)
            } else if strStatus == "3" {
                inviteCell.acceptBtn.setTitle("Checked In", for: .normal)
            } else {
                inviteCell.acceptBtn.setTitle("Opt Out", for: .normal)
            }
            
            
            return inviteCell
        }
        if indexPath.section == 3 {

            let requestCell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestCell
            requestCell.userImage.sd_setImage(with: URL(string: self.sentRequest[indexPath.row].flyerImagePath), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
            
            let strStatus =  self.sentRequest[indexPath.row].status
            requestCell.nameLabel.text = self.sentRequest[indexPath.row].eventName
            
            requestCell.acceptButton.tag = indexPath.row
            requestCell.declineButton.tag = indexPath.row
            requestCell.speculationBtn.tag = indexPath.row
            
            requestCell.acceptButton.isHidden = false
            requestCell.declineButton.isHidden = false
            requestCell.speculationBtn.isHidden = true
            
            
            requestCell.btnProfile.tag = (indexPath.section * 1000) + indexPath.row
            requestCell.btnProfile.addTarget(self, action: #selector(buttonProfileRequests(_:)), for: .touchUpInside)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
            let dateTime = self.sentRequest[indexPath.row].date
            let postdate =  dateFormatter.date(from: dateTime!)
            
            if postdate != nil {
                
                let elapsed = Date().timeIntervalSince(postdate!)
                let diff = self.stringFromTimeInterval(interval: elapsed)
                
                if diff.intValue > 0 {
                    requestCell.speculationBtn.setTitle("Attendance", for: .normal)
                } else {
                    requestCell.speculationBtn.setTitle("Guest List", for: .normal)
                }
            }
            
            requestCell.acceptButton.isEnabled = false
            requestCell.declineButton.isHidden = true
            
            requestCell.userImageView.sd_setImage(with: URL(string: self.sentRequest[indexPath.row].touserImagePath), placeholderImage: #imageLiteral(resourceName: "danceplaceholder"))
            let toUserName = self.sentRequest[indexPath.row].touserName
            requestCell.messageLabel.text = "You have requested \(toUserName ?? "") to attend!"
            
            if strStatus == "0" {
                requestCell.widthDeclineConstraint.constant = self.view.frame.size.width - 16
                
                requestCell.acceptButton.isHidden = false
                requestCell.declineButton.isHidden = true
                requestCell.acceptButton.isEnabled = false
                
                requestCell.acceptButton.setTitle("Pending...", for: .normal)
                requestCell.acceptButton.layer.borderColor = purp.cgColor
                requestCell.acceptButton.setTitleColor(purp, for: .normal)
                
                requestCell.speculationBtn.isHidden = true
                
            } else if strStatus == "1" {
                requestCell.messageLabel.text = "\(toUserName!) has accepted your request!!"
                requestCell.acceptButton.isHidden = false
                requestCell.declineButton.isHidden = false
                
                requestCell.acceptButton.isEnabled = true
                requestCell.declineButton.isEnabled = true
                requestCell.speculationBtn.isHidden = false
                
                if postdate != nil {
                    
                    let elapsed = Date().timeIntervalSince(postdate!)
                    let diff = self.stringFromTimeInterval(interval: elapsed)
                    
                    if diff.intValue > 0 {
                        requestCell.acceptButton.setTitle("Check In", for: .normal)
                        requestCell.acceptButton.isEnabled = true
                        requestCell.acceptButton.addTarget(self, action: #selector(actionAcceptCheckIn(_:)), for: .touchUpInside)
                    } else {
                        requestCell.acceptButton.setTitle("Accepted", for: .normal)
                        requestCell.acceptButton.isEnabled = false
                    }
                }
                
                requestCell.declineButton.setTitle("Opt Out", for: .normal)
                
                requestCell.declineButton.addTarget(self, action: #selector(actionDeclineOptOut(_:)), for: .touchUpInside)
                
            } else if strStatus == "2" {
                requestCell.widthDeclineConstraint.constant = self.view.frame.size.width - 16
                requestCell.messageLabel.text = "Sorry, \(toUserName!) declined your request."
                requestCell.acceptButton.isHidden = false
                requestCell.declineButton.isHidden = true
                requestCell.acceptButton.isEnabled = false
                
                requestCell.acceptButton.setTitle("Declined",  for: .normal)
                requestCell.acceptButton.layer.borderColor = purp.cgColor
                requestCell.acceptButton.setTitleColor(purp, for: .normal)
            } else if strStatus == "3" {
                
                requestCell.speculationBtn.isHidden = false
                
                requestCell.acceptButton.isHidden = false
                requestCell.declineButton.isHidden = false
                
                requestCell.acceptButton.isEnabled = true
                requestCell.declineButton.isEnabled = true
                
                requestCell.acceptButton.setTitle("Checked In", for: .normal)
                requestCell.declineButton.setTitle("Opt Out", for: .normal)
                
                requestCell.declineButton.addTarget(self, action: #selector(actionDeclineOptOut(_:)), for: .touchUpInside)
                
            } else {
                
                requestCell.widthDeclineConstraint.constant = self.view.frame.size.width - 16
                requestCell.messageLabel.text = "You're no longer attending."
                requestCell.acceptButton.isHidden = false
                requestCell.declineButton.isHidden = true
                requestCell.acceptButton.isEnabled = false
                requestCell.acceptButton.setTitle("Opted Out",  for: .normal)
                requestCell.acceptButton.setTitleColor(purp, for: .normal)
                requestCell.acceptButton.layer.borderColor = purp.cgColor
            }
            
            requestCell.speculationBtn.addTarget(self, action: #selector(actionAttendeesRequest(_:)), for: .touchUpInside)
            
            return requestCell
        }
        
        
        let requestCell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestCell
        return requestCell
    }
    
    
    //    MARK: - Attendees
    
    func actionAttendeesInvites(_ sender: UIButton) {
        
        let postid = self.invitationsArray[sender.tag].postID as String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AttendeesTable")
        
        let dateTime = self.invitationsArray[sender.tag].date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        
        let postdate =  dateFormatter.date(from: dateTime!)
        
        if postdate != nil {
            let elapsed = Date().timeIntervalSince(postdate!)
            let diff = self.stringFromTimeInterval(interval: elapsed)
            
            if diff.intValue >= 1 {
                controller.title = "Attendance"
            } else {
                controller.title = "Guest List"
            }
        }
        
        attendPostID = postid
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func actionAttendeesRequest(_ sender: UIButton) {
        
        let postid = self.sentRequest[sender.tag].postID as String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AttendeesTable")
        attendPostID = postid
        
        let dateTime = self.sentRequest[sender.tag].date
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy hh:mm a"
        
        let postdate =  dateFormatter.date(from: dateTime!)
        
        if postdate != nil {
            let elapsed = Date().timeIntervalSince(postdate!)
            let diff = self.stringFromTimeInterval(interval: elapsed)
            
            if diff.intValue >= 1 {
                controller.title = "Attendance"
            } else {
                controller.title = "Guest List"
            }
        }
        
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    
    //    MARK: - Request
    func actionAcceptRequest(_ sender: UIButton) {
        
       
        let ref = Database.database().reference()
        
        ref.child("Flyers").child(self.requestArray[sender.tag].postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let posts = snapshot.value as? [String : AnyObject]
            if posts != nil {
                
                var CapacityCount = posts?["CapacityCount"] as? Int!
                
                ref.child("Flyers").child(self.requestArray[sender.tag].postID).child("Requests").observeSingleEvent(of: .value, with: { (snapshot1) in
                    
                    let posts1 = snapshot1.value as? [String : AnyObject]
                    
                    if posts1 != nil {
                        for(key,values) in posts1! {
                            let sentby = values["from"] as! String
                            
                            if sentby == self.requestArray[sender.tag].from {
                                
                                
                                ref.child("Flyers").child(self.requestArray[sender.tag].postID).child("Requests").child(key).updateChildValues(["status" : "1"])
                                
                                ref.child("Users").child(sentby).child("Requests").observeSingleEvent(of: DataEventType.value, with: { (snapshot2) in
                                    
                                    let posts2 = snapshot2.value as? [String : AnyObject]
                                    
                                    if posts2 != nil {
                                        
                                        for(key,values) in posts2! {
                                            
                                            let sentby = values["from"] as! String
                                            
                                            if sentby == self.requestArray[sender.tag].from {
                                                ref.child("Users").child(sentby).child("Requests").child(key).updateChildValues(["status" : "1"])
                                                
                                                CapacityCount = CapacityCount!+1
                                                ref.child("Flyers").child(self.requestArray[sender.tag].postID).updateChildValues(["CapacityCount": CapacityCount!])
                                                
                                                 self.fetchProfile()
                                                break;
                                            }
                                            
                                        }
                                    }
                                })
                                
                                
                                
                                break;
                            }
                            
                            
                        }
                       
                    }
                })
            }
        })
        
        ref.removeAllObservers()
    }
    
    func actionDeclineRequest(_ sender: UIButton) {
        
        let ref = Database.database().reference()
        
        ref.child("Flyers").child(self.requestArray[sender.tag].postID).child("Requests").observeSingleEvent(of: DataEventType.value, with: { (snaphot) in
            
            let posts = snaphot.value as? [String : AnyObject]
            
            if posts != nil {
                for(key,values) in posts! {
                    let sentby = values["from"] as! String
                    if sentby == self.requestArray[sender.tag].from {
                        ref.child("Flyers").child(self.requestArray[sender.tag].postID).child("Requests").child(key).updateChildValues(["status" : "2"])
                        
                        ref.child("Users").child(sentby).child("Requests").observeSingleEvent(of: DataEventType.value, with: { (snapshot2) in
                            
                            let posts2 = snapshot2.value as? [String : AnyObject]
                            
                            if posts2 != nil {
                                
                                for(key,values) in posts2! {
                                    
                                    let sentby = values["from"] as! String
                                    
                                    if sentby == self.requestArray[sender.tag].from {
                                        ref.child("Users").child(sentby).child("Requests").child(key).updateChildValues(["status" : "2"])
                                        
                                    }
                                    
                                }
                            }
                        })
                        
                        break;
                    }
                }
                self.fetchProfile()
            }
        })
        
        ref.removeAllObservers()
    }
    
    func actionAcceptCheckIn(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let request = ref.child("Users").child(uid).child("Requests").child(self.keyArrayRequest[sender.tag])
        request.updateChildValues(["status":"3"] )
        
        ref.child("Flyers").child(self.requestArray[sender.tag].postID).child("Requests").observeSingleEvent(of: DataEventType.value, with: { (snaphot) in
            
            let posts = snaphot.value as? [String : AnyObject]
            
            if posts != nil {
                for(key,values) in posts! {
                    let sentby = values["from"] as! String
                    if sentby == self.requestArray[sender.tag].from {
                        ref.child("Flyers").child(self.requestArray[sender.tag].postID).child("Requests").child(key).updateChildValues(["status" : "3"])
                        break;
                    }
                }
            }
        })
        
        ref.removeAllObservers()
    }
    
    
    func actionDeclineOptOut(_ sender: UIButton) {
        
        let ref = Database.database().reference()
        let uid = Auth.auth().currentUser!.uid
        ref.child("Flyers").child(self.sentRequest[sender.tag].postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let posts = snapshot.value as? [String : AnyObject]
            if posts != nil {
                
                
                var CapacityCount = posts?["CapacityCount"] as? Int!
                
                
                let request = ref.child("Users").child(uid).child("Requests").child(self.sentKeyArrayRequest[sender.tag])
                request.updateChildValues(["status":"4"] )
                ref.child("Flyers").child(self.sentRequest[sender.tag].postID).child("Requests").observeSingleEvent(of: .value, with: { (snapshot1) in
                    
                    let posts1 = snapshot1.value as? [String : AnyObject]
                    
                    if posts1 != nil {
                        for(key,values) in posts1! {
                            let sentby = values["from"] as! String
                            
                            if sentby == self.sentRequest[sender.tag].from {
                                ref.child("Flyers").child(self.sentRequest[sender.tag].postID).child("Requests").child(key).updateChildValues(["status" : "4"])
                                
                                
                                
                                CapacityCount = CapacityCount!-1
                                ref.child("Flyers").child(self.sentRequest[sender.tag].postID).updateChildValues(["CapacityCount": CapacityCount!])
                                
                                break;
                            }
                            
                            
                        }
                    }
                })
            }
        })
        
        ref.removeAllObservers()
    }
    
    //   MARK: - Invitation
    
    func invitationAccepted(_ sender: UIButton) {
        
        let alertViewController = UIAlertController(title: "", message: "Are you sure?", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
            
            
            let uid = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            
            ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let posts = snapshot.value as? [String : AnyObject]
                if posts != nil {
                    
                    var CapacityCount = posts?["CapacityCount"] as? Int!
                    
                    
                    ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).child("Invites").observeSingleEvent(of: .value, with: { (snapshot1) in
                        let posts1 = snapshot1.value as? [String : AnyObject]
                        
                        if posts1 != nil {
                            for(key,values) in posts1! {
                                let sentTo = values["touserID"] as! String
                                
                                if sentTo == self.invitationsArray[sender.tag].touserID {
                                    ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).child("Invites").child(key).updateChildValues(["status" : "1"])
                                    
                                    let request = ref.child("Users").child(uid).child("Invites").child(self.keyArrayInvites[sender.tag])
                                    
                                    request.updateChildValues(["status":"1"] )
                                    CapacityCount = CapacityCount!+1
                                    
                                    ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).updateChildValues(["CapacityCount": CapacityCount ?? 0 ])
                                    break;
                                }
                                
                            }
                        }
                    })
                }
                
            })
            
            ref.removeAllObservers()
            
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .default) { (action) -> Void in
        }
        
        alertViewController.addAction(okAction)
        alertViewController.addAction(cancelAction)
        
        
        self.present(alertViewController, animated: true, completion: nil)
        
    }
    
    func invitationDeclined(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        let request = ref.child("Users").child(uid).child("Invites").child(self.keyArrayInvites[sender.tag])
        request.updateChildValues(["status":"2"] )
        ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).child("Invites").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let posts = snapshot.value as? [String : AnyObject]
            
            if posts != nil {
                for(key,values) in posts! {
                    let sentTo = values["touserID"] as! String
                    if sentTo == self.invitationsArray[sender.tag].touserID {
                        ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).child("Invites").child(key).updateChildValues(["status" : "2"])
                        break;
                    }
                }
            }
        })
        
        ref.removeAllObservers()
    }
    
    func invitationCheckIn(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        let request = ref.child("Users").child(uid).child("Invites").child(self.keyArrayInvites[sender.tag])
        request.updateChildValues(["status":"3"] )
        ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).child("Invites").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let posts = snapshot.value as? [String : AnyObject]
            
            if posts != nil {
                for(key,values) in posts! {
                    let sentTo = values["touserID"] as! String
                    if sentTo == self.invitationsArray[sender.tag].touserID {
                        ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).child("Invites").child(key).updateChildValues(["status" : "3"])
                        break;
                    }
                }
            }
        })
        
        ref.removeAllObservers()
    }
    
    func invitationOptOut(_ sender: UIButton) {
        
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let posts = snapshot.value as? [String : AnyObject]
            if posts != nil {
                
                var CapacityCount = posts?["CapacityCount"] as? Int!
                
                ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).child("Invites").observeSingleEvent(of: .value, with: { (snapshot1) in
                    let posts1 = snapshot1.value as? [String : AnyObject]
                    
                    if posts1 != nil {
                        for(key,values) in posts1! {
                            let sentTo = values["touserID"] as! String
                            
                            
                            if sentTo == self.invitationsArray[sender.tag].touserID {
                                ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).child("Invites").child(key).updateChildValues(["status" : "4"])
                                
                                let request = ref.child("Users").child(uid).child("Invites").child(self.keyArrayInvites[sender.tag])
                                
                                request.updateChildValues(["status":"4"] )
                                CapacityCount = CapacityCount!-1
                                
                                
                                ref.child("Flyers").child(self.invitationsArray[sender.tag].postID).updateChildValues(["CapacityCount": CapacityCount ?? 0 ])
                                break;
                            }
                            
                        }
                    }
                })
            }
            
        })
        
        ref.removeAllObservers()
    }
    
    //   MARK: - Time Differences
    func stringFromTimeInterval(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        return NSString(format: "%0.2d",ti)
    }
    
    func stringFromTimeIntervalinHours(interval: TimeInterval) -> NSString {
        let ti = NSInteger(interval)
        let hours = (ti / 3600)
        return NSString(format: "%0.2d",hours)
        
        
    }
    
    // MARK: - Navigation
    func buttonProfileInvites(_ sender: UIButton) {
        
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        
        if section == 0 {
            let postItem = self.invitationsArray[row]
            var userNav = String()
            UserID = postItem.from
            let uID : String = (Auth.auth().currentUser?.uid)!
            
            if UserID == uID {
                userNav = postItem.touserID
            } else {
                userNav = UserID
            }
            
            let ref = Database.database().reference()
            
            ref.child("Users").child(userNav).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                let users = snapshot.value as! [String : AnyObject]
                
                let  firstName = users["FirstName"] as? String
                let lastName = users["LastName"] as? String
                let age = users["Age"] as? String
                let city = users["City"] as? String
                let gender = users["Gender"] as? String
                let state = users["State"] as? String
                let bio = users["Bio"] as? String
                // let followers = users["Followers"] as? [String: AnyObject]
                // let following = users["Following"] as? [String: AnyObject]
                let imagePath = users["urlToImage"] as? String
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
                
                let navController = UINavigationController(rootViewController: vc)
                
                vc.firstName = firstName!
                vc.lastName = lastName!
                vc.age = age!
                vc.city = city!
                vc.state = state!
                vc.gender = gender!
                vc.pathToImage = imagePath!
                vc.bioTextForOtherUser = bio!
                
                vc.urlTextForOtherUser = "No URL Available."
                vc.discoverSwipe.isEnabled = true
                vc.followersSwipe.isEnabled = false
                vc.followingSwipe.isEnabled = false
                
                
                self.present(navController, animated: true, completion: nil)
            })

        }
        
        if section == 2 {
            let postItem = self.sentInvitations[row]
            var userNav = String()
            UserID = postItem.from
            let uID : String = (Auth.auth().currentUser?.uid)!
            
            if UserID == uID {
                userNav = postItem.touserID
            } else {
                userNav = UserID
            }
            
            let ref = Database.database().reference()
            
            ref.child("Users").child(userNav).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                let users = snapshot.value as! [String : AnyObject]
                
                let  firstName = users["FirstName"] as? String
                let lastName = users["LastName"] as? String
                let age = users["Age"] as? String
                let city = users["City"] as? String
                let gender = users["Gender"] as? String
                let state = users["State"] as? String
                let bio = users["Bio"] as? String
                // let followers = users["Followers"] as? [String: AnyObject]
                // let following = users["Following"] as? [String: AnyObject]
                let imagePath = users["urlToImage"] as? String
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
                
                let navController = UINavigationController(rootViewController: vc)
                
                vc.firstName = firstName!
                vc.lastName = lastName!
                vc.age = age!
                vc.city = city!
                vc.state = state!
                vc.gender = gender!
                vc.pathToImage = imagePath!
                vc.bioTextForOtherUser = bio!
                
                vc.urlTextForOtherUser = "No URL Available."
                vc.discoverSwipe.isEnabled = true
                vc.followersSwipe.isEnabled = false
                vc.followingSwipe.isEnabled = false
                
                
                self.present(navController, animated: true, completion: nil)
            })
        }
        
        
        
        
    }
    
    func buttonProfileRequests(_ sender: UIButton) {
        
        let row = sender.tag % 1000
        let section = sender.tag / 1000
        
        if section == 1 {
            let postItem = self.requestArray[row]
            var userNav = String()
            UserID = postItem.from
            let uID : String = (Auth.auth().currentUser?.uid)!
            
            if UserID == uID {
                userNav = postItem.touserID
            } else {
                userNav = UserID
            }
            
            let ref = Database.database().reference()
            
            ref.child("Users").child(userNav).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                let users = snapshot.value as! [String : AnyObject]
                
                let  firstName = users["FirstName"] as? String
                let lastName = users["LastName"] as? String
                let age = users["Age"] as? String
                let city = users["City"] as? String
                let gender = users["Gender"] as? String
                let state = users["State"] as? String
                let bio = users["Bio"] as? String
                // let followers = users["Followers"] as? [String: AnyObject]
                // let following = users["Following"] as? [String: AnyObject]
                let imagePath = users["urlToImage"] as? String
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
                
                let navController = UINavigationController(rootViewController: vc)
                
                vc.firstName = firstName!
                vc.lastName = lastName!
                vc.age = age!
                vc.city = city!
                vc.state = state!
                vc.gender = gender!
                vc.pathToImage = imagePath!
                vc.bioTextForOtherUser = bio!
                
                vc.urlTextForOtherUser = "No URL Available."
                vc.discoverSwipe.isEnabled = true
                vc.followersSwipe.isEnabled = false
                vc.followingSwipe.isEnabled = false
                
                
                self.present(navController, animated: true, completion: nil)
            })

        }
        
        
        if section == 3 {
            let postItem = self.sentRequest[row]
            
            var userNav = String()
            UserID = postItem.from
            let uID : String = (Auth.auth().currentUser?.uid)!
            
            if UserID == uID {
                userNav = postItem.touserID
            } else {
                userNav = UserID
            }
            
            let ref = Database.database().reference()
            
            ref.child("Users").child(userNav).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                
                let users = snapshot.value as! [String : AnyObject]
                
                let  firstName = users["FirstName"] as? String
                let lastName = users["LastName"] as? String
                let age = users["Age"] as? String
                let city = users["City"] as? String
                let gender = users["Gender"] as? String
                let state = users["State"] as? String
                let bio = users["Bio"] as? String
                // let followers = users["Followers"] as? [String: AnyObject]
                // let following = users["Following"] as? [String: AnyObject]
                let imagePath = users["urlToImage"] as? String
                
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
                
                let navController = UINavigationController(rootViewController: vc)
                
                vc.firstName = firstName!
                vc.lastName = lastName!
                vc.age = age!
                vc.city = city!
                vc.state = state!
                vc.gender = gender!
                vc.pathToImage = imagePath!
                vc.bioTextForOtherUser = bio!
                
                vc.urlTextForOtherUser = "No URL Available."
                vc.discoverSwipe.isEnabled = true
                vc.followersSwipe.isEnabled = false
                vc.followingSwipe.isEnabled = false
                
                
                self.present(navController, animated: true, completion: nil)
            })
        }
        
        
    }
    
    
//    func buttonProfileRequestsSent(_ sender: UIButton) {
//        
//        
//        
//    }
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

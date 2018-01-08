//
//  ChatLogController.swift
//  gameofchats
//
//  Created by Brian Voong on 7/7/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.firstName
            
            let button =  UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
            button.setTitle(user?.firstName, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(self.clickOnButton), for: .touchUpInside)
            self.navigationItem.titleView = button
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    var keys = [String]()
    var titleLbl = ""
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.userID else {
            return
        }
        
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                self.keys.append(snapshot.key)
                
                let message = Message()
                message.setValuesForKeys(dictionary)
                //do we need to attempt filtering anymore?
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                })
                
                }, withCancel: nil)
            
            }, withCancel: nil)
        
        
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor.white
        textField.placeholder = "Enter message..."
        textField.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.keyboardDismissMode = .interactive
        let backgroundImage = #imageLiteral(resourceName: "Backgroundloginsignup")
        let imageView = UIImageView(image: backgroundImage)
        collectionView?.backgroundView = imageView
        
        let lpgr = UILongPressGestureRecognizer(target:self, action: #selector(self.handleLongPress))
        collectionView?.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        let p = gesture.location(in: self.collectionView)
        
        if let indexPath = self.collectionView?.indexPathForItem(at: p) {
            
            var alert = UIAlertController(title: "Do you want to delete this message?", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                alert = UIAlertController(title: "Do you want to delete this message?", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            }
            
            let delete = UIAlertAction(title: "Delete", style: .default, handler: { (ACTION) in
                print(self.messages[indexPath.row])
                
                let messageId = self.keys[indexPath.row]
                let messagesRef = Database.database().reference().child("messages").child(messageId)
                
                messagesRef.removeValue(completionBlock: { (error , reference) in
                    
                    let uid = Auth.auth().currentUser?.uid
                    let ref = Database.database().reference()
                    
                    ref.child("user-messages").child(uid!).child((self.user?.userID)!).child(messageId).removeValue()
                    ref.child("user-messages").child((self.user?.userID)!).child(uid!).child(messageId).removeValue()
                    
                    self.messages.remove(at: indexPath.row)
                    self.collectionView?.reloadData()
                })
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (ACTION) in
               
            })
            
            alert.addAction(delete)
            alert.addAction(cancel)
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            alert.view.tintColor = purp
            self.present(alert, animated: true, completion:nil)
           
        } else {
            print("couldn't find index path")
        }
    }
    
    func clickOnButton() {

        UserID = (user?.userID)!
        let ref = Database.database().reference()
        
        ref.child("Users").child(UserID).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            let users = snapshot.value as! [String : AnyObject]
            
            let firstName = users["FirstName"] as? String
            let lastName = users["LastName"] as? String
            let age = users["Age"] as? String
            let city = users["City"] as? String
            let gender = users["Gender"] as? String
            let state = users["State"] as? String
            let bio = users["Bio"] as? String
            // let followers = users["Followers"] as? [String: AnyObject]
            // let following = users["Following"] as? [String: AnyObject]
            let imagePath = users["urlToImage"] as? String
            
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "otherVC") as! OtherUser
            
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
    
    lazy var inputContainerView: UIView = {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = UIColor.black
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
       
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        sendButton.setTitleColor(purp, for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let cameraButton = UIButton(type: .system)
        cameraButton.setImage(UIImage(named: "camareEvent"), for: .normal)
        cameraButton.tintColor = purp
//        cameraButton.backgroundColor = UIColor.clear
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        cameraButton.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        containerView.addSubview(cameraButton)
        //x,y,w,h
        cameraButton.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        cameraButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        containerView.addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: cameraButton.leftAnchor, constant: 55).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: { 
            self.view.layoutIfNeeded()
        }) 
    }
    
    func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        }) 
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell, message: message)
        
        
        if message.text == nil {
            cell.textView.isHidden = true
            cell.bubbleWidthAnchor?.constant = 200
            cell.chatImageView.sd_setImage(with: URL.init(string: message.imageUrl))
        } else {
            cell.textView.isHidden = false
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(message.text!).width + 32
        }
        
        
        return cell
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let message = messages[indexPath.item]
        if message.text == nil {
            let cell = collectionView.cellForItem(at: indexPath) as! ChatMessageCell
            inputContainerView.isHidden = true
            let newImageView = UIImageView(image: cell.chatImageView.image)
            newImageView.frame = UIScreen.main.bounds
            newImageView.backgroundColor = .black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
            newImageView.addGestureRecognizer(tap)
            newImageView.isUserInteractionEnabled = true
            
            self.view.addSubview(newImageView)
            self.navigationController?.isNavigationBarHidden = true
            self.tabBarController?.tabBar.isHidden = true
        
        }

    }
    
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        inputContainerView.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.imagePath {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
            if message.text == nil {
                cell.chatImageView.isHidden = false
                cell.profileImageView.isHidden = true
                cell.textView.isHidden = true
                cell.bubbleViewRightAnchor?.isActive = false
                cell.bubbleViewLeftAnchor?.isActive = false
                cell.chatWidthAnchor?.isActive = true
                cell.chatViewRightAnchor?.isActive = true
                cell.chatViewLeftAnchor?.isActive = false
                cell.bubbleView.isHidden = true
            } else {
                cell.bubbleView.backgroundColor = purp
                cell.textView.textColor = UIColor.white
                cell.profileImageView.isHidden = true
                cell.chatImageView.isHidden = true
                cell.bubbleViewRightAnchor?.isActive = true
                cell.bubbleViewLeftAnchor?.isActive = false
                
                cell.chatWidthAnchor?.isActive = false
                cell.chatViewRightAnchor?.isActive = false
                cell.chatWidthAnchor?.isActive = false
                cell.bubbleView.isHidden = false
            }
            
            
        } else {
            //incoming gray
            let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 0.5)
            if message.text == nil {
                cell.profileImageView.isHidden = false
                cell.chatImageView.isHidden = false
                cell.textView.isHidden = true
                cell.bubbleView.isHidden = true
                cell.bubbleViewRightAnchor?.isActive = false
                cell.bubbleViewLeftAnchor?.isActive = false
                cell.chatWidthAnchor?.isActive = true
                cell.chatViewRightAnchor?.isActive = false
                cell.chatViewLeftAnchor?.isActive = true
            } else {
                cell.bubbleView.backgroundColor = purp
                cell.textView.textColor = UIColor.white
                cell.profileImageView.isHidden = false
                cell.chatImageView.isHidden = true
                cell.bubbleViewRightAnchor?.isActive = false
                cell.bubbleViewLeftAnchor?.isActive = true
                
                cell.chatWidthAnchor?.isActive = false
                cell.chatViewRightAnchor?.isActive = false
                cell.chatWidthAnchor?.isActive = false
                cell.bubbleView.isHidden = false
            }
            
          
            
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        //get estimated height somehow????
        if let text = messages[indexPath.item].text {
            height = estimateFrameForText(text).height + 20
        } else {
            height = 200
        }
        
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    func setupInputComponents() {
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)

        let containerView = UIView()
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        //ios9 constraint anchors
        //x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.tintColor = purp //Not working
        sendButton.setTitle("Send", for: UIControlState())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        //x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func pickImage () {
        inputContainerView.isHidden = true

        
        var alert = UIAlertController(title: "Select image to send", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert = UIAlertController(title: "Select image to send", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        }
        
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (ACTION) in
            self.inputContainerView.isHidden = false
            let image = UIImagePickerController()
            image.sourceType = .camera
            image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            image.allowsEditing = true
            self.present(image, animated: true, completion: nil)
            print("Camera Pressed")
        })
        
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default, handler: { (ACTION) in
            self.inputContainerView.isHidden = false

            let image = UIImagePickerController()
            image.sourceType = .photoLibrary
            image.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            image.allowsEditing = true
            self.present(image, animated: true, completion: nil)
            print("Photo Library Pressed")
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (ACTION) in
            print("Canecel Pressed")
            self.inputContainerView.isHidden = false

        })
        
        alert.addAction(camera)
        alert.addAction(photoLibrary)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion:nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        // Dismiss the picker if the user canceled.
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary contains multiple representations of the image, and this uses the original.
        
        let selectedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        
        // Set photoImageView to display the selected image.
        // Dismiss the picker.
        
        dismiss(animated: true) { 
            let uid = Auth.auth().currentUser?.uid
            let ref = Database.database().reference()
            let storage = Storage.storage().reference(forURL: "gs://jugg-88ab9.appspot.com")
            
            let key = ref.child("messages").childByAutoId().key
            
            let flyerRef = storage.child("messages").child(uid!).child("\(key).jpg")
            
            let data = UIImageJPEGRepresentation(selectedImage, 0.6)
            
            let uploadTask = flyerRef.putData(data!, metadata: nil) { (metadata, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                } else {
                    flyerRef.downloadURL(completion: { (urlImage, error) in
                        
                        let ref = Database.database().reference().child("messages")
                        let childRef = ref.childByAutoId()
                        
                        let toId = self.user!.userID!
                        let fromId = Auth.auth().currentUser!.uid
                        let timestamp = Int(Date().timeIntervalSince1970)
                        let values = ["toId": toId, "fromId": fromId, "timestamp": timestamp,"imageUrl": urlImage!.absoluteString] as [String : Any]
                        
                        childRef.updateChildValues(values) { (error, ref) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            
                            //                    self.inputTextField.text = nil
                            
                            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
                            
                            let messageId = childRef.key
                            userMessagesRef.updateChildValues([messageId: 1])
                            
                            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
                            recipientUserMessagesRef.updateChildValues([messageId: 1])
                        }
                        
                    })
                    
                }
            }
            
            uploadTask.resume()
            
            
            
        }
    
    }
    
    
    func handleSend() {
        
        if  inputTextField.text?.characters.count == 0 {
            return
        }
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        
        let toId = user!.userID!
        let fromId = Auth.auth().currentUser!.uid
        let timestamp = Int(Date().timeIntervalSince1970)
        let values = ["text": inputTextField.text!, "toId": toId, "fromId": fromId, "timestamp": timestamp] as [String : Any]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}














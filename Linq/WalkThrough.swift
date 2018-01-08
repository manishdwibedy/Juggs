//
//  WalkThrough.swift
//  Linq
//
//  Created by Quinton Askew on 9/13/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class WalkThrough: UIViewController {

 
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var skipButton: UIButton!
    
    var index = 0
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = UIImage(named: imageName)

        backgroundImageView.setNeedsDisplay()
        backgroundImageView.reloadInputViews()
    }

    override func viewWillAppear(_ animated: Bool) {
    
        if index == 5 {
            startButton.isHidden = false
            skipButton.isHidden = true
        } else {
            
            if index == 0 {
              skipButton.isHidden = true
            } else {
                skipButton.isHidden = false
            }
            startButton.isHidden = true
            
        }
    }
    
    @IBAction func skipTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "PageViewController")as! PageViewController
        initialViewController.nextPageWithIndex()
    }
    
    @IBAction func startTapped(_ sender: Any)
    {
    
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: "DisplayedWalkThrough")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "login")
        
        UIApplication.shared.keyWindow?.rootViewController = initialViewController
        
        self.dismiss(animated: true, completion: nil)
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

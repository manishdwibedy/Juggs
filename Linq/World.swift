//
//  World.swift
//  Linq
//
//  Created by Quinton Askew on 5/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit
import MapKit
class World: UIViewController {

    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var discoverView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBAction func segmentChanged(_ sender: Any) {
    
        if (segmentedControl.selectedSegmentIndex == 0) {
            
            mapView.isHidden = false
            discoverView.isHidden = true
        }else{
            
            discoverView.isHidden = false
            mapView.isHidden = true
            
        }
    
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSegmentedControl()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setupSegmentedControl() {
        
        let purp = UIColor(red: 142/255, green: 68/255, blue: 173/255, alpha: 1.0)
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        segmentedControl.selectedSegmentIndex = 1
        self.tabBarController?.tabBar.tintColor = purp
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        segmentedControl.layer.cornerRadius = 15
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.borderWidth = 2
        segmentedControl.layer.borderColor = purp.cgColor
        segmentedControl.setWidth(190, forSegmentAt: 0)
        segmentedControl.setWidth(190, forSegmentAt: 1)
        
        
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

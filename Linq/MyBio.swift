//
//  MyBio.swift
//  Linq
//
//  Created by Quinton Askew on 7/2/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

class MyBio: UIViewController {

    @IBOutlet weak var websiteTextView: UITextView!
    @IBOutlet weak var biographyTextView: UITextView!
    
    var biographyText = ""
    var websiteText = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
   
    }

    func setup() {
        biographyTextView.text = biographyText
        websiteTextView.text = websiteText
        
        
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

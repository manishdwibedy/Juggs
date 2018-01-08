//
//  DesignableSlider.swift
//  Linq
//
//  Created by Quinton Askew on 7/24/17.
//  Copyright © 2017 QuintonAskew. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableSlider: UISlider {

    @IBInspectable var thumbImage: UIImage? {
        didSet{
            setThumbImage(thumbImage, for: .normal)
            setThumbImage(thumbImage, for: .highlighted)
        }
    }
    

}

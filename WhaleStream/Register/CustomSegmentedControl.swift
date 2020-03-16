//
//  CustomSegmentedControl.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/27/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//
import  UIKit

open class CustomSegmentedControl: UISegmentedControl {

    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 9
        layer.masksToBounds = true
        clipsToBounds = true
//        layer.borderWidth = 1.0
//        layer.borderColor = UIColor.purplePink.cgColor
    }
    
}


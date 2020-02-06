//
//  CustomAddClassLabel.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/5/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit

class CustomAddClassLabel: UILabel {
    
    let padding: UIEdgeInsets
//    let height: CGFloat
    init(padding: UIEdgeInsets, height: CGFloat) {
        self.padding = padding //A Swift class must initialize its own (non-inherited) properties before it calls its superclass’s designated initializer.  You can then set inherited properties after calling the superclass’s designated initializer, if you wish.
//        self.height = height
        super.init(frame: .zero) //A designated initializer must call a designated initializer from its immediate superclass.
        
//        layer.cornerRadius = height / 2
//        layer.opacity = 1
        backgroundColor = UIColor.white
    }
    
//    override var intrinsicContentSize: CGSize {
//        return .init(width: 0, height: height) //default first size
//    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

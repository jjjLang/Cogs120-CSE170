//
//  CustomTextField.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/5/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit

class CustomTextField : UITextField {
    
    let padding: CGFloat
    let height: CGFloat
    init(padding: CGFloat, height: CGFloat) {
        self.padding = padding //A Swift class must initialize its own (non-inherited) properties before it calls its superclass’s designated initializer.  You can then set inherited properties after calling the superclass’s designated initializer, if you wish.
        self.height = height
        super.init(frame: .zero) //A designated initializer must call a designated initializer from its immediate superclass.
        
        layer.cornerRadius = height / 2
        layer.opacity = 1
        backgroundColor = UIColor.white
    }
    
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: height) //default first size
    }
    //right text padding wehn enter text
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    //left text padding when enter text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: padding, dy: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

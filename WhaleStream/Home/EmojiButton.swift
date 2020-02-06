//
//  EmojiButton.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/5/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit

class EmojiButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
//        isUserInteractionEnabled = true
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        
    }
    

}


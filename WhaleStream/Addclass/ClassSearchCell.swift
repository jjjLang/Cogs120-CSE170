//
//  ClassSearchCell.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/4/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit


class ClassSearchCell: UICollectionViewCell {
    
    var course: Course? {
        didSet {
            courseNameLabel.text = course?.name
        }
    }
    
    let courseNameLabel: UILabel = {
        let label = UILabel()
        label.text = "class"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(courseNameLabel)
        courseNameLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        courseNameLabel.centerYToSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

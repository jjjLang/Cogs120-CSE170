//
//  AddClassTableViewCell.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/4/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit

protocol AddClassCellDelegate {
    func tapClass(for cell: AddClassCell)
    func deleteClass(for cell: AddClassCell)
}

class AddClassCell: UICollectionViewCell {
    
    let ranColor = UIColor.random
    
    var course: Course? {
        didSet {
//            selectClassButton.setTitle(course?.name, for: .normal)
            let attributedText = NSMutableAttributedString(string: course?.className ?? "Class name", attributes: [.font: UIFont.boldSystemFont(ofSize: 24), .foregroundColor : UIColor.black])
            attributedText.append(NSMutableAttributedString(string: "\n\n\(course?.prof ?? "\nInstructor name")", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor : ranColor]))
            selectClassLabel.attributedText = attributedText

        }
    }
    
    var delegate: AddClassCellDelegate?
    
    lazy var selectClassLabel: CustomAddClassLabel = {
        let b = CustomAddClassLabel(padding: UIEdgeInsets(top: -10, left: 16, bottom: 0, right: 0), height: 0)
//        b.setTitle("Add Class", for: .normal)
        b.text = "Add Class"
        b.font = UIFont.boldSystemFont(ofSize: 36)
        b.textColor = UIColor.black
//        b.setTitleColor(.black, for: .normal)
        b.layer.opacity = 1
        b.backgroundColor = .white
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        b.textAlignment = .left
        b.numberOfLines = 0
//        b.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        return b
    }()
    
    
        lazy var selectClassProf: UILabel = {
           let b = UILabel()
    //        b.setTitle("Add Class", for: .normal)
            b.text = "Instructor name"
            b.textColor = UIColor.black
    //        b.setTitleColor(.black, for: .normal)
            b.layer.opacity = 1
            b.backgroundColor = .white
            b.layer.cornerRadius = 16
            b.clipsToBounds = true
            b.textAlignment = .center
    //        b.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
            return b
        }()
    
    @objc fileprivate func handleAdd() {
        
    }
    
//    lazy var vertiStackView: UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [selectClassLabel, selectClassProf ])
//        sv.axis = .vertical
//        sv.distribution = .fill
//        sv.spacing = 8
//        sv.alignment = .leading
//        return sv
//    }()
    
    lazy var moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "more").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        return button
    }()
    
    @objc func handleMore() {
        print("delete class")
        delegate?.deleteClass(for: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let view = UIView()
        addSubview(view)
        view.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 16, left: 37, bottom: 16, right: 37))

        view.addSubview(selectClassLabel)

//        addSubview(vertiStackView)
//        vertiStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
//        vertiStackView.setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: 8), color: .lightGray)

        selectClassLabel.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        view.setupShadow(opacity: 0.4 , radius: 1.3, offset: .init(width: 0, height: 3), color: .lightGray)
//        view.setupShadow(opacity: 0.4 , radius: 1.3, offset: .init(width: -1, height: 3), color: .lightGray)

        let colorView = UIView()
        colorView.backgroundColor = ranColor
        colorView.clipsToBounds = true
        selectClassLabel.addSubview(colorView)
        colorView.anchor(top: selectClassLabel.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 7))

        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapClass)))


        addSubview(moreButton)
        moreButton.anchor(top: nil, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 14, right: 10), size: .init(width: 15, height: 15))
        
//        addSubview(selectClassProf)
//        selectClassProf.anchor(top: selectClassLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
    }
    
    

    
    @objc func handleTapClass() {
        delegate?.tapClass(for: self)
    }
    
    

    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  HomeAltNavBar.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/27/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit


protocol HomeAltNavBarDelegate: UIViewController {
    func didTapProfileImage()
}

class HomeAltNavBar: UIView {
    
    let userProfileImageView = CircularImageView(width: 44)
    let classLabel = UILabel(text: "", font: .boldSystemFont(ofSize: 26))
    let backButton = UIButton(image: #imageLiteral(resourceName: "back") , tintColor: UIColor.purpleBlue)// command shift l to search media
//    let flagButton = UIButton(image: #imageLiteral(resourceName: "more(1)"), tintColor: UIColor.purpleBlue)
//    let flagButton : UIButton = {
//        let b = UIButton()
//        b.titleLabel?.numberOfLines = 0
//        let attributedString = NSMutableAttributedString(string: "•••")
////        let paragraphStyle = NSMutableParagraphStyle()
//////        paragraphStyle.lineSpacing = -1 // Whatever line spacing you want in points
////        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
//        b.setAttributedTitle(attributedString, for: .normal)
//        b.titleLabel?.textColor = UIColor.purpleBlue
//        return b
//    }()
    
    
    weak var delegate: HomeAltNavBarDelegate?


    fileprivate let className: String
    fileprivate let profileUrl: String
    
    init(className: String, profileUrl: String) {
        self.className = className
        self.profileUrl = profileUrl
        classLabel.text = className
        classLabel.textColor = UIColor.purpleBlue
//        userProfileImageView.sd_setImage(with: URL(string: profileUrl), completed: nil)
        super.init(frame: .zero) //since anchor in higher hierarchy class will reset frame.
        backgroundColor = .white
        layer.opacity = 1
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        //use CircularImageView instead of these lines
        
//        userProfileImageView.constrainWidth(44)
//        userProfileImageView.constrainHeight(44)
//        userProfileImageView.clipsToBounds = true
//        userProfileImageView.layer.cornerRadius = 44/2
        let middleStack = hstack(
            stack(classLabel,
                  spacing: 8,
                  alignment: .center),
            alignment: .center
        )
        
        
        let endStack = hstack(
            stack(userProfileImageView,
                  spacing: 8,
                  alignment: .center),
            alignment: .center
        )
       
        hstack(backButton.withWidth(50), middleStack, endStack).withMargins(.init(top: 0, left: 4, bottom: 0, right: 16))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userProfileImageView.isUserInteractionEnabled = true
        userProfileImageView.addGestureRecognizer(tapGestureRecognizer)


    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        // And some actions
        delegate?.didTapProfileImage()
        
    }
    
//    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
//        // And some actions
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("homenavbar deinit")
    }
}


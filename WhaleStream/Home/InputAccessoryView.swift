//
//  InputAccessoryView.swift
//  WhaleStream
//
//  Created by wenlong qiu on 3/5/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

//
//  ChatInputAccessoryView.swift
//  Big-n-Little
//
//  Created by wenlong qiu on 12/30/19.
//  Copyright © 2019 wenlong qiu. All rights reserved.
//

import UIKit



class InputAccessoryView: UIView, UITextViewDelegate {
    
    let textView = UITextView()
    let sendButton = UIButton(title: "Send", titleColor: .black, font: .boldSystemFont(ofSize: 14), backgroundColor: .white, target: nil, action: nil)
    
    var placeHolderLabel = UILabel(text: "Enter message", font: .systemFont(ofSize: 16), textColor: .lightGray)

    
    //make scalable views depends on their content, in this case text views?
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        alpha = 1
        //height -8 to make shadow go upward, radius is corner radius?
//        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)

        //resize by expanding height
        autoresizingMask = .flexibleHeight
        textView.isScrollEnabled = false
        textView.font = .systemFont(ofSize: 16)
        
        //self observe textdidchangenotificaiton
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: UITextView.textDidChangeNotification, object: nil)
        
        let stackview = UIStackView(arrangedSubviews: [textView, sendButton])
        stackview.alignment = .center
        sendButton.constrainHeight(0)
        sendButton.constrainWidth(60)
        sendButton.isHidden = true

        addSubview(stackview)
stackview.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))

        stackview.isLayoutMarginsRelativeArrangement = true


//        hstack(textView, sendButton.withSize(.init(width: 0, height: 60)), alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
        
//        addSubview(textView)
//        textView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 32, bottom: 0, right: 32))
        textView.layer.cornerRadius = 20
        textView.clipsToBounds = true
        textView.layer.borderWidth = 0.6
        textView.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        textView.returnKeyType = .send
        

        
        addSubview(placeHolderLabel)
        
        placeHolderLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: textView.trailingAnchor, padding: .init(top: 0, left: 35, bottom: 0, right: 0))
//        placeHolderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        placeHolderLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor).isActive = true

        
//        let stackview = UIStackView(arrangedSubviews: [textView, sendButton])
//        stackview.alignment = .center
//        sendButton.constrainHeight(60)
//        sendButton.constrainWidth(60)
//
//        redView.addSubview(stackview)
//        stackview.fillSuperview()
//
//        //so stackview content stays inside stackview's layout margin?
//        stackview.isLayoutMarginsRelativeArrangement = true
    }
    
    @objc fileprivate func handleTextChange() {
        placeHolderLabel.isHidden = textView.text.count != 0
    }
    
    

    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self) //remove observer to prevent retain cycle
//        print("chatinputaccesoryview self destruct, no retain cycle")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

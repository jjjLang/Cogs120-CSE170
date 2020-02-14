//
//  CommentController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/13/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit

protocol CommentControllerDelegate {
    func didSendComment(comment: String)
}

class CommentController: UIViewController {
    
    var delegate : CommentControllerDelegate?
    
    let commentInstruction = UILabel(text: "Comments on the materials:", font: .systemFont(ofSize: 20), numberOfLines: 0)

//    lazy var commentTextField : UITextField = {
//        let tf = CustomTextField(padding: 16, height: view.frame.height / 2 - 100)
//           tf.placeholder = ""
//           tf.backgroundColor = .white
//           tf.borderStyle = .roundedRect
//           return tf
//    }()
    
        let commentTextField: UITextView = {
            let tf = UITextView()
            tf.font = UIFont.systemFont(ofSize: 15)
            tf.textContainerInset = UIEdgeInsets(top: 8, left: 13, bottom: 0, right: 13)
            tf.backgroundColor = .white
            tf.withBorder(width: 2, color: .gray)
            return tf
        }()
    
    let cancelButton : UIButton = {
          let b = UIButton(title: "Cancel", titleColor: .blue)
           b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
           b.backgroundColor = .white
           b.layer.cornerRadius = 8
           b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
           return b
    }()
    
    @objc func handleCancel() {
        navigationController?.popViewController(animated: true)
    }
    
    let sendButton : UIButton = {
          let b = UIButton(title: "Send", titleColor: .white)
           b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
           b.backgroundColor = .blue
           b.layer.cornerRadius = 8
           b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
           return b
    }()
    
    @objc fileprivate func handleSend() {
        delegate?.didSendComment(comment: commentTextField.text ?? "")
        navigationController?.popViewController(animated: true)
    }
    
    lazy var buttonStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            cancelButton.withHeight(50).withWidth(120),
            sendButton.withHeight(50).withWidth(120)
            ])
        sv.distribution = .equalCentering
        sv.axis = .horizontal
        return sv
        
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        commentTextField.withBorder(width: 2, color: .lightGray)
//        commentTextField.layer.cornerRadius = 10
        view.backgroundColor = .white
        
        view.addSubview(commentInstruction)
        commentInstruction.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        view.addSubview(commentTextField)
        commentTextField.anchor(top: commentInstruction.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 10, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: view.frame.height / 2 - 100))
        view.addSubview(buttonStackView)
        buttonStackView.anchor(top: commentTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
    }
}

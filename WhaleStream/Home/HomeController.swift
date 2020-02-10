//
//  HomeController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/5/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellID = "cellId"
    let tableView = UITableView()
    
    let lightYellow = UIColor.rgb(red: 255, green: 255, blue: 237)
    
    fileprivate lazy var laughButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = lightYellow
        button.setTitle("😄", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        button.addTarget(self, action: #selector(handleTapEmoji), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var smileButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = lightYellow
        button.setTitle("😊", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)

        button.addTarget(self, action: #selector(handleTapEmoji), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var sadButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = lightYellow
        button.setTitle("☹️", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)

        button.addTarget(self, action: #selector(handleTapEmoji), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleTapEmoji(button: UIButton) {
        switch button {
        case laughButton:
            if laughButton.backgroundColor == lightYellow {
                laughButton.backgroundColor = UIColor.yellow
                smileButton.backgroundColor = lightYellow
                sadButton.backgroundColor = lightYellow
            } else {
                laughButton.backgroundColor = lightYellow
            }
            
        case smileButton:
            if smileButton.backgroundColor == lightYellow {
                smileButton.backgroundColor = UIColor.yellow
                laughButton.backgroundColor = lightYellow
                sadButton.backgroundColor = lightYellow

            } else {
                smileButton.backgroundColor = lightYellow
            }
        default:
            if sadButton.backgroundColor == lightYellow {
                sadButton.backgroundColor = UIColor.yellow
                laughButton.backgroundColor = lightYellow
                smileButton.backgroundColor = lightYellow

            } else {
                sadButton.backgroundColor = lightYellow
            }
        }
    }
    
    lazy var emojiStackView : UIStackView  = {
       let sv = UIStackView(arrangedSubviews: [
        laughButton.withWidth(100).withHeight(100),
        smileButton.withSize(CGSize(width: 100, height: 100)),
        sadButton.withSize(CGSize(width: 100, height: 100))
       ])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 16
        return sv
    }()
    
    
    let emojiIntructionLabel: UILabel = {
        let l = UILabel(text: "You could change your emoji anytime during the class!", font: UIFont.systemFont(ofSize: 26), textAlignment: .left, numberOfLines: 0)
        return l
    }()
    
    let helpLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = .left
        l.font = .systemFont(ofSize: 26)
        l.attributedText = NSAttributedString(string: "Help?", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        return l
    }()
    
    let commentInstruction = UILabel(text: "Comments on the materials", font: .systemFont(ofSize: 26), numberOfLines: 0)
    
    let commentTextField : UITextField = {
       let tf = CustomTextField(padding: 16, height: 60)
        tf.placeholder = "Type your comment"
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    
    let historyCommentInstruction = UILabel(text: "View you own history of comments", font: .systemFont(ofSize: 20), numberOfLines: 0)

    
    let viewFullButton : UIButton = {
       let b = UIButton(title: "View Full", titleColor: .white)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        b.backgroundColor = .blue
        b.layer.cornerRadius = 8
        b.clipsToBounds = true
        return b
    }()
    
    
    
    lazy var overallStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
                emojiIntructionLabel,
                emojiStackView,
                helpLabel,
                commentInstruction,
                commentTextField,
                historyCommentInstruction,
                tableView.withHeight(300),
                
            ])
        sv.spacing = 8
        sv.axis = .vertical
        return sv
        
    }()
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
//        view.addSubview(overallStackView)
        tableView.separatorStyle = .none
        
        
        
        view.addSubview(emojiIntructionLabel)
        emojiIntructionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        
        view.addSubview(emojiStackView)
        emojiStackView.anchor(top: emojiIntructionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        view.addSubview(helpLabel)
        helpLabel.anchor(top: emojiStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        
        view.addSubview(commentInstruction)
        commentInstruction.anchor(top: helpLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        
        view.addSubview(commentTextField)
        commentTextField.anchor(top: commentInstruction.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        view.addSubview(historyCommentInstruction)
        historyCommentInstruction.anchor(top: commentTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16),size: .init(width: 0, height: 50))
        
        view.addSubview(tableView)
        tableView.anchor(top: historyCommentInstruction.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        
        view.addSubview(viewFullButton)
        viewFullButton.anchor(top: tableView.bottomAnchor, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 8, right: 16), size: .init(width: 180, height: 50))
        
        
        
        
//        overallStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
    }
    
    
    fileprivate func setupTapGesture() {
        //add recignizer on view, wont trigger on ui elements such as buttons and textfields
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
    }
    //dismiss keyboard
    @objc fileprivate func handleTapDismiss() {
        view.endEditing(true)
        //scroll view scrolls back down so view beccomes original
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.transform = .identity
        })
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.withBorder(width: 2, color: .lightGray)
        tableView.layer.cornerRadius = 10
        
        setupUI()
        setupTapGesture()
    }
    
    

    
    var comments = ["Why does 1+1 = 3? That was counterintuitive for me.", "Okay, Gotta!", "I love your shirt!", "Could you speak slower?", "Your handwriting is hard to read, what is the second word of the upper-right sentence on the blackboard?"]
    var commentsTime = ["2:05PM", "2:04PM", "2:03PM", "2:03PM", "2:00PM"]

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! UITableViewCell
        let attiText = NSMutableAttributedString(string: commentsTime[indexPath.row] , attributes: [.foregroundColor : UIColor.blue])
        attiText.append(NSMutableAttributedString(string: " \(comments[indexPath.row])"))
        cell.textLabel?.attributedText = attiText
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    
    
    
}

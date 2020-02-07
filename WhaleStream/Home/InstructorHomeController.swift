//
//  InstructorHomeController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/6/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit

class InstructorHomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let cellID = "cellId"
    let tableView = UITableView()
    
    let lightYellow = UIColor.rgb(red: 255, green: 255, blue: 237)
    
    fileprivate lazy var laughButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("😄", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
        return button
    }()
    fileprivate lazy var smileButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("😊", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)

        return button
    }()
    fileprivate lazy var sadButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("☹️", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)

        return button
    }()
    
    let laughNum : UILabel = {
       let b = UILabel(text: "21")
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .center
        return b
    }()
    let laughBar : UILabel = {
       let b = UILabel(backgroundColor: .green, opacity: 1)
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        return b
    }()
    let smileNum : UILabel = {
       let b = UILabel(text: "40")
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .center

        return b
    }()
    let smileBar : UILabel = {
       let b = UILabel(backgroundColor: .yellow, opacity: 1)
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        return b
    }()
    let sadNum : UILabel = {
       let b = UILabel(text: "33")
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .center
        return b
    }()
    let sadBar : UILabel = {
       let b = UILabel(backgroundColor: .red, opacity: 1)
        b.layer.cornerRadius = 16
        b.clipsToBounds = true
        return b
    }()
    
    lazy var laughStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [laughNum, laughBar.withHeight(130), laughButton])
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fill
        return sv
    }()
    
    lazy var smileStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [smileNum, smileBar.withHeight(240), smileButton])
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fill

        return sv
    }()

    lazy var sadStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sadNum, sadBar.withHeight(200), sadButton])
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fill
        return sv
    }()

    
    
    
    lazy var emojiStackView : UIStackView  = {
       let sv = UIStackView(arrangedSubviews: [
        laughStack.withWidth(50),
        smileStack.withWidth(50),
        sadStack.withWidth(50)
       ])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.spacing = 16
        return sv
    }()
    
    
    let emojiIntructionLabel: UILabel = {
        let l = UILabel(text: "In class real-time response:", font: UIFont.systemFont(ofSize: 16), textAlignment: .left, numberOfLines: 0)
        return l
    }()
    
    
    let commentInstruction = UILabel(text: "Real-time comments:", font: .systemFont(ofSize: 16), numberOfLines: 0)
    
    
    
    let endClassButton : UIButton = {
       let b = UIButton(title: "End Class", titleColor: .white)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        b.backgroundColor = .red
        b.layer.cornerRadius = 8
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(handleEndClass), for: .touchUpInside)
        return b
    }()
    
    @objc fileprivate func handleEndClass() {
        navigationController?.popViewController(animated: true)
    }
    
    
//
//    lazy var overallStackView : UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [
//                emojiIntructionLabel,
//                emojiStackView,
//                helpLabel,
//                commentInstruction,
//                commentTextField,
//                historyCommentInstruction,
//                tableView.withHeight(300),
//
//            ])
//        sv.spacing = 8
//        sv.axis = .vertical
//        return sv
//
//    }()
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
//        view.addSubview(overallStackView)
        tableView.separatorStyle = .none
        
        view.addSubview(emojiIntructionLabel)
        emojiIntructionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        view.addSubview(emojiStackView)
        emojiStackView.anchor(top: emojiIntructionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 80, bottom: 0, right: 80))
        emojiStackView.withBorder(width: 3, color: .lightGray)


        
        view.addSubview(commentInstruction)
        commentInstruction.anchor(top: emojiStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 16, bottom: 0, right: 16))
        
        
        view.addSubview(tableView)
        tableView.anchor(top: commentInstruction.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 300))
        
        
        view.addSubview(endClassButton)
        endClassButton.anchor(top: tableView.bottomAnchor, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 8, right: 16), size: .init(width: 180, height: 50))
        
        
        
        
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
        tableView.withBorder(width: 3, color: .lightGray)
        tableView.layer.cornerRadius = 10
        
        setupUI()
        setupTapGesture()
    }
    
    

    
    var comments = ["Why does 1+1 = 3? That was counterintuitive for me.", "I love your shirt!", "Could you speak slower?", "Your handwriting is hard to read, what is the second word of the upper-right sentence on the blackboard?", "What does an user-friendly app mean?"]
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

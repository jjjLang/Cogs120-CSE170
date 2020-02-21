//
//  HomeController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/5/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommentControllerDelegate {
    let cellID = "cellId"
    let tableView = UITableView()
    
    let lightYellow = UIColor.rgb(red: 255, green: 255, blue: 237)
    
      var course: Course? {
          didSet {
            navigationItem.title = course?.className
            fetchComments(classID: course?.classID ?? "")
          }
      }
    
    

    
    var listener: ListenerRegistration?
    

    
    fileprivate func fetchComments(classID: String) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let query = Firestore.firestore().collection("classComments").document(classID).collection("comments").order(by: "timestamp", descending: false)
        listener = query.addSnapshotListener({ (querySnapshot, err) in
            if let err = err {
                print(err)
                return
            }
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added  {
                    let dict = change.document.data()
//                    self.comments.append(Comment(dictionary: dict))
                    self.comments.insert(Comment(dictionary: dict), at: 0)
                }
            })
            self.tableView.reloadData()
        })
    }
    
    
        func didSendComment(comment: String) {
            guard let currentUID = Auth.auth().currentUser?.uid else {return}
            let dict = ["text": comment, "fromId": currentUID, "timestamp": Timestamp(date: Date())] as [String:Any]
            Firestore.firestore().collection("classComments").document(course?.classID ?? "").collection("comments").addDocument(data: dict)
            
    //        tableView.reloadData()
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            listener?.remove()
//            reactionListener?.remove()
        }
    }
    
    
    
    
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
    
    fileprivate func sendReaction() {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let dict = ["uid": currentUID, "reactionID": reactionID, "previousReactionID": previousReactionID] as [String:Any]
        
        Firestore.firestore().collection("classReactions").document(course?.classID ?? "").collection("reactions").document(currentUID).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("classReactions").document(self.course?.classID ?? "").collection("reactions").document(currentUID).updateData(dict)
            } else {
                Firestore.firestore().collection("classReactions").document(self.course?.classID ?? "").collection("reactions").document(currentUID).setData(dict)
            }
        }
    }
    
    var previousReactionID: Double = -1
    var reactionID : Double = -1
    
    @objc fileprivate func handleTapEmoji(button: UIButton) {
        switch button {
        case laughButton:
            if laughButton.backgroundColor == lightYellow {
                laughButton.backgroundColor = UIColor.green
                smileButton.backgroundColor = lightYellow
                sadButton.backgroundColor = lightYellow
                previousReactionID = reactionID
                reactionID = 0
                sendReaction()
            } else {
                laughButton.backgroundColor = lightYellow
            }
            
            
            
        case smileButton:
            if smileButton.backgroundColor == lightYellow {
                smileButton.backgroundColor = UIColor.yellow
                laughButton.backgroundColor = lightYellow
                sadButton.backgroundColor = lightYellow
                previousReactionID = reactionID
                reactionID = 1
                sendReaction()
            } else {
                smileButton.backgroundColor = lightYellow
            }
        default:
            if sadButton.backgroundColor == lightYellow {
                sadButton.backgroundColor = UIColor.red
                laughButton.backgroundColor = lightYellow
                smileButton.backgroundColor = lightYellow
                previousReactionID = reactionID
                reactionID = 2
                sendReaction()
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
    

    
    let commentInstruction = UILabel(text: "Comments on the materials", font: .systemFont(ofSize: 26), numberOfLines: 0)
    
    let commentTextField : UITextField = {
       let tf = CustomTextField(padding: 16, height: 60)
        tf.placeholder = "Type your comment"
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(handleComment), for: .touchDown)
        return tf
    }()
    
    @objc func handleComment() {
        let commentController = CommentController()
        commentController.delegate = self
        navigationController?.pushViewController(commentController, animated: true)
    }
    

    
    
    let historyCommentInstruction = UILabel(text: "View you own history of comments", font: .systemFont(ofSize: 20), numberOfLines: 0)

    
    let viewFullButton : UIButton = {
       let b = UIButton(title: "View Full", titleColor: .white)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        b.backgroundColor = .blue
        b.layer.cornerRadius = 8
        b.clipsToBounds = true
//        b.addTarget(self, action: #selector(handleViewFull), for: .touchUpInside)
        return b
    }()
    
//    @objc fileprivate func handleViewFull() {
//        let fullCommentController = FullCommentViewController()
//        fullCommentController.comments = comments
//        fullCommentController.commentsTime = commentsTime
//        navigationController?.pushViewController(fullCommentController, animated: true)
//    }
    
    
    
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
    
    var barColor : UIColor? {
        didSet {
            navigationController?.navigationBar.barTintColor = barColor ?? UIColor.white
        }
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
//        view.addSubview(overallStackView)
        tableView.separatorStyle = .none
        
        
        
        
        view.addSubview(emojiIntructionLabel)
        emojiIntructionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 100))
        
        view.addSubview(emojiStackView)
        emojiStackView.anchor(top: emojiIntructionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
//        view.addSubview(helpLabel)
//        helpLabel.anchor(top: emojiStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        
        view.addSubview(commentInstruction)
        commentInstruction.anchor(top: emojiStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        
        view.addSubview(commentTextField)
        commentTextField.anchor(top: commentInstruction.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        view.addSubview(historyCommentInstruction)
        historyCommentInstruction.anchor(top: commentTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16),size: .init(width: 0, height: 50))
        
        view.addSubview(tableView)
        tableView.anchor(top: historyCommentInstruction.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        
        view.addSubview(viewFullButton)
        viewFullButton.anchor(top: tableView.bottomAnchor, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 8, right: 16), size: .init(width: 180, height: 50))
        
        viewFullButton.isHidden = true
        
        
        
        
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(handleHelp))
        
        setupUI()
        setupTapGesture()
        
//        fetchComments()
    }
    
        let helpLabel : UIButton = {
            let l = UIButton()
            l.titleLabel?.textAlignment = .left
    //        l.titleLabel?.textColor = .black
            l.titleLabel?.font = .systemFont(ofSize: 26)
            
            l.setAttributedTitle(NSAttributedString(string: "Help?", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
                , for: .normal)
            l.addTarget(self, action: #selector(handleHelp), for: .touchUpInside)
            return l
        }()
        
        @objc func handleHelp() {
             let ac = UIAlertController(title: "Help", message: "The instructor cares about your feeling and your thoughts on the material! Try press an emoji or send a comment! The instructor will receive your feedback instantly! (Remember: you are free to change your feeling anytime during the lecture)", preferredStyle: .alert)
                   let cancelAction = UIAlertAction(title: "Got it", style: .cancel, handler: nil)
                   ac.addAction(cancelAction)
                   present(ac, animated: true)
        }
    

    
    
    
//    var comments = ["Why does 1+1 = 3? That was counterintuitive for me.", "Okay, Gotta!", "I love your shirt!", "Could you speak slower?", "Your handwriting is hard to read, what is the second word of the upper-right sentence on the blackboard?"]
//    var commentsTime = ["2:05PM", "2:04PM", "2:03PM", "2:03PM", "2:00PM"]
    
    var comments = [Comment]()

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! UITableViewCell
        let comment = comments[indexPath.item]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd hh:mma" // "a" prints "pm" or "am"
        let timeString = formatter.string(from: comment.timestamp.dateValue()) // "12 AM"
        
        let attiText = NSMutableAttributedString(string: timeString, attributes: [.foregroundColor : UIColor.blue])
        attiText.append(NSMutableAttributedString(string: " \(comment.text)"))
        cell.textLabel?.attributedText = attiText
        cell.textLabel?.numberOfLines = 0
        
        if let uid = Auth.auth().currentUser?.uid {
            if comments[indexPath.row].fromId == uid {
                cell.backgroundColor = .orange
            } else {
                cell.backgroundColor = .white
            }
        }

        return cell
    }
    
    
    
    
}

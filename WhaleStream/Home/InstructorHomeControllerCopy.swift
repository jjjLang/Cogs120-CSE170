////
////  InstructorHomeControllerCopy.swift
////  WhaleStream
////
////  Created by wenlong qiu on 2/27/20.
////  Copyright © 2020 wenlong qiu. All rights reserved.
////
//
////
////  InstructorHomeController.swift
////  WhaleStream
////
////  Created by wenlong qiu on 2/6/20.
////  Copyright © 2020 wenlong qiu. All rights reserved.
////
//
//import UIKit
//import Firebase
//
//class InstructorHomeController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    let cellID = "cellId"
//    let tableView = UITableView()
//    
//    let lightYellow = UIColor.rgb(red: 255, green: 255, blue: 237)
//    
//    fileprivate lazy var laughButton: EmojiButton = {
//        let button = EmojiButton(type: .system)
//        button.backgroundColor = .white
//        button.setTitle("😄", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
//        return button
//    }()
//    fileprivate lazy var smileButton: EmojiButton = {
//        let button = EmojiButton(type: .system)
//        button.backgroundColor = .white
//        button.setTitle("😊", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
//
//        return button
//    }()
//    fileprivate lazy var sadButton: EmojiButton = {
//        let button = EmojiButton(type: .system)
//        button.backgroundColor = .white
//        button.setTitle("☹️", for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 26)
//
//        return button
//    }()
//    
//    let laughNum : UILabel = {
//       let b = UILabel(text: "0")
//        b.font = UIFont.systemFont(ofSize: 16)
//        b.textAlignment = .center
//        return b
//    }()
//    let laughBar : UIButton = {
//        let b = UIButton(backgroundColor: .green, opacity: 1)
//        b.layer.cornerRadius = 16
//        b.clipsToBounds = true
//        return b
//    }()
//    
//    let laughContainer : UIView = {
//        let v = UIView()
//        v.backgroundColor = .white
//        return v
//    }()
//    
//    let smileContainer : UIView = {
//        let v = UIView()
//        v.backgroundColor = .white
//        return v
//    }()
//    
//    let sadContainer : UIView = {
//        let v = UIView()
//        v.backgroundColor = .white
//        return v
//    }()
//    
//    
//    let smileNum : UILabel = {
//       let b = UILabel(text: "0")
//        b.font = UIFont.systemFont(ofSize: 16)
//        b.textAlignment = .center
//
//        return b
//    }()
//    let smileBar : UIButton = {
//        let b = UIButton(backgroundColor: .yellow, opacity: 1)
//        b.layer.cornerRadius = 16
//        b.clipsToBounds = true
//        return b
//    }()
//    let sadNum : UILabel = {
//       let b = UILabel(text: "0")
//        b.font = UIFont.systemFont(ofSize: 16)
//        b.textAlignment = .center
//        return b
//    }()
//    let sadBar : UIButton = {
//        let b = UIButton(backgroundColor: .red, opacity: 1)
//        b.layer.cornerRadius = 16
//        b.clipsToBounds = true
//        return b
//    }()
//    
//    lazy var laughStack: UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [laughNum, laughContainer.withHeight(240), laughButton])
//        sv.axis = .vertical
//        sv.spacing = 5
//        sv.distribution = .fill
//        return sv
//    }()
//    
//    lazy var smileStack: UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [smileNum, smileContainer.withHeight(240), smileButton])
//        sv.axis = .vertical
//        sv.spacing = 5
//        sv.distribution = .fill
//
//        return sv
//    }()
//
//    lazy var sadStack: UIStackView = {
//        let sv = UIStackView(arrangedSubviews: [sadNum, sadContainer.withHeight(240), sadButton])
//        sv.axis = .vertical
//        sv.spacing = 5
//        sv.distribution = .fill
//        return sv
//    }()
//
//    
//    
//    
//    lazy var emojiStackView : UIStackView  = {
//       let sv = UIStackView(arrangedSubviews: [
//        laughStack.withWidth(50),
//        smileStack.withWidth(50),
//        sadStack.withWidth(50)
//       ])
//        sv.axis = .horizontal
//        sv.distribution = .equalSpacing
//        sv.spacing = 16
//        return sv
//    }()
//    
//    
//    let emojiIntructionLabel: UILabel = {
//        let l = UILabel(text: "In class real-time response:", font: UIFont.systemFont(ofSize: 16), textAlignment: .left, numberOfLines: 0)
//        return l
//    }()
//    
//    
//    let commentInstruction = UILabel(text: "Real-time comments:", font: .systemFont(ofSize: 16), numberOfLines: 0)
//    
//    
//    
//    let endClassButton : UIButton = {
//       let b = UIButton(title: "End Class", titleColor: .white)
//        b.titleLabel?.font = UIFont.systemFont(ofSize: 20)
//        b.backgroundColor = .red
//        b.layer.cornerRadius = 8
//        b.clipsToBounds = true
//        b.addTarget(self, action: #selector(handleEndClass), for: .touchUpInside)
//        return b
//    }()
//    
//    @objc fileprivate func handleEndClass() {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    
////
////    lazy var overallStackView : UIStackView = {
////        let sv = UIStackView(arrangedSubviews: [
////                emojiIntructionLabel,
////                emojiStackView,
////                helpLabel,
////                commentInstruction,
////                commentTextField,
////                historyCommentInstruction,
////                tableView.withHeight(300),
////
////            ])
////        sv.spacing = 8
////        sv.axis = .vertical
////        return sv
////
////    }()
//    
//    fileprivate func setupUI() {
//        view.backgroundColor = .white
////        view.addSubview(overallStackView)
//        tableView.separatorStyle = .none
//        
//        view.addSubview(emojiIntructionLabel)
//        emojiIntructionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
//        
//        view.addSubview(emojiStackView)
//        emojiStackView.anchor(top: emojiIntructionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 80, bottom: 0, right: 80))
//        emojiStackView.withBorder(width: 3, color: .lightGray)
//
//        view.addSubview(commentInstruction)
//        commentInstruction.anchor(top: emojiStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 5, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
//        
//        
//        view.addSubview(tableView)
//        tableView.anchor(top: commentInstruction.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 0))
//        
//        
//        view.addSubview(endClassButton)
//        endClassButton.anchor(top: tableView.bottomAnchor, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 8, right: 16), size: .init(width: 180, height: 50))
//        
//        
//        
//        laughContainer.addSubview(laughBar)
//        laughBar.anchor(top: nil, leading: laughContainer.leadingAnchor, bottom: laughContainer.bottomAnchor, trailing: laughContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
//        
//        smileContainer.addSubview(smileBar)
//        smileBar.anchor(top: nil, leading: smileContainer.leadingAnchor, bottom: smileContainer.bottomAnchor, trailing: smileContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
//        
//        sadContainer.addSubview(sadBar)
//        sadBar.anchor(top: nil, leading: sadContainer.leadingAnchor, bottom: sadContainer.bottomAnchor, trailing: sadContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
//        
//        
//        
//        
////        overallStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
//    }
//    
//    
//    fileprivate func setupTapGesture() {
//        //add recignizer on view, wont trigger on ui elements such as buttons and textfields
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapDismiss)))
//    }
//    //dismiss keyboard
//    @objc fileprivate func handleTapDismiss() {
//        view.endEditing(true)
//        //scroll view scrolls back down so view beccomes original
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.view.transform = .identity
//        })
//    }
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
//        tableView.withBorder(width: 3, color: .lightGray)
//        tableView.layer.cornerRadius = 10
//        
//        setupUI()
//        setupTapGesture()
//    }
//    
//    
//         var course: Course? {
//              didSet {
//                navigationItem.title = course?.className
//                fetchComments(classID: course?.classID ?? "")
//                fetchReactions(classID: course?.classID ?? "")
//              }
//          }
//    
//    var totalReactionCount : Double = 0
//    var laughCount : Double = 0
//    var smileCount : Double = 0
//    var sadCount : Double = 0
//    
//    var reactionListener: ListenerRegistration?
//
//    fileprivate func fetchReactions(classID: String) {
//        guard let currentUID = Auth.auth().currentUser?.uid else {return}
//        let query = Firestore.firestore().collection("classReactions").document(classID).collection("reactions")
//        reactionListener = query.addSnapshotListener({ (querySnapshot, err) in
//            if let err = err {
//                print(err)
//                return
//            }
//            querySnapshot?.documentChanges.forEach({ (change) in
//                if change.type == .added {
//                    let dict = change.document.data()
//                    if dict["reactionID"] as? Int == 0 {
//                        self.laughCount += 1
//                    } else if dict["reactionID"] as? Int == 1 {
//                        self.smileCount += 1
//                    } else if dict["reactionID"] as? Int == 2 {
//                        self.sadCount += 1
//                    }
//                    self.totalReactionCount += 1
//                } else if change.type == .modified {
//                    let dict = change.document.data()
//                    guard let reactionID = dict["reactionID"] as? Int else {return}
//                    guard let prevID = dict["previousReactionID"] as? Int else {return}
////                    if reactionID == prevID {
////                        return
////                    }
//                    if dict["reactionID"] as? Int == 0 {
//                        self.laughCount += 1
//                    } else if dict["reactionID"] as? Int == 1 {
//                        self.smileCount += 1
//                    } else if dict["reactionID"] as? Int == 2 {
//                        self.sadCount += 1
//                    }
//                    
//                    if dict["previousReactionID"] as? Int == 0 {
//                        self.laughCount -= 1
//
//                    } else if dict["previousReactionID"] as? Int == 1 {
//                        self.smileCount -= 1
//
//                    } else if dict["previousReactionID"] as? Int == 2 {
//                        self.sadCount -= 1
//                    }
//                }
//            })
//            self.reloadReactionBars()
//            self.tableView.reloadData()
//        })
//    }
//    
//    
//    var laughBarHeightConstraint : NSLayoutConstraint?
//    var smileBarHeightConstraint : NSLayoutConstraint?
//    var sadBarHeightConstraint : NSLayoutConstraint?
//
//
//    
//    fileprivate func reloadReactionBars() {
//        
//        if totalReactionCount == 0.0 {
//            return
//        }
//        
//            var laughHeight = CGFloat(self.laughCount/self.totalReactionCount * 240 - 1)
////            if laughHeight > 239 {
////                laughHeight = 239
////            } else
//            if laughHeight < 1 {
//                laughHeight = 0
//            }
//        
//        //        self.laughBar.constrainHeight(laughHeight)
//        //        self.laughBar.heightAnchor
//        //        self.laughBar.withSize(CGSize(width: 60, height: laughHeight))
//        //        laughBarHeightConstraint = self.laughBar.constrainHeight(laughHeight)
//
//        laughBar.removeConstraint(laughBarHeightConstraint ?? NSLayoutConstraint())
//        laughBarHeightConstraint = laughBar.heightAnchor.constraint(equalToConstant: laughHeight)
//        laughBarHeightConstraint?.isActive = true
//        self.laughBar.layoutIfNeeded()
////        self.laughBar.updateConstraints()
//
//
//
//            
//            var smileHeight = CGFloat(self.smileCount/self.totalReactionCount * 240 - 1)
////            if smileHeight > 239 {
////                smileHeight = 239
////            } else
//            if smileHeight < 1 {
//                smileHeight = 0
//            }
//        
//        
//        smileBar.removeConstraint(smileBarHeightConstraint ?? NSLayoutConstraint())
//        smileBarHeightConstraint = smileBar.heightAnchor.constraint(equalToConstant: smileHeight)
//        smileBarHeightConstraint?.isActive = true
//        self.smileBar.layoutIfNeeded()
//            
//
//
//
//            var sadHeight = CGFloat(self.sadCount/self.totalReactionCount * 240 - 1)
////            if sadHeight > 239 {
////                sadHeight = 239
////            } else
//            if sadHeight < 1 {
//                sadHeight = 0
//            }
//        
//        sadBar.removeConstraint(sadBarHeightConstraint ?? NSLayoutConstraint())
//        sadBarHeightConstraint = sadBar.heightAnchor.constraint(equalToConstant: sadHeight)
//        sadBarHeightConstraint?.isActive = true
//        self.sadBar.layoutIfNeeded()
//        
//        
// 
//
//        laughNum.text = "\(laughCount)"
//        smileNum.text = "\(smileCount)"
//        sadNum.text = "\(sadCount)"
//
//        
//    }
//        
//        var listener: ListenerRegistration?
//
//        
//        fileprivate func fetchComments(classID: String) {
//            guard let currentUID = Auth.auth().currentUser?.uid else {return}
//            let query = Firestore.firestore().collection("classComments").document(classID).collection("comments").order(by: "timestamp", descending: false)
//            listener = query.addSnapshotListener({ (querySnapshot, err) in
//                if let err = err {
//                    print(err)
//                    return
//                }
//                querySnapshot?.documentChanges.forEach({ (change) in
//                    if change.type == .added {
//                        let dict = change.document.data()
//    //                    self.comments.append(Comment(dictionary: dict))
//                        self.comments.insert(Comment(dictionary: dict), at: 0)
//                    }
//                })
//                self.tableView.reloadData()
//            })
//        }
//        
//        override func viewWillDisappear(_ animated: Bool) {
//            super.viewWillDisappear(animated)
//            if isMovingFromParent {
//                listener?.remove()
//                reactionListener?.remove()
//            }
//        }
//    
//    
//    
//
//    
////    var comments = ["Why does 1+1 = 3? That was counterintuitive for me.", "I love your shirt!", "Could you speak slower?", "Your handwriting is hard to read, what is the second word of the upper-right sentence on the blackboard?", "What does an user-friendly app mean?"]
////    var commentsTime = ["2:05PM", "2:04PM", "2:03PM", "2:03PM", "2:00PM"]
//    
//    var comments = [Comment]()
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return comments.count
//    }
////
////    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////        return 100
////    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//         let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! UITableViewCell
//         let comment = comments[indexPath.item]
//         
//         let formatter = DateFormatter()
//         formatter.dateFormat = "MM-dd hh:mma" // "a" prints "pm" or "am"
//         let timeString = formatter.string(from: comment.timestamp.dateValue()) // "12 AM"
//         
//         let attiText = NSMutableAttributedString(string: timeString, attributes: [.foregroundColor : UIColor.blue])
//         attiText.append(NSMutableAttributedString(string: " \(comment.text)"))
//         cell.textLabel?.attributedText = attiText
//         cell.textLabel?.numberOfLines = 0
//         return cell
//     }
//    
//    
//    
//    
//}

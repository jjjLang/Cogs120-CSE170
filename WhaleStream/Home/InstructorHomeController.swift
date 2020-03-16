//
//  InstructorHomeController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/6/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class InstructorHomeController: UIViewController, UITableViewDelegate, UITableViewDataSource, HomeAltNavBarDelegate {

    
    let cellID = "cellId"
    let tableView = UITableView()
    
    let lightYellow = UIColor.rgb(red: 255, green: 255, blue: 237)
    
    fileprivate lazy var laughButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("😄", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 34)
        return button
    }()
    fileprivate lazy var smileButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("😲", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 34)

        return button
    }()
    fileprivate lazy var sadButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("🤔", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 34)

        return button
    }()
    
    let laughNum : UILabel = {
       let b = UILabel(text: "0")
        b.font = UIFont.systemFont(ofSize: 20)
        b.textAlignment = .center
        return b
    }()
    let laughBar : UIButton = {
        let b = UIButton(backgroundColor: UIColor.rgb(red: 39, green: 174, blue: 96), opacity: 1)

        b.layer.cornerRadius = 20
        b.clipsToBounds = true
        return b
    }()
    
    let laughContainer : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let smileContainer : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    let sadContainer : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    
    
    let smileNum : UILabel = {
       let b = UILabel(text: "0")
        b.font = UIFont.systemFont(ofSize: 20)
        b.textAlignment = .center

        return b
    }()
    let smileBar : UIButton = {
        let b = UIButton(backgroundColor: UIColor.rgb(red: 242, green: 201, blue: 76), opacity: 1)
        b.layer.cornerRadius = 20
        b.clipsToBounds = true
        return b
    }()
    let sadNum : UILabel = {
       let b = UILabel(text: "0")
        b.font = UIFont.systemFont(ofSize: 20)
        b.textAlignment = .center
        return b
    }()
    let sadBar : UIButton = {
        let b = UIButton(backgroundColor: UIColor.rgb(red: 253, green: 93, blue: 93), opacity: 1)
        b.layer.cornerRadius = 20
        b.clipsToBounds = true
        return b
    }()
    
    var emojibarHeight: Double = 170
    
    lazy var laughStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [laughNum, laughContainer.withHeight(CGFloat(emojibarHeight)), laughButton])
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fill
        return sv
    }()
    
    lazy var smileStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [smileNum, smileContainer.withHeight(CGFloat(emojibarHeight)), smileButton])
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fill

        return sv
    }()

    lazy var sadStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sadNum, sadContainer.withHeight(CGFloat(emojibarHeight)), sadButton])
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fill
        return sv
    }()

    
    
    
    lazy var emojiStackView : UIStackView  = {
       let sv = UIStackView(arrangedSubviews: [
        laughStack.withWidth(40),
        smileStack.withWidth(40),
        sadStack.withWidth(40)
       ])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.spacing = 16
        return sv
    }()
    
    
    let emojiIntructionLabel: UILabel = {
        let l = UILabel(text: "In class real-time response:", font: .systemFont(ofSize: 18), textAlignment: .left, numberOfLines: 0)
        return l
    }()
    
    
    let commentInstruction = UILabel(text: "Real-time comments:", font: .systemFont(ofSize: 18), numberOfLines: 0)
    
    
    
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
    
    
    fileprivate var userProfileUrl: String

    fileprivate let course: Course
    
    
    init(course: Course, userProfileUrl: String) {
        self.userProfileUrl = userProfileUrl
        self.course = course
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate let navBarHeight:CGFloat = 120
    
    func didTapProfileImage() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changeProfileAction = UIAlertAction(title: "Change Profile Image", style: .default) { (_) in
            self.handleChangeProfilePhoto()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(changeProfileAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet,animated: true,completion: nil)
    }
    
    
    func handleChangeProfilePhoto() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        present(imagePickerController, animated: true)
    }
    
    func fetchProfileUrl() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            let dict = snapshot?.data()
            self.userProfileUrl = dict?["imageUrl"] as? String ?? ""
            self.homeAltNavBar.userProfileImageView.sd_setImage(with: URL(string: self.userProfileUrl), completed: nil)
            
        }
        
    }


    fileprivate lazy var homeAltNavBar = HomeAltNavBar(className: course.className ?? "", profileUrl: userProfileUrl )

    @objc func handleBack() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
//        view.addSubview(overallStackView)
        tableView.separatorStyle = .none
        
        homeAltNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)

        
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = true
        
        homeAltNavBar.delegate = self

        fetchProfileUrl()
        
        view.addSubview(homeAltNavBar)
        homeAltNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
        
        let statusBarCover = UIView(backgroundColor: .white, opacity: 1)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        

    
        
        view.addSubview(emojiIntructionLabel)
        emojiIntructionLabel.anchor(top: homeAltNavBar.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 25, bottom: 0, right: 25), size: .init(width: 0, height: 50))
        
        let emoStackViewContainer = UIView()
        emoStackViewContainer.addSubview(emojiStackView)
        emojiStackView.anchor(top: emoStackViewContainer.topAnchor, leading: emoStackViewContainer.leadingAnchor, bottom: emoStackViewContainer.bottomAnchor, trailing: emoStackViewContainer.trailingAnchor, padding: .init(top: 16, left: 60, bottom: 8, right: 60), size: .init(width: 0, height: 0))
        emoStackViewContainer.withBorder(width: 2, color: UIColor.init(white: 0, alpha: 0.1))
        emoStackViewContainer.layer.cornerRadius = 12


        
        view.addSubview(emoStackViewContainer)
        emoStackViewContainer.anchor(top: emojiIntructionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 20, bottom: 0, right: 20))
//        emojiStackView.withBorder(width: 3, color: .lightGray)

        view.addSubview(commentInstruction)
        commentInstruction.anchor(top: emojiStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 25, bottom: 0, right: 25), size: .init(width: 0, height: 50))
        
        
        view.addSubview(tableView)
        tableView.anchor(top: commentInstruction.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 8, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 0))
        
        
        view.addSubview(endClassButton)
        endClassButton.anchor(top: tableView.bottomAnchor, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 5, left: 16, bottom: 8, right: 16), size: .init(width: 180, height: 30))
        
        
        
        laughContainer.addSubview(laughBar)
        laughBar.anchor(top: nil, leading: laughContainer.leadingAnchor, bottom: laughContainer.bottomAnchor, trailing: laughContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        smileContainer.addSubview(smileBar)
        smileBar.anchor(top: nil, leading: smileContainer.leadingAnchor, bottom: smileContainer.bottomAnchor, trailing: smileContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        sadContainer.addSubview(sadBar)
        sadBar.anchor(top: nil, leading: sadContainer.leadingAnchor, bottom: sadContainer.bottomAnchor, trailing: sadContainer.trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        
        endClassButton.isHidden = true
        
        
        
        
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
//        tableView.withBorder(width: 3, color: .lightGray)
        tableView.withBorder(width: 2, color: UIColor.init(white: 0, alpha: 0.1))
        tableView.layer.cornerRadius = 10
        
        setupUI()
        setupTapGesture()
        
        fetchComments(classID: course.classID ?? "")
        fetchReactions(classID: course.classID ?? "")
    }
    
    
//         var course: Course? {
//              didSet {
//                navigationItem.title = course?.className
//                fetchComments(classID: course?.classID ?? "")
//                fetchReactions(classID: course?.classID ?? "")
//              }
//          }
    
    var totalReactionCount : Double = 0
    var laughCount : Double = 0
    var smileCount : Double = 0
    var sadCount : Double = 0
    
    var reactionListener: ListenerRegistration?

    fileprivate func fetchReactions(classID: String) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let query = Firestore.firestore().collection("classReactions").document(classID).collection("reactions")
        reactionListener = query.addSnapshotListener({ (querySnapshot, err) in
            if let err = err {
                print(err)
                return
            }
            querySnapshot?.documentChanges.forEach({ (change) in
                if change.type == .added {
                    let dict = change.document.data()
                    if dict["reactionID"] as? Int == 0 {
                        self.laughCount += 1
                    } else if dict["reactionID"] as? Int == 1 {
                        self.smileCount += 1
                    } else if dict["reactionID"] as? Int == 2 {
                        self.sadCount += 1
                    }
                    self.totalReactionCount += 1
                } else if change.type == .modified {
                    let dict = change.document.data()
                    guard let reactionID = dict["reactionID"] as? Int else {return}
                    guard let prevID = dict["previousReactionID"] as? Int else {return}
//                    if reactionID == prevID {
//                        return
//                    }
                    if dict["reactionID"] as? Int == 0 {
                        self.laughCount += 1
                    } else if dict["reactionID"] as? Int == 1 {
                        self.smileCount += 1
                    } else if dict["reactionID"] as? Int == 2 {
                        self.sadCount += 1
                    }
                    
                    if dict["previousReactionID"] as? Int == 0 {
                        self.laughCount -= 1

                    } else if dict["previousReactionID"] as? Int == 1 {
                        self.smileCount -= 1

                    } else if dict["previousReactionID"] as? Int == 2 {
                        self.sadCount -= 1
                    }
                }
            })
            self.reloadReactionBars()
            self.tableView.reloadData()
        })
    }
    
    
    var laughBarHeightConstraint : NSLayoutConstraint?
    var smileBarHeightConstraint : NSLayoutConstraint?
    var sadBarHeightConstraint : NSLayoutConstraint?


    
    fileprivate func reloadReactionBars() {
        
        if totalReactionCount == 0.0 {
            return
        }
        
            var laughHeight = CGFloat(self.laughCount/self.totalReactionCount * emojibarHeight - 1)
//            if laughHeight > 239 {
//                laughHeight = 239
//            } else
            if laughHeight < 1 {
                laughHeight = 0
            }
        
        //        self.laughBar.constrainHeight(laughHeight)
        //        self.laughBar.heightAnchor
        //        self.laughBar.withSize(CGSize(width: 60, height: laughHeight))
        //        laughBarHeightConstraint = self.laughBar.constrainHeight(laughHeight)

        laughBar.removeConstraint(laughBarHeightConstraint ?? NSLayoutConstraint())
        laughBarHeightConstraint = laughBar.heightAnchor.constraint(equalToConstant: laughHeight)
        laughBarHeightConstraint?.isActive = true
        self.laughBar.layoutIfNeeded()
//        self.laughBar.updateConstraints()



            
            var smileHeight = CGFloat(self.smileCount/self.totalReactionCount * emojibarHeight - 1)
//            if smileHeight > 239 {
//                smileHeight = 239
//            } else
            if smileHeight < 1 {
                smileHeight = 0
            }
        
        
        smileBar.removeConstraint(smileBarHeightConstraint ?? NSLayoutConstraint())
        smileBarHeightConstraint = smileBar.heightAnchor.constraint(equalToConstant: smileHeight)
        smileBarHeightConstraint?.isActive = true
        self.smileBar.layoutIfNeeded()
            



            var sadHeight = CGFloat(self.sadCount/self.totalReactionCount * emojibarHeight - 1)
//            if sadHeight > 239 {
//                sadHeight = 239
//            } else
            if sadHeight < 1 {
                sadHeight = 0
            }
        
        sadBar.removeConstraint(sadBarHeightConstraint ?? NSLayoutConstraint())
        sadBarHeightConstraint = sadBar.heightAnchor.constraint(equalToConstant: sadHeight)
        sadBarHeightConstraint?.isActive = true
        self.sadBar.layoutIfNeeded()
        
        
 

        laughNum.text = "\(Int(laughCount))"
        smileNum.text = "\(Int(smileCount))"
        sadNum.text = "\(Int(sadCount))"

        
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
                    if change.type == .added {
                        let dict = change.document.data()
                        self.comments.append(Comment(dictionary: dict))
//                        self.comments.insert(Comment(dictionary: dict), at: 0)
                    }
                })
                self.tableView.reloadData()
                if self.comments.count != 0 {
                    self.tableView.scrollToRow(at: [0, self.comments.count - 1], at: .bottom, animated: false)
                }
            })
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            if isMovingFromParent {
                listener?.remove()
                reactionListener?.remove()
            }
        }
    
    
    

    
//    var comments = ["Why does 1+1 = 3? That was counterintuitive for me.", "I love your shirt!", "Could you speak slower?", "Your handwriting is hard to read, what is the second word of the upper-right sentence on the blackboard?", "What does an user-friendly app mean?"]
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
        
//        var foreGroundColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
        
        var foreGroundColor = UIColor(red: 0.184, green: 0.502, blue: 0.929, alpha: 1)
        
//        if let uid = Auth.auth().currentUser?.uid {
//            if comments[indexPath.row].fromId == uid {
//                foreGroundColor = UIColor(red: 0.922, green: 0.341, blue: 0.341, alpha: 1)
//            } else {
//                foreGroundColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
//            }
//        }
        
        let attiText = NSMutableAttributedString(string: timeString, attributes: [.foregroundColor : foreGroundColor, .font: UIFont.systemFont(ofSize: 17)])
        attiText.append(NSMutableAttributedString(string: "   \(comment.text)" , attributes: [.font: UIFont.systemFont(ofSize: 17)]))
        cell.textLabel?.attributedText = attiText
        cell.textLabel?.numberOfLines = 0
        return cell
     }
    
    
    let upimageHud = JGProgressHUD(style: .dark)

    
}

extension InstructorHomeController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
//        registerCampusViewModel.bindableImage.value = image
//        registerCampusViewModel.checkRegisterInputValid() //checkfromvalidity gets called when text changes, not when image selected
        homeAltNavBar.userProfileImageView.image = selectedImage?.withRenderingMode(.alwaysOriginal)
        dismiss(animated: true)
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "\(filename)")

        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else {return}
        
//        let hud = JGProgressHUD(style: .dark)
//        hud.textLabel.text = "uploading image..."
//        hud.show(in: view)
        upimageHud.textLabel.text = "uploading image..."
        upimageHud.show(in: view) //show hud when click save

        ref.putData(uploadData, metadata: nil, completion: { (_, err) in
            if let err = err {
                return
            }
//            print("uploaded image to storage")
            _ = ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    return
                }

                let imageUrl = url?.absoluteString ?? ""
                self.saveProfileFirestore(imageUrl: imageUrl)
            })
        })
        
        
        
    }
    
    
    func saveProfileFirestore(imageUrl: String) {
        guard let uid = Auth.auth().currentUser?.uid else {return}

        Firestore.firestore().collection("users").document(uid).updateData(["imageUrl": imageUrl]) { (err) in
            self.upimageHud.dismiss()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}


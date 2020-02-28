//
//  HomeAltController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/26/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//


import UIKit
import Firebase
import JGProgressHUD


class HomeAltController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommentControllerDelegate, UITextFieldDelegate, HomeAltNavBarDelegate {
    let cellID = "cellId"
    let tableView = UITableView()
    
//    let lightYellow = UIColor.rgb(red: 255, green: 255, blue: 237)
    let lightYellow = UIColor.rgb(red: 248, green: 234, blue: 207)
//      var course: Course? {
//          didSet {
//            navigationItem.title = course?.className
//            fetchComments(classID: course?.classID ?? "")
//          }
//      }
    
//    var userProfileUrl: String? {
//        didSet {
////            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(handleHelp))
////            navigationItem.rightBarButtonItem = UIBarButtonItem(image: , style: <#T##UIBarButtonItem.Style#>, target: <#T##Any?#>, action: <#T##Selector?#>)
//
//        }
//    }
    
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
                    self.comments.append(Comment(dictionary: dict))
//                    self.comments.insert(Comment(dictionary: dict), at: 0)
                }
            })
            self.tableView.reloadData()
            if self.comments.count != 0 {
                self.tableView.scrollToRow(at: [0, self.comments.count - 1], at: .bottom, animated: false)
            }
        })
    }
    
    
        func didSendComment(comment: String) {
            guard let currentUID = Auth.auth().currentUser?.uid else {return}
            let dict = ["text": comment, "fromId": currentUID, "timestamp": Timestamp(date: Date())] as [String:Any]
            Firestore.firestore().collection("classComments").document(course.classID ?? "").collection("comments").addDocument(data: dict)
            if self.comments.count != 0 {
                self.tableView.scrollToRow(at: [0, self.comments.count - 1], at: .bottom, animated: false)
            }
            
    //        tableView.reloadData()
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            listener?.remove()
            NotificationCenter.default.removeObserver(self)
//            homeAltNavBar.userProfileImageView.removeGestureRecognizer(tapGestureRecognizer)
//            reactionListener?.remove()
        }
    }
    
    
    
    
    fileprivate lazy var laughButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = lightYellow
        button.setTitle("😄", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        button.addTarget(self, action: #selector(handleTapEmoji), for: .touchUpInside)
        button.layer.cornerRadius = 87 / 2

        return button
    }()
    fileprivate lazy var smileButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = lightYellow
        button.setTitle("😲", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        button.layer.cornerRadius = 87 / 2

        button.addTarget(self, action: #selector(handleTapEmoji), for: .touchUpInside)
        return button
    }()
    fileprivate lazy var sadButton: EmojiButton = {
        let button = EmojiButton(type: .system)
        button.backgroundColor = lightYellow
        button.setTitle("🤔", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        button.layer.cornerRadius = 87 / 2
        button.addTarget(self, action: #selector(handleTapEmoji), for: .touchUpInside)
        return button
    }()
    
    fileprivate func sendReaction() {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        let dict = ["uid": currentUID, "reactionID": reactionID, "previousReactionID": previousReactionID] as [String:Any]
        
        Firestore.firestore().collection("classReactions").document(course.classID ?? "").collection("reactions").document(currentUID).getDocument { (snapshot, err) in
            if let err = err {
                print(err)
                return
            }
            if snapshot?.exists == true {
                Firestore.firestore().collection("classReactions").document(self.course.classID ?? "").collection("reactions").document(currentUID).updateData(dict)
            } else {
                Firestore.firestore().collection("classReactions").document(self.course.classID ?? "").collection("reactions").document(currentUID).setData(dict)
            }
        }
    }
    
    var previousReactionID: Double = -1
    var reactionID : Double = -1
    
    @objc fileprivate func handleTapEmoji(button: UIButton) {
        switch button {
        case laughButton:
            if laughButton.backgroundColor == lightYellow {
                laughButton.backgroundColor = UIColor.rgb(red: 253, green: 93, blue: 93)

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
                smileButton.backgroundColor = UIColor.rgb(red: 242, green: 201, blue: 76)
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
                sadButton.backgroundColor = UIColor.rgb(red: 39, green: 174, blue: 96)
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
        laughButton.withWidth(87).withHeight(87),
        smileButton.withSize(CGSize(width: 87, height: 87)),
        sadButton.withSize(CGSize(width: 87, height: 87))
       ])
        sv.axis = .horizontal
        sv.distribution = .equalSpacing
        sv.spacing = 16
        return sv
    }()
    
    
    let emojiIntructionLabel: UILabel = {
//        let l = UILabel(text: "React to lecture", font:  UIFont.boldSystemFont(ofSize: 24), textColor: UIColor.rgb(red: 249, green: 165, blue: 85), textAlignment: .center, numberOfLines: 0)
//        let l = UILabel(text: "React to lecture", font:  UIFont.italicSystemFont(ofSize: 24), textColor: UIColor.rgb(red: 252, green: 108, blue: 111), textAlignment: .center, numberOfLines: 0)
        
        let l = UILabel(text: "React to lecture", font:  UIFont.italicSystemFont(ofSize: 20), textColor: UIColor.purplePink, textAlignment: .center, numberOfLines: 0)


        return l
    }()
    

    
//    let commentInstruction = UILabel(text: "Comments on the materials", font: .systemFont(ofSize: 26), numberOfLines: 0)
    
    lazy var commentTextField : UITextField = {
       let tf = CustomTextField(padding: 16, height: 45)
        tf.placeholder = "Add comment"
        tf.backgroundColor = .white
//        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 20
        tf.layer.borderWidth = 0.3
        tf.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
//        tf.addTarget(self, action: #selector(handleComment), for: .touchDown)
        tf.returnKeyType = .send
        tf.delegate = self
        return tf
    }()
    
    @objc func handleComment() {
//        let commentController = CommentController()
//        commentController.delegate = self
//        navigationController?.pushViewController(commentController, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didSendComment(comment: textField.text ?? "")
        textField.text = nil
        textField.resignFirstResponder()
        return true
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
//                commentInstruction,
                commentTextField,
//                historyCommentInstruction,
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
    
    
    fileprivate let navBarHeight:CGFloat = 120
    
    func didTapProfileImage() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let changeProfileAction = UIAlertAction(title: "Change Profile Image", style: .default) { (_) in
            self.handleChangeProfilePhoto()
        }
        let helpAction = UIAlertAction(title: "Help", style: .default) { (_) in
            self.handleHelp()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(changeProfileAction)
        actionSheet.addAction(helpAction)
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

    
    fileprivate func setupUI() {
        view.backgroundColor = .white
//        view.addSubview(overallStackView)
        tableView.separatorStyle = .none
        
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
        emojiIntructionLabel.anchor(top: homeAltNavBar.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 31, bottom: 0, right: 31), size: .init(width: 0, height: 45))
        
        view.addSubview(emojiStackView)
        emojiStackView.anchor(top: emojiIntructionLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 44, bottom: 0, right: 44))
        
//        view.addSubview(helpLabel)
//        helpLabel.anchor(top: emojiStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        
//        view.addSubview(commentInstruction)
//        commentInstruction.anchor(top: emojiStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        
 
        
//        view.addSubview(historyCommentInstruction)
//        historyCommentInstruction.anchor(top: commentTextField.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16),size: .init(width: 0, height: 50))
        
        view.addSubview(tableView)
        tableView.anchor(top: emojiStackView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 43, left: 31, bottom: 0, right: 31))
        
        
        view.addSubview(commentTextField)
        commentTextField.anchor(top: tableView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 30, left: 32, bottom: 0, right: 32), size: .init(width: 0, height: 45))
        
        
        view.addSubview(viewFullButton)
        viewFullButton.anchor(top: commentTextField.bottomAnchor, leading: nil, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 8, left: 16, bottom: 8, right: 16), size: .init(width: 180, height: 30))
        
        
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
    
    
    fileprivate lazy var homeAltNavBar = HomeAltNavBar(className: course.className ?? "", profileUrl: userProfileUrl )
    
//    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.withBorder(width: 2, color: UIColor.init(white: 0, alpha: 0.1))
        tableView.layer.cornerRadius = 10
        
//        navigationItem.title = course.className
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Help", style: .plain, target: self, action: #selector(handleHelp))
        
        setupUI()
        setupTapGesture()
        
        fetchComments(classID: course.classID ?? "")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        

        homeAltNavBar.backButton.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        
//        fetchComments()
    }
    
    
    @objc func handleBack() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.popViewController(animated: true)
    }
    
    

    
    
    
    @objc fileprivate func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
          self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc fileprivate func keyboardWillHide(notification: NSNotification) {
          self.view.frame.origin.y = 0
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
        
        var foreGroundColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
        
        if let uid = Auth.auth().currentUser?.uid {
            if comments[indexPath.row].fromId == uid {
                foreGroundColor = UIColor(red: 0.922, green: 0.341, blue: 0.341, alpha: 1)
            } else {
                foreGroundColor = UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
            }
        }
        
        let attiText = NSMutableAttributedString(string: timeString, attributes: [.foregroundColor : foreGroundColor, .font: UIFont.systemFont(ofSize: 17)])
        attiText.append(NSMutableAttributedString(string: "   \(comment.text)" , attributes: [.font: UIFont.systemFont(ofSize: 17)]))
        cell.textLabel?.attributedText = attiText
        cell.textLabel?.numberOfLines = 0
        


        return cell
    }
    
    let upimageHud = JGProgressHUD(style: .dark)

    
    
    
    
}


extension HomeAltController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    
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


//
//  AddClassTableViewController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/2/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit
import Firebase

class AddClassCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ClassSearchControllerDelegate, UINavigationControllerDelegate, LoginControllerDelegate, AddClassCellDelegate {

    let cellId = "cellId"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser == nil {
            let registrationController = RegisterController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    var user : User?
    var courses = [Course]()

    
    func didFinishLoggingIn() {
        self.courses = [Course]()
        self.user = nil
        collectionView.reloadData()
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                return
            }
            self.user = user
            let view = UILabel(text: "Hi, \(user?.name ?? "")", font: UIFont.systemFont(ofSize: 26))
            self.navigationItem.titleView = view
            self.collectionView.reloadData()
            self.fetchClasses()

        }
    }
    
    fileprivate func fetchClasses() {
        for classId in user?.classes ?? [String]() {
            Firestore.firestore().collection("classes").document(classId).getDocument { (snapshot, err) in
                if let err = err {
                    return
                }
                guard let dict = snapshot?.data() else {return}
                self.courses.append(Course(dictionary: dict))
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.courses = [Course]()
        self.user = nil
        collectionView.reloadData()
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                return
            }
            self.user = user
            self.fetchClasses()
//            let label = self.navigationItem.titleView as! UILabel
//            label.text = "Hi, \(user?.name)"
            let view = UILabel(text: "Hi, \(user?.name ?? "")", font: UIFont.systemFont(ofSize: 26))
            self.navigationItem.titleView = view

        }
//        collectionView.backgroundColor = UIColor.rgb(red: 254, green: 163, blue: 88)
        collectionView.backgroundColor = .white
        collectionView.register(AddClassCell.self, forCellWithReuseIdentifier: cellId)
        modalPresentationStyle = .fullScreen
        navigationController?.navigationBar.barTintColor = collectionView.backgroundColor
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))


        
//        courses.append(Course(name: "COGS120", prof: "Scott klemmer"))
//        courses.append(Course(name: "DSGN189", prof: "Instructor name"))
        
    }
    
    @objc func handleLogout() {
        try? Auth.auth().signOut() //dont need try catch block if use try?
        let registrationController = RegisterController()
        registrationController.delegate = self
        let navController = UINavigationController(rootViewController: registrationController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return courses.count + 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AddClassCell
        cell.delegate = self
        if indexPath.item == courses.count {
             let attributedText = NSMutableAttributedString(string: "Add Class", attributes: [.font: UIFont.boldSystemFont(ofSize: 36)])
            cell.selectClassLabel.attributedText = attributedText
            cell.moreButton.isHidden = true
        } else {
            cell.course = courses[indexPath.item]
            cell.moreButton.isHidden = false

        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 170)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.item == courses.count {
//            handleAddSearch()
//            return
//        }
//
//        if user?.isStudent == true {
////            let shouldCommentLocationDown = RemoteConfigManager.value(forKey: RCKey.commentLocationDown)
//            let shouldCommentLocationDown = "true"
//            if shouldCommentLocationDown == "false" {
//                let home = HomeController()
//                home.course = courses[indexPath.item]
//                navigationController?.pushViewController(home, animated: true)
//            } else {
//                let home = HomeAltController(course: courses[indexPath.item], userProfileUrl: user?.imageUrl ?? "")
////                home.course = courses[indexPath.item]
//                navigationController?.pushViewController(home, animated: true)
//            }
////            home.barColor =
//            return
//        } else {
//            let home = InstructorHomeController(course: courses[indexPath.item], userProfileUrl: user?.imageUrl ?? "")
////            home.course = courses[indexPath.item]
//            navigationController?.pushViewController(home, animated: true)
//        }
//
//
//    }
    
    func deleteClass(for cell: AddClassCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let reportAction = UIAlertAction(title: "Remove yourself from this class", style: .default) { (_) in
            let courseID = self.courses.remove(at: indexPath.item).classID
            guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
            if let classIndex = self.user?.classes.firstIndex(of: courseID ?? "") {
                self.user?.classes.remove(at: classIndex)
                Firestore.firestore().collection("users").document(currentUID).updateData(["classes": self.user?.classes])
                self.courses = [Course]()
                self.fetchClasses()
            }


//            self.collectionView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        present(actionSheet,animated: true,completion: nil)
    }
    
    func tapClass(for cell: AddClassCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        if indexPath.item == courses.count {
            handleAddSearch()
            return
        }
        if user?.isStudent == true {
            let shouldCommentLocationDown = RemoteConfigManager.value(forKey: RCKey.changeAddCommentLogic)
//            let shouldCommentLocationDown = "true"
            if shouldCommentLocationDown == "false" {
                let home = HomeController()
                home.course = courses[indexPath.item]
                navigationController?.pushViewController(home, animated: true)
            } else {
                let home = HomeAltController(course: courses[indexPath.item], userProfileUrl: user?.imageUrl ?? "")
//                home.course = courses[indexPath.item]
                navigationController?.pushViewController(home, animated: true)
            }
//            home.barColor =
            return
        } else {
            let home = InstructorHomeController(course: courses[indexPath.item], userProfileUrl: user?.imageUrl ?? "")
//            home.course = courses[indexPath.item]
            navigationController?.pushViewController(home, animated: true)
        }
    }
    
    func selectCourse(course: Course) {
        courses.append(course)
        studentAddClassToFireStore(course: course)
        collectionView.reloadData()
    }
    
    
    fileprivate func studentAddClassToFireStore(course: Course) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        user?.classes.append(course.classID ?? "")
        Firestore.firestore().collection("users").document(currentUID).updateData(["classes": user?.classes])
        courses = [Course]()
        fetchClasses()
    }
    
    fileprivate func handleAddSearch() {
        if user?.isStudent == true {
            let classSearchController = ClassSearchController(collectionViewLayout: UICollectionViewFlowLayout())
            classSearchController.alreadyHaveCourses = Set<String>(user?.classes ?? [String]())
            let navController = UINavigationController(rootViewController: classSearchController)
            navController.modalPresentationStyle = .fullScreen
            classSearchController.delegate = self
            present(navController, animated: true, completion: nil)
        } else { //if professor
            let ac = UIAlertController(title: "Enter new Class Info", message: nil, preferredStyle: .alert)
               ac.addTextField { (tf) in
                   tf.placeholder = "Course Name/Number"
                   tf.autocapitalizationType = .allCharacters
               }
               ac.addTextField { (tf) in
                   tf.placeholder = "set up passcode"
                   tf.autocapitalizationType = .words
               }
            
               let addAction = UIAlertAction(title: "Add", style: .default) { [unowned ac] _ in
                let className = ac.textFields![0].text ?? ""
                let code = ac.textFields![1].text ?? ""
                self.instructorAddClassToFireStore(className: className, code: code)
               }
               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
               ac.addAction(addAction)
               ac.addAction(cancelAction)

               present(ac, animated: true)
        }

    }
    
    

    
    fileprivate func instructorAddClassToFireStore(className: String, code: String) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
//        let filename = UUID().uuidString
        var dict = ["className": className, "code": code, "prof": user?.name]
        let docId = Firestore.firestore().collection("classes").addDocument(data: dict).documentID
//        dict["classID"] = docId
        Firestore.firestore().collection("classes").document(docId).updateData(["classID": docId])
        user?.classes.append(docId)
        Firestore.firestore().collection("users").document(currentUID).updateData(["classes": user?.classes])
        courses = [Course]()
        fetchClasses()
    }
    

}

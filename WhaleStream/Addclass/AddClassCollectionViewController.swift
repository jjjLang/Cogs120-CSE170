//
//  AddClassTableViewController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/2/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit
import Firebase

class AddClassCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ClassSearchControllerDelegate, UINavigationControllerDelegate, LoginControllerDelegate {

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
        Firestore.firestore().fetchCurrentUser { (user, err) in
            if let err = err {
                return
            }
            self.user = user
            let view = UILabel(text: "Hi, \(user?.name ?? "")", font: UIFont.systemFont(ofSize: 26))
            self.navigationItem.titleView = view
            self.courses = [Course]()
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
        if indexPath.item == courses.count {

        } else {
            cell.course = courses[indexPath.item]
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == courses.count {
            handleAddSearch()
            return
        }
        
        if user?.isStudent == true {
            let home = HomeController()
//            home.barColor =
            navigationController?.pushViewController(home, animated: true)
            return
        } else {
            let home = InstructorHomeController()
            navigationController?.pushViewController(home, animated: true)
        }


    }
    
    func selectCourse(course: Course) {
        courses.append(course)
        collectionView.reloadData()
    }
    
    fileprivate func handleAddSearch() {
        if user?.isStudent == true {
            let classSearchController = ClassSearchController(collectionViewLayout: UICollectionViewFlowLayout())
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
                   tf.placeholder = "Class Code"
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
        let filename = UUID().uuidString
        let dict = ["className": className, "code": code, "prof": user?.name]
        let docId = Firestore.firestore().collection("classes").addDocument(data: dict).documentID
        user?.classes.append(docId)
        Firestore.firestore().collection("users").document(currentUID).updateData(["classes": user?.classes])
        courses = [Course]()
        fetchClasses()
        
    }
    

}

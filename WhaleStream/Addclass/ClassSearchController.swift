//
//  ClassSearchController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/4/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit
import Firebase


protocol ClassSearchControllerDelegate: UIViewController {
    func selectCourse(course: Course)
}

class ClassSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    weak var delegate: ClassSearchControllerDelegate?
    
    lazy var searchBar: UISearchBar = { //lazy var instead of let is required because self/usersearchcontroller must be instantiated before this variable is defined, else err: Cannot assign value of type '(UserSearchController) -> () -> (UserSearchController)' to type 'UISearchBarDelegate?' when set sb.delegate = self at line 20
        let sb = UISearchBar()
        sb.placeholder = "Enter Class"
        sb.barTintColor = .gray //deosnt do anything
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230) //get the textfeild contained in this class
        
        sb.delegate = self //make sure self exist before accessing it by making searchbar a lazy vairable
        
        return sb
    }()
    
    //delegate is that an event happened, calls the method of the delegate class that shits happened, repond by running the block of code. delegate is part of the company, shoulding off functions to the delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            filteredCourses = courses
        } else {
            filteredCourses = courses.filter { (course) -> Bool in //filter takes in a function that returns a bool as parameter that determines whether to keep it in the result collection
                let lowercaseSearch = searchText.lowercased()
                return course.className?.lowercased().contains(lowercaseSearch) ?? false || course.prof?.lowercased().contains(lowercaseSearch) ?? false
            }
        }
        collectionView.reloadData()
    }

    
    
    let cellId = "cellId"
    let footId = "footId"
    let addCell = "addCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        
        //if missing this line, bug , no leading anscestor
        navigationController?.navigationBar.addSubview(searchBar) //add searchbar to the navigation bar
        
        let navBar = navigationController?.navigationBar
        //was set to true in registraction controller
         navigationController?.isNavigationBarHidden = false
        //anchor searchbar in the navBar
        searchBar.anchor(top: navBar?.topAnchor, leading: navBar?.leadingAnchor, bottom: navBar?.bottomAnchor, trailing: navBar?.trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 0))
        
        view.addSubview(goBackButton)
        goBackButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        

//        collectionView.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footId)
        collectionView.register(ClassSearchCell.self, forCellWithReuseIdentifier: cellId)

        
        collectionView.alwaysBounceVertical = true //bounces when scroll down or up even not enough cells to exceed screen space
        collectionView.keyboardDismissMode = .onDrag //keyboard dismiss whenever drag on view
        
        fetchCourses()
    }
    
    //calls after viewdid load, but will load multiple times everything view shows, viewdidload just load into memory
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder() //dimiss keyboard when push into another view
        
//        if indexPath.item == filteredCourses.count {
//            searchBar.isHidden = false
//            handleAdd()
//            return
//        }
        
        let courseName = filteredCourses[indexPath.item]
        delegate?.selectCourse(course: courseName)
        dismiss(animated: true)
        
        
    }
    
    
    
    var filteredCourses = [Course]()
    var courses = [Course]()
    
    let goBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go Back", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.addTarget(self, action: #selector(handleBack), for: .touchUpInside)
        return button
    }()
    
    @objc fileprivate func handleBack() {
        dismiss(animated: true, completion: nil)
    }
//    var courseNames = ["COGS102B", "COGS102C", "COGS118B", "COGS115", "COGS119", "COGS120", "COGS163", "COGS164", "COGS169", "COGS171", "COGS172", "COGS174", "COGS175", "COGS176", "COGS177", "COGS178", "COGS179", "COGS180", "COGS184",  "COGS120", "COGS121", "COGS153", "COGS160", "COGS189", "COGS199", "PSYC116", "PSYC122", "PSYC123", "PSYC125", "PSYC132", "PSYC133", "PSYC144", "PSYC150", "PSYC159", "PSYC169", "PSYC170", "PSYC171", "PSYC179", "PSYC181", "PSYC189"]
    
    
    
    fileprivate func fetchCourses() {
        
        let query = Firestore.firestore().collection("classes")
        query.getDocuments { (snapshot, err) in
            if let err = err {
//                print(err)
                return
            }
            snapshot?.documents.forEach({ (document) in
                let courseDict = document.data()
                self.courses.append(Course(dictionary: courseDict))
            })
//            self.courses.sort { (cp1, cp2) -> Bool in
//                return cp1.taskAssisted > cp2.taskAssisted
//            }
            self.filteredCourses = self.courses
            self.collectionView.reloadData()

        }
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCourses.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //last cell
//        if indexPath.item == filteredCourses.count {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addCell, for: indexPath) as! CampusAddCell
//            return cell
//        }
//
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ClassSearchCell
        
        cell.course = filteredCourses[indexPath.item]
        return cell
    }
    
    
//    let addButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Be the First to Register your Campus", for: .normal)
//        button.titleLabel?.numberOfLines = 0
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = UIColor.purpleBlue
//        button.layer.opacity = 1
//        button.layer.cornerRadius = 22
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
//        button.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
//        return button
//    }()
//
    
//    @objc fileprivate func handleAdd() {
//        let registerCampusController = RegisterCampusController()
//        registerCampusController.delegate = self
//        present(registerCampusController, animated: true)
////        navigationController?.pushViewController(registerCampusController, animated: true)
//    }
    
//    func didFinishRegisterCampus() {
//        filteredCourses.removeAll()
//        courses.removeAll()
//        fetchCampus()
//        let temp = searchBar.searchTextField.text
//        searchBar.searchTextField.text = ""
//        searchBar.searchTextField.text = temp
//
//    }
    
    //collection view shows rows and not grid because cgsize width is set to view.frame.width
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize(width: view.frame.width, height: 66) //profileimage is 50 + 8 + 8 for padding
     }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return .init(width: view.frame.width, height: 50)
//    }
    
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return .init(width: view.frame.width, height: 66)
//    }
    
    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footId, for: indexPath)
//        footer.addSubview(addButton)
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapDetected))
//        view.addGestureRecognizer(tapGestureRecognizer)
//        addButton.anchor(top: footer.topAnchor, leading: footer.leadingAnchor, bottom: footer.bottomAnchor, trailing: footer.trailingAnchor, padding: .init(top: 8, left: 30, bottom: 8, right: 30))
//        return footer
//    }
//
//    @objc fileprivate func tapDetected(sender: UIGestureRecognizer) {
//        searchBar.endEditing(true)
//    }
    
    deinit {
//        print("campusSearchController self destruct, no retain cyle")
    }
}

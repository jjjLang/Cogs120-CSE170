//
//  AddClassTableViewController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/2/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit

class AddClassCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ClassSearchControllerDelegate, UINavigationControllerDelegate {

    let cellId = "cellId"
    
    var courses = [Course]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.backgroundColor = UIColor.rgb(red: 254, green: 163, blue: 88)
        collectionView.backgroundColor = .white
        collectionView.register(AddClassCell.self, forCellWithReuseIdentifier: cellId)
        modalPresentationStyle = .fullScreen
        navigationController?.navigationBar.barTintColor = collectionView.backgroundColor
        let view = UILabel(text: "Hi, Emily!", font: UIFont.systemFont(ofSize: 26))
        navigationItem.titleView = view
        
        courses.append(Course(name: "COGS120", prof: "Scott klemmer"))
        courses.append(Course(name: "DSGN189", prof: "Instructor name"))
        
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
        let home = HomeController()
        navigationController?.pushViewController(home, animated: true)
    }
    
    func selectCourse(course: Course) {
        courses.append(course)
        collectionView.reloadData()
    }
    
    fileprivate func handleAddSearch() {
        let classSearchController = ClassSearchController(collectionViewLayout: UICollectionViewFlowLayout())
        let navController = UINavigationController(rootViewController: classSearchController)
        navController.modalPresentationStyle = .fullScreen
        classSearchController.delegate = self
        present(navController, animated: true, completion: nil)
    }

}

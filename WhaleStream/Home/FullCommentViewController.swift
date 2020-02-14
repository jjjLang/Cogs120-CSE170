//
//  FullCommentViewController.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/13/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit

class FullCommentViewController: UITableViewController {
    let cellID = "cellID"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    var comments = [String]()
    var commentsTime = [String]()
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! UITableViewCell
        let attiText = NSMutableAttributedString(string: commentsTime[indexPath.row] , attributes: [.foregroundColor : UIColor.blue])
        attiText.append(NSMutableAttributedString(string: " \(comments[indexPath.row])"))
        cell.textLabel?.attributedText = attiText
        cell.textLabel?.numberOfLines = 0
        return cell
    }
}

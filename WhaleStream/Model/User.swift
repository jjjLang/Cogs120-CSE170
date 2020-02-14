//
//  User.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/13/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import Foundation


struct User {
    var name: String?
    var imageUrl: String?
    var uid: String?
    var isStudent: Bool?
    var classes = [String]()
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.isStudent = dictionary["isStudent"] as? Bool ?? true
        self.classes = dictionary["classes"] as? [String] ?? [String]()
    }

}

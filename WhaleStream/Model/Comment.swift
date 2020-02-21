//
//  Comment.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/20/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import Firebase

struct Comment {
    let text, fromId : String
    let timestamp: Timestamp
//    let isUserText: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
//        self.isUserText = Auth.auth().currentUser?.uid == fromId
    }
    
}

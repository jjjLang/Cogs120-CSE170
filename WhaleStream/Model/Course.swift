//
//  Class.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/4/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import Foundation


struct Course {
    var className : String?
    var prof: String?
    var code: String?
    
    init(dictionary: [String: Any]) {
        self.className = dictionary["className"] as? String ?? ""
        self.prof = dictionary["prof"] as? String ?? ""
        self.code = dictionary["code"] as? String ?? ""
    }
}

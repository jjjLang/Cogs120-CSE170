//
//  Bindable.swift
//  Big-n-Little
//
//  Created by wenlong qiu on 12/23/19.
//  Copyright © 2019 wenlong qiu. All rights reserved.
//

import Foundation
class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    //another object changes the value and defines its reaction of the change
    var observer: ((T?) -> ())?
    
    //make sure observer is being called
    func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}

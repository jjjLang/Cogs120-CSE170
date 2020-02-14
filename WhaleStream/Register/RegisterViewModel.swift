//
//  RegisterViewModel.swift
//  WhaleStream
//
//  Created by wenlong qiu on 2/12/20.
//  Copyright © 2020 wenlong qiu. All rights reserved.
//

import UIKit
import Firebase
class RegisterCampusViewModel {
    
    var binadableShowRegisterHUD = Bindable<Bool>()
    
    var bindableEnableRegisterButton = Bindable<Bool>()
    
    var showCampusAlreadyExistsHUD = Bindable<Bool>()
    
    //    var isFormValidObserver: ((Bool) -> ())?
    
    //then only need to set the value and reactor
    var bindableImage = Bindable<UIImage>()
    
//    var image: UIImage? {
//        didSet {
//            imageObserver?(image)
//        }
//    }
//    //observe variable change in viewmodel and reflect in view, variable is image, so thats the input parameter; either have definiton or be optional, else need initializer
//    var imageObserver: ((UIImage?) -> ())?
    
    
    var name: String? {
        didSet { //changes in state triggers action, setup button in view or controller class, should trigger action in UI

            checkRegisterInputValid()
        }
    }
    var email: String? {
        didSet {

            checkRegisterInputValid()
        }
    }
    
    var password: String? {
        didSet {
            checkRegisterInputValid()
        }
    }
    
    var isStudent: Bool? {
        didSet {
            checkRegisterInputValid()
        }
    }
    

    //checks own property, self calls a functor that makes another class do stuff
    func checkRegisterInputValid() {
        let isFormValid = name?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false &&  bindableImage.value != nil
        bindableEnableRegisterButton.value = isFormValid
    }
    
    
    func register(completion: @escaping (Error?) -> ()) {
        
        binadableShowRegisterHUD.value = true //reactor already settted up in another class, calls reactor in bindable
        guard let name = name, let email = email, let pass = password else {return}
        
        Auth.auth().createUser(withEmail: email, password: pass) { (result, err) in
            if let err = err {
                completion(err)
                return
            }
            self.storeProfileImageFirebaseStorage(userId: result?.user.uid ?? "", completion: completion)
        }
        
    }
    
   
    
    fileprivate func storeProfileImageFirebaseStorage(userId: String, completion: @escaping (Error?) -> ()) {
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            if let err = err {
                completion(err)
                return
            }
//            print("uploaded image to storage")
            _ = ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                self.binadableShowRegisterHUD.value = false
                
                let imageUrl = url?.absoluteString ?? ""
                self.saveRegisterDataFirestore(imageUrl: imageUrl, completion: completion)
            })
        })
    }
    
    fileprivate func saveRegisterDataFirestore(imageUrl: String,completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        guard var name = name else {return}
        if name.last == " " {
            name.removeLast()
        }
        let data : [String: Any] = [
                                    "imageUrl": imageUrl,
                                    "name": name,
                                    "uid": uid,
                                    "isStudent": isStudent ?? true
        ]
        Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
    }

}

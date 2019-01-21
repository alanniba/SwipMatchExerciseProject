//
//  RegistrationViewModel.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/7.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit
import Firebase
class RegistrationViewModel{
    
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var fullName : String?{didSet{checkFormValidity()}}
    var email: String?{didSet{checkFormValidity()}}
    var password: String?{didSet{checkFormValidity()}}
    
    func checkFormValidity(){
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        
        bindableIsFormValid.value = isFormValid
    }

    var bindableIsFormValid = Bindable<Bool>()
    
    func proformRegistration(completion : @escaping (Error?) -> ()){
        guard let email = self.email else {return}
        guard let password = self.password else {return}
        bindableIsRegistering.value = true

        Auth.auth().createUser(withEmail: email, password: password) {  (res, err) in
            if let err = err{
                completion(err)
                return
            }
            self.saveImageToFireBase(completion: completion)
        }
    }
    

    
    fileprivate func saveImageToFireBase(completion : @escaping (Error?)->()){
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            if let err = err {
                completion(err)
                return
            }
            print("finished uploading image to storage")
            ref.downloadURL(completion: { (url, err) in
                if let err = err{
                    completion(err)
                    return
                }
                self.bindableIsRegistering.value = false
                print(url?.absoluteURL ?? "")
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl : String ,completion:@escaping (Error?) ->()){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData : [String : Any] = [
            "fullName":fullName ?? "",
            "uid": uid ,
            "imageUrl1": imageUrl,
            "age" : 18,
            "minSeekingAge" : 18,
            "maxSeekingAge" : 50
        ]
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err{
                completion(err)
                return
            }
            completion(nil)
        }
    }
}

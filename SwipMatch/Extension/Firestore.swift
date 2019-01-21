//
//  Firestore.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/22.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import Firebase

extension Firestore{
    func fetchCurrentUser(completion: @escaping (User? , Error?) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { (snapShot, err) in
            if let err = err {
                print(err)
                return
            }
            
            guard let dic = snapShot?.data() else {return}
            let user = User(dictionary: dic)
            completion(user, nil)

        }
        
    }
}

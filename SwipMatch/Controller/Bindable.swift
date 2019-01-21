//
//  Bindable.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/9.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import Foundation


class Bindable<T>{
    var value : T?{
        didSet{
            observer?(value)
        }
    }
    var observer: ((T?) ->())?
    func bind(observer: @escaping (T?) -> ()){
        self.observer = observer
    }
}

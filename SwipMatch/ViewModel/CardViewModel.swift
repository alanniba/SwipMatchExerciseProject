//
//  CardViewModel.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/4.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel {
    // we'll define the properties that are view will display/render out
    let uid : String
    let imageUrls : [String]
    let attributedString : NSAttributedString
    let textAlignment : NSTextAlignment
    init(uid : String ,imageNames : [String], attributedString : NSAttributedString , textAlignment : NSTextAlignment) {
        self.uid = uid
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAlignment = textAlignment
    }
    fileprivate var index = 0{
        didSet{
            let imageUrl = imageUrls[index]
            imageIndexObserver?( index , imageUrl)
        }
    }
    
    //reactive programming
    var imageIndexObserver: (( Int , String?) -> ())?
    
    
    func toNextPhoto(){
        index = min(index + 1 , imageUrls.count - 1)
    }
    func toLastPhoto(){
        index = max( 0 , index - 1)
    }
}

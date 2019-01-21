//
//  Advertiser.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/4.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

struct Advertiser : ProducesCardViewModel {
    let title : String
    let brandName : String
    let posterPhotoName : String
    
    func toCardViewModel() -> CardViewModel{
        let attributeString = NSMutableAttributedString(string: title , attributes : [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributeString.append(NSAttributedString(string: "\n\(brandName)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        return CardViewModel(uid: "" ,imageNames: [posterPhotoName], attributedString: attributeString, textAlignment: .center)

    }
}

//
//  User.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/4.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

struct User : ProducesCardViewModel {
    //defining our properties for our model layer
    var name : String?
    var age : Int?
    var profession : String?
    var uid : String?
    var imageUrl1 : String?
    var imageUrl2 : String?
    var imageUrl3 : String?

    var minSeekingAge : Int?
    var maxSeekingAge : Int?
    
    init(dictionary : [String : Any]) {
        let name = dictionary["fullName"] as? String ?? ""
        self.name = name
        
        let imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.imageUrl1 = imageUrl1
        
        let imageUrl2 = dictionary["imageUrl2"] as? String ?? ""
        self.imageUrl2 = imageUrl2

        
        let imageUrl3 = dictionary["imageUrl3"] as? String ?? ""
        self.imageUrl3 = imageUrl3


        let uid = dictionary["uid"] as? String ?? ""
        self.uid = uid

        self.age = dictionary["age"] as? Int ?? 0
        self.profession = dictionary["profession"] as? String ?? ""
        
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int ?? -1
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int ?? -1
    }
    
    func toCardViewModel () -> CardViewModel{
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "Unknow"
        attributedText.append(NSAttributedString(string: " \(ageString)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionString = profession != nil ? profession! : "Unknow"
        attributedText.append(NSAttributedString(string: " \n\(professionString)", attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        var imageArray = [String]()
        if let url = imageUrl1 {imageArray.append(url)}
        if let url = imageUrl2 {imageArray.append(url)}
        if let url = imageUrl3 {imageArray.append(url)}
        
        return CardViewModel( uid: self.uid ?? "" , imageNames: imageArray, attributedString: attributedText, textAlignment: .left)

    }
}


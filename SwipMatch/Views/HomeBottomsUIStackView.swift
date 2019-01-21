//
//  HomeBottomsUIStackView.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/11/29.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

class HomeBottomsUIStackView: UIStackView {

    static func createButton(image: UIImage) -> UIButton{
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }

    let refreshButton = createButton(image: #imageLiteral(resourceName: "Image"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "Image-1"))
    let superlikeButton = createButton(image: #imageLiteral(resourceName: "Image-2"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "Image-3"))
    let spicialButton = createButton(image: #imageLiteral(resourceName: "Image-4"))

    override init(frame: CGRect) {
        super.init(frame: frame)
        

        [refreshButton , dislikeButton , superlikeButton , likeButton , spicialButton].forEach { (v) in
            addArrangedSubview(v)
        }
        
        self.distribution = .fillEqually
        self.axis = .horizontal
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

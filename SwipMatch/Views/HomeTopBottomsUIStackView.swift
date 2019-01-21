//
//  HomeTopBottomsUIStackView.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/11/29.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

class HomeTopBottomsUIStackView: UIStackView {

    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    
    var fireImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        settingsButton.setImage(UIImage(named: "Image-5")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(named: "Image-7")?.withRenderingMode(.alwaysOriginal), for: .normal)
        fireImageView.image = UIImage(named: "Image-6")
        fireImageView.contentMode = .scaleAspectFit

        
        [settingsButton ,fireImageView , messageButton ].forEach { (button) in
            addArrangedSubview(button)
        }
        
        self.distribution = .equalCentering
        self.axis = .horizontal
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 28, bottom: 0, right: 28)
        isLayoutMarginsRelativeArrangement = true
        heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

//
//  AgeRangeTableViewCell.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/20.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

class AgeRangeTableViewCell: UITableViewCell {

    let minSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 80
        return slider
    }()
    let maxSlider : UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 80
        return slider
    }()
    
    let minLabb : UILabel = {
        let lab = AgeRangeLabel()
        lab.text = "minimum"
        return lab
    }()
    
    let maxLab : UILabel = {
        let lab = AgeRangeLabel()
        lab.text = "maxinum"
        return lab
    }()
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize{
            return .init(width: 80, height: 0)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let sliderStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews:[minLabb , minSlider] ) ,
            UIStackView(arrangedSubviews: [maxLab , maxSlider] )
            ])
        sliderStackView.axis = .vertical
        sliderStackView.spacing = 15
        addSubview(sliderStackView)
        sliderStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 12, bottom: 8, right: 12))
        

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

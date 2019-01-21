//
//  CustomTextField.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/6.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    
    let padding : Int
//    let height: CGFloat
    init(padding : Int){
        self.padding = padding
//        self.height = height
        super.init(frame : .zero)
        layer.cornerRadius = 25
        backgroundColor = .white
    }
    
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: CGFloat(padding), dy: 0)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: CGFloat(padding), dy: 0)
    }
    override var intrinsicContentSize: CGSize{
        return .init(width: 0, height: 50)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

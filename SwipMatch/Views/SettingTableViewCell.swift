//
//  SettingTableViewCell.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2018/12/12.
//  Copyright © 2018 haoyuan tan. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    class SettingTextField: UITextField {
        override var intrinsicContentSize: CGSize{
            return .init(width: 0, height: 44)
        }
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
    }
    
    
    
    let textField : UITextField = {
        let tf = SettingTextField()
        tf.placeholder = "Enter name"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

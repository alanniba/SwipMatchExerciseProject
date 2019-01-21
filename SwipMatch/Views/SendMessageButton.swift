//
//  SendMessageButton.swift
//  SwipMatch
//
//  Created by haoyuan tan on 2019/1/15.
//  Copyright © 2019 haoyuan tan. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {


    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.9870426059, green: 0.1387707293, blue: 0.4519075751, alpha: 1).cgColor
        let rightColor = #colorLiteral(red: 0.9215686275, green: 0.4392156863, blue: 0.3450980392, alpha: 1).cgColor
        gradientLayer.colors = [leftColor , rightColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        gradientLayer.frame = rect
    }

}

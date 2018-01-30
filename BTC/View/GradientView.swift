//
//  GradientView.swift
//  BTC
//
//  Created by Jairo Bambang Oetomo on 28-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class GradientView: UIView {

    var gradientColor1 = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    var gradientColor2 = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    private let gradientLayer = CAGradientLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        gradientLayer.frame = bounds.insetBy(dx: -100, dy: -100)
        gradientLayer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
        layer.addSublayer(gradientLayer)
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds.insetBy(dx: -100, dy: -100)
    }
    
}

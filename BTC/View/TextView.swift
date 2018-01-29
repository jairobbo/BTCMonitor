//
//  TextView.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 29-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class TextView: GradientControl {
    
    let label = UILabel()
    
    func setText(text: String) {
        label.text = text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textColor = .white
        label.textAlignment = .center
        addSubview(label)
    }
    
}
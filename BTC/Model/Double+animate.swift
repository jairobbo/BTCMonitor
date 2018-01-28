//
//  ValueAnimator.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 28-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

extension Double {
    
    mutating func animate(duration: TimeInterval, startValue: Double, endValue: Double) {
        
        self = startValue
        let delta = (endValue - startValue) / duration * 60
        
    }
}

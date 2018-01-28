//
//  AnimatedLayer.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 28-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class AnimatedLayer: CALayer, Animated {
    var fractionComplete: Double = 1 {
        didSet {
            update()
        }
    }
    var update: () -> Void = {}
    
    func animate(duration: TimeInterval) {
        fractionComplete = 0
        let delta = 1/(duration * 60)
        let timer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { (timer) in
            self.fractionComplete += delta
            if self.fractionComplete >= 1 {
                self.fractionComplete = 1
                timer.invalidate()
            }
        }
        timer.fire()
    }
}

protocol Animated {
    var fractionComplete: Double { get set }
    func animate(duration: TimeInterval)
}

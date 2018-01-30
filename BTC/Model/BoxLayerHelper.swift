//
//  BoxLayerHelper.swift
//  BTC
//
//  Created by Jairo Bambang Oetomo on 30-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class BoxLayerHelper {
    
    func createTitleLayer(text: String, fontSize: CGFloat) -> AnimatedLayer {
        let animatedLayer = AnimatedLayer()
        animatedLayer.frame = CGRect(x: 0, y: 0, width: 400, height: 50)
        let textLayer = CATextLayer()
        textLayer.frame = animatedLayer.bounds
        textLayer.font = UIFont(name: "Arial", size: 20)
        textLayer.fontSize = fontSize
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.string = text
        textLayer.contentsScale = UIScreen.main.scale
        animatedLayer.addSublayer(textLayer)
        animatedLayer.update = {
            textLayer.opacity = Float(animatedLayer.fractionComplete)
        }
        return animatedLayer
    }
    
}

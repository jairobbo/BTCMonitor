//
//  Protocols.swift
//  BTC
//
//  Created by Jairo Bambang Oetomo on 30-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit




@objc protocol Animations {
    @objc optional func animateBirth(duration: TimeInterval, delay: TimeInterval, completion: ((Bool)->Void)? )
}

extension Animations where Self:UIView {
    func animateBirth(duration: TimeInterval, delay: TimeInterval, completion: ((Bool)->Void)? ) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.alpha = 1
        }, completion: completion)
    }
    
    func animateConstraints(duration: TimeInterval, delay: TimeInterval, view: UIView, widthCstr: NSLayoutConstraint, width: CGFloat,  heightCstr: NSLayoutConstraint, height: CGFloat, completion: ((Bool)->Void)?) {
        view.updateConstraintsIfNeeded()
        widthCstr.constant = width
        heightCstr.constant = height
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.25, options: [], animations: {
            view.layoutIfNeeded()
        }, completion: completion)
    }
}


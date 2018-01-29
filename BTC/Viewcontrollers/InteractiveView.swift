//
//  BTCGraphView.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 26-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class InteractiveView: GradientControl {
    
    var contentView = UIView()
    private var blurView = UIVisualEffectView()
    var hudViewContainer = UIView()
    
    var touch: UITouch = UITouch()
    
    private var blurAnimator = UIViewPropertyAnimator()
    private var hudAnimator = UIViewPropertyAnimator()
    
    let activityIndicator: UIActivityIndicatorView = {
        let act = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        act.hidesWhenStopped = true
        return act
    }()
    
    var inset: CGFloat = 30 // be carefull, also change in DrawLayer!
    
    private var is3DTouchAvailable: Bool {
        return traitCollection.forceTouchCapability == .available
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = bounds
        addSubview(contentView)
        
        activityIndicator.frame = CGRect(x: 0, y: 0, width: bounds.width / 3, height: bounds.width / 3)
        activityIndicator.center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        
        blurView.frame = bounds
        blurView.effect = nil
        blurView.isHidden = true
        addSubview(blurView)
        
        hudViewContainer.frame = bounds
        hudViewContainer.alpha = 0
        addSubview(hudViewContainer)
        
        blurAnimator = UIViewPropertyAnimator(duration: Double.greatestFiniteMagnitude, curve: .easeOut, animations: {
            self.blurView.effect = UIBlurEffect(style: .regular)
            self.hudViewContainer.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        blurAnimator.isInterruptible = true
        
        hudAnimator = UIViewPropertyAnimator(duration: Double.greatestFiniteMagnitude, curve: .easeIn, animations: {
            self.hudViewContainer.alpha = 1
        })
        hudAnimator.isInterruptible = true
        
        blurAnimator.startAnimation()
        hudAnimator.startAnimation()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            handleTouchesMoved(touch: touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        hudViewContainer.isHidden = true
        blurView.isHidden = true
    }
    
    func handleTouchesMoved(touch: UITouch) {
        hudViewContainer.isHidden = false
        blurView.isHidden = false
        
        if is3DTouchAvailable {
            let maximumForce = touch.maximumPossibleForce
            let force = touch.force
            
            blurAnimator.fractionComplete = (force / maximumForce)
            hudAnimator.fractionComplete = (force / maximumForce) * 5
        } else {
            hudViewContainer.alpha = 1
            blurView.effect = UIBlurEffect(style: .regular)
        }
        
        self.touch = touch
        
        sendActions(for: .editingChanged)
        
    }
    
}



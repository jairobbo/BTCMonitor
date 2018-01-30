//
//  BTCGraphView.swift
//  BTC
//
//  Created by Jairo Bambang Oetomo on 26-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class InteractiveView: UIControl, Animations {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var hudContainerView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var touch: UITouch = UITouch()
    
    private var blurAnimator = UIViewPropertyAnimator()
    private var hudAnimator = UIViewPropertyAnimator()
    
    var inset: CGFloat = 30 // be carefull, also change in DrawLayer!
    
    private var is3DTouchAvailable: Bool {
        return traitCollection.forceTouchCapability == .available
    }
    private var nibName = "InteractiveView"
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        layer.cornerRadius = 20
        layer.masksToBounds = true
        
        blurView.effect = nil
        blurView.isHidden = true
        
        hudContainerView.alpha = 0
        
        blurAnimator = UIViewPropertyAnimator(duration: Double.greatestFiniteMagnitude, curve: .easeOut, animations: {
            self.blurView.effect = UIBlurEffect(style: .regular)
            self.hudContainerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        blurAnimator.isInterruptible = true
        
        hudAnimator = UIViewPropertyAnimator(duration: Double.greatestFiniteMagnitude, curve: .easeIn, animations: {
            self.hudContainerView.alpha = 1
        })
        hudAnimator.isInterruptible = true
        
        blurAnimator.startAnimation()
        blurAnimator.pauseAnimation()
        hudAnimator.startAnimation()
        hudAnimator.pauseAnimation()
        
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            handleTouchesMoved(touch: touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        hudContainerView.isHidden = true
        blurView.isHidden = true
    }
    
    private func handleTouchesMoved(touch: UITouch) {
        hudContainerView.isHidden = false
        blurView.isHidden = false
        
        if is3DTouchAvailable {
            let maximumForce = touch.maximumPossibleForce
            let force = touch.force
            
            blurAnimator.fractionComplete = (force / maximumForce)
            hudAnimator.fractionComplete = (force / maximumForce) * 5
        } else {
            hudContainerView.alpha = 1
            blurView.effect = UIBlurEffect(style: .regular)
        }
        
        self.touch = touch
        
        sendActions(for: .editingChanged)
        
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}



//
//  BTCGraphView.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 26-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class GraphView: UIView {
    
    private var model: GraphModel?
    private var drawLayer: DrawLayer?
    
    private var blurView = UIVisualEffectView()
    private var hudView: HUDView?
    private var blurAnimator = UIViewPropertyAnimator()
    private var hudAnimator = UIViewPropertyAnimator()
    
    var graphLayer = AnimatedLayer()
    var axisXLayer = CALayer()
    var axisYLayer = CALayer()
    
    var gradientColor1 = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    var gradientColor2 = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
    
    var inset: CGFloat = 30
    
    var is3DTouchAvailable: Bool {
        return traitCollection.forceTouchCapability == .available
    }
    
    
    init(frame: CGRect, model: GraphModel) {
        super.init(frame: frame)
        self.model = model
        
        addGraphLayers()
        
        blurView.frame = bounds
        blurView.effect = nil
        blurView.isHidden = true
        addSubview(blurView)
        
        hudView = HUDView(frame: bounds, model: model)
        hudView?.alpha = 0
        addSubview(hudView!)
        
        blurAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeOut, animations: {
            self.blurView.effect = UIBlurEffect(style: .regular)
            self.hudView?.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        hudAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeIn, animations: {
            self.hudView?.alpha = 1
        })
        
        graphLayer.animate(duration: 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addGraphLayers() {
        self.drawLayer = DrawLayer(bounds: bounds)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [gradientColor1.cgColor, gradientColor2.cgColor]
        layer.addSublayer(gradientLayer)
        graphLayer = drawLayer!.drawGraphLayer(data: model!.graphData, lineWidth: 1)
        layer.addSublayer(graphLayer)
        axisXLayer = drawLayer!.drawXAxisLayer(data: model!.axisXData)
        layer.addSublayer(axisXLayer)
        axisYLayer = drawLayer!.drawYAxisLayer(data: model!.axisYData)
        layer.addSublayer(axisYLayer)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            handleTouchesMoved(touch: touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        hudView?.isHidden = true
        blurView.isHidden = true
    }
    
    func handleTouchesMoved(touch: UITouch) {
        hudView?.isHidden = false
        blurView.isHidden = false
        
        if is3DTouchAvailable {
            let maximumForce = touch.maximumPossibleForce
            let force = touch.force
            blurAnimator.fractionComplete = (force / maximumForce)
            hudAnimator.fractionComplete = (force / maximumForce) * 5
        } else {
            hudView?.alpha = 1
            blurView.effect = UIBlurEffect(style: .regular)
        }
        
        
        let point = touch.location(in: self)
        let relativeXPostition: CGFloat = (point.x - 1/2 * inset) / (bounds.width - 2 * inset)
        let index = max(0, min(Int(relativeXPostition * CGFloat(model?.graphData.count ?? 0)) , model!.graphData.count - 1))
        let yPos = bounds.insetBy(dx: inset, dy: inset).height - bounds.insetBy(dx: inset, dy: inset).height * CGFloat(model?.graphData[index].relativeYPosition ?? 0)
        let relativeYPosition: CGFloat = (yPos + inset * 2/3)/bounds.height
        
        hudView?.actionCoordinate = (point.x/bounds.width, relativeYPosition)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.currencySymbol = "$"
        numberFormatter.numberStyle = .currency
        let amountNumber = NSNumber(value: model?.rawData[index].value ?? 0)
        hudView?.currentAmount = numberFormatter.string(from: amountNumber) ?? ""
    }
    
}



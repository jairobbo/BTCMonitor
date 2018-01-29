//
//  HUDView.swift
//  BTC
//
//  Created by Jairo Bambang Oetomo on 27-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class HUDView: UIView {
    
    private var model: GraphModel?
    private var drawLayer: GraphLayerHelper?
    
    private var graphLineLayer = CALayer()
    private var graphicLayer: CAShapeLayer = {
        let graphicLayer = CAShapeLayer()
        graphicLayer.lineWidth = 0.25
        graphicLayer.strokeColor = UIColor.white.cgColor
        graphicLayer.fillColor = UIColor.white.cgColor
        return graphicLayer
    }()
    private var amountTextLayer = CATextLayer()
    
    private var interactionPoint = CGPoint() {
        didSet {
            updateHUD()
        }
    }
    private var currentAmountString = ""
    
    var inset: CGFloat = 30

    init(frame: CGRect, model: GraphModel) {
        super.init(frame: frame)
        self.model = model
        drawLayer = GraphLayerHelper(bounds: bounds)
        graphLineLayer = drawLayer!.drawGraphLayer(data: model.graphData, lineWidth: 2)
        graphicLayer.frame = bounds
        updateHUD()
        amountTextLayer.frame = bounds.insetBy(dx: 40, dy: 40)
        amountTextLayer.font = UIFont(name: "Helvetica", size: 10)
        amountTextLayer.fontSize = 24
        amountTextLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(amountTextLayer)
        layer.addSublayer(graphicLayer)
        layer.addSublayer(graphLineLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func interact(control: InteractiveView) {
        
        let point = control.touch.location(in: self)
        let relativeXPostition: CGFloat = (point.x - 1/2 * inset) / (bounds.width - 2 * inset)
        let index = max(0, min(Int(relativeXPostition * CGFloat(model?.graphData.count ?? 0)), model!.graphData.count - 1))
        let yPos = bounds.insetBy(dx: inset, dy: inset).height - bounds.insetBy(dx: inset, dy: inset).height * CGFloat(model?.graphData[index].relativeYPosition ?? 0)
        let relativeYPosition: CGFloat = (yPos + inset * 2/3)/bounds.height
        
        interactionPoint = CGPoint(x: point.x/bounds.width, y: relativeYPosition)
        
        let numberFormatter = NumberFormatter()
        numberFormatter.currencySymbol = "$"
        numberFormatter.numberStyle = .currency
        let amountNumber = NSNumber(value: model?.rawData[index].value ?? 0)
        currentAmountString = numberFormatter.string(from: amountNumber) ?? ""
    }
    
    private func updateHUD() {
        graphicLayer.path = drawPath().cgPath
        amountTextLayer.string = currentAmountString
    }
    
    private func drawPath() -> UIBezierPath {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: interactionPoint.x * bounds.width, y: 0))
        linePath.addLine(to: CGPoint(x: interactionPoint.x * bounds.width, y: bounds.height))
        let point = CGPoint(x: interactionPoint.x * bounds.width, y: interactionPoint.y * bounds.height)
        let circlePath = UIBezierPath(arcCenter: point, radius: 4, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        linePath.append(circlePath)
        return linePath
    }
}

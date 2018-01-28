//
//  HUDView.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 27-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class HUDView: UIView {
    
    var drawLayer: DrawLayer?
    
    var graphLineLayer = CALayer()
    var graphicLayer = CAShapeLayer()
    var amountTextLayer = CATextLayer()
    var actionCoordinate: (CGFloat, CGFloat) = (0.5, 0.5) {
        didSet {
            updateGraphics()
        }
    }
    var currentAmount = ""

    init(frame: CGRect, model: GraphModel) {
        super.init(frame: frame)
        drawLayer = DrawLayer(bounds: bounds)
        graphLineLayer = drawLayer!.drawGraphLayer(data: model.graphData, lineWidth: 2)
        graphicLayer.frame = bounds
        updateGraphics()
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
    
    func updateGraphics() {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: actionCoordinate.0 * bounds.width, y: 0))
        linePath.addLine(to: CGPoint(x: actionCoordinate.0 * bounds.width, y: bounds.height))
        let point = CGPoint(x: actionCoordinate.0 * bounds.width, y: actionCoordinate.1 * bounds.height)
        let circlePath = UIBezierPath(arcCenter: point, radius: 4, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        linePath.append(circlePath)
        graphicLayer.path = linePath.cgPath
        graphicLayer.lineWidth = 0.5
        graphicLayer.strokeColor = UIColor.white.cgColor
        graphicLayer.fillColor = UIColor.white.cgColor
        amountTextLayer.string = currentAmount
    }
    
    
}

//
//  DrawLayer.swift
//  BTC
//
//  Created by Jairo Bambang Oetomo on 27-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class GraphLayerHelper {
    
    private enum Axis {
        case x
        case y
    }
    
    private var inset: CGFloat = 30
    private var axisLineWidth: CGFloat = 1
    private var axisLineLength: CGFloat = 5
    private var xLabelsYOffset: CGFloat = 8
    private var xLabelsFontSize: CGFloat = 11
    private var yLabelXOffset: CGFloat = 6
    private var yLabelsFontSize: CGFloat = 10
    
    private var foregroundColor: UIColor = .white
    
    private var bounds: CGRect
    
    init(bounds: CGRect) {
        self.bounds = bounds
    }
    
    func drawGraphLayer(data: GraphData, lineWidth: CGFloat) -> AnimatedLayer {
        
        func convertPoint(point: (Double, Double)) -> CGPoint {
            return CGPoint(x: bounds.insetBy(dx: inset, dy: inset).width * CGFloat(point.0), y: bounds.insetBy(dx: inset, dy: inset).height - bounds.insetBy(dx: inset, dy: inset).height * CGFloat(point.1))
        }
        let parentLayer = AnimatedLayer()
        parentLayer.frame = bounds.insetBy(dx: inset, dy: inset).applying(CGAffineTransform(translationX: -inset/2, y: -inset/3))
        let graphLayer = CAShapeLayer()
        graphLayer.frame = parentLayer.bounds
        parentLayer.addSublayer(graphLayer)
        let graphPath = UIBezierPath()
        graphPath.lineJoinStyle = .round
        graphPath.move(to: convertPoint(point: data[0]))
        for i in 1..<data.count {
            graphPath.addLine(to: convertPoint(point: data[i]))
        }
        graphLayer.path = graphPath.cgPath
        graphLayer.strokeColor = foregroundColor.cgColor
        graphLayer.lineWidth = lineWidth
        graphLayer.fillColor = UIColor.clear.cgColor
        graphLayer.strokeEnd = 1
        parentLayer.update = {
            graphLayer.strokeEnd = CGFloat(parentLayer.fractionComplete)
        }
        return parentLayer
    }
    
    
    func drawXAxisLayer(data: AxisData) -> AnimatedLayer {
        let xAxisLayer = AnimatedLayer()
        xAxisLayer.frame = bounds.applying(CGAffineTransform(translationX: -inset/2, y: -inset/3))
        let xAxisLinesLayer = drawLinesLayer(data: data, axis: .x)
        xAxisLayer.addSublayer(xAxisLinesLayer)
        let xAxisLabelLayer = labelsX(data: data)
        xAxisLayer.addSublayer(xAxisLabelLayer)
        xAxisLayer.update = {
            xAxisLinesLayer.opacity = Float(xAxisLayer.fractionComplete)
            xAxisLabelLayer.opacity = Float(xAxisLayer.fractionComplete)
        }
        return xAxisLayer
        
    }
    
    func drawYAxisLayer(data: AxisData) -> AnimatedLayer {
        let axisYLayer = AnimatedLayer()
        axisYLayer.frame = bounds.applying(CGAffineTransform(translationX: -inset/2, y: -inset/3))
        let axisYLinesLayer = drawLinesLayer(data: data, axis: .y)
        axisYLayer.addSublayer(axisYLinesLayer)
        let axisYLabelLayer = labelsY(data: data)
        axisYLayer.addSublayer(axisYLabelLayer)
        axisYLayer.update = {
            axisYLinesLayer.opacity = Float(axisYLayer.fractionComplete)
            axisYLabelLayer.opacity = Float(axisYLayer.fractionComplete)
        }
        return axisYLayer
    }
    
    private func labelsY(data: AxisData) -> CALayer {
        let layer = CALayer()
        layer.frame = bounds
        for entry in data {
            let labelLayer = CATextLayer()
            let xPos = bounds.width - inset + yLabelXOffset
            let yPos = bounds.height - inset - CGFloat(entry.relativePosition) * bounds.insetBy(dx: inset, dy: inset).height - yLabelsFontSize * 1.25/2
            labelLayer.frame = CGRect(x: xPos, y: yPos, width: 50, height: 30)
            labelLayer.string = entry.value
            labelLayer.contentsScale = UIScreen.main.scale
            labelLayer.font = UIFont(name: "Helvetica", size: 2)
            labelLayer.fontSize = yLabelsFontSize
            labelLayer.foregroundColor = foregroundColor.cgColor
            layer.addSublayer(labelLayer)
        }
        return layer
    }
    
    private func labelsX(data: AxisData) -> CALayer {
        let layer = CALayer()
        layer.frame = bounds
        for entry in data {
            let labelLayer = CATextLayer()
            let xPos = inset + CGFloat(entry.relativePosition) * bounds.insetBy(dx: inset, dy: inset).width - 4
            let yPos = bounds.height - inset + xLabelsYOffset
            labelLayer.frame = CGRect(x: xPos, y: yPos, width: 25, height: 20)
            labelLayer.transform = CATransform3DMakeRotation(-.pi/3, 0, 0, 1)
            labelLayer.string = entry.value
            labelLayer.alignmentMode = kCAAlignmentRight
            labelLayer.contentsScale = UIScreen.main.scale
            labelLayer.font = UIFont(name: "Helvetica", size: 2)
            labelLayer.fontSize = xLabelsFontSize
            labelLayer.foregroundColor = foregroundColor.cgColor
            layer.addSublayer(labelLayer)
        }
        return layer
    }
    
    private func drawLinesLayer(data: AxisData, axis: Axis) -> CAShapeLayer {
        
        func getStartPoint(relativePosition: Double) -> CGPoint {
            switch axis {
            case .x:
                return CGPoint(x: inset + CGFloat(relativePosition) * bounds.insetBy(dx: inset, dy: inset).width, y: bounds.height - inset - axisLineLength/2)
            case .y:
                return CGPoint(x: inset + bounds.insetBy(dx: inset, dy: inset).width - axisLineLength/2, y: bounds.height - inset - CGFloat(relativePosition) * bounds.insetBy(dx: inset, dy: inset).height)
            }
        }
        
        func getEndPoint(relativePosition: Double) -> CGPoint {
            switch axis {
            case .x:
                return CGPoint(x: inset + CGFloat(relativePosition) * bounds.insetBy(dx: inset, dy: inset).width, y: bounds.height - inset + axisLineLength/2)
            case .y:
                return CGPoint(x: inset + bounds.insetBy(dx: inset, dy: inset).width + axisLineLength/2, y: bounds.height - inset - CGFloat(relativePosition) * bounds.insetBy(dx: inset, dy: inset).height)
            }
        }
        
        let axisLinesLayer = CAShapeLayer()
        axisLinesLayer.frame = bounds
        let path = UIBezierPath()
        for entry in data {
            path.move(to: getStartPoint(relativePosition: entry.relativePosition))
            path.addLine(to: getEndPoint(relativePosition: entry.relativePosition))
        }
        axisLinesLayer.path = path.cgPath
        axisLinesLayer.lineWidth = axisLineWidth
        axisLinesLayer.strokeColor = foregroundColor.cgColor
        axisLinesLayer.fillColor = UIColor.clear.cgColor
        return axisLinesLayer
    }
}

//
//  GraphView.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 28-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class GraphView: UIView {

    private var layerHelper: GraphLayerHelper?

    var graphLayer = AnimatedLayer()
    var axisXLayer = AnimatedLayer()
    var axisYLayer = AnimatedLayer()
    
    init(frame: CGRect, model: GraphModel) {
        super.init(frame: frame)
        
        self.layerHelper = GraphLayerHelper(bounds: bounds)

        graphLayer = layerHelper!.drawGraphLayer(data: model.graphData, lineWidth: 1)
        layer.addSublayer(graphLayer)
        axisXLayer = layerHelper!.drawXAxisLayer(data: model.axisXData)
        layer.addSublayer(axisXLayer)
        axisYLayer = layerHelper!.drawYAxisLayer(data: model.axisYData)
        layer.addSublayer(axisYLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation() {
        axisXLayer.animate(duration: 0.2)
        axisYLayer.animate(duration: 0.2)
        graphLayer.animate(duration: 1)
    }
    
}

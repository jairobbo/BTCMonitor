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
        
        backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        
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
    
}

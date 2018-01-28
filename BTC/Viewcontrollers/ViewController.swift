//
//  ViewController.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 25-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var interactiveView: InteractiveView!
    
    let alpha = AlphaVantage()
    var graphView: GraphView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                
        alpha.getBTCData { (model) in
            self.interactiveView.model = model
            self.graphView = GraphView(frame: self.interactiveView.bounds, model: model!)
            self.interactiveView.addSubview(self.graphView!)
            self.view.addSubview(self.graphView!)
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        interactiveView.activityIndicator.stopAnimating()
        graphView?.axisXLayer.animate(duration: 0.2)
        graphView?.axisYLayer.animate(duration: 0.2)
        graphView?.graphLayer.animate(duration: 1)
    }

}


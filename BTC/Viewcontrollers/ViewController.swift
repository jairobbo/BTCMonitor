//
//  ViewController.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 25-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    let alpha = AlphaVantage()
    var graph = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                
        alpha.getBTCData { (model) in
            self.graph = GraphView(frame: CGRect(x: 20, y: 60, width: self.view.bounds.width - 40, height: 250), model: model!)
            self.graph.layer.cornerRadius = 10
            self.graph.layer.masksToBounds = true
            self.view.addSubview(self.graph)
        }
    }
    
    

}


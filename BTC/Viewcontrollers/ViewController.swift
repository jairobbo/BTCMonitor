//
//  ViewController.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 25-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var graphView: GraphView!
    
    let alpha = AlphaVantage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                
        alpha.getBTCData { (model) in
            self.graphView.initWithModel(model: model!)
        }
    }
    
    

}


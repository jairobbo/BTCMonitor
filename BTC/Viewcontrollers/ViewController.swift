//
//  ViewController.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 25-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: TextView!
    @IBOutlet weak var interactiveView: InteractiveView!
    @IBOutlet weak var scrollView: VerticalScrollView!
    
    var graphView: GraphView?
    var hudView: HUDView?
    var refreshControl = UIRefreshControl()
    
    let alpha = AlphaVantage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        textView.setText(text: "Bitcoin Monitor v0.1")
        refreshControl.tintColor = UIColor.white.withAlphaComponent(0.5)
        refreshControl.addTarget(self, action: #selector(load), for: UIControlEvents.valueChanged)
        scrollView.refreshControl = refreshControl
        load()
        
    }
    
    @objc func load() {
        refreshControl.endRefreshing()
        interactiveView.contentView.subviews.first?.removeFromSuperview()
        interactiveView.hudViewContainer.subviews.first?.removeFromSuperview()
        if !interactiveView.activityIndicator.isAnimating {
            interactiveView.activityIndicator.startAnimating()
        }
        alpha.getBTCData { (model) in
            self.graphView = GraphView(frame: self.interactiveView.bounds, model: model!)
            self.interactiveView.contentView.addSubview(self.graphView!)
            self.interactiveView.activityIndicator.stopAnimating()
            self.hudView = HUDView(frame: self.interactiveView.bounds, model: model!)
            self.interactiveView.hudViewContainer.addSubview(self.hudView!)
            self.interactiveView.addTarget(self.hudView, action: #selector(HUDView.interact(control:)), for: .editingChanged)
            self.graphView?.startAnimation()
        }
    }
    
}



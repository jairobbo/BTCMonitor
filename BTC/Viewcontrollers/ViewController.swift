//
//  ViewController.swift
//  BTC
//
//  Created by Jairo Bambang Oetomo on 25-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var textView: ContainerView!
    @IBOutlet weak var interactiveView: InteractiveView!
    @IBOutlet weak var scrollView: VerticalScrollView!
    @IBOutlet weak var titleBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var titleBoxWidth: NSLayoutConstraint!
    @IBOutlet weak var graphBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var grapBoxWidth: NSLayoutConstraint!
    
    var graphView: GraphView?
    var hudView: HUDView?
    var refreshControl = UIRefreshControl()
    
    var duration: TimeInterval = 4
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let alpha = AlphaVantage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        refreshControl.tintColor = UIColor.white.withAlphaComponent(0.5)
        refreshControl.addTarget(self, action: #selector(load), for: UIControlEvents.valueChanged)
        scrollView.refreshControl = refreshControl
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let contentWidth = self.view.bounds.width - CGFloat(40)
        let initialDelay: TimeInterval = 2
        
        textView.animateBirth(duration: 0.6, delay: initialDelay, completion: nil)
        interactiveView.animateBirth(
            duration: 0.6,
            delay: 0.6 + initialDelay,
            completion: nil)
        self.textView.animateConstraints(
            duration: 0.8,
            delay: 1 + initialDelay,
            view: self.view,
            widthCstr: self.titleBoxWidth,
            width: contentWidth,
            heightCstr: self.titleBoxHeight,
            height: 56, completion: {finished in
                let titleLayer = AnimatedLayer()
                titleLayer.animate(duration: 0.3)
        })
        self.interactiveView.animateConstraints(
            duration: 0.8,
            delay: 1.2 + initialDelay,
            view: self.view,
            widthCstr: grapBoxWidth,
            width: contentWidth,
            heightCstr: graphBoxHeight,
            height: 250,
            completion: {finished in
            self.load()
        })
    }
    
    @objc func load() {
        refreshControl.endRefreshing()
        interactiveView.contentView.subviews.first?.removeFromSuperview()
        interactiveView.hudContainerView.subviews.first?.removeFromSuperview()
        if !interactiveView.activityIndicator.isAnimating {
            interactiveView.activityIndicator.startAnimating()
        }
        alpha.getBTCData { (model) in
            self.graphView = GraphView(frame: self.interactiveView.bounds, model: model!)
            self.interactiveView.contentView.addSubview(self.graphView!)
            self.interactiveView.activityIndicator.stopAnimating()
            self.hudView = HUDView(frame: self.interactiveView.bounds, model: model!)
            self.interactiveView.hudContainerView.addSubview(self.hudView!)
            self.interactiveView.addTarget(self.hudView, action: #selector(HUDView.interact(control:)), for: .editingChanged)
            self.graphView?.startAnimation()
        }
    }
}



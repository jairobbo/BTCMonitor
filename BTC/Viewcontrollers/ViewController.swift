//
//  ViewController.swift
//  BTC
//
//  Created by Jairo Bambang Oetomo on 25-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum Value {
        case low
        case high
    }
    
    @IBOutlet weak var textView: ContainerView!
    @IBOutlet weak var interactiveView: InteractiveView!
    @IBOutlet weak var scrollView: VerticalScrollView!
    @IBOutlet weak var btcLowContainer: ContainerView!
    @IBOutlet weak var btcHighContainer: ContainerView!
    
    
    @IBOutlet weak var titleBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var titleBoxWidth: NSLayoutConstraint!
    @IBOutlet weak var graphBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var grapBoxWidth: NSLayoutConstraint!
    @IBOutlet weak var lowBoxWidth: NSLayoutConstraint!
    @IBOutlet weak var lowBoxHeight: NSLayoutConstraint!
    @IBOutlet weak var highBoxWidth: NSLayoutConstraint!
    @IBOutlet weak var highBoxHeight: NSLayoutConstraint!
    
    let boxHelper = BoxLayerHelper()
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
        
        btcLowContainer.gradientView.setColors(color1: #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), color2: #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1))
        btcHighContainer.gradientView.setColors(color1: #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), color2: #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let margin: CGFloat = 20
        let contentWidth = self.view.bounds.width - 2 * margin
        let contentWidthHalf = (self.view.bounds.width - 3 * margin) / 2
        let initialDelay: TimeInterval = 2
        let plopDuration: TimeInterval = 0.6
        let frameAnimationDelay: TimeInterval = 0.75
        
        textView.animateBirth(duration: plopDuration, delay: initialDelay, completion: nil)
        interactiveView.animateBirth(duration: plopDuration, delay: 0.1 + initialDelay, completion: nil)
        btcLowContainer.animateBirth(duration: plopDuration, delay: 0.2 + initialDelay, completion: nil)
        btcHighContainer.animateBirth(duration: plopDuration, delay: 0.3 + initialDelay, completion: nil)
        self.textView.animateConstraints(
            duration: 0.8,
            delay: frameAnimationDelay + initialDelay,
            view: view,
            widthCstr: titleBoxWidth,
            width: contentWidth,
            heightCstr: titleBoxHeight,
            height: 56, completion: {finished in
                let titleLayer = self.boxHelper.createTitleLayer(text: "Bitcoin monitor v0.1", fontSize: 24)
                let view = UIView(frame: self.textView.container.bounds)
                view.transform = CGAffineTransform(translationX: 10, y: 5)
                view.layer.addSublayer(titleLayer)
                self.textView.container.addSubview(view)
                titleLayer.animate(duration: 0.3)
        })
        self.interactiveView.animateConstraints(
            duration: 0.8,
            delay: 0.1 + frameAnimationDelay + initialDelay,
            view: self.view,
            widthCstr: grapBoxWidth,
            width: contentWidth,
            heightCstr: graphBoxHeight,
            height: 250,
            completion: {finished in self.load()}
        )
        self.btcLowContainer.animateConstraints(
            duration: 0.8,
            delay: 0.2 + frameAnimationDelay + initialDelay,
            view: self.view,
            widthCstr: lowBoxWidth,
            width: contentWidthHalf,
            heightCstr: lowBoxHeight,
            height: 56,
            completion: nil
        )
        self.btcHighContainer.animateConstraints(
            duration: 0.8,
            delay: 0.3 + frameAnimationDelay + initialDelay,
            view: self.view,
            widthCstr: highBoxWidth,
            width: contentWidthHalf,
            heightCstr: highBoxHeight,
            height: 56,
            completion: nil)
    }
    
    @objc func load() {
        refreshControl.endRefreshing()
        hudView?.removeFromSuperview()
        graphView?.removeFromSuperview()
        btcLowContainer.container.subviews.first?.removeFromSuperview()
        btcHighContainer.container.subviews.first?.removeFromSuperview()
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
            
            let lowLayer = self.boxHelper.createTitleLayer(text: self.getValue(.low, model: model!), fontSize: 22)
            let lowview = UIView(frame: self.textView.container.bounds)
            lowview.transform = CGAffineTransform(translationX: 10, y: 5)
            lowview.layer.addSublayer(lowLayer)
            self.btcLowContainer.container.addSubview(lowview)
            lowLayer.animate(duration: 0.3)
            
            let highLayer = self.boxHelper.createTitleLayer(text: self.getValue(.high, model: model!), fontSize: 22)
            let highview = UIView(frame: self.textView.container.bounds)
            highview.transform = CGAffineTransform(translationX: 10, y: 5)
            highview.layer.addSublayer(highLayer)
            self.btcHighContainer.container.addSubview(highview)
            highLayer.animate(duration: 0.3)
        }
    }
    
    func getValue(_ value: Value, model: GraphModel) -> String {
        let sorted = model.rawData.sorted { (left, right) -> Bool in
            left.value > right.value
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "$"
        switch value {
        case .high:
            return numberFormatter.string(from: NSNumber(value: sorted.first?.value ?? 0)) ?? ""
        case .low:
            return numberFormatter.string(from: NSNumber(value: sorted.last?.value ?? 0)) ?? ""
        }
    }
}



//
//  TextView.swift
//  BTC
//
//  Created by Jairo Bambang Oetomo on 29-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class ContainerView: UIView, Animations {
    @IBOutlet weak var container: UIView!
    
    let nibName = "ContainerView"
    let label = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        guard let view = viewFromNib() else { return }
        view.frame = self.bounds
        addSubview(view)
        layer.cornerRadius = 20
        layer.masksToBounds = true
    }
    
    override func awakeFromNib() {
        super.layoutSubviews()
        alpha = 0
        transform = CGAffineTransform(scaleX: 0, y: 0)
    }
    
    func viewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}





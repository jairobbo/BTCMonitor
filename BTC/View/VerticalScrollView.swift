//
//  VerticalScrollView.swift
//  BTC
//
//  Created by Jairo Bambang Oetomo on 29-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class VerticalScrollView: UIScrollView {

    var sensitivity: CGFloat = 3 // the threshold ratio of vertical to horizontal movement
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let absY = abs((gestureRecognizer as? UIPanGestureRecognizer)?.translation(in: self).y ?? 1)
        let absX = abs((gestureRecognizer as? UIPanGestureRecognizer)?.translation(in: self).x ?? 1)
        if absY/absX > sensitivity {
            return true
        }
        return false
    }
    
}

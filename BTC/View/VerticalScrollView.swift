//
//  VerticalScrollView.swift
//  BTC
//
//  Created by Lise-Lotte Geutjes on 29-01-18.
//  Copyright © 2018 DramaMedia. All rights reserved.
//

import UIKit

class VerticalScrollView: UIScrollView {

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let absY = abs((gestureRecognizer as? UIPanGestureRecognizer)?.translation(in: self).y ?? 1)
        let absX = abs((gestureRecognizer as? UIPanGestureRecognizer)?.translation(in: self).x ?? 1)
        if absY/absX > 3 {
            return true
        }
        return false
    }
    
}

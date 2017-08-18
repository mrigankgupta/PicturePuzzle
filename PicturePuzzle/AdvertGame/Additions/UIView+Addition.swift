//
//  Fadeable.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 11/08/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fade(time:TimeInterval) {
       let anim = CATransition()
        anim.type = kCATransitionFade
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        anim.startProgress = 1.0
        anim.endProgress = 0.0
        anim.duration = time
        self.layer.add(anim, forKey: "fadeOut")
    }
}

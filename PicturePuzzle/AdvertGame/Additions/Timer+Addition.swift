//
//  Timer+Addition.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 12/08/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

extension Timer {
    convenience init(timeInterval:TimeInterval, initialDelay:TimeInterval, aSelector:Selector, target:Any) {
        let now = Date.init()
        self.init(fireAt: now.addingTimeInterval(initialDelay), interval: timeInterval, target: target, selector: aSelector, userInfo:nil, repeats: true)
        RunLoop.main.add(self, forMode: RunLoopMode.commonModes)
        self.fire()
    }
}

extension Array {
    mutating func swapAt(_ i:Int, _ j:Int) {
            let temp = self[i]
            self[i] = self[j]
            self[j] = temp
    }
}

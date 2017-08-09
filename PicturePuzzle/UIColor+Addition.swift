//
//  UIColor+Addition.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 08/08/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex:UInt32) {
        let b = hex & 0xFF
        let g = (hex >> 8) & 0xFF
        let r = (hex >> 16) & 0xFF
        self.init(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255, alpha: 1.0)
    }
    convenience init(hexHashString:String) {
        var cString:String = hexHashString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        var rgb = UInt32()
        Scanner(string: cString).scanHexInt32(&rgb)
        self.init(hex: rgb)
    }
}



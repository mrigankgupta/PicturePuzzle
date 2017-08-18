//
//  Array+Addition.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 18/08/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation

extension Array {
    mutating func swapAt(_ i:Int, _ j:Int) {
        let temp = self[i]
        self[i] = self[j]
        self[j] = temp
    }
}

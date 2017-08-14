//
//  Model.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 22/07/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

struct Puzzle {
    let row: Int
    let col: Int
    let imageURL: String
}

struct Slice {
    let index: Int
    let image: UIImage
}

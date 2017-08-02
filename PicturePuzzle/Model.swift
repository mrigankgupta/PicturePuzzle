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

extension UIImage {
    func slice(row:Int, col:Int) -> [Slice] {
        var slices = [Slice]()
        let size = CGSize(width: self.size.width*self.scale/CGFloat(col), height: self.size.height*self.scale/CGFloat(row))
        print("\(String(describing: self.cgImage?.width))")
        for i in 0..<row {
            for j in 0..<col {
                let rect = CGRect(origin: CGPoint(x:CGFloat(j)*size.width,y:CGFloat(i)*size.height), size: size)
//                print("\(rect)")
                let cgImage = self.cgImage?.cropping(to: rect)
                if let cgImage = cgImage {
                    let slicedImage = UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
                    let singleSlice = Slice(index: (i+1)*j, image: slicedImage)
                    slices.append(singleSlice)
                }
            }
        }
        return slices
    }
}

extension UIImage {
    enum AssetIdentifier: String {
        case defaultImage = "defaultImage"
        case trackImage = "trackImage"
    }
    convenience init(assetIdentifier:AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)!
    }
}

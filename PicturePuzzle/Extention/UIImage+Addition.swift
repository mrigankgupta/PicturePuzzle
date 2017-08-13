//
//  UIImage+Addition.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 08/08/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func slice(row:Int, col:Int) -> [Slice] {
        var slices = [Slice]()
        let size = CGSize(width: self.size.width*self.scale/CGFloat(col), height: self.size.height*self.scale/CGFloat(row))
        for i in 0..<row {
            for j in 0..<col {
                let rect = CGRect(origin: CGPoint(x:CGFloat(j)*size.width,y:CGFloat(i)*size.height), size: size)
                let cgImage = self.cgImage?.cropping(to: rect)
                if let cgImage = cgImage {
                    let slicedImage = UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
                    let index = j + i*col
                    let singleSlice = Slice(index: index, image: slicedImage)
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

//
//  VerticalProgressView.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 27/07/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

class VerticalProgressView: UIView {
    fileprivate var progressLayer: CAShapeLayer?
    private var progressLabel = UILabel()
    fileprivate var finalBezeirPath:UIBezierPath?
    private var innerProgress: Float = 0.5 {
        didSet {
            if let _ = progressLayer {
                animate(bounds)
            }
        }
    }
    public var insetX: Float = 10.0 {
        didSet {
            if let progressLayer = progressLayer {
            }
        }
    }
    public var insetY: Float = 10.0 {
        didSet {
            if let progressLayer = progressLayer {
            }
        }
    }
    public var cornerRadius: Float = 10 {
        didSet {
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    public var progress: Float {
        get {
            return innerProgress
        }
        set {
            if newValue > 1.0 {
                innerProgress = 1.0
            }else if newValue < 0.0 {
                innerProgress = 0.0
            }else {
                innerProgress = newValue
            }
        }
    }
    
    public var trackImage: UIImage? {
        didSet {
            layer.contents = trackImage?.cgImage
            layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    public var fillImage: UIImage? {
        didSet {
            progressLayer?.contents = fillImage?.cgImage
            progressLayer?.fillColor = UIColor.clear.cgColor
        }
    }
    
    public var trackColor = UIColor.gray {
        didSet {
            layer.backgroundColor = trackColor.cgColor
        }
    }
    
    public var fillColor = UIColor.blue {
        didSet {
            progressLayer?.fillColor = fillColor.cgColor
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createTrackBar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createTrackBar()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if progressLayer == nil {
            createProgressBar(bounds)
        }
    }
    
    public func layerProperties () {
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.masksToBounds = true
    }
    
    private func createTrackBar() {
        layerProperties()
        layer.backgroundColor = trackColor.cgColor
    }
    
    private func createProgressBar(_ rect:CGRect) {
        progressLayer = CAShapeLayer()
        progressLayer?.frame = rect
        print("initial rect\(rect)")
        let progressRect = CGRect(x: rect.origin.x, y: rect.origin.y,
                                  width: rect.size.width, height: CGFloat(progress)*rect.size.height)
        let progressRectInset = progressRect.insetBy(dx: CGFloat(insetX), dy: CGFloat(insetY))
        let bezier = UIBezierPath(roundedRect: progressRectInset, cornerRadius: CGFloat(cornerRadius))
        progressLayer?.path = bezier.cgPath
        progressLayer?.fillColor = fillColor.cgColor
        layer.addSublayer(progressLayer!)
    }
    
    private func animate(_ rect:CGRect) {
        let basicAnimation = CABasicAnimation(keyPath: "path")
        let currentPresentationLayer = progressLayer?.presentation()
        if let oldBezierPath = currentPresentationLayer?.path {
            let newProgressRect = CGRect(x: rect.origin.x, y: rect.origin.y,
                                 width: rect.size.width, height: CGFloat(progress)*rect.size.height)
            let progressRectInset = newProgressRect.insetBy(dx: CGFloat(insetX), dy: CGFloat(insetY))
            finalBezeirPath = UIBezierPath(roundedRect: progressRectInset, cornerRadius: CGFloat(cornerRadius))
            basicAnimation.fromValue = oldBezierPath
            basicAnimation.toValue = finalBezeirPath?.cgPath
            basicAnimation.duration = 2.0
            basicAnimation.fillMode = kCAFillModeBoth
            basicAnimation.delegate = self
            progressLayer?.add(basicAnimation, forKey: "progress")
        }
    }
}

extension VerticalProgressView: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//        progressLayer?.path = finalBezeirPath?.cgPath
    }

}

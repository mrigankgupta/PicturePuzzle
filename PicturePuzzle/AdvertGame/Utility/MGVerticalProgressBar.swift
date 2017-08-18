//
//  MGVerticalProgressBar.swift
//  PicturePuzzle
//
//  Created by Gupta, Mrigank on 27/07/17.
//  Copyright © 2017 Gupta, Mrigank. All rights reserved.
//

import Foundation
import UIKit

class MGVerticalProgressBar: UIView {
    fileprivate var progressLayer: CAShapeLayer?
    private var textLayer: CATextLayer?
    private var innerProgress: Float = 0.5 {
        didSet {
            if let progressLayer = progressLayer {
                animateLayer(progressLayer, with: bounds)
            }
        }
    }
    
    @IBInspectable public var insetX: Float = 2.0 {
        didSet {
            if let progressLayer = progressLayer {
                progressLayer.path = getRectangularBezierPath(forRect: bounds, progress: progress,
                                                              insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
            }
        }
    }
    
    @IBInspectable public var insetY: Float = 2.0 {
        didSet {
            if let progressLayer = progressLayer {
                progressLayer.path = getRectangularBezierPath(forRect: bounds, progress: progress,
                                                              insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
            }
        }
    }
    
    @IBInspectable public var cornerRadius: Float = 4.0 {
        didSet {
            layer.cornerRadius = CGFloat(cornerRadius)
        }
    }
    
    @IBInspectable public var progress: Float {
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
    
    @IBInspectable public var trackImage: UIImage? {
        didSet {
            layer.contents = trackImage?.cgImage
            layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    @IBInspectable public var fillImage: UIImage? {
        didSet {
            progressLayer?.contents = fillImage?.cgImage
            progressLayer?.fillColor = UIColor.clear.cgColor
        }
    }
    
    @IBInspectable public var trackColor: UIColor = UIColor.gray {
        didSet {
            if trackImage == nil {
                layer.backgroundColor = trackColor.cgColor
            }
        }
    }
    
    @IBInspectable public var fillColor: UIColor = UIColor.blue {
        didSet {
            if fillImage == nil {
                progressLayer?.fillColor = fillColor.cgColor
            }
        }
    }
    
    @IBInspectable public var fontSize: Float = 10.0 {
        didSet {
            if let textLayer = textLayer {
                textLayer.fontSize = CGFloat(fontSize)
            }
        }
    }
    
    @IBInspectable public var fontColor: UIColor = UIColor.white {
        didSet {
            if let textLayer = textLayer {
                textLayer.foregroundColor = fontColor.cgColor
            }
        }
    }
    
    public var percentText = "" {
        didSet {
            if let textLayer = textLayer {
                textLayer.string = percentText
            }
        }
    }
    
    public func layerProperties() {
        layer.cornerRadius = CGFloat(cornerRadius)
        layer.masksToBounds = cornerRadius > 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTrackBar()
        configureProgressTrack()
        layer.addSublayer(textLayer!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureTrackBar()
        configureProgressTrack()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeTextLayer(frame: bounds)
        shapeProgressLayer(frame: bounds)
    }
}

private extension MGVerticalProgressBar {
    
    func configureTrackBar() {
        layerProperties()
        layer.backgroundColor = trackColor.cgColor
    }
    
    func configureProgressTrack() {
        if progressLayer == nil {
            createProgressLayer(frame: bounds)
            layer.addSublayer(progressLayer!)
        }
        if textLayer == nil && progressLayer != nil {
            createTextLayer(frame: bounds)
            layer.addSublayer(textLayer!)
        }
    }
    
    func createProgressLayer(frame:CGRect) {
        progressLayer = CAShapeLayer()
        shapeProgressLayer(frame: frame)
        progressLayer!.fillColor = fillColor.cgColor
    }
    
    func shapeProgressLayer(frame:CGRect) {
        progressLayer?.frame = frame
        progressLayer?.path = getRectangularBezierPath(forRect: frame, progress: progress,
                                                       insetX: insetX, insetY: insetY, cornerRadius: cornerRadius).cgPath
    }
    
    func createTextLayer(frame:CGRect) {
        textLayer = CATextLayer()
        shapeTextLayer(frame: frame)
        textLayer!.alignmentMode = kCAAlignmentCenter
        textLayer!.isWrapped = true
    }
    
    func shapeTextLayer(frame:CGRect) {
        let fullRectInset = frame.insetBy(dx: CGFloat(insetX), dy: CGFloat(insetY))
        let textFrame = CGRect(x: fullRectInset.origin.x, y: fullRectInset.origin.y + fullRectInset.size.height - fullRectInset.size.width,
                               width: fullRectInset.size.width, height: fullRectInset.size.width)
        textLayer?.frame = textFrame
    }
    
    func animateLayer(_ layer:CAShapeLayer, with rect:CGRect) {
        let basicAnimation = CABasicAnimation(keyPath: "path")
        let currentPresentationLayer = layer.presentation()
        if let oldBezierPath = currentPresentationLayer?.path {
            let finalBezeirPath = getRectangularBezierPath(forRect: rect, progress: progress,
                                                           insetX: insetX, insetY: insetY, cornerRadius: cornerRadius)
            basicAnimation.fromValue = oldBezierPath
            basicAnimation.toValue = finalBezeirPath.cgPath
            basicAnimation.duration = 2.0
            basicAnimation.fillMode = kCAFillModeBoth
            basicAnimation.delegate = self
            layer.path = finalBezeirPath.cgPath
            if fillImage != nil {
                layer.mask = finalBezeirPath.path
            }
            layer.add(basicAnimation, forKey: "progress")
        }
    }
    
    func getRectangularBezierPath(forRect rect:CGRect, progress:Float, insetX:Float, insetY:Float, cornerRadius:Float) -> UIBezierPath {
        let fullRectInset = rect.insetBy(dx: CGFloat(insetX), dy: CGFloat(insetY))
        let progressHeight = fullRectInset.size.height*CGFloat(progress)
        let progressRect = CGRect(x: fullRectInset.origin.x, y: fullRectInset.origin.y + fullRectInset.size.height - progressHeight,
                                  width: fullRectInset.size.width, height: progressHeight)
        return UIBezierPath(roundedRect: progressRect, cornerRadius: CGFloat(cornerRadius))
    }
}

extension MGVerticalProgressBar: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    }
}

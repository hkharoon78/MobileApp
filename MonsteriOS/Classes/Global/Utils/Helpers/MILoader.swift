//
//  MILoader.swift
//  MonsteriOS
//
//  Created by Piyush on 19/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit


class MILoader: UIView {
    static let shared = MILoader.Loader()
    private let drawableLayer = CAShapeLayer()
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    class func Loader() -> MILoader {
        let loader = UINib(nibName: "MILoader", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MILoader
//        header.setUI()
//        header.topView.roundCorner(0, borderColor: nil, rad: 8)
        loader.setUI()
        return loader
    }
    
    func setUI() {
        let onView = kAppDelegate.window
        self.frame = onView!.bounds
        onView?.addSubview(self)
        self.setNeedsLayout()
        self.alpha = 0.0
        self.imgView.layer.addSublayer(self.drawableLayer)
        self.drawableLayer.strokeColor = Color.colorLightDefault.cgColor
        self.drawableLayer.lineWidth = 4
        self.drawableLayer.fillColor = UIColor.clear.cgColor
        self.drawableLayer.lineCap = .round//kCALineJoinRound
        self.drawableLayer.strokeStart = 0.99
        self.drawableLayer.strokeEnd = 1

        self.topView.circular(0, borderColor: nil)
        self.updateFrame()
        self.updatePath()
        self.stopAnimating()
    }
    
    
//    @IBInspectable public var color: UIColor = UIColor(hex: 0x5c4aae) {
//        didSet {
//            drawableLayer.strokeColor = self.color.cgColor
//        }
//    }
//
//    @IBInspectable public var lineWidth: CGFloat = 4 {
//        didSet {
//            drawableLayer.lineWidth = self.lineWidth
//            self.updatePath()
//        }
//    }
    
    func startAnimating() {
        UIView.animate(withDuration: 0.3) { self.alpha = 1.0 }
        self.resetAnimations()
        
    }
    
    func stopAnimating() {
        self.drawableLayer.removeAllAnimations()
        UIView.animate(withDuration: 0.3) { self.alpha = 0.0 }
    }
    
    
    private func updateFrame() {
        self.drawableLayer.frame  = CGRect(x: 0, y: 0, width: self.imgView.bounds.width, height: self.imgView.bounds.height)
    }
    
    private func updatePath() {
        let center = CGPoint(x: self.imgView.bounds.midX, y: self.imgView.bounds.midY)
        let radius = min(self.topView.bounds.width, self.topView.bounds.height) / 2 - 4
        self.drawableLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: CGFloat(2 * Double.pi),
            clockwise: true)
            .cgPath
    }
    
    private func resetAnimations() {
        drawableLayer.removeAllAnimations()
        
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnim.fromValue = 0
        rotationAnim.duration = 4
        rotationAnim.toValue = 2 * Double.pi
        rotationAnim.repeatCount = Float.infinity
        rotationAnim.isRemovedOnCompletion = false
        
        let startHeadAnim = CABasicAnimation(keyPath: "strokeStart")
        startHeadAnim.beginTime = 0.1
        startHeadAnim.fromValue = 0
        startHeadAnim.toValue = 0.25
        startHeadAnim.duration = 1
        startHeadAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let startTailAnim = CABasicAnimation(keyPath: "strokeEnd")
        startTailAnim.beginTime = 0.1
        startTailAnim.fromValue = 0
        startTailAnim.toValue = 1
        startTailAnim.duration = 1
        startTailAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let endHeadAnim = CABasicAnimation(keyPath: "strokeStart")
        endHeadAnim.beginTime = 1
        endHeadAnim.fromValue = 0.25
        endHeadAnim.toValue = 0.99
        endHeadAnim.duration = 0.5
        endHeadAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let endTailAnim = CABasicAnimation(keyPath: "strokeEnd")
        endTailAnim.beginTime = 1
        endTailAnim.fromValue = 1
        endTailAnim.toValue = 1
        endTailAnim.duration = 0.5
        endTailAnim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        let strokeAnimGroup = CAAnimationGroup()
        strokeAnimGroup.duration = 1.5
        strokeAnimGroup.animations = [startHeadAnim, startTailAnim, endHeadAnim, endTailAnim]
        strokeAnimGroup.repeatCount = Float.infinity
        strokeAnimGroup.isRemovedOnCompletion = false
        
        self.drawableLayer.add(rotationAnim, forKey: "rotation")
        self.drawableLayer.add(strokeAnimGroup, forKey: "stroke")
    }
    
}

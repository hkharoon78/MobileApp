//
//  MKActivityIndicator.swift
//
//
//  Created by Anupam Katiyar on 06/12/18.
//  Copyright © 2018 Anupam Katiyar. All rights reserved.
//

import UIKit

@IBDesignable
class MIActivityIndicator: ShadowView {
    
    private let drawableLayer = CAShapeLayer()
    private let centerImgView = UIImageView()
    var animating = false
    
    func activityIndicatorView(onView:UIView?) -> MIActivityIndicator {
        let activity = MIActivityIndicator(frame: CGRect(x: (kScreenSize.width/2)-30, y: 100, width: 60, height: 60))
        activity.center = kAppDelegate.window?.center ?? CGPoint(x: kScreenSize.width/2, y: kScreenSize.height/2)
        onView?.addSubview(activity)
        return activity
    }
    lazy var activityIndicator: MIActivityIndicator = {
        let activity = MIActivityIndicator(frame: CGRect(x: (kScreenSize.width/2)-30, y: 100, width: 60, height: 60))
        activity.center = kAppDelegate.window?.center ?? CGPoint(x: kScreenSize.width/2, y: kScreenSize.height/2)
//        obj?.addSubview(self)
        kAppDelegate.window?.addSubview(activity)
        return activity
    }()
    
//    func addMe(OnView:UIView) {
//        if obj != nil {
//            
//        } else {
//            obj = OnView
//            OnView.addSubview(self)
//            self.bringSubviewToFront(OnView)
//        }
//        self.startAnimating()
//    }
    
    class func activityShared() -> MIActivityIndicator {
        let activityIndicator = MIActivityIndicator(frame: CGRect(x: (kScreenSize.width/2)-30, y: 100, width: 60, height: 60))
            activityIndicator.center = CGPoint(x: kScreenSize.width/2, y: kScreenSize.height/2)
            kAppDelegate.window?.addSubview(activityIndicator)
            activityIndicator.stopAnimating()
            return activityIndicator
    }
    
    @IBInspectable public var color: UIColor = AppTheme.defaltTheme {
        didSet {
            drawableLayer.strokeColor = self.color.cgColor
        }
    }
    
    @IBInspectable public var lineWidth: CGFloat = 3 {
        didSet {
            drawableLayer.lineWidth = self.lineWidth
            self.updatePath()
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override var bounds: CGRect {
        didSet {
            updateFrame()
            updatePath()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
        updatePath()
    }
    
    public func startAnimating() {
        if self.animating {
            return
        }
        
        self.animating = true
        self.isHidden = false
        self.resetAnimations()
    }
    
    public func stopAnimating() {
        self.drawableLayer.removeAllAnimations()
        self.animating = false
        self.isHidden = true
    }
    
    private func setup() {
        
        self.backgroundColor = .white
        self.isHidden = true
        self.layer.addSublayer(self.drawableLayer)
        self.drawableLayer.strokeColor = self.color.cgColor
        self.drawableLayer.lineWidth = self.lineWidth
        self.drawableLayer.fillColor = UIColor.clear.cgColor
        self.drawableLayer.lineCap = .round
        self.drawableLayer.strokeStart = 0.99
        self.drawableLayer.strokeEnd = 1
        
        centerImgView.contentMode = .scaleAspectFit
        centerImgView.image = #imageLiteral(resourceName: "mLogo")
        self.addSubview(centerImgView)
        
        updateFrame()
        updatePath()
    }
    
    private func updateFrame() {
        self.drawableLayer.frame  = CGRect(x: 4, y: 4, width: self.bounds.width-8, height: self.bounds.height-8)
        let radius = min(self.bounds.width, self.bounds.height) / 2 - self.lineWidth
        self.centerImgView.frame  = CGRect(x: 0, y: 0, width: radius, height: radius)
        self.centerImgView.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)

        self.cornerRadius = min(self.bounds.width, self.bounds.height)/2
    }
    
    private func updatePath() {
        let center = CGPoint(x: self.drawableLayer.bounds.midX, y: self.drawableLayer.bounds.midY)
        let radius = min(self.drawableLayer.bounds.width, self.drawableLayer.bounds.height) / 2 - self.lineWidth
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

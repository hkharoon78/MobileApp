//
//  CircularProgressView.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 15/11/18.
//  Copyright © 2018 Monster. All rights reserved.//

import UIKit

class DefaultColor {
    static let circleStrokeColor: UIColor = UIColor(red: 233.0/255.0, green: 233.0/255.0, blue: 233.0/255.0, alpha: 1)
    static let circleFillColor: UIColor = UIColor.white
    static let progressCircleStrokeColor: UIColor = UIColor(red: 0.0/255.0, green: 184.0/255.0, blue: 249.0/255.0, alpha: 1)
    static let progressCircleFillColor: UIColor = UIColor(red: 0.0/255.0, green: 184.0/255.0, blue: 249.0/255.0, alpha: 0.2)
}

class CircularProgressView: UIView {
    
    // progress: Should be between 0 to 1
    var progress: CGFloat = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private var circleStrokeWidth: CGFloat = 5
    private var circleStrokeColor: UIColor = DefaultColor.circleStrokeColor
    private var circleFillColor: UIColor = DefaultColor.circleFillColor
    private var progressCircleStrokeColor: UIColor = DefaultColor.progressCircleStrokeColor
    private var progressCircleFillColor: UIColor = DefaultColor.progressCircleFillColor
    
    private var textLabel: UILabel!
    private var textFont: UIFont? = UIFont.boldSystemFont(ofSize: 17)
    private var textColor: UIColor? = UIColor.black
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUpView()
    }
    
    // MARK: Public Methods
    
    func setCircleStrokeWidth(_ circleStrokeWidth: CGFloat) {
        self.circleStrokeWidth = circleStrokeWidth
        setCircleStrokeColor()
    }
    
    func setCircleStrokeColor(_ circleStrokeColor: UIColor = DefaultColor.circleStrokeColor, circleFillColor: UIColor = DefaultColor.circleFillColor, progressCircleStrokeColor: UIColor = DefaultColor.progressCircleStrokeColor, progressCircleFillColor: UIColor = DefaultColor.progressCircleFillColor) {
        self.circleStrokeColor = circleStrokeColor
        self.circleFillColor = circleFillColor
        self.progressCircleStrokeColor = progressCircleStrokeColor
        self.progressCircleFillColor = progressCircleFillColor
        
        self.setNeedsDisplay()
    }
    
    func setProgressText(_ text: String) {
        textLabel.text = text
    }
    
    func setProgressTextFont(_ font: UIFont = UIFont.boldSystemFont(ofSize: 17), color: UIColor = UIColor.black) {
        textLabel.font = font
        textLabel.textColor = color
    }

    // MARK: Private Methods
    
    private func setUpView() {
        textLabel = UILabel(frame: self.bounds)
        textLabel.textAlignment = .center
        textLabel.font = textFont
        textLabel.textColor = textColor
        textLabel.numberOfLines = 0
        
        self.addSubview(textLabel)
    }
    
    // MARK: Core Graphics Drawing
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawRect(rect, margin: 0, color: circleStrokeColor, percentage: 1)
        drawRect(rect, margin: circleStrokeWidth, color: circleFillColor, percentage: 1)
        drawRect(rect, margin: circleStrokeWidth, color: progressCircleFillColor, percentage: progress)
        
        drawProgressCircle(rect)
    }
    
    private func drawRect(_ rect: CGRect, margin: CGFloat, color: UIColor, percentage: CGFloat) {
        
        let radius: CGFloat = min(rect.height, rect.width) * 0.5 - margin
        let centerX: CGFloat = rect.width * 0.5
        let centerY: CGFloat = rect.height * 0.5
        
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        let center: CGPoint = CGPoint(x: centerX, y: centerY)
        context.move(to: center)
        let halfPie: CGFloat = -.pi/2
        let startAngle: CGFloat = halfPie
        let endAngle: CGFloat = halfPie + .pi * 2 * percentage
        context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.closePath()
        context.fillPath()
    }
    
    private func drawProgressCircle(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setLineWidth(circleStrokeWidth)
        context.setStrokeColor(progressCircleStrokeColor.cgColor)
        
        let centerX: CGFloat = rect.width * 0.5
        let centerY: CGFloat = rect.height * 0.5
        let radius: CGFloat = min(rect.height, rect.width) * 0.5 - (circleStrokeWidth / 2)
        let startAngle: CGFloat = -.pi/2
        let endAngle: CGFloat = -.pi/2 + .pi * 2 * progress
        let center: CGPoint = CGPoint(x: centerX, y: centerY)
        
        context.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        context.strokePath()
    }
}

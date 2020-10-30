//
//  AKLoadingButton.swift
//  MonsterIndia
//
//  Created by Anupam Katiyar 12/01/2019.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

public enum ActivityIndicatorAlignment: Int {
    case Left
    case Right
    case Center
}

public class AKLoadingButton: UIButton {
    
    let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    
    public var indicatorAlignment:ActivityIndicatorAlignment = ActivityIndicatorAlignment.Right {
        didSet {
            setupPositionIndicator()
        }
    }
    
    public var isLoading:Bool = false {
        didSet {
            realoadView()
        }
    }
    
    @IBInspectable public var hideWhenLoad: Bool = false {
        didSet {
            indicatorAlignment = .Center
        }
    }
    @IBInspectable public var indicatorColor:UIColor = UIColor.lightGray {
        didSet {
            activityIndicatorView.color = indicatorColor
        }
    }
    
    public var normalText:String? = nil {
        didSet {
            if(normalText == nil){
                normalText = self.titleLabel?.text
            }
            self.titleLabel?.text = normalText
        }
    }
    
    public var loadingText:String? = "Please Wait"
    
    private var topContraints:NSLayoutConstraint?
    private var bottomContraints:NSLayoutConstraint?
    private var widthContraints:NSLayoutConstraint?
    private var rightContraints:NSLayoutConstraint?
    private var leftContraints:NSLayoutConstraint?
    private var centerX:NSLayoutConstraint?
    
    required  public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        if normalText == nil{
            normalText = title
        }
    }
    
    
    func setView() {
        activityIndicatorView.hidesWhenStopped = true;
        self.normalText = self.titleLabel?.text
        self.addSubview(activityIndicatorView)
        setupPositionIndicator()
    }
    
    func realoadView() {
        if(isLoading){
            self.isEnabled = false
            activityIndicatorView.isHidden = false;
            activityIndicatorView.startAnimating()
            if( self.loadingText != nil && self.indicatorAlignment != .Center){
                self.setTitle(loadingText, for: .normal)
            }
        }else{
            self.isEnabled = true
            activityIndicatorView.stopAnimating()
            self.setTitle(normalText, for: .normal)
        }
        
        if self.indicatorAlignment == .Center {
            if isLoading {
                self.titleLabel?.removeFromSuperview()
                self.imageView?.removeFromSuperview()
            } else {
                self.insertSubview(self.titleLabel!, at: 0)
                self.insertSubview(self.imageView!, at: 0)
            }
        }
    }
    
    private func setupPositionIndicator()  {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        if(topContraints==nil){
            topContraints = NSLayoutConstraint(item: activityIndicatorView, attribute:
                .top, relatedBy: .equal, toItem: self,
                      attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0,
                      constant: 0)
        }
        
        if(bottomContraints==nil){
            bottomContraints = NSLayoutConstraint(item: activityIndicatorView, attribute:
                .bottom, relatedBy: .equal, toItem: self,
                         attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0,
                         constant: 0)
        }
        
        if(widthContraints==nil){
            widthContraints = NSLayoutConstraint(item: activityIndicatorView, attribute:
                .width, relatedBy: .equal, toItem: nil,
                        attribute: .width, multiplier: 1.0,
                        constant: 30)
        }
        
        if(rightContraints==nil){
            rightContraints = NSLayoutConstraint(item: activityIndicatorView, attribute:
                .trailingMargin, relatedBy: .equal, toItem: self,
                                 attribute: .trailingMargin, multiplier: 1.0,
                                 constant: 0)
        }
        
        if(leftContraints==nil){
            leftContraints = NSLayoutConstraint(item: activityIndicatorView, attribute:
                .leading, relatedBy: .equal, toItem: self,
                          attribute: .leading, multiplier: 1.0,
                          constant: 0)
        }
        
        if(centerX==nil) {
            centerX = NSLayoutConstraint(item: activityIndicatorView, attribute:
                .centerX, relatedBy: .equal, toItem: self,
                          attribute: .centerX, multiplier: 1.0,
                          constant: 0)
        }
        
        
        if(indicatorAlignment == .Right ){
            NSLayoutConstraint.deactivate([leftContraints!, centerX!])
            NSLayoutConstraint.activate([topContraints!,rightContraints!,widthContraints!,bottomContraints!])
        } else if (indicatorAlignment == .Left ){
            NSLayoutConstraint.deactivate([centerX!, rightContraints!])
            NSLayoutConstraint.activate([topContraints!,leftContraints!,widthContraints!,bottomContraints!])
        } else if (indicatorAlignment == .Center ){
            NSLayoutConstraint.deactivate([rightContraints!, leftContraints!])
            NSLayoutConstraint.activate([topContraints!,centerX!,widthContraints!,bottomContraints!])
            
        }
    }
    
    deinit {
        activityIndicatorView.removeFromSuperview()
    }
}

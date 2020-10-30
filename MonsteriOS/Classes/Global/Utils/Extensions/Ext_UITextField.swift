//
//  Ext_UITextField.swift
//  EExpress
//
//  Created by TTLAPTOP0437 on 2/24/17.
//  Copyright © 2017 Paytm. All rights reserved.
//

import UIKit

fileprivate let keyboardHeight = CGFloat(250)
extension UITextView {
    
    func movingHeightIn(view: UIView) -> CGFloat {
        var bottHeight = view.frame.size.height
        bottHeight -= self.frame.maxY
        var subView = self.superview
        var parentView : UIView? = view
        while parentView != nil {
            if view == subView {
                parentView = nil
            } else {
                if subView is UIScrollView {
                    let scrollView:UIScrollView = subView as! UIScrollView
                    bottHeight += scrollView.contentOffset.y
                }
                bottHeight -= (subView?.frame.minY)!
            }
            subView = subView?.superview
        }
        let movingHeight = keyboardHeight + 75 - bottHeight
        return movingHeight
    }
    
}
extension UITextField {
    func setMargin(_ margin: CGFloat) {
        let padV = UIView(frame: CGRect(x: 0, y: 0, width: margin, height: 20))
        self.leftView = padV;
//        self.leftViewMode = UITextFieldViewMode.always;
    }
    
    func movingHeightIn(view: UIView) -> CGFloat {
        var bottHeight = view.frame.size.height
        bottHeight -= self.frame.maxY
        var subView = self.superview
        var parentView : UIView? = view
        while parentView != nil {
            if view == subView {
                parentView = nil
            } else {
                if subView is UIScrollView {
                    let scrollView:UIScrollView = subView as! UIScrollView
                    bottHeight += scrollView.contentOffset.y
                }
                bottHeight -= (subView?.frame.minY)!
            }
            subView = subView?.superview
        }
        let movingHeight = keyboardHeight + 75 - bottHeight
        return movingHeight
    }
    
    func getTopOriginYFrom(view:UIView) -> CGFloat {
        var topOriginY = self.frame.origin.y
        var subView = self.superview
        var parentView : UIView? = view
        while parentView != nil {
            if view == subView {
                parentView = nil
            } else {
                topOriginY += (subView?.frame.origin.y)!
            }
            subView = subView?.superview
        }
        return topOriginY
    }
    
    func getOriginXFrom(view:UIView) -> CGFloat {
        var originX = self.frame.origin.x
        var subView = self.superview
        var parentView : UIView? = view
        while parentView != nil {
            if view == subView {
                parentView = nil
            } else {
                originX += (subView?.frame.origin.x)!
            }
            subView = subView?.superview
        }
        return originX
    }
    func setBottomBorder(borderColor: CGColor, backgroundColor: CGColor = UIColor.clear.cgColor) {
        self.borderStyle = .none
        self.layer.backgroundColor = backgroundColor
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = borderColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: kScreenSize.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.barTintColor = AppTheme.viewBackgroundColor
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction(_:)))
        done.tintColor=AppTheme.defaltBlueColor
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
        
    }
    @objc func doneButtonAction(_ sender: UIBarButtonItem) {
        self.resignFirstResponder()
    }
    
    func setRightViewForTextField(_ rightImage:String? = .none, width: Int = 25) {
        self.rightViewMode = .always
        let rightPadingView = UIImageView.init(frame: CGRect(x: 10, y: 0, width: width, height: 15))
        if let imageName = rightImage {
            rightPadingView.image = UIImage(named: imageName)
        }
        rightPadingView.contentMode = .right//(width == 25) ? .center : .left
        self.rightView = rightPadingView
    }
    func setLeftViewForTextField(_ leftImage:String? = .none) {
        self.leftViewMode = .always
        let leftPadingView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        if let imageName = leftImage {
            leftPadingView.image = UIImage(named: imageName)
        }
        leftPadingView.contentMode = .center
        self.leftView = leftPadingView
    }
    
//    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
//        return action != #selector(UIResponderStandardEditActions.paste) || action != #selector(UIResponderStandardEditActions.copy) || action != #selector(UIResponderStandardEditActions.cut)
//    }
    
}

extension UIScrollView {
    
    func getViewTopOriginFrom(view:UIView) -> CGFloat {
        var topOriginY = self.frame.origin.y
        var subView = self.superview
        var parentView : UIView? = view
        while parentView != nil {
            if view == subView {
                parentView = nil
            } else {
                topOriginY += (subView?.frame.origin.y)!
            }
            subView = subView?.superview
        }
        return topOriginY
    }
}



//
//  PBPopupView.swift
//  BusinessApp
//
//  Created by Prakash Raj Jha on 22/01/18.
//  Copyright © 2018 PayTm. All rights reserved.
//

import UIKit

typealias MIPopupViewCloseCompletion = (_ index: Int, _ inView: MIPopupView?) -> Swift.Void

class MIPopupView: UIView {

    var closeCompletion : MIPopupViewCloseCompletion?
    var shouldRemoveOnTouch = true
    func innovate() { }
    
    func addMe(onView: UIView, onCompletion: MIPopupViewCloseCompletion?) {
        self.closeCompletion = onCompletion
        
        let v = AppDelegate.instance.window ?? onView
        
        self.frame = v.bounds
        v.addSubview(self)
        self.setNeedsLayout()
        self.alpha = 0.0
        UIView.animate(withDuration: 0.3) { self.alpha = 1.0 }
    }
    
    func addFromTop(onView: UIView,topHeight:CGFloat = 66, onCompletion: MIPopupViewCloseCompletion?) {
        self.removeFromSuperview()
        self.shouldRemoveOnTouch = false
        self.closeCompletion = onCompletion
        let frame = CGRect(x: 0, y: topHeight, width: kScreenSize.width, height: kScreenSize.height - topHeight)
        self.frame = frame
        onView.addSubview(self)
        self.setNeedsLayout()
        self.alpha = 0.0
        UIView.animate(withDuration: 0.2) { self.alpha = 1.0 }
    }
    
    func removeMe() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.0
            self.removeFromSuperview()
        }, completion: { (success: Bool) in
           
          // self.superview?.willRemoveSubview(self)
           // self.removeFromSuperview()
        })
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesEnded(touches, with: event)
//        if shouldRemoveOnTouch {
//            self.removeMe()
//        }
//    }
}

//
//  MIError404Popup.swift
//  MonsteriOS
//
//  Created by Piyush on 21/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIError404Popup: MIPopupView {
    
    static let shared = MIError404Popup.popup()
    class func popup() -> MIError404Popup {
        let header = UINib(nibName: "MIError404Popup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIError404Popup
        header.setUI()
        return header
    }
    
    func setUI() {
        let onView = kAppDelegate.window
        self.frame = onView!.bounds
        onView?.addSubview(self)
        self.setNeedsLayout()
        self.alpha = 0.0
    }
    
    func show() {
        self.alpha = 1.0
    }
    
    func hide() {
        self.alpha = 0.0
    }
    
    @IBAction func hide(_ sender: UIButton) {
        self.hide()
    }
}

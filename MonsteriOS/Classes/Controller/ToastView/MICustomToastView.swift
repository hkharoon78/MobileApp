//
//  MICustomToastView.swift
//  MonsteriOS
//
//  Created by Rakesh on 25/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

enum ToastPosition {
    case Top
    case Bottom
    case Center
}

@available(iOS 11.0, *)
class MICustomToastView: UIView {

    
    @IBOutlet var lbl_title:UILabel!
    @IBOutlet var lbl_message:UILabel!
    var title:String?
    var message:String?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    class var toastView : MICustomToastView {
           return UINib.init(nibName: "MICustomToastView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MICustomToastView
    }
    
    func viewconfig(title:String,message:String){
        self.removeFromSuperview()
        self.lbl_title.text = title
        self.lbl_message.text = message
        self.frame = CGRect(x: 0, y: 20, width: kScreenSize.width, height: 60)
        kAppDelegate.window?.addSubview(self)
        
        
        UIView.animate(withDuration: 3, animations: {
            self.frame.origin.y = 20
        }) { (status) in
            UIView.animate(withDuration: 5, animations: {
                self.frame.origin.y = 0
                self.removeFromSuperview()

            })
        }
    }
    
}

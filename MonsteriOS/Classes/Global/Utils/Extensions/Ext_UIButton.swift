//
//  Ext_UIButton.swift
//  MonsteriOS
//
//  Created by Monster on 16/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

extension UIButton {
    func showUI(titleColor:UIColor?, cornerRadius:CGFloat, borderWidth:CGFloat,borderColor:UIColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor  = borderColor.cgColor
        self.layer.borderWidth  = borderWidth
        if titleColor != nil {
            self.setTitleColor(titleColor, for: .normal)
        }
    }
    
    func showPrimaryBtn(fontSize:Int = 16) {
        
        self.layer.cornerRadius = CornerRadius.btnCornerRadius
        self.backgroundColor    = AppTheme.btnCTAGreenColor
        self.tintColor          = UIColor.white
        self.titleLabel?.font = UIFont.customFont(type: .Semibold, size: CGFloat(fontSize))
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    func showSecondaryBtnLayout(fontSize:Int = 16,bgColor:UIColor = Color.blueThemeColor) {
        self.layer.cornerRadius = CornerRadius.btnCornerRadius
        self.backgroundColor    = bgColor
        self.tintColor          = UIColor.white
        self.titleLabel?.font = UIFont.customFont(type: .Semibold, size: CGFloat(fontSize))
        self.setTitleColor(UIColor.white, for: .normal)
    }
    
    func showSecondaryBtn(ttl:String,borderColor:UIColor = Color.colorClearBtnBorder,titileColor:UIColor  = Color.colorLightDefault ) {
        self.layer.cornerRadius = CornerRadius.btnCornerRadius
        self.layer.borderWidth  = BorderWidth.btnBorderWidth
        self.layer.borderColor  = borderColor.cgColor
        self.backgroundColor    = UIColor.white
        self.titleLabel?.font   = UIFont.customFont(type: .Medium, size: 14)
        self.setTitle(ttl, for: .normal)
        self.setTitleColor(titileColor, for: .normal)
    }
    
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }
    func removeButtonBorderLayer(){
        let border = CALayer()
        border.backgroundColor = UIColor.white.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - 1, width:self.frame.size.width, height:1)
        self.layer.addSublayer(border)
    }
        
    func setUnAnimatedTitle(title: String?, for state: UIControl.State) {
        UIView.setAnimationsEnabled(false)
        
        setTitle(title, for: state)
        
        layoutIfNeeded()
        UIView.setAnimationsEnabled(true)
    }
    
}

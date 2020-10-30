//
//  Ext_UILabel.swift
//  BusinessApp
//
//  Created by Piyush Dwivedi on 16/01/18.
//  Copyright © 2018 PayTm. All rights reserved.
//

import UIKit

extension UILabel {
    func showAttributedTxtColor(str:String, with selectedColor: UIColor, defaultColor:UIColor = UIColor.black) {
        
//        let fontName = self.getBoldFontName()
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: [
            .font: UIFont(name: self.font.fontName, size: self.font.pointSize)!,
            .foregroundColor: defaultColor
            ])
        
        
        let rangeStr: NSRange? = (attributedString.string as NSString?)?.range(of: str)
        attributedString.addAttribute(.font, value: UIFont(name: self.font.fontName, size: self.font.pointSize)!, range: rangeStr!)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: selectedColor, range: rangeStr!)
        self.attributedText = attributedString
    }
    
    
    func showMultiAttributedTxtColor(multiStr:[String], with textColor: UIColor) {
        
        //        let fontName = self.getBoldFontName()
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: [
            .font: UIFont(name: self.font.fontName, size: self.font.pointSize)!,
            .foregroundColor: self.textColor
            ])
        
        for str in multiStr {
            let rangeStr: NSRange? = (attributedString.string as NSString?)?.range(of: str)
            attributedString.addAttribute(.font, value: UIFont(name: self.font.fontName, size: self.font.pointSize)!, range: rangeStr!)
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: rangeStr!)
            self.attributedText = attributedString
        }
    }
    
    func showAttributedTxt(boldString:String, with textColor: UIColor) {
        
        let fontName = self.getBoldFontName()
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: [
            .font: UIFont(name: self.font.fontName, size: self.font.pointSize)!,
            .foregroundColor: textColor
            ])
        
        let rangeStr: NSRange? = (attributedString.string as NSString?)?.range(of: boldString)
        attributedString.addAttribute(.font, value: UIFont(name: fontName, size: self.font.pointSize)!, range: rangeStr!)
        self.attributedText = attributedString
    }

    func showAttributedTxt(semibold:String) {
        
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: [
            .font: UIFont(name: self.font.fontName, size: self.font.pointSize) as UIFont? as Any,
            .foregroundColor: self.textColor
            ])
        
        let rangeStr: NSRange? = (attributedString.string as NSString?)?.range(of: semibold)
        attributedString.addAttribute(.font, value: UIFont.customFont(type: .Semibold, size: self.font.pointSize) as UIFont? as Any, range: rangeStr!)
        self.attributedText = attributedString
    }
    
    func showAttributedTxt(boldString:String) {
        
        let fontName = self.getBoldFontName()
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: [
            .font: UIFont(name: self.font.fontName, size: self.font.pointSize) as UIFont? as Any,
            .foregroundColor: self.textColor
            ])
        
        let rangeStr: NSRange? = (attributedString.string as NSString?)?.range(of: boldString)
        attributedString.addAttribute(.font, value: UIFont(name: fontName, size: self.font.pointSize) as UIFont? as Any, range: rangeStr!)
        self.attributedText = attributedString
    }
    
    func showAttributedMultiTxt(boldStringArr:[String]) {
        
        let fontName = self.getBoldFontName()
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: [
            .font: UIFont(name: self.font.fontName, size: self.font.pointSize) as UIFont? as Any,
            .foregroundColor: self.textColor
            ])
        
        for boldString in boldStringArr {
            let rangeStr: NSRange? = (attributedString.string as NSString?)?.range(of: boldString)
            attributedString.addAttribute(.font, value: UIFont(name: fontName, size: self.font.pointSize) as UIFont? as Any, range: rangeStr!)
            self.attributedText = attributedString
        }
    }
    
    func getBoldFontName() ->  String{
        var fontName = self.font.fontName
        if let range = fontName.range(of: "-") {
            fontName = String(fontName[(fontName.startIndex)..<range.lowerBound])
            fontName.append("-Bold")
        }
        return fontName
    }
    
    func show(text: NSAttributedString) {
        if text.length == 0 {
            self.attributedText = text
        }
    }
}



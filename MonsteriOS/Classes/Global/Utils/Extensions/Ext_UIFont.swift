//
//  Ext_UIFont.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import Foundation
import UIKit.UIFont

extension UIFont{
    class func customFont(type:FontName,size:CGFloat)-> UIFont {
        var newSize=size
//        if AppDelegate.isIPhone5(){
//            newSize -= 2
//        }
//        if AppDelegate.isIPhone6or7or8(){
//            newSize -= 1
//        }
////        if AppDelegate.isIPhone6or7or8Plus(){
////            newSize += 1
////        }
//        if AppDelegate.isIPhoneXorXs(){
//            newSize += 1
//        }
//        if AppDelegate.isIPhoneXmax(){
//            newSize += 2
//        }
        if let font = UIFont(name: type.name, size: newSize){
            return font
        }else{
            return UIFont.systemFont(ofSize: 14)
        }
    }
}

extension AppDelegate {
    class func isIPhone5 () -> Bool{
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 568.0
    }
    class func isIPhone6or7or8 () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 667.0
    }
    class func isIPhone6or7or8Plus () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 736.0
    }
    
    class func isIPhoneXorXs () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 812.0
    }
    class func isIPhoneXmax () -> Bool {
        return max(UIScreen.main.bounds.width, UIScreen.main.bounds.height) == 896.0
    }
}




enum SourceSansPro: String {
    case Regular
    case SemiBold
    
    var fontName: String {
        return "SourceSansPro-\(self.rawValue)"
    }
    
    func ofSize(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.fontName, size: size)!
    }
}

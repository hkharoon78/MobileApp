//
//  AKAlertController.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 15/01/19.
//  Copyright © 2019 Anupam Katiyar. All rights reserved.
//

import UIKit

@objc open class AKAlertController : NSObject {
    
    //==========================================================================================================
    // MARK: - Singleton
    //==========================================================================================================
    
    class var instance : AKAlertController {
        struct Static {
            static let inst : AKAlertController = AKAlertController ()
        }
        return Static.inst
    }
    
    //==========================================================================================================
    // MARK: - Private Functions
    //==========================================================================================================
    
    private func topMostController() -> UIViewController? {
        
        var presentedVC = UIApplication.shared.keyWindow?.rootViewController
        while let pVC = presentedVC?.presentedViewController
        {
            presentedVC = pVC
        }
        
        if presentedVC == nil {
            print("AKAlertController Error: You don't have any views set. You may be calling in viewdidload. Try viewdidappear.")
        }
        return presentedVC
    }
    
    
    //==========================================================================================================
    // MARK: - Class Functions
    //==========================================================================================================
    
    @discardableResult
    open class func alert(_ title: String) -> UIAlertController {
        return alert(title, message: "")
    }
    
    @discardableResult
    open class func alert(_ title: String? = nil, message: String) -> UIAlertController {
        return alert(title, message: message, acceptMessage: "OK", acceptBlock: {
            // Do nothing
        })
    }
    
    @discardableResult
    open class func alert(_ title: String? = nil, message: String? = nil, acceptMessage: String, acceptBlock: @escaping () -> ()) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let acceptButton = UIAlertAction(title: acceptMessage, style: .default, handler: { (action: UIAlertAction) in
            acceptBlock()
        })
        alert.addAction(acceptButton)
        
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult
    open class func alert(_ title: String? = nil, message: String? = nil, buttons:[String], tapBlock:((UIAlertController, UIAlertAction, Int) -> Void)?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    
    
    @discardableResult
    open class func alert(_ title: String? = nil, message: String? = nil, textFieldPlaceholders: [String], buttons:[String], tapBlock:((UIAlertController, UIAlertAction, Int) -> Void)?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert, textFieldPlaceholders: textFieldPlaceholders, buttons: buttons, tapBlock: tapBlock)
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    
    @discardableResult
    open class func actionSheet(_ title: String? = nil, message: String? = nil, sourceView: Any, actions: [UIAlertAction]) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.actionSheet)
        for action in actions {
            alert.addAction(action)
        }
        if let view = sourceView as? UIBarButtonItem {
            alert.popoverPresentationController?.barButtonItem = view
        }
        if let view = sourceView as? UIView {
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = view.bounds
        }
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        return alert
    }
    
    @discardableResult
    open class func actionSheet(_ title: String? = nil, message: String? = nil, sourceView: Any, buttons:[String], tapBlock:((UIAlertController, UIAlertAction, Int) -> Void)?) -> UIAlertController{
        var alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet, buttons: buttons, tapBlock: tapBlock)
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ){
            alert = UIAlertController(title: title, message: message, preferredStyle: .alert, buttons: buttons, tapBlock: tapBlock)
        }
        if let view = sourceView as? UIBarButtonItem {
            alert.popoverPresentationController?.barButtonItem = view
        }
        if let view = sourceView as? UIView {
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = view.bounds
        }
        instance.topMostController()?.present(alert, animated: true, completion: nil)
        
        return alert
    }
    
}


private extension UIAlertController {
    
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, textFieldPlaceholders: [String]? = nil, buttons:[String], tapBlock:((UIAlertController, UIAlertAction,Int) -> Void)?) {
        self.init(title: title, message: message, preferredStyle:preferredStyle)
        var buttonIndex = 0
        for buttonTitle in buttons {
            var preferredStyle: UIAlertAction.Style!
            switch buttonTitle.lowercased() {
            case "Remove profile picture".lowercased() :
                preferredStyle = .destructive
            case "cancel":
                preferredStyle = .cancel
            default:
                preferredStyle = .default
            }
            let action = UIAlertAction(title: buttonTitle, preferredStyle: preferredStyle, alert: self, buttonIndex: buttonIndex, tapBlock: tapBlock)
            buttonIndex += 1
            self.addAction(action)
        }
        
        guard let placeholders = textFieldPlaceholders else { return }
        for placeholder in placeholders {
            self.addTextField(configurationHandler: { (textField) in
                textField.placeholder = placeholder
                textField.isSecureTextEntry = placeholder.lowercased().contains("password")
            })
        }
    }
    
    
}



private extension UIAlertAction {
    convenience init(title: String?, preferredStyle: UIAlertAction.Style, alert: UIAlertController, buttonIndex:Int, tapBlock:((UIAlertController, UIAlertAction, Int) -> Void)?) {
        self.init(title: title, style: preferredStyle) {
            (action:UIAlertAction) in
            if let block = tapBlock {
                block(alert, action, buttonIndex)
            }
        }
    }
}

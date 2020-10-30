//
//  Ext_UIViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 05/11/18.
//  Copyright © 2018 Monster. All rights reserved.
// 

import UIKit
import DropDown
extension UIViewController {
    
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIViewController? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIViewController
    }
    
    func configureDropDown(dropDown: DropDown){
        dropDown.direction = .any
        dropDown.dismissMode = .onTap
        dropDown.cellHeight = 40
        dropDown.selectionBackgroundColor = .white
        dropDown.separatorColor = .lightGray
        dropDown.textFont=UIFont.customFont(type: .Regular, size: 14)
        dropDown.backgroundColor = .white
        dropDown.textColor=AppTheme.textColor
    }
    
    func hideNavigationBackBarButtonText() {
        self.navigationItem.backBarButtonItem?.title = ""
    }
    
    func loadJson(filename fileName: String) -> [String: AnyObject]?
    {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json")
        {
            if let data = NSData(contentsOf: url) {
                do {
                    let object = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
                    if let dictionary = object as? [String: AnyObject] {
                        return dictionary
                    }
                } catch {
                    print("Error!! Unable to parse  \(fileName).json")
                }
            }
            print("Error!! Unable to load  \(fileName).json")
        }
        return nil
    }
    
    func handleAPIError(errorParams:Any?,error:Error?) {
        DispatchQueue.main.async {
            
            if let responseParams = errorParams as? [String:Any] {
                if let errorMessage = responseParams["errorMessage"] as? String {
                    self.showAlert(title: "", message: errorMessage)
                }else{
                    self.showAlert(title: "", message: "We are sorry for the delay. We will get back soon.")
                }
            }else if let errorBody = error , errorBody.localizedDescription.count > 0 {
                self.showAlert(title: "", message: errorBody.localizedDescription)
                
            }else{
                self.showAlert(title: "", message: "We are sorry for the delay. We will get back soon.")
            }
        }
        
    }

    
    func toastView(messsage : String, isErrorOccured:Bool = true ,successComplitionHandler: (()->Void)? = nil){
        
        if (self.view.viewWithTag(9009)) != nil {
            return
        }
        if messsage.withoutWhiteSpace().isEmpty {
            return
        }
        let topSpace:CGFloat?
        if #available(iOS 11.0, *) {
            topSpace = self.view.safeAreaInsets.top
        } else {
            topSpace = self.topLayoutGuide.length
        }
        let heightlbl = messsage.height(withConstrainedWidth: kScreenSize.width, font: UIFont.customFont(type: .Regular, size: 14))
        let rectView = CGRect(x:0, y:0, width: kScreenSize.width,  height : heightlbl+30)
        
        let toastView = UIView(frame:rectView)
        let imgView = UIImageView.init(frame: CGRect(x:kScreenSize.width-35, y:(heightlbl+30)/2-12, width: 25,  height :25))
        if isErrorOccured  {
            toastView.backgroundColor =  UIColor.init(hex: "e30000") //
            imgView.image = UIImage(named: "icon-wrong")
        }else{
            toastView.backgroundColor =  UIColor.init(hex: "117869") //
            imgView.image = UIImage(named: "icon-right")
        }
        toastView.tag = 9009
        
        imgView.contentMode = .scaleAspectFit
        toastView.addSubview(imgView)
        
        let rectLbl = CGRect(x:8, y:0, width: kScreenSize.width-40,  height : heightlbl+30)
        let toastLabel = UILabel(frame:rectLbl)
        toastLabel.backgroundColor =  .clear //UIColor.init(hex: "4bca81") //
        toastLabel.textColor = .white
        toastLabel.textAlignment = .center
        toastLabel.tag = 455
        toastLabel.font = UIFont.customFont(type: .Regular, size: 14)
        // toastLabel.textAlignment = NSTextAlignment.center
        toastLabel.numberOfLines = 0
        let padding = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        
        toastLabel.drawText(in:rectLbl.inset(by: padding) )
        toastLabel.text = " \(messsage) "
        toastView.addSubview(toastLabel)
        self.view.addSubview(toastView)
        toastView.alpha = 1.0
        UIView.animate(withDuration: 0.5, animations: {
            toastView.frame.origin.y = topSpace!
        }) { (status) in
            UIView.animate(withDuration: Double(messsage.components(separatedBy: " ").count)*0.25, delay: 0.4, options: UIView.AnimationOptions.curveEaseOut, animations: {
                toastView.alpha = 0.6
            }, completion: { (status) in
                if !isErrorOccured {
                    successComplitionHandler?()
                }
                toastView.removeFromSuperview()
            })
        }
    }
    
    func showPopUpView(title:String = "",message:String,primaryBtnTitle:String,secondaryBtnTitle:String = "",ortext:String = "",hideCloseBtn:Bool = true, completionHandler:@escaping ((_ primaryBtnClicked:Bool)-> Void)) {
        let vPopup = MIJobPreferencePopup.popup()
        vPopup.closeBtn.isHidden = hideCloseBtn
        vPopup.setViewWithTitle(title: title, viewDescriptionText:  message, or: ortext, primaryBtnTitle: primaryBtnTitle, secondaryBtnTitle:secondaryBtnTitle)
        vPopup.completionHandeler = {
            completionHandler(true)
        }
        vPopup.cancelHandeler = {
            completionHandler(false)

        }
        vPopup.addMe(onView: self.view, onCompletion: nil)
  
    }
}


extension UIViewController {
    
    var controllerName :String {
        let name = NSStringFromClass(self.classForCoder)
        return name
    }
    
    var isModal: Bool {
        
        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController
        
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar || false
    }
    
    
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }


    func getVisibleViewController(_ rootViewController: UIViewController? = nil) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
    func getSiteCountryISOCode() -> (isoCode:String,countryPhoneCode:String) {
        let site = AppDelegate.instance.site
        let sourceCountryISOCode = site?.defaultCountryDetails.isoCode ?? ""
        let mobileCountryCode = site?.defaultCountryDetails.callPrefix.stringValue ?? ""
        return (sourceCountryISOCode,mobileCountryCode)
    }
}



extension UIApplication {
    
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}


extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

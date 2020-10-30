//
//  Ext_UIView.swift
//  MonsteriOS
//
//  Created by Monster on 22/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

let kPlaceHolderIconTag = 990088
var navigateVc:UIViewController?
var navigateAction:NavigateAction = .none
var navigateJobId:String?
var navigateStartValue:String?

enum NavigateAction{
    case apply
    case save
    case createAlert
    case followCompany
    case followRecruiter
    case deepUrlCreateAlert
    case deepProfileUrl
    case none
}
extension UIView {

    func circular(_ aBorder: CGFloat, borderColor: UIColor?) {
        self.roundCorner(aBorder, borderColor: borderColor, rad: self.bounds.size.height/2.0)
    }
    
    func roundCorner(_ aBorder: CGFloat, borderColor: UIColor?, rad: CGFloat) {
        self.layer.masksToBounds = true;
        self.layer.cornerRadius = rad
        self.clipsToBounds = true
        
        self.layer.borderWidth = aBorder
        if let color = borderColor {
            self.layer.borderColor = color.cgColor
        }
    }
    
    func addShadow(opacity:CGFloat = 0.2) {
        self.layer.shadowOpacity = 1
        self.layer.shadowColor   = UIColor.black.withAlphaComponent(opacity).cgColor
        self.layer.shadowRadius  = 1
        self.layer.shadowOffset  = Shadow.shadowViewOffset
        self.layer.masksToBounds = false
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func setupView(){
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [ UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func addPlaceHolderIcon(_ aTxt: String,font:UIFont, bgColor: UIColor = UIColor(hex: "f4f6f8")) {
        self.removePlaceHolderIcon()
        let placLbl = UILabel(frame: self.bounds)
        placLbl.backgroundColor = bgColor
        self.addSubview(placLbl)
        placLbl.tag = kPlaceHolderIconTag
        placLbl.text = aTxt.displaySortText().uppercased()
        placLbl.textAlignment = .center
        placLbl.textColor = AppTheme.defaltBlueColor
        placLbl.font = font
    }
    
    func removePlaceHolderIcon() {
        if let vv = self.viewWithTag(kPlaceHolderIconTag) {
            vv.removeFromSuperview()
        }
    }
    
//    func strtAnimating() {

//        kActivityIndicator.obj  = self
//        let kActivityView  = kActivityIndicator.activityIndicatorView(onView: self)

        
//        if kActivityView.obj != nil {
//
//        } else {
//            kActivityView.obj = OnView
//            OnView.addSubview(self)
//            self.bringSubviewToFront(OnView)
//        }
//        self.bringSubviewToFront(kActivityView)
//        self.startActivityIndicator()
//    }
    
//    func stopAnimation() {
//        let kActivityView  = kActivityIndicator.activityIndicator
//        self.stopActivityIndicator()
//    }
}

extension UIViewController {
    func popupAlert(title: String?, message: String?, actionTitles:[String?], actions:[((UIAlertAction) -> Void)?]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
//    func showAlert(title: String?, message: String?, actionTitles:[String?] = ["OK"]) {
//        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
//
//        for actionTtl in actionTitles {
//            let action1 = UIAlertAction(title: actionTtl, style: .default) { (action:UIAlertAction) in
////                self.dismiss(animated: true, completion: nil)
//            }
//            alertController.addAction(action1)
//        }
//
//        self.present(alertController, animated: true, completion: nil)
//    }
//    func showAlert(title: String?, message: String?,successCompletionHandler:(()->Void)?) {
//        DispatchQueue.main.async {
//            self.toastView(messsage: message ?? "",isErrorOccured: true,successCompletionHandler:successCompletionHandler )
//
//        }
//    }
    
//    func showAlert(title: String?, message: String?,successComplitionHandler: (()->Void)? = nil) {
//        DispatchQueue.main.async {
//            self.toastView(messsage: message ?? "",isErrorOccured: true )
//
//        }
//    }
    func showAlert(title: String?, message: String?,isErrorOccured:Bool = true,successComplitionHandler: (()->Void)? = nil) {
        DispatchQueue.main.async {
            self.toastView(messsage: message ?? "",isErrorOccured: isErrorOccured,successComplitionHandler: successComplitionHandler)
            
        }
    }
    
    func showLoginAlert(msg:String?,navaction:NavigateAction = .none,jobId:String? = nil){
        
        self.showPopUpView( message: msg ?? "Please log in to continue.", primaryBtnTitle: "Log in", secondaryBtnTitle: "Cancel") { (isPrimarBtnClicked) in
                       if isPrimarBtnClicked {
                           for vc in self.navigationController?.viewControllers ?? []{
                               if let vc=self as? MIJobDetailsViewController{
                                   vc.stopActivityIndicator()
                               }
                               if let langinVc = vc as? MILandingViewController{
                                   navigateVc=self
                                   navigateAction=navaction
                                   navigateJobId=jobId
                                  self.navigationController?.popToRootViewController(animated: false)
                                   langinVc.applyLoginFlag=true
                                   break
                               }
                           }
                       }else{
                           if let vc=self as? MIJobDetailsViewController{
                                          vc.stopActivityIndicator()
                                      }
                                      navigateVc=nil
                                      navigateAction = .none
                                      navigateJobId=nil
                                      navigateStartValue=nil
                       }
        }
        
        
//        let vPopup = MIJobPreferencePopup.popup()
//        vPopup.closeBtn.isHidden = true
//        vPopup.setViewWithTitle(title: "", viewDescriptionText:  msg ?? "You must login to continue.", or: "", primaryBtnTitle: "OK", secondaryBtnTitle: "Cancel")
//        vPopup.completionHandeler = {
//            for vc in self.navigationController?.viewControllers ?? []{
//                if let vc=self as? MIJobDetailsViewController{
//                    vc.stopActivityIndicator()
//                }
//                if let langinVc = vc as? MILandingViewController{
//                    navigateVc=self
//                    navigateAction=navaction
//                    navigateJobId=jobId
//                   self.navigationController?.popToRootViewController(animated: false)
//                    langinVc.applyLoginFlag=true
//                    break
//                }
//            }
//        }
//        vPopup.cancelHandeler = {
//            if let vc=self as? MIJobDetailsViewController{
//                           vc.stopActivityIndicator()
//                       }
//                       navigateVc=nil
//                       navigateAction = .none
//                       navigateJobId=nil
//                       navigateStartValue=nil
//        }
//        vPopup.addMe(onView: self.view, onCompletion: nil)
        
        
//        let alertController = UIAlertController(title:nil, message: msg, preferredStyle: .alert)
//        let okAction=UIAlertAction(title: "OK", style: .destructive) { (action) in
//            for vc in self.navigationController?.viewControllers ?? []{
//                if let vc=self as? MIJobDetailsViewController{
//                    vc.stopActivityIndicator()
//                }
//                if let langinVc = vc as? MILandingViewController{
//                    navigateVc=self
//                    navigateAction=navaction
//                    navigateJobId=jobId
//                   self.navigationController?.popToRootViewController(animated: false)
//                    langinVc.applyLoginFlag=true
//                    break
//                }
//            }
//
//
//        }
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{(action) in
//            if let vc=self as? MIJobDetailsViewController{
//                vc.stopActivityIndicator()
//            }
//            navigateVc=nil
//            navigateAction = .none
//            navigateJobId=nil
//            navigateStartValue=nil
//
//        }))
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
    }
    
    func logoutToLogin(){
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            
            let alertMsg=AppDelegate.instance.authInfo.accessToken.count != 0 ? "Your Session is Expire. Kindly Login Again to Continue" : "Please log in to continue."

            self.showPopUpView(message: alertMsg, primaryBtnTitle: "Log in") { (isPrimarBtnClicked) in
                if isPrimarBtnClicked {
                    
                    
                    for vc in self.navigationController?.viewControllers ?? []{
                        if let vc=self as? MIJobDetailsViewController{
                            vc.stopActivityIndicator()
                        }
                        if let langinVc = vc as? MILandingViewController{
                            CommonClass.deleteUserLogs()
                            canCallCardAPI = true
                            AppUserDefaults.removeValue(forKey: .UserData)
                            self.navigationController?.popToRootViewController(animated: false)
                            langinVc.applyLoginFlag=true
                            break
                        }
                    }
                    if self.tabBarController != nil{
                        canCallCardAPI = true
                        CommonClass.deleteUserLogs()
                        AppUserDefaults.removeValue(forKey: .UserData)
                        let rootVc = MISplashViewController()
                        let nav = MINavigationViewController(rootViewController: rootVc)
                        if let landVc=rootVc.landingNavigation.viewControllers.first as? MILandingViewController{
                            landVc.navigationItem.title = ""
                            landVc.applyLoginFlag=true
                        }
                        AppDelegate.instance.window?.rootViewController = nav
                        AppDelegate.instance.window?.makeKeyAndVisible()
                    }
                    
                }
            }
            
            
            
//            let vPopup = MIJobPreferencePopup.popup()
//            vPopup.closeBtn.isHidden = true
//            vPopup.setViewWithTitle(title: "", viewDescriptionText:  alertMsg , or: "", primaryBtnTitle: "OK", secondaryBtnTitle: "")
//            vPopup.completionHandeler = {
//
//
//                for vc in self.navigationController?.viewControllers ?? []{
//                    if let vc=self as? MIJobDetailsViewController{
//                        vc.stopActivityIndicator()
//                    }
//                    if let langinVc = vc as? MILandingViewController{
//                        CommonClass.deleteUserLogs()
//                        canCallCardAPI = true
//                        AppUserDefaults.removeValue(forKey: .UserData)
//                        self.navigationController?.popToRootViewController(animated: false)
//                        langinVc.applyLoginFlag=true
//                        break
//                    }
//                }
//                if self.tabBarController != nil{
//                    canCallCardAPI = true
//                    CommonClass.deleteUserLogs()
//                    AppUserDefaults.removeValue(forKey: .UserData)
//                    let rootVc = MISplashViewController()
//                    let nav = MINavigationViewController(rootViewController: rootVc)
//                    if let landVc=rootVc.landingNavigation.viewControllers.first as? MILandingViewController{
//                        landVc.navigationItem.title = ""
//                        landVc.applyLoginFlag=true
//                    }
//                    AppDelegate.instance.window?.rootViewController = nav
//                    AppDelegate.instance.window?.makeKeyAndVisible()
//                }
//
//            }
//            vPopup.cancelHandeler = {
//
//            }
//            vPopup.addMe(onView: self.view, onCompletion: nil)
            
            
            
            
            
            
//
//            let alertMsg=AppDelegate.instance.authInfo.accessToken.count != 0 ? "Your Session is Expire. Kindly Login Again to Continue" : "Kindly Login to Continue"
//
//            let alert=UIAlertController(title: "", message: alertMsg, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
//                for vc in self.navigationController?.viewControllers ?? []{
//                    if let vc=self as? MIJobDetailsViewController{
//                        vc.stopActivityIndicator()
//                    }
//                    if let langinVc = vc as? MILandingViewController{
//                        CommonClass.deleteUserLogs()
//                        canCallCardAPI = true
//                        AppUserDefaults.removeValue(forKey: .UserData)
//                        self.navigationController?.popToRootViewController(animated: false)
//                        langinVc.applyLoginFlag=true
//                        break
//                    }
//                }
//                if self.tabBarController != nil{
//                    canCallCardAPI = true
//                    CommonClass.deleteUserLogs()
//                    AppUserDefaults.removeValue(forKey: .UserData)
//                    let rootVc = MISplashViewController()
//                    let nav = MINavigationViewController(rootViewController: rootVc)
//                    if let landVc=rootVc.landingNavigation.viewControllers.first as? MILandingViewController{
//                        landVc.navigationItem.title = ""
//                        landVc.applyLoginFlag=true
//                    }
//                    AppDelegate.instance.window?.rootViewController = nav
//                    AppDelegate.instance.window?.makeKeyAndVisible()
//                }
//
//            }))
//            self.present(alert, animated: true, completion: nil)
        }
      
    }
    
}

extension UIView {
    
    func tableViewCell() -> UITableViewCell? {
        var tableViewcell : UIView? = self
        while(tableViewcell != nil)
        {
            if tableViewcell! is UITableViewCell {
                break
            }
            tableViewcell = tableViewcell!.superview
        }
        return tableViewcell as? UITableViewCell
    }
    
    
    func tableViewIndexPath(_ tableView: UITableView) -> IndexPath? {
        if let cell = self.tableViewCell() {
            return tableView.indexPath(for: cell)
        }
        else {
            return nil
        }
    }
    
}


extension UIView {
    
    @IBInspectable var cornerRad: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var colorBorder: UIColor {
        get {
            guard let color = layer.borderColor else {
                return UIColor.clear
            }
            return UIColor(cgColor: color)
        }
        set {
            layer.borderColor = newValue.cgColor
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var widthBorder: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}


extension UIView {
    
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set {
            self.frame.origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set {
            self.frame.origin.y = newValue
        }
    }
    
    var midX: CGFloat {
        return self.frame.midX
    }
    
    var maxX: CGFloat {
        return self.frame.maxX
    }
    
    var midY: CGFloat {
        return self.frame.midY
    }
    
    var maxY: CGFloat {
        return self.frame.maxY
    }
    
    var width: CGFloat {
        get {
            return self.frame.size.width
        } set {
            self.frame.size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return self.frame.size.height
        } set {
            self.frame.size.height = newValue
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set {
            self.frame.size = newValue
        }
    }
    
}

extension UIScreen {
    
    static var width: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    static var height: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    static var size: CGSize {
        return UIScreen.main.bounds.size
    }
}

// MARK: - Show hide animations in StackViews
extension UIView {
    
    func hideAnimated(in stackView: UIStackView) {
        if !self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.alpha = 0
                    self.isHidden = true
                    stackView.layoutIfNeeded()
            },
                completion: nil
            )
        }
    }
    
    func showAnimated(in stackView: UIStackView) {
        if self.isHidden {
            UIView.animate(
                withDuration: 0.35,
                delay: 0,
                usingSpringWithDamping: 0.9,
                initialSpringVelocity: 1,
                options: [],
                animations: {
                    self.alpha = 1
                    self.isHidden = false
                    stackView.layoutIfNeeded()
            },
                completion: nil
            )
        }
    }
}

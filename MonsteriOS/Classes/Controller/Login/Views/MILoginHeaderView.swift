//
//  MILoginHeaderView.swift
//  MonsteriOS
//
//  Created by Monster on 15/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

protocol MILoginHeaderViewDelegate:class {
    func fbClicked()
    func gmailClicked()
    
    @available(iOS 13.0, *)
    func appleClicked()
}

class MILoginHeaderView: UIView {
    
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
       
    var signinView = UIView()
        
    weak var delegate:MILoginHeaderViewDelegate?
    
    class var header:MILoginHeaderView {
        let header = UINib(nibName: "MILoginHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MILoginHeaderView
        header.btnFacebook.showUI(titleColor: nil, cornerRadius: CornerRadius.btnCornerRadius, borderWidth: BorderWidth.btnBorderWidth, borderColor: Color.colorClearBtnBorder)
        header.btnGoogle.showUI(titleColor: nil, cornerRadius: CornerRadius.btnCornerRadius, borderWidth: BorderWidth.btnBorderWidth, borderColor: Color.colorClearBtnBorder)
        header.btnApple.showUI(titleColor: nil, cornerRadius: CornerRadius.btnCornerRadius, borderWidth: BorderWidth.btnBorderWidth, borderColor: Color.colorClearBtnBorder)
        return header
    }
    
    func show(topTtl:String? = nil, bottom btTtl:String? = nil, topColor:UIColor? = nil, btColor:UIColor = Color.colorClearBtnBorder)
    {
        if let topTtl = topTtl {
            self.topLbl.text = topTtl
        }
        if let btTtl = btTtl {
            self.bottomLbl.text = btTtl
        }
        if let topColor = topColor {
            self.topLbl.textColor = topColor
        }
        self.bottomLbl.textColor = btColor
        
        if #available(iOS 13.0, *) {
            self.btnApple.isHidden = false
            btnApple.addTarget(self, action: #selector(handleLogInWithAppleIDButton), for: .touchUpInside)
        } else {
            self.btnApple.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        signinView.center = bottomLbl.center
//        var frame = signinView.frame
//        frame.origin.y = bottomLbl.maxY + 10
//        signinView.frame = frame
    }
    
    //MARK:- Actions
    @available(iOS 13.0, *)
    @IBAction func handleLogInWithAppleIDButton() {
        self.delegate?.appleClicked()
    }
    
    @IBAction func fbClicked(_ sender: UIButton) {
        FBSDKLoginManager().logOut()
        self.delegate?.fbClicked()
    }
    
    @IBAction func gmailClicked(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signOut()
        self.delegate?.gmailClicked()
    }
}

protocol MILoginFooterViewDelegate:class {
    func footerBtnClicked(_ sender: AKLoadingButton)
}

class MILoginFooterView: UIView {
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak private var btnAgree: UIButton!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    weak var delegate:MILoginFooterViewDelegate?
    
    class var header:MILoginFooterView {
        let header = UINib(nibName: "MILoginHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! MILoginFooterView
        header.btn.showPrimaryBtn()
        return header
    }
    
    func show(ttl:String, shouldHideAgreeBtn:Bool  = true, agreTitle:String = "Agree to T&C",imgName:String = "agree") {
        btn.setTitle(ttl, for: .normal)
        btnAgree.isHidden = shouldHideAgreeBtn
        btnAgree.setTitle(agreTitle, for: .normal)
        btnAgree.setImage(UIImage(named: imgName), for: .normal)
    }
    
    func set(lead:Int, trail:Int) {
        leadingConstraint.constant  = CGFloat(lead)
        trailingConstraint.constant = CGFloat(trail)
    }
    
    @IBAction func btnClicked(_ sender: AKLoadingButton) {
        self.delegate?.footerBtnClicked(sender)
    }
}

class MILoginORView: UIView {
    
    class var header:MILoginORView {
        let header = UINib(nibName: "MILoginHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil)[2] as! MILoginORView
        return header
    }
    
}


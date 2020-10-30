//
//  MISocialView.swift
//  MonsteriOS
//
//  Created by Rakesh on 26/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MISocialView: UIView {

    @IBOutlet weak var lbl_title : UILabel!
    //@IBOutlet weak var lbl_description : UILabel!
    @IBOutlet weak var btn_facebook : UIButton!
    @IBOutlet weak var btn_google : UIButton!
    @IBOutlet weak var btn_apple : UIButton!

    @IBOutlet weak var helpButton: UIButton!
    var callBackForToolTip : ((UIButton) -> Void)?
    var callBackForSocial : ((String) -> Void)?
    
    class var header:MISocialView {
        let header = UINib(nibName: "MISocialView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MISocialView
        return header
    }
    
    func createBorderForSocialBtn() {
        
        btn_facebook.roundCorner(1, borderColor: UIColor.init(hex: "c4cdd5"), rad: 4)
        btn_google.roundCorner(1, borderColor: UIColor.init(hex: "c4cdd5"), rad: 4)
        btn_apple.roundCorner(1, borderColor: UIColor.init(hex: "c4cdd5"), rad: 4)
        
        if #available(iOS 13.0, *) {
            self.btn_apple.isHidden = false
        } else {
            self.btn_apple.isHidden = true
        }
    }
    @IBAction func facebookBtnClicked(){
        if let callBack = self.callBackForSocial {
            callBack("facebook")
        }
    }
    @IBAction func googlePlusBtnClicked(){
        if let callBack = self.callBackForSocial {
            callBack("google")
        }
    }
    
    @IBAction func appleButtonClicked(_ sender: Any) {
        if let callBack = self.callBackForSocial {
            callBack("apple")
        }
    }
    
    @IBAction func helpButtonAction(_ sender: UIButton) {
        self.helpButton.setImage(#imageLiteral(resourceName: "help"), for: .normal)
        self.callBackForToolTip?(sender)
    }
    
}


class MIRegisterBottomView : UIView {
    
    @IBOutlet weak var register_Btn: UIButton!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var trmsCondition_Lbl: UILabel!
    var didTapOnlabl:((Bool, AgreementType)->Void)?
    var registerBtnCallBack:((UIButton)->Void)?
    var checkBoxSelectionAction : ((Bool, MIRegisterBottomView)->Void)?

    class var footerView:MIRegisterBottomView {
        let header = UINib(nibName: "MISocialView", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! MIRegisterBottomView
        return header
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    func showPrivacyPolicyContent() {
        let titleString=NSMutableAttributedString(string:RegisterViewStoryBoardConstant.registerAggrement, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.appGreyColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 11)])
        let privacy=NSAttributedString(string:RegisterViewStoryBoardConstant.termsAndConditions, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.defaltBlueColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 11)])
        titleString.append(privacy)
        let terms=NSAttributedString(string:RegisterViewStoryBoardConstant.privacyPolicy, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.defaltBlueColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 11)])
        titleString.append(terms)
        let normalTerms=NSMutableAttributedString(string:RegisterViewStoryBoardConstant.normalterms, attributes: [NSAttributedString.Key.foregroundColor:AppTheme.appGreyColor,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 11)])
        titleString.append(normalTerms)
        
        //  trmsCondition_Lbl.numberOfLines=0
        trmsCondition_Lbl.attributedText=titleString
        trmsCondition_Lbl.isUserInteractionEnabled = true
        let tapGest=UITapGestureRecognizer(target: self, action: #selector(MIRegisterBottomView.attributedTextTapped(_:)))
        tapGest.numberOfTapsRequired=1
        self.trmsCondition_Lbl.addGestureRecognizer(tapGest)
        
        register_Btn.showPrimaryBtn()
        register_Btn.setTitle(RegisterViewStoryBoardConstant.register, for: .normal)
    }

    @objc func attributedTextTapped(_ sender:UITapGestureRecognizer){
        if let termsCondition = self.trmsCondition_Lbl.text?.range(of:RegisterViewStoryBoardConstant.termsAndConditions)?.nsRange{
            if sender.didTapAttributedTextInLabel(label: self.trmsCondition_Lbl, inRange: termsCondition) {
                // Substring tapped
                if let action=self.didTapOnlabl{
                    action(true, .Terms)
                }
            }
        }
        if let privacyPolicy = self.trmsCondition_Lbl.text?.range(of:RegisterViewStoryBoardConstant.privacyPolicy)?.nsRange{
            if sender.didTapAttributedTextInLabel(label: self.trmsCondition_Lbl, inRange: privacyPolicy) {
                // Substring tapped
                if let action=self.didTapOnlabl{
                    action(true, .Privacy)
                }
            }
        }
        
    }
    
    @IBAction func registerBtnClicked(_ sender:UIButton) {
        if let callBack = self.registerBtnCallBack {
            callBack(sender)
        }
        
    }
    
    @IBAction func checkboxButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        checkBoxSelectionAction?(sender.isSelected, self)
    }
    
    
}


enum AgreementType {
    case Privacy
    case Terms
    case Default
}

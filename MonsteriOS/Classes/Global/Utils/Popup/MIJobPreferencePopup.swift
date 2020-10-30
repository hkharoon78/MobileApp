//
//  MIJobPreferencePopup.swift
//  MonsteriOS
//
//  Created by Piyush on 18/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
enum PopUpOptionSelection {
    case Completed
    case Ignored
    case Close
}

internal typealias NilCallback = (()->Void)

protocol JobPreferencePopUpDelegate {
    func optionCompleteIgnoredSelected(popSelection:PopUpOptionSelection, popup: MIPopupView)
}
class MIJobPreferencePopup: MIPopupView {
    
    @IBOutlet weak var btn_Primary: UIButton!
    @IBOutlet weak var btn_secondary: UIButton!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_description: UILabel!

    @IBOutlet weak var orLabel: UILabel?
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    var delegate : JobPreferencePopUpDelegate? = nil

     var completionHandeler: NilCallback?
     var cancelHandeler: NilCallback?

    class func popup(
        horizontalButtons: Bool = false,
        completionHandeler: NilCallback? = nil,
        cancelHandeler: NilCallback? = nil ) -> MIJobPreferencePopup {
        
        let horizontal = horizontalButtons ? 1 : 0
        let header = UINib(nibName: "MIJobPreferencePopup", bundle: nil).instantiate(withOwner: nil, options: nil)[horizontal] as! MIJobPreferencePopup
        header.setUI(horizontalButtons)
        header.topView.roundCorner(0, borderColor: nil, rad: 8)
        
        header.completionHandeler = completionHandeler
        header.cancelHandeler = cancelHandeler

        return header
    }
    
    func setUI(_ h: Bool) {
        if h {
            btn_Primary.roundCorner(1, borderColor: UIColor(hex: 0x1a95e0), rad: CornerRadius.btnCornerRadius)
            btn_secondary.roundCorner(1, borderColor: UIColor(hex: 0x1a95e0), rad: CornerRadius.btnCornerRadius)
        } else {
            btn_Primary.roundCorner(1, borderColor: UIColor(hex: 0x1a95e0), rad: CornerRadius.btnCornerRadius)
            btn_secondary.roundCorner(0, borderColor: UIColor(hex: 0x1a95e0), rad: CornerRadius.btnCornerRadius)
        }
    }
    
    func setViewWithTitle(title: String, viewDescriptionText: String, or: String = "", primaryBtnTitle: String, secondaryBtnTitle: String,  secondaryBtnTextColor: UIColor? = nil){
        
        self.lbl_title.text = title
        self.lbl_description.text = viewDescriptionText
        self.orLabel?.text = or
        
        btn_Primary.setTitle(primaryBtnTitle, for: .normal)
        btn_Primary.isHidden = (primaryBtnTitle.count == 0)
        
        btn_secondary.setTitle(secondaryBtnTitle, for: .normal)
        btn_secondary.isHidden = (secondaryBtnTitle.count == 0)

        if let color = secondaryBtnTextColor {
            btn_secondary.setTitleColor(color, for: .normal)
        }
        self.orLabel?.isHidden = or.isEmpty
        self.lbl_description.isHidden = viewDescriptionText.isEmpty
        self.lbl_title.isHidden = title.isEmpty
    }
    
    @IBAction func completeProfileClicked(_ sender: UIButton) {
        self.removeMe()
        if delegate != nil{
            self.delegate?.optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection.Completed, popup: self)
        }
        self.completionHandeler?()
    }
    
    @IBAction func ignoreClicked(_ sender: UIButton) {
        self.removeMe()
        if delegate != nil{
            self.delegate?.optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection.Ignored, popup: self)
        }
        self.cancelHandeler?()
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.removeMe()
        if delegate != nil{
            self.delegate?.optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection.Close, popup: self)
        }
    }
    
}

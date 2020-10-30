//
//  MIBottomButtonView.swift
//  MonsteriOS
//
//  Created by Rakesh on 18/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIBottomButtonView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

class MISingleButtonView : UIView {
    
    @IBOutlet weak var btn_delete : UIButton!
    @IBOutlet var btn_leadingConstraint : NSLayoutConstraint!
    @IBOutlet var btn_trailingConstairnt : NSLayoutConstraint!


    var btnActionCallBack : ((Int) -> Void)?
    var sectionIndex = 0
    class var singleBtnView : MISingleButtonView {
        return  UINib(nibName: "MIBottomButtonView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MISingleButtonView

    }
    
    func setBtnAttributes(cornerRadius:CGFloat,borderWidth:CGFloat,borderColor:UIColor){
         self.btn_delete.roundCorner(borderWidth, borderColor: borderColor, rad: cornerRadius)
    }
    
    @IBAction func btnClickedAction(_ sender : UIButton) {
        if let callBack = self.btnActionCallBack {
            callBack(sectionIndex)
        }
    }
}

class MIDoubleButtonView : UIView {
    
    @IBOutlet weak var btn_addAnother : UIButton!
    @IBOutlet weak var btn_next : UIButton!
    @IBOutlet weak var nxtBtnBgView_TopConstraint : NSLayoutConstraint!
    @IBOutlet var btn_leadingConstraint : NSLayoutConstraint!
    @IBOutlet var btn_trailingConstairnt : NSLayoutConstraint!
    @IBOutlet var btnSecondryHtConstraint : NSLayoutConstraint!
    @IBOutlet var nxtBtnTopConsttaint : NSLayoutConstraint!
    @IBOutlet var btnAddAnother_leadingConstraint : NSLayoutConstraint!
    @IBOutlet var btnAddAnother_trailingConstairnt : NSLayoutConstraint!

    var addAnotherCallBack  : (() -> Void)?
    var nextBtnCallBack : (() -> Void)?
    
    class var doubleBtnView : MIDoubleButtonView {
        return  UINib(nibName: "MIBottomButtonView", bundle: nil).instantiate(withOwner: nil, options: nil)[1] as! MIDoubleButtonView
        
    }
    
    func setTitleForAddAnother(title:String) {
        self.btn_addAnother.setTitle(title, for: .normal)
    }
    
    @IBAction func addAnotherBtnClicked(_ sender : UIButton) {
        if let callBack = self.addAnotherCallBack {
            callBack()
        }
    }
    @IBAction func nextBtnClicked(_ sender : UIButton){
        //if let callBack = self.nextBtnCallBack {
               self.nextBtnCallBack?()
        //}
    }
}

//
//  MITextFieldTableViewCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 11/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MITextFieldTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var secondryTextField: RightViewTextField!
    @IBOutlet weak var primaryTextField: RightViewTextField!
    @IBOutlet weak var verifyBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var secondryErrorLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var secondryTFWidth: NSLayoutConstraint?
    
    @IBOutlet weak var btnCovidSituation: UIButton!
    @IBOutlet weak var heightbtnCovidSituation: NSLayoutConstraint!
    @IBOutlet weak var bottomBtnCovidSituation: NSLayoutConstraint!
    var covidSituationCallBack: ((Bool)->Void)?
    
    var primaryTextFieldAction: ((UITextField)->())?
    var secondryTextFieldAction: ((UITextField)->(Bool))?
    var showPopUpCallBack : (()->Void)?

    var eyeIcon:UIButton?
    var hidePasswordCallBack : ((Bool)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        self.helpButton.isHidden = true
        
        self.btnCovidSituation.isHidden = true
        self.heightbtnCovidSituation.constant = 0
        self.bottomBtnCovidSituation.constant = 0
        
        self.primaryTextField.setRightViewForTextField("darkRightArrow")
        self.secondryTextField.setRightViewForTextField("darkRightArrow")//, width: 15)

        primaryTextField.layer.borderColor  = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        secondryTextField.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)

        primaryTextField.layer.borderWidth = 1
        secondryTextField.layer.borderWidth = 1
        
        primaryTextField.layer.cornerRadius = 5
        secondryTextField.layer.cornerRadius = 5
        
        self.titleLabel.textColor = AppTheme.appGreyColor
        primaryTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .editingDidBegin)
        primaryTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
        primaryTextField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .valueChanged)
        primaryTextField.addTarget(self, action: #selector(textFieldDidBeginEditing(_:)), for: .allTouchEvents)

        secondryTextField.delegate = self
        self.errorLabel.font = UIFont.customFont(type: .Regular, size: 12)
        self.setupPasswordIconButton()
        
    }

    func setupPasswordIconButton() {
        eyeIcon = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        eyeIcon?.setImage(UIImage(named: "hide-password"), for: .normal)
        eyeIcon?.setImage(UIImage(named: "showpassword"), for: .selected)
        eyeIcon?.contentHorizontalAlignment = .left
        eyeIcon?.addTarget(self, action: #selector(securePassword(_ :)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func makeEqualTextFields() {
        self.stackView.distribution = .fillEqually
        self.secondryTFWidth?.isActive = false
    }
    func revertTextFields() {
        self.stackView.distribution = .fillProportionally
        self.secondryTFWidth?.isActive = true
    }
    func verfiedTextManaged(model:MIProfilePersonalDetailInfo,title:String) {
        if title == RegisterViewStoryBoardConstant.email {
            self.verifyBtn.setTitleColor(model.emailVerifedStatus ? AppTheme.greenColor : AppTheme.defaltBlueColor, for: .normal)
            self.verifyBtn.setTitle(model.emailVerifedStatus ? "Verified" : "Verify", for: .normal)

        }else if title == RegisterViewStoryBoardConstant.mobileNumber{
            self.verifyBtn.setTitleColor(model.mobileNumberVerifedStatus ? AppTheme.greenColor : AppTheme.defaltBlueColor, for: .normal)
            self.verifyBtn.setTitle(model.mobileNumberVerifedStatus ? "Verified" : "Verify", for: .normal)

        }
        
        
    }
    @IBAction func helpButtonAction(_ sender: Any) {
        self.helpButton.setImage(#imageLiteral(resourceName: "help"), for: .normal)
        self.showPopUpCallBack?()
    }
    
    @IBAction func verifyBtn(_ sender: Any) {
        self.showPopUpCallBack?()

    }
    @IBAction func btnHideCovidSituation(_ sender: UIButton){
        sender.isSelected = !sender.isSelected
        covid19Flag = sender.isSelected
        
        if let action = self.covidSituationCallBack{
            action(sender.isSelected)
        }

       
    }
    
    @objc func securePassword(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        self.hidePasswordCallBack?(sender.isSelected)
    }

    func showError(with message: String, animated: Bool = true) {

        primaryTextField.layer.borderColor = Color.errorColor.cgColor
        errorLabel.textColor = Color.errorColor
        
        if animated { (self.superview as? UITableView)?.beginUpdates() }
        errorLabel.text = message
        if animated { (self.superview as? UITableView)?.endUpdates()  }
        if message.count == 0 {
            self.deselectTF(self.primaryTextField)
        }
    }
    
    func showErrorOnSecondryTF(with message: String, animated: Bool = true) {
        
        secondryTextField.layer.borderColor = Color.errorColor.cgColor
        secondryErrorLabel.textColor = Color.errorColor
        
        if animated { (self.superview as? UITableView)?.beginUpdates() }
        secondryErrorLabel.text = message
        if animated { (self.superview as? UITableView)?.endUpdates()  }
        if message.count == 0 {
            self.deselectTF(self.secondryTextField)
        }
    }
    
    func selectTF(_ textField: UITextField) {
        textField.layer.borderColor = AppTheme.defaltBlueColor.cgColor
    
        (self.superview as? UITableView)?.beginUpdates()
        errorLabel.text = ""
        secondryErrorLabel.text = ""
        (self.superview as? UITableView)?.endUpdates()
    }
    
    func deselectTF(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        errorLabel.text = ""
        secondryErrorLabel.text = ""
    }
    
    func showInfoPopup(infoMsg:String) {
        let controller = MIInfoPopOverController()
        controller.message = infoMsg
        controller.delegate = self
        controller.preferredContentSize = CGSize(width: self.bounds.size.width, height: 110)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = self.helpButton
        presentationController.sourceRect = self.helpButton.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.superview?.parentViewController?.present(controller, animated: true)
    }
}

extension MITextFieldTableViewCell: UITextFieldDelegate {
    
   @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        self.selectTF(textField)
    }
    
   @objc func textFieldDidEndEditing(_ textField: UITextField) {
        self.deselectTF(textField)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return self.secondryTextFieldAction?(secondryTextField) ?? false
    }
    
}


class RightViewTextField : UITextField {
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let offset = 5
        let width  = 20
        let height = bounds.height
        let x = Int(bounds.width) - width - offset
        let y = 0
        let rightViewBounds = CGRect(x: x, y: y, width: width, height: Int(height))
        return rightViewBounds
    }

}

extension MITextFieldTableViewCell: DismissPopOverControllerDelegate {
    func dismissInfoPopOverController() {
        self.helpButton.setImage(#imageLiteral(resourceName: "helpgray"), for: .normal)
    }
    
    
}

//
//  MIRegisterMobileNumbCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 02/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIRegisterMobileNumbCell: UITableViewCell {
    
    weak var delegate:MILoginEmailCellDelegate?
    
    @IBOutlet weak var countryTextFieldWidth: NSLayoutConstraint!
    @IBOutlet weak var mobileTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var countryCodeTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var mobileTitleLabel: UILabel!
    @IBOutlet weak var mobileNumberLeading: NSLayoutConstraint!
    
    var countryCodeSelected: ((UITextField)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        mobileTitleLabel.font=UIFont.customFont(type: .Regular, size: 14)
        mobileTitleLabel.textColor=AppTheme.defaltTheme
        countryCodeTextField.textColor=AppTheme.textColor
        mobileNumberTextField.textColor=AppTheme.textColor
        countryCodeTextField.font=UIFont.customFont(type: .Regular, size: 16)
        countryCodeTextField.textAlignment = .center
        mobileNumberTextField.font=UIFont.customFont(type: .Regular, size: 16)
        mobileNumberTextField.delegate=self
        countryCodeTextField.delegate=self
        mobileNumberTextField.keyboardType = .numberPad
        mobileNumberTextField.addDoneButtonOnKeyboard()
        self.countryCodeTextField.placeholder=RegisterViewStoryBoardConstant.countryCode
        self.countryCodeTextField.attributedPlaceholder=NSAttributedString(string:RegisterViewStoryBoardConstant.countryCode, attributes:[NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 16)])
        self.mobileTitleLabel.text=RegisterViewStoryBoardConstant.mobileNumber
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }

    var hideAndShowCountryCode=false{
        didSet{
            let border = CALayer()
            let height = CGFloat(0.7)
            border.borderColor = UIColor.init(hex: "E0E0E0").cgColor
            border.frame = CGRect(x: 0, y: self.mobileNumberTextField.bounds.height - height, width: self.mobileNumberTextField.bounds.width+60, height: height)
            border.borderWidth = height
            mobileNumberTextField.layer.addSublayer(border)
            mobileNumberTextField.layer.masksToBounds = true
            let border1 = CALayer()
            border1.borderColor = UIColor.init(hex: "E0E0E0").cgColor
            border1.frame = CGRect(x: 0, y: self.countryCodeTextField.bounds.height - height, width: self.countryCodeTextField.bounds.width, height: height)
            border1.borderWidth = height
            countryCodeTextField.layer.addSublayer(border1)
            countryCodeTextField.layer.masksToBounds = true
          
            if hideAndShowCountryCode{
                self.countryTextFieldWidth.constant=0
                self.countryCodeTextField.isHidden=true
                self.mobileTitleHeight.constant=0
                self.mobileTitleLabel.isHidden=true
                self.mobileNumberLeading.constant=0
            }else {
                self.countryTextFieldWidth.constant=60
                self.countryCodeTextField.isHidden=false
                self.mobileTitleHeight.constant=20
                self.mobileTitleLabel.isHidden=false
                self.mobileNumberLeading.constant=8
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showDataWithAttributedContent(model:MIUserModel,with title:String){
        self.mobileNumberTextField.text = model.userMobileNumber
        self.countryCodeTextField.text = model.userCountryCode
        self.mobileNumberTextField.attributedPlaceholder=NSAttributedString(string:title, attributes:[NSAttributedString.Key.foregroundColor:UIColor.lightGray,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 16)])
    }
    
   
}

extension MIRegisterMobileNumbCell:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            if textField==countryCodeTextField{
                self.countryCodeSelected!(countryCodeTextField)
                return false
                //           let countryList = self.getCountryCodes()
//           let list = countryList.map({ [$0.dialCode, $0.name].joined(separator: " - ") })
//            let item = countryList.first(where: { $0.dialCode == countryCodeTextField.text! })
//            let firstComponent = [item?.dialCode ?? "", item?.name ?? ""].joined(separator: " - ")
//            AKMultiPicker.openPickerIn(countryCodeTextField, firstComponentArray: list, firstComponent: firstComponent) { (value, _, index, _) in
//                textField.text = countryList[index!].dialCode
//          }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField==mobileNumberTextField{
            if textField.text!.count > 0{
                DispatchQueue.main.async {
                    self.hideAndShowCountryCode=false
                }
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.txtFldDidBeginEditing(fld: textField)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.txtFldDidEndEditing(fld: textField)
    }
    
    private func getCountryCodes() -> CountryCode {
        if let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let list = try JSONDecoder().decode(CountryCode.self, from: data)
                return list
            } catch {
              //  print(error)
            }
        }
        return []
    }
    
}

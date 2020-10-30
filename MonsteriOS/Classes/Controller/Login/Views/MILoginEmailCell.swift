//
//  MILoginEmailCell.swift
//  MonsteriOS
//
//  Created by Monster on 15/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MILoginModel: NSObject {
    var title      = ""
    var leftImgNm  = ""
    var rightImgNm = ""
    var countryCode = ""
    var data       = ""
    var adtionalData = ""
    var extradata = ""
    var countrydata = ""

    init(with ttl:String, leftImgName:String, rightImgName:String = "") {
        title      = ttl
        leftImgNm  = leftImgName
        rightImgNm = rightImgName
    
    }
    

}

protocol MILoginEmailCellDelegate:class {
    func txtFldDidBeginEditing(fld:UITextField)
    func txtFldDidEndEditing(fld:UITextField)
}

class MILoginEmailCell: UITableViewCell,UITextFieldDelegate {

    weak var delegate:MILoginEmailCellDelegate?
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var leftImgView: UIImageView!
    @IBOutlet weak private var rightImgView: UIImageView!
    @IBOutlet weak private var titleBtn: UIButton!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak private var btnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var btnLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var leftImgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var leftImgViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var rightImgViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var lblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak private var errorLbl: UILabel!
    @IBOutlet weak var errorHeightConstraint: NSLayoutConstraint!
    var btnLeadingSpace = -20
    
    
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var countryCodeView: UIView!
    @IBOutlet weak var textFieldContainerLeading: NSLayoutConstraint!
    
    //private var countryList = CountryCode()
    var showCountryField = false
    var countryCodeSelected: ((UITextField)->())?
    
    var returnKeyAction: ((UITextField)->())?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
        self.txtField.delegate = self
        self.countryCodeTF.delegate = self
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.txtFldDidBeginEditing(fld: textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.3) {
            self.lblTopConstraint.constant = 0
        }
        lblTitle.text = ""
        self.delegate?.txtFldDidEndEditing(fld: textField)
    }
    
    func show(info:MILoginModel, shouldShowPassword:Bool = false, errorMsg:String = "", isFirstResponder:Bool = false) {
        
        //Set country wise placeholder
        let site = AppDelegate.instance.site

        if site?.defaultCountryDetails.langOne?.first?.name == "India"{
            if info.title == "Email" {
                self.txtField.placeholder = "Email / Phone Number"
            }else{
                self.txtField.placeholder = info.title
            }
        } else {
            self.txtField.placeholder = info.title
        }

        //self.txtField.placeholder = info.title
        
        self.leftImgView.image = UIImage(named: info.leftImgNm)
        self.rightImgView.image = UIImage(named: info.rightImgNm)
        if info.leftImgNm.isEmpty {
            leftImgViewWidthConstraint.constant = 0
            leftImgViewLeadingConstraint.constant = -10
            btnLeadingSpace = 10
        }
        
        if info.rightImgNm.isEmpty {
            rightImgViewWidthConstraint.constant = 0
        }
        if txtField.text!.isEmpty {
           txtField.text = info.data
            countryCodeTF.text = info.adtionalData
            self.manageCountryCodeView(info.data)
        }
       
        self.txtField.isSecureTextEntry = shouldShowPassword
        
        if errorMsg.isEmpty {
            errorLbl.text = ""
            errorHeightConstraint.constant = 0
        } else {
            errorLbl.text = errorMsg
            errorHeightConstraint.constant = 25
        }
        
        if isFirstResponder {
            self.txtField.becomeFirstResponder()
        }
    }
    
    func getCellData() -> (data: String, aditional: String) {
        return (self.txtField.text ?? "", self.countryCodeTF.text ?? "")
    }
    
    @IBAction func titleClicked(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.btnTopConstraint.constant = -40
            self.btnLeadingConstraint.constant = CGFloat(self.btnLeadingSpace)
            self.titleBtn.layoutIfNeeded()
            self.titleBtn.isUserInteractionEnabled = false
            self.txtField.becomeFirstResponder()
            self.titleBtn.setTitleColor(UIColor.colorWith(r: 152, g: 132, b: 247, a: 1.0), for: .normal)
        }
    }
    
    
    //MARK:- UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { [unowned self] in
            self.manageCountryCodeView(textField.text!)
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case countryCodeTF:
            self.countryCodeSelected?(countryCodeTF)
            return false
        default:
            break
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let action = self.returnKeyAction {
            action(textField)
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return false
    }
    
    private func manageCountryCodeView(_ text: String) {
        guard self.showCountryField else { return }

        let show = text.isNumeric && text.count > 3
        
        UIView.animate(withDuration: 0.3) { [unowned self] in
            if show {
                self.textFieldContainerLeading.constant = 78
                self.countryCodeView.isHidden = false
            } else {
                self.textFieldContainerLeading.constant = 15
                self.countryCodeView.isHidden = true
            }
            self.layoutIfNeeded()
        }
    }
    
    
    
    // self.countryList = self.getCountryCodes()
    // let list = self.countryList.map({ [$0.dialCode, $0.name].joined(separator: " - ") })
    // let item = self.countryList.first(where: { $0.dialCode == countryCodeTF.text! })
    // let firstComponent = [item?.dialCode ?? "", item?.name ?? ""].joined(separator: " - ")
    // AKMultiPicker.openPickerIn(countryCodeTF, firstComponentArray: list, firstComponent: firstComponent) { (value, _, index, _) in
    //     textField.text = self.countryList[index!].dialCode
    // }
    
    //    private func getCountryCodes() -> CountryCode {
    //        if let path = Bundle.main.path(forResource: "CountryCodes", ofType: "json") {
    //            do {
    //                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    //                let list = try JSONDecoder().decode(CountryCode.self, from: data)
    //                return list
    //            } catch {
    //                print(error)
    //            }
    //        }
    //        return []
    //    }
}

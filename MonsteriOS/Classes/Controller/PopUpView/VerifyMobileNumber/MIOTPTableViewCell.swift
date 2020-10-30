//
//  MIOTPTableViewCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 18/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIOTPTableViewCell: UITableViewCell {

    @IBOutlet var optTextField: [OTPTextField]!
    @IBOutlet weak var resendOTPButton: UIButton!
    
    @IBOutlet weak var progressBar: UIProgressView!

    var resendButtonCallBack: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .none
        
        for textField in optTextField {
            textField.delegate=self
            textField.addTarget(self, action: #selector(MIOTPViewController.textFieldTap(_:)), for: .editingChanged)
            textField.onDeleteBackwards = {
                
                switch textField.tag{
                case 5:
                    self.optTextField[4].becomeFirstResponder()
                case 4:
                    self.optTextField[3].becomeFirstResponder()
                case 3:
                    self.optTextField[2].becomeFirstResponder()
                case 2:
                    self.optTextField[1].becomeFirstResponder()
                case 1:
                    self.optTextField[0].becomeFirstResponder()
                default:
                    break
                }
            }
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func resendButtonAction(_ sender: Any) {
        self.resendButtonCallBack?()
    }
    
    @discardableResult
    func startTimer() -> Timer? {
        guard self.time <= 0 else {
            return nil
        }

    
        self.resendOTPButton.setTitleColor(UIColor(hex: 0x727272), for: .normal)
        self.progressBar.isHidden = false

        UIView.animate(withDuration: 30) {
            self.progressBar.setProgress(1.0, animated: true)
        }
        
        self.time = 30
        return Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerStarted(_:)), userInfo: nil, repeats: true)
    }
    
    var time = 0
    @objc func timerStarted(_ timer: Timer) {
        var timeString = "Resend OTP"
        if time > 0 {
            timeString += " (00:" + time.stringValue + ")"
        } else {
            self.resendOTPButton.setTitleColor(UIColor(hex: 0x0091ff), for: .normal)
            self.progressBar.isHidden = true
            self.progressBar.progress = 0
            timer.invalidate()
        }
        self.resendOTPButton.setUnAnimatedTitle(title: timeString, for: .normal)
        time -= 1
    }
    
    @objc func textFieldTap(_ sender:UITextField){
        let textCount = sender.text?.count ?? 0
        
        if textCount == 1 {
            switch sender.tag{
            case 0:
                optTextField[1].becomeFirstResponder()
            case 1:
                optTextField[2].becomeFirstResponder()
            case 2:
                optTextField[3].becomeFirstResponder()
            case 3:
                optTextField[4].becomeFirstResponder()
            case 4:
                optTextField[5].becomeFirstResponder()
                
            default:
                break
            }
        }
    }
}


extension MIOTPTableViewCell: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(hex: "0091ff").cgColor
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(hex: 0xdddddd).cgColor
    }

    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        switch textField.tag {
        case 1:
            if optTextField[0].text?.count ?? 0 > 0{
                return true
            }else{
                return false
            }
        case 2:
            if optTextField[1].text?.count ?? 0 > 0{
                return true
            }else{
                return false
            }
            
        case 3:
            if optTextField[2].text?.count ?? 0 > 0{
                return true
            }else{
                return false
            }
            
        case 4:
            if optTextField[3].text?.count ?? 0 > 0{
                return true
            }else{
                return false
            }
            
        case 5:
            if optTextField[4].text?.count ?? 0 > 0{
                return true
            }else{
                return false
            }
            
        default:
            return true
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let maxLength = 1
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if textField.tag==5{
            if newString.length==maxLength{
                DispatchQueue.main.async {
                    textField.resignFirstResponder()
                    //Last Field
                }
            }
        }
        return newString.length <= maxLength && allowedCharacters.isSuperset(of: characterSet)
    }

}

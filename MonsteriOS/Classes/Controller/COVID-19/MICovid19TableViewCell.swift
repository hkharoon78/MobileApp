//
//  MICovid19TableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 20/05/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit

class MICovid19TableViewCell: UITableViewCell {
    
    //MARK:- IBOutlet 
    @IBOutlet weak var imgCovidLogo: UIImageView!
    @IBOutlet weak var lblNoYes: UILabel!
    @IBOutlet weak var switchOnOff:UISwitch!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var switchImg: UIImageView!
    
    
    var flagValue: Bool = false
    var viewController: UIViewController?
    var covidFlagCallBack: (()->Void)?
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
                       
        //self.switchOnOff.onTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
       // self.switchOnOff.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.switchOnOff.subviews[0].subviews[0].backgroundColor = .clear
       // self.switchOnOff.layer.cornerRadius = self.switchOnOff.frame.height / 2
        
        
        self.switchOnOff.tintColor = .clear
        self.switchOnOff.backgroundColor = .clear
        self.switchImg.isUserInteractionEnabled = false
        
        self.switchOnOff.isOn = false
        self.switchImg.image = #imageLiteral(resourceName: "Toggle off")
        self.lblNoYes.attributedText = self.onOffName(name: "No")
        
        self.viewBackground.layer.borderWidth = 1
        self.covidOnOff(covid19Flag)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    
    @IBAction func onOffValueChanged(_ sender: UISwitch) {
        
        if (!MIReachability.isConnectedToNetwork()){
            self.viewController?.toastView(messsage: ExtraResponse.noInternet)
          } else {
              self.covidOnOff(sender.isOn)
          }
        
       // self.covidOnOff(sender.isOn)
        self.callUpdateCovidFlag(updateValue: sender.isOn, method: .put)
        self.covidFlagCallBack?()
        
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        UserDefaults.standard.synchronize()
    }
    
    func covidOnOff(_ isTrue: Bool){
       
        self.imgCovidLogo.image = isTrue ? #imageLiteral(resourceName: "bacteriaGREEN") : #imageLiteral(resourceName: "bacteriaRED")
        self.viewBackground.backgroundColor = isTrue ? #colorLiteral(red: 0.9529411765, green: 0.9921568627, blue: 0.9411764706, alpha: 1) : #colorLiteral(red: 1, green: 0.9411764706, blue: 0.9490196078, alpha: 1)
        self.viewBackground.layer.borderColor = isTrue ?  #colorLiteral(red: 0.3843137255, green: 0.7294117647, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 1, green: 0.3215686275, blue: 0.3411764706, alpha: 1)
       
       // self.switchOnOff.thumbTintColor =  isTrue ?  #colorLiteral(red: 0.3843137255, green: 0.7294117647, blue: 0.2745098039, alpha: 1) : #colorLiteral(red: 1, green: 0.3215686275, blue: 0.3411764706, alpha: 1)
     
        self.switchOnOff.isOn = isTrue
        self.lblNoYes.attributedText = isTrue ? self.onOffName(name: "Yes") : self.onOffName(name: "No")
        self.switchOnOff.isOn ? (self.switchImg.image = #imageLiteral(resourceName: "Toggle on")) : (self.switchImg.image = #imageLiteral(resourceName: "Toggle off"))
        
        covid19Flag = isTrue
        CommonClass.googleEventTrcking("dashboard_screen", action: isTrue ? "covid_button_on" : "covid_button_off", label: "")
        
    }
    
    func onOffName(name: String) -> NSAttributedString {
        
        if name == "No" {
            let attributed = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: "505050"), NSAttributedString.Key.font: UIFont.customFont(type: .Bold, size: 13)])
            
            attributed.append(NSAttributedString(string:  " | Yes", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "CDCDCD"), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 13)]))
         
            return attributed
            
        } else {
             let attributed = NSMutableAttributedString(string: " No | ", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: "CDCDCD"), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 13)])
            
              attributed.append(NSAttributedString(string: name, attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "505050"), NSAttributedString.Key.font: UIFont.customFont(type: .Bold, size: 13)]))
            
            return attributed
        }
                 
    }
    
    
    
}

extension MICovid19TableViewCell {
    
    func callUpdateCovidFlag(updateValue: Bool, method: ServiceMethod) {
        
         //MIActivityLoader.showLoader()
        MIApiManager.hitCovidFlagAPI(method, covidFlag: updateValue) { (success, response, error, code) in

            DispatchQueue.main.async {
                //MIActivityLoader.hideLoader()
                    if let responseData = response as? JSONDICT {
                        let successMessage = responseData["successMessage"] as? String ?? ""
                       // self.viewController?.toastView(messsage: successMessage)
                    } else {
                        if (!MIReachability.isConnectedToNetwork()){
                            self.viewController?.toastView(messsage: ExtraResponse.noInternet)
                        }
                    }
            }
        }
    }
    
    
    
}

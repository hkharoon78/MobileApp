//
//  MIPopUpSuccessErrorVC.swift
//  MonsteriOS
//
//  Created by Rakesh on 26/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIPopUpSuccessErrorVC: UIViewController {

    @IBOutlet weak var bgView:UIView!
    @IBOutlet weak var lbl_infoMessage:UILabel!
    @IBOutlet weak var darkView:UIView!
    var popUpForError = true
    var isErrorCase : ((Bool)-> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bgView.roundCorner(0, borderColor: .red, rad: 8)
        
        lbl_infoMessage.text = "Do any additional setup after loading the view"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MIPopUpSuccessErrorVC.dismissView(_:)))
        tapGesture.numberOfTapsRequired=1
        self.darkView.addGestureRecognizer(tapGesture)
        if popUpForError{
            self.managePopContentForError()
            bgView.backgroundColor = UIColor(hex: "bf0505")
        }else{
            self.managePopContentForSuccess()
            bgView.backgroundColor = AppTheme.greenColor
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
    }
    func managePopContentForSuccess() {
       // "Thanks for updating your profile. Start your job search now"
         let thanks = NSMutableAttributedString(string:"Thanks for updating your profile. ", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 16)])
        let search = NSAttributedString(string:"Start your job search now", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 16),NSAttributedString.Key.underlineStyle:1,NSAttributedString.Key.underlineColor:UIColor.white])

        thanks.append(search)
        lbl_infoMessage.attributedText = thanks
        lbl_infoMessage.isUserInteractionEnabled = true
        let tapGest=UITapGestureRecognizer(target: self, action: #selector(MIPopUpSuccessErrorVC.attributedTextTapped(_:)))
        tapGest.numberOfTapsRequired=1
        self.lbl_infoMessage.addGestureRecognizer(tapGest)

    }
   
    func managePopContentForError(){
        // "Oops! We encountered an issue while updating few details. Please visit your profile to try again"

        let oops = NSMutableAttributedString(string:"Oops! We encountered an issue while updating few details. ", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 16)])
        let visit = NSMutableAttributedString(string:"Please visit your ", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 16)])

        let profile = NSAttributedString(string:"Profile", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 16),NSAttributedString.Key.underlineStyle:1,NSAttributedString.Key.underlineColor:UIColor.white])
        let tryAgain = NSMutableAttributedString(string:" to try again", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 16)])

        oops.append(visit)
        oops.append(profile)
        oops.append(tryAgain)

        lbl_infoMessage.attributedText = oops
        lbl_infoMessage.isUserInteractionEnabled = true
        let tapGest=UITapGestureRecognizer(target: self, action: #selector(MIPopUpSuccessErrorVC.attributedTextTapped(_:)))
        tapGest.numberOfTapsRequired=1
        self.lbl_infoMessage.addGestureRecognizer(tapGest)
    }
    @objc func attributedTextTapped(_ sender:UITapGestureRecognizer){
        if let callBack = self.isErrorCase {
                callBack(popUpForError)
        }
        self.dismiss(animated: false, completion: nil)
//        if let search = self.lbl_infoMessage.text?.range(of:" Start your job search now")?.nsRange{
//            if sender.didTapAttributedTextInLabel(label: self.lbl_infoMessage, inRange: search) {
//                // Substring tapped
//                if let callBack = self.isErrorCase {
//                    callBack(true)
//                }
//                self.dismiss(animated: false, completion: nil)
//
//            }
//        }
//        if let profile = self.lbl_infoMessage.text?.range(of:" Profile")?.nsRange{
//            if sender.didTapAttributedTextInLabel(label: self.lbl_infoMessage, inRange: profile) {
//                // Substring tapped
//                if let callBack = self.isErrorCase {
//                    callBack(false)
//                }
//                self.dismiss(animated: false, completion: nil)
//
//            }
//        }
        
        
    }
    @objc func dismissView(_ gesture:UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)

    }
    @IBAction func crossBtnPressed(_ sender:UIButton){
        self.dismiss(animated: false, completion: nil)
    }

}

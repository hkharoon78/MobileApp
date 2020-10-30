//
//  MIUpdateWorkExp.swift
//  MonsteriOS
//
//  Created by Rakesh on 11/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import MobileCoreServices.UTType


enum PopUpViewMode {
    case Resume
    case Fresher
    case Experience
}
class MIUpdateWorkExp: UIViewController {
    
    @IBOutlet weak var workExpLogo:UIImageView!
    @IBOutlet weak var lbl_title:UILabel!
    @IBOutlet weak var lbl_guideText:UILabel!
    @IBOutlet weak var txtF_Fresher:RightViewTextField!
    @IBOutlet weak var btn_Update:UIButton!
    @IBOutlet weak var txtF_YearExp:RightViewTextField!
    @IBOutlet weak var txtF_MnthExp:RightViewTextField!
    @IBOutlet weak var view_ExpBackground:UIView!
    @IBOutlet weak var view_ResumeBackground:UIView!
    @IBOutlet weak var lbl_errorFirst:UILabel!
    @IBOutlet weak var lbl_errorSec:UILabel!
    @IBOutlet weak var chooseResume_btn:UIButton!
    
    var popUpMode : PopUpViewMode = .Resume
    var card: Card?
    var urlData: URL?
    var viewLoadDate:Date!
    var oldyearWxp = 0
    var oldmnthExp = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = ""
        self.navigationController?.isNavigationBarHidden = true
        if popUpMode == .Resume {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.USER_ENGAGMENT_RESUME_SCREEN)

        }else{
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.USER_ENGAGMENT_WORK_EXPERIENCE_SCREEN)

        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setUpDotLayers()
    }
    
    func setUpView() {
        viewLoadDate = Date()
        txtF_Fresher.roundCorner(1, borderColor: UIColor.lightGray, rad: 5)
        txtF_YearExp.roundCorner(1, borderColor: UIColor.lightGray, rad: 5)
        txtF_MnthExp.roundCorner(1, borderColor: UIColor.lightGray, rad: 5)
        txtF_Fresher.setRightViewForTextField("right_direction_arrow")
        txtF_MnthExp.setRightViewForTextField("right_direction_arrow")
        txtF_YearExp.setRightViewForTextField("right_direction_arrow")
        txtF_Fresher.setLeftViewForTextField(nil)
        txtF_YearExp.setLeftViewForTextField(nil)
        txtF_MnthExp.setLeftViewForTextField(nil)
        txtF_Fresher.delegate = self
        txtF_MnthExp.delegate = self
        txtF_YearExp.delegate = self
        txtF_Fresher.text = "Fresher"
        workExpLogo.roundCorner(0, borderColor: .clear, rad: workExpLogo.frame.size.height/2)
        workExpLogo.backgroundColor = UIColor(hex: "f1f1f1")
        btn_Update.showSecondaryBtnLayout()
       
        if let cardData = card?.data as? [String:Any] {
            self.txtF_MnthExp.placeholder = "Month(s)"
            self.txtF_YearExp.placeholder = "Year(s)"
            popUpMode = .Experience

            if let month = cardData["months"] as? Int  {
                oldmnthExp = month
                self.txtF_MnthExp.text = "\(month) \(month > 1 ? "Months" : "Month")"
            }
           // let year = cardData.stringFor(key: "years")
            if let year = cardData["years"] as? Int  {
                oldyearWxp = year
                self.txtF_YearExp.text = "\(year) \((year) > 1 ? "Years" : "Year")"
            }
            if oldmnthExp == 0 && oldyearWxp == 0 {
                popUpMode = .Fresher
            }
        }
        self.manageFieldAsperPopUpType()
    }
    func manageFieldAsperPopUpType() {
        self.view_ExpBackground.isHidden = true
        self.view_ResumeBackground.isHidden = true
        self.txtF_Fresher.isHidden = true
        self.lbl_title.text = "Update Work Experience"
        self.showAttributtedForUpdareWork()
        btn_Update.setTitle("UPDATE", for: .normal)

        if popUpMode == .Resume {
            btn_Update.setTitle("UPLOAD", for: .normal)
            self.view_ResumeBackground.isHidden = false
            btn_Update.alpha = 0.3
            workExpLogo.image = UIImage(named: "resume_pop")
            self.lbl_title.text = "Upload Your Resume"
            self.showAttributtedForResume()
            self.lbl_errorFirst.text = "* doc, docx, rtf, pdf - 6MB max"
            self.lbl_errorFirst.textColor = UIColor(hex: "505050")
        }else if popUpMode == .Fresher {
            self.txtF_Fresher.isHidden = false
            workExpLogo.image = UIImage(named: "shape")
        }else {
            self.view_ExpBackground.isHidden = false
            workExpLogo.image = UIImage(named: "shape")
        }
    }
    func showAttributtedForUpdareWork(){
        let experDetail = NSMutableAttributedString(string:"Keeping experience details up-to-date gets you ", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
        let calls = NSMutableAttributedString(string:" calls. ", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
        let relevant = NSAttributedString(string:"relevant", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 13)])
        let everyTime = NSAttributedString(string:" Every Time!", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 13)])
        experDetail.append(relevant)
        experDetail.append(calls)
        experDetail.append(everyTime)
        self.lbl_guideText.attributedText = experDetail
        
    }
    func showError(with txtFld:UITextField,message:String,isPrimary:Bool) {
        txtFld.layer.borderColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        lbl_errorFirst.textColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        lbl_errorFirst.text = message
        
        if message.count == 0 {
            txtFld.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            lbl_errorFirst.text = ""
        }
    }
    
    func showAttributtedForResume(){
        let resume = NSMutableAttributedString(string:"A resume is the ", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
        let mostImp = NSAttributedString(string:"most important ", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 13)])
        let document = NSMutableAttributedString(string:"document recruiters look for", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
        
        resume.append(mostImp)
        resume.append(document)
        self.lbl_guideText.attributedText = resume
    }

    func setUpDotLayers(){
        for layer in view_ResumeBackground.layer.sublayers ?? [] {
            if layer is DotShapeLayer {
                layer.removeFromSuperlayer()
            }
        }
        
        let dotLayer = DotShapeLayer()
        dotLayer.strokeColor = UIColor.init(red: 230, green: 230, blue: 230).cgColor
        dotLayer.lineDashPattern = [2, 2]
        dotLayer.frame = view_ResumeBackground.bounds
        dotLayer.fillColor = nil
        dotLayer.path = UIBezierPath(roundedRect: view_ResumeBackground.bounds, cornerRadius: 4).cgPath
        view_ResumeBackground.layer.addSublayer(dotLayer)
        view_ResumeBackground.layer.cornerRadius = 4
    }
    
    func uploadResume(){
        let documentPicker = UIDocumentPickerViewController(documentTypes: [ "com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document",kUTTypeRTFD as String ,kUTTypePDF as String], in: .import)
        
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func remindMeLater(_ sender:UIButton) {
        self.callAPIForSkip()
    }
    
    @IBAction func uploadResumeAction(_ sender:UIButton) {
        self.uploadResume()
    }
    @IBAction func updateDataAction(_ sender:UIButton) {
        
        self.showError(with: txtF_YearExp, message: "", isPrimary: true)
        self.showError(with: txtF_MnthExp, message: "", isPrimary: false)
        
        if popUpMode == .Experience {
            
            if txtF_YearExp.text?.count == 0 && txtF_MnthExp.text?.count == 0 {
                self.showError(with: txtF_YearExp, message: "Select your work experience.", isPrimary: true)
            }else{
                self.callAPIForUpdateWorkExp()
            }
        }else if popUpMode == .Fresher {
            self.callAPIForUpdateWorkExp()
        }else{
            if let url = urlData {
                
                self.callAPIForUploadResume(url: url)
                let fileName = url.lastPathComponent
                self.chooseResume_btn.setTitle(fileName, for: .normal)
                self.lbl_errorFirst.text = ""
            }else{
                //self.lbl_errorFirst.text = "Please upload your resume."
            }
        }
    }
    
    func callAPIForUpdateWorkExp() {
        var params = [String:Any]()
        params["years"] = 0
        params["months"] = 0
        if popUpMode != .Fresher {
            if  let exYear = txtF_YearExp.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ,let y = Int(exYear) {
                params["years"] = y
                
            }
            if let exMnth = txtF_MnthExp.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ,let m = Int(exMnth) {
                params["months"] = m
            }
        }
        let added = self.addTaskToDispatchGroup()
        let headerDict = [
            "x-rule-applied": card?.ruleApplied ?? "",
            "x-rule-version": card?.ruleVersion ?? ""
        ]
        MIApiManager.callAPIForUpdateWorkExperience(methodType: .put, path: APIPath.updateWorkExp, params: ["experience":params], customHeaderParams: headerDict) { (success, response, error, code) in
            DispatchQueue.main.async {
                defer { self.leaveDispatchGroup(added) }


                if error == nil && (code >= 200) && (code <= 299) {
                    if ((self.oldyearWxp != (params["years"] as? Int)) || (self.oldmnthExp != (params["months"] as? Int))) {
                        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.TOTAL_WORK_EXP]
                    }
                    if let tabbar = self.tabbarController {
                        tabbar.handlePopFinalState(isErrorHappen: false)
                    }

                }else{
                    if let tabbar = self.tabbarController {
                        tabbar.isErrorOccuredOnProfileEngagement = true
                    }
                }
            }
        }
        self.callAPIForEventTracking(updated: 1, remindMeLater: 0)
        self.skipProfileEngagementPopup()
    }
}

extension MIUpdateWorkExp : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let workExpList = MIWorkExpListVC()
        if popUpMode == .Fresher {
            workExpList.experienceInYear = "0"
        }else{
            if  let year = txtF_YearExp.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ,let y = Int(year) {
                workExpList.experienceInYear = "\(y + 1)"
            }
            if  let mnth = txtF_MnthExp.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ,let m = Int(mnth) {
                workExpList.experienceInMonth = "\(m)"
            }
        }
        self.navigationController?.pushViewController(workExpList, animated: true)
        workExpList.workExperienceSelected = {[weak self] year,month in
            
            if let wself = self {
                wself.txtF_YearExp.text = ""
                wself.txtF_MnthExp.text = ""
                wself.showError(with: wself.txtF_YearExp, message: "", isPrimary: true)
                wself.txtF_YearExp.placeholder = "Year(s)"
                wself.txtF_MnthExp.placeholder = "Month(s)"
                if year == "0" {
                    wself.txtF_Fresher.text = "Fresher"
                    wself.popUpMode = .Fresher
                    wself.manageFieldAsperPopUpType()
                }else{
                    if let yearExp = year , let data = Int(yearExp )  {
                        wself.txtF_YearExp.text = "\(data - 1) \((data-1) > 1 ? "Years" : "Year")"
                    }
                    if let mnthExp = month , let data = Int(mnthExp )  {
                        wself.txtF_MnthExp.text = "\(data) \(data > 1 ? "Months" : "Month")"
                    }
                    wself.popUpMode = .Experience
                    wself.manageFieldAsperPopUpType()
                }
            }
        }
        return false
    }
}

extension MIUpdateWorkExp: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        controller.dismiss(animated: true, completion: nil)
        urlData = nil
        if self.sizePerMB(url: url) >= 6{
            self.lbl_errorFirst.text = "File Size should be less than 6 Mb."
            lbl_errorFirst.textColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        }else{
            urlData = url
            let fileName = url.lastPathComponent
            self.chooseResume_btn.setTitle(fileName, for: .normal)
            self.chooseResume_btn.setTitleColor(.black, for: .normal)
            btn_Update.alpha = 1.0
            self.lbl_errorFirst.text = ""
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func callAPIForUploadResume(url:URL) {
        let experience = AppDelegate.instance.userInfo.expereienceLevel        
        var params = [String:Any]()
        if let data = try? Data(contentsOf: url){
            params["file"] = data
            params["parseResume"] = CommonClass.enableResumeParse
            let headerDict = [
                "x-rule-applied": card?.ruleApplied ?? "",
                "x-rule-version": card?.ruleVersion ?? ""
            ]
            let extenstion = url.pathExtension
            let fileName = url.lastPathComponent.components(separatedBy: ".").first ?? ""
            if !extenstion.isEmpty {
                let added = self.addTaskToDispatchGroup()
                MIApiManager.callAPIForUploadAvatarResume(path:APIPath.uploadResumeForDocParse , params: params, extenstion: extenstion, filename: fileName,customHeaderParams:headerDict  ) { (success, response, error, code) in
                    DispatchQueue.main.async {
                        defer { self.leaveDispatchGroup(added) }
                        if error == nil && (code >= 200) && (code <= 299){
                            JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.UPLOAD_RESUME]

                            shouldRunProfileApi = true
                            if let tabbar = self.tabbarController {
                                tabbar.handlePopFinalState(isErrorHappen: false)
                            }

                        }else{
                            if let tabbar = self.tabbarController {
                                tabbar.isErrorOccuredOnProfileEngagement = true
                            }
                        }
                    }
                }
                self.callAPIForEventTracking(updated: 1, remindMeLater: 0)
                self.skipProfileEngagementPopup()
            }else {
                self.showAlert(title: "", message: "File format is not correct.")
            }
        }else{
            self.showAlert(title: "", message: "Please add file to upload.")
        }
    }
    func callAPIForSkip(){
        if let card = self.card {

            let headerDict = [
                "x-rule-applied": card.ruleApplied ?? "",
                "x-rule-version": card.ruleVersion ?? ""
            ]
            MIApiManager.hitRemindMeLaterApi(card.type, userActions: card.text, headerDict: headerDict) { (success, response, error, code) in
              
//                DispatchQueue.main.async {
//                    // MIActivityLoader.hideLoader()
//                    if error == nil && (code >= 200) && (code <= 299) {
//                   
//                    }
//                }
            }
            self.callAPIForEventTracking(updated: 0, remindMeLater: 1)
            self.skipProfileEngagementPopup()
            
        }
    }
    
    func callAPIForEventTracking(updated: Int, remindMeLater: Int) {
        var attribute = "EXPERIENCE" //(CV, EXPERIENCE, EDUCATION, SKILL, LOCATION, MOB, DESIGNATION
        
        var oldData = [String:Any]()
        var newData = [String:Any]()
        if updated == 1 {
            if popUpMode == .Resume {
                attribute = "CV"
                if let url = urlData {
                    //  let extenstion = url.pathExtension
                    oldData["cv"] = ""

                    if newData.count == 0{
                        newData["cv"] = url.lastPathComponent
                    }
                }
            }else {
                var newYear = 0
                var newMnth = 0
                if  let exYear = txtF_YearExp.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ,let y = Int(exYear) {
                    newYear = y
                }
                if let exMnth = txtF_MnthExp.text?.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() ,let m = Int(exMnth) {
                    newMnth = m
                }
                oldData["workExp"] = ["year":oldyearWxp,"month":oldmnthExp] //"\(oldyearWxp):\(oldmnthExp)"
                newData["workExp"] = ["year":newYear,"month":newMnth]
            }
        }else{
            if popUpMode == .Resume {
                oldData["cv"] = ""
                newData["cv"] = ""

            }else{
                oldData["workExp"] = [String:Any]()
                newData["workExp"] = [String:Any]()

            }
        }
        
        MIApiManager.hitTrackingEventsApi(attribute, updated: updated, remindMeLater: remindMeLater, oldValue: oldData, newValue: newData, timeSpent: viewLoadDate.getSecondDifferenceBetweenDates(), cardRule: card) { (success, response, error, code) in

        }
    }
}

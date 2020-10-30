//
//  MIBasicRegisterVC.swift
//  MonsteriOS
//
//  Created by Rakesh on 26/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import DropDown
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices

class MIBasicRegisterVC: MIBaseViewController {
    
    @IBOutlet weak var tblView:UITableView!
    
    var listFields = [String]()
    var newUserObj = MIUserModel(userId: "")
    var hidePassword = true
    var registerViaType: RegisterVia = .None
    var appleData: [String:Any]?

    var otpID = ""
    var otpCode = ""
    let hPopup = MIJobPreferencePopup.popup(horizontalButtons: true)
    let vPopup = MIJobPreferencePopup.popup()
    let dropDown = DropDown()
    
    var errorData : (index:Int,errorMessage:String) = (-1,"") {
        didSet {
            guard errorData.index >= 0 else { return }
            self.tblView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GA for Screen
        CommonClass.googleAnalyticsScreen(self)
        
        // Do any additional setup after loading the view.
        self.setUpViewOnLoad()
        
        //Get Channel based Code
        self.getCurrentChannelSite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Create your Account"
        
        if let authData = AppUserDefaults.value(forKey: .AuthenticationInfo, fallBackValue: "").stringValue.data(using: .utf8),
            let authInfo = try? JSONDecoder().decode(LoginAuth.self, from: authData) {
            //  JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
            
            AppDelegate.instance.authInfo = authInfo
            MIUserModel.resetUserResumeData()
            
            let home = MIHomeTabbarViewController()
            home.modalPresentationStyle = .fullScreen
            self.present(home, animated: true, completion: nil)
            
            RegisterFlowInstances.instance.controllers.removeAll()
            return
        } else {
            JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
            
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_PERSONAL, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING], destination: CONSTANT_SCREEN_NAME.REGISTER_PERSONAL) { (success, response, error, code) in
            }
        }
        self.tblView.reloadData()
    }
    //Mark:- Custom function
    func setUpViewOnLoad() {
        
        //Register TableView Cell
        tblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        tblView.register(UINib(nibName:String(describing: MITextViewTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
        tblView.register(UINib(nibName:String(describing: MISepratorCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MISepratorCell.self))
        tblView.register(UINib(nibName:String(describing: MIVisaTypeCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIVisaTypeCell.self))
        tblView.register(UINib(nibName:String(describing: MIUploadResumeCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIUploadResumeCell.self))
        tblView.register(nib: MISeparateCheckTickCell.loadNib(), withCellClass: MISeparateCheckTickCell.self)
        
        //Setting Tableview height
        tblView.estimatedRowHeight           = tblView.rowHeight
        tblView.rowHeight                    = UITableView.automaticDimension
        tblView.estimatedSectionHeaderHeight = tblView.sectionHeaderHeight
        tblView.sectionHeaderHeight          = UITableView.automaticDimension
        tblView.estimatedSectionFooterHeight = tblView.sectionFooterHeight
        tblView.sectionFooterHeight          = UITableView.automaticDimension
        tblView.keyboardDismissMode          = .onDrag
        
        newUserObj.userJobPreference = MIJobPreferencesModel()
        newUserObj.userSkills = [MIUserSkills]()
        self.manageFieldTitle()
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.clientID = kGmailClientId
        
        //        //Get region based on Site
        //        if let res = self.loadJson(filename: "SiteSubRegionLocation"), let data = res["data"] as? [[String:Any]],data.count > 0 {
        //            self.regionBasedLocation = data
        //        }
        self.checkUserRegisterViaSocial()
        //        let site = AppDelegate.instance.site
        //
        //        let sourceCountryISO = site?.defaultCountryDetails.isoCode ?? ""
        
        //        if sourceCountryISO.lowercased() != "in"{
        //            if sourceCountryISO.lowercased() == "sa" {
        //                self.callAPIForChannelBasedLocation(groupName: "Gulf")
        //            }else{
        //                self.callAPIForChannelBasedLocation(groupName: "SEA")
        //            }
        //        }
        self.configDropDown()
        self.configureDropDown(dropDown: dropDown)
        dropDown.width = self.tblView.frame.size.width
        
        //Setting Back Button
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(MIBasicRegisterVC.backBtnAction))
    }
    
    
    func checkUserRegisterViaSocial(){
        
        switch self.registerViaType {
            
        case .Facebook:
            MISocialHelper.getFacebookUserProfile(vc: self)
            MISocialHelper.socialShareInstance.socialCallBack = { result,error in
                CommonClass.googleEventTrcking("registration_screen", action: "social", label: "facebook")
                
                if let res = result {
                    self.registerViaType = .Facebook
                    self.manageFieldTitle()
                    self.populateSocialUserData(paramData: res, withToken: result?.stringFor(key: "token") ?? "")

                } else {
                    self.registerViaType = .None
                }
            }
            
        case .Google:
            guard let token = GIDSignIn.sharedInstance()?.currentUser.authentication.idToken else {
                self.registerViaType = .None
                return
            }
            
            var userName = ""
            if let firstName = GIDSignIn.sharedInstance()?.currentUser.profile.givenName {
                userName = firstName.capitalizedFirstLetter()
            }
            
            if let lastName = GIDSignIn.sharedInstance()?.currentUser.profile.familyName {
                userName = userName + " " + lastName.capitalizedFirstLetter()
            }
            
            let param = [
                "name"  : userName,
                "email" : GIDSignIn.sharedInstance()?.currentUser.profile.email ?? ""
                ] as [String : Any]
            
            self.registerViaType = .Google
            self.manageFieldTitle()
            self.populateSocialUserData(paramData: param, withToken: token)
            
        case .Apple:
            if let d = appleData {
                self.registerViaType = .Apple
                self.manageFieldTitle()
                self.populateSocialUserData(paramData: d, withToken: d["code"] as! String)
            } else {
                self.registerViaType = .None
            }
            
        default:
            break
        }
    }
    
    func setTitleToDefaultState() {
        listFields = [
            RegisterViewStoryBoardConstant.fullName,
            RegisterViewStoryBoardConstant.email,
            RegisterViewStoryBoardConstant.password,
            RegisterViewStoryBoardConstant.mobileNumber,
            RegisterViewStoryBoardConstant.currentLocation,
            RegisterViewStoryBoardConstant.cityName,
            RegisterViewStoryBoardConstant.nationality,
            RegisterViewStoryBoardConstant.visaTypeField,
            RegisterViewStoryBoardConstant.totalExperience,
            RegisterViewStoryBoardConstant.fieldSpace,
            RegisterViewStoryBoardConstant.skills,
            MIJobPreferenceViewControllerConstant.preferredIndu,
            MIJobPreferenceViewControllerConstant.preferredFunc,
            RegisterViewStoryBoardConstant.fieldSpace,
            RegisterViewStoryBoardConstant.uploadResume]
    }
    
    func manageFieldTitle() {
        
        let site = AppDelegate.instance.site
        let sourceCountryISO = site?.defaultCountryDetails.isoCode ?? ""
        self.setTitleToDefaultState()
        
        if sourceCountryISO.lowercased() == "in" {
            if registerViaType == .None  {
                self.filterTitleWithValue(values: [RegisterViewStoryBoardConstant.nationality, RegisterViewStoryBoardConstant.visaTypeField])
            }else{
                self.filterTitleWithValue(values: [RegisterViewStoryBoardConstant.nationality, RegisterViewStoryBoardConstant.visaTypeField, RegisterViewStoryBoardConstant.password])
            }
        }else{
            let visaType = self.checkRegionForCountryISO()
            var dataToFilter = [String]()
            
            if registerViaType != .None  {
                dataToFilter.append(RegisterViewStoryBoardConstant.password)
                self.newUserObj.userPassword = ""
            }
            if visaType == .None {
                self.newUserObj.visaType = MICategorySelectionInfo()
                dataToFilter.append(RegisterViewStoryBoardConstant.visaTypeField)
            }
            
            self.filterTitleWithValue(values: dataToFilter)
        }
        if !self.newUserObj.userlocationModal.name.lowercased().contains("other") {
            self.filterTitleWithValue(values: [RegisterViewStoryBoardConstant.cityName])
        }
    }
    func filterTitleWithValue(values:[String]) {
        for obj in values {
            if let index = listFields.firstIndex(of:obj) {
                listFields.remove(at: index)
            }
        }
    }
    func getCurrentChannelSite(){
        
        let siteValue = self.getSiteCountryISOCode()
        if !(siteValue.isoCode.lowercased() == "sg" || siteValue.isoCode.lowercased() == "ph" || siteValue.isoCode.lowercased() == "my" || siteValue.isoCode.lowercased() == "hk") {
            self.newUserObj.allowPromotionOfferMails = true
        }
        if !siteValue.countryPhoneCode.isEmpty {
            newUserObj.userCountryCode = "+" + siteValue.countryPhoneCode
            newUserObj.userCountryNameCode = siteValue.isoCode
        }
        if siteValue.isoCode.lowercased() == "in" {
            newUserObj.nationalityModal.name = "Indian"
            newUserObj.nationalityModal.countryISOCode = "in"
            newUserObj.nationalityModal.uuid = kIndianNationalityUUID
        }
    }
    
    func checkRegionForCountryISO() -> VisaOptionOpen {
        let site = AppDelegate.instance.site
        let sourceCountryISO = site?.defaultCountryDetails.isoCode ?? ""
        
        if sourceCountryISO.lowercased() == "in" {
            return VisaOptionOpen.None
        }else{
            if self.newUserObj.userlocationModal.countryUUID.isEmpty || self.newUserObj.nationalityModal.countryUUID.isEmpty {
                return VisaOptionOpen.None
            }else{
                if self.newUserObj.userlocationModal.countryUUID.withoutWhiteSpace().lowercased() ==  self.newUserObj.nationalityModal.countryUUID.withoutWhiteSpace().lowercased() {
                    return VisaOptionOpen.None
                }else{
                    return VisaOptionOpen.VisaTypeSelect
                }
            }
            
        }
    }
    
    func pushToMasterDataSelection(masterType:String,fieldName:String,selectionLimit:Int) {
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.delegate = self
        vc.limitSelectionCount = selectionLimit
        vc.masterType = MasterDataType(rawValue: masterType) ?? .ROLE
        
        if fieldName == RegisterViewStoryBoardConstant.currentLocation {
            if !newUserObj.userlocationModal.name.isEmpty {
                vc.selectDataArray  = [newUserObj.userlocationModal]
                vc.selectedInfoArray = [newUserObj.userlocationModal.name]
            }
        }
        if fieldName == RegisterViewStoryBoardConstant.nationality {
            if !newUserObj.nationalityModal.name.isEmpty {
                vc.selectDataArray  = [newUserObj.nationalityModal]
                vc.selectedInfoArray = [newUserObj.nationalityModal.name]
            }
        }
        if fieldName == MIJobPreferenceViewControllerConstant.preferredFunc {
            if let funtionData =  newUserObj.userJobPreference?.preferredFunctions , funtionData.count > 0 {
                let tuples = MICategorySelectionInfo.getSelectedMasterDataFor(dataSource:funtionData)
                vc.selectDataArray  = tuples.masterDataObject
                vc.selectedInfoArray = tuples.masterDataNames
            }
        }
        if fieldName == MIJobPreferenceViewControllerConstant.preferredIndu {
            if let industryData =  newUserObj.userJobPreference?.preferredIndustrys , industryData.count > 0 {
                let tuples = MICategorySelectionInfo.getSelectedMasterDataFor(dataSource:industryData)
                vc.selectDataArray  = tuples.masterDataObject
                vc.selectedInfoArray = tuples.masterDataNames
            }
        }
        if fieldName == RegisterViewStoryBoardConstant.visaTypeField {
            if self.checkRegionForCountryISO() == .None {
                return
            }
            if !self.newUserObj.visaType.name.isEmpty {
                vc.selectDataArray  = [self.newUserObj.visaType]
                vc.selectedInfoArray = [self.newUserObj.visaType.name]
            }
            vc.isoCountryCode = self.newUserObj.userlocationModal.countryISOCode.withoutWhiteSpace().uppercased()
        }
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    func validateFields() {
        
//        self.otpCode = "123455"
//        // self.newUserObj.userProfessionalType = .Fresher
//        self.newUserObj.userProfessionalType = .Experienced
//        self.newUserObj.userExperienceInYear = "1"
//        
//        self.navigationToNextController()
//        
//        return
//        return
        
        CommonClass.googleEventTrcking("registration_screen", action: "next", label: "page_1_personal")
        
        var validationMessage = [[String: Any]]()
        defer {
            var eventData = [
                "eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_SUBMIT,
                "recievePromotions" : self.newUserObj.allowPromotionOfferMails ? 1 : 0,
                "validationErrorMessages" : validationMessage
                ] as [String : Any]
            
            if self.registerViaType != .None {
                eventData["socialPlatformName"] = self.registerViaType.rawValue
            }
            
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_PERSONAL, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_PERSONAL) { (success, response, error, code) in
            }
        }
        
        
        let siteValue = self.getSiteCountryISOCode()
        let sourceCountryISO = siteValue.isoCode
        
        self.view.endEditing(true)
        if self.newUserObj.userFullName.count == 0 {
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.fullName) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.name.rawValue)
                validationMessage.append(["field":"Full Name", "message" : ErrorAndValidationMsg.name.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if self.newUserObj.userEmail.count == 0{
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.email) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.emailId.rawValue)
                validationMessage.append(["field":"Eamil ID", "message" : ErrorAndValidationMsg.emailId.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if self.newUserObj.userEmail.isValidEmail == false{
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.email) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.validEmail.rawValue)
                validationMessage.append(["field":"Eamil ID", "message" : ErrorAndValidationMsg.validEmail.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if self.newUserObj.userPassword.count == 0 && (registerViaType == .None){
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.password) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.password.rawValue)
                validationMessage.append(["field":"Password", "message" : ErrorAndValidationMsg.password.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if (self.newUserObj.userPassword.count < 6) && (registerViaType == .None) {
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.password) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.passwordless.rawValue)
                validationMessage.append(["field":"Password", "message" : ErrorAndValidationMsg.passwordless.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if (self.newUserObj.userPassword.count > 20) && (registerViaType == .None) {
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.password) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.passwordless.rawValue)
                validationMessage.append(["field":"Password", "message" : ErrorAndValidationMsg.passwordless.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if self.newUserObj.userCountryCode.count == 0{
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.mobileNumber) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.countryNumberCode.rawValue)
                validationMessage.append(["field":"Mobile Number", "message" : ErrorAndValidationMsg.countryNumberCode.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if self.newUserObj.userMobileNumber.count == 0{
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.mobileNumber) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.mobileNumber.rawValue)
                validationMessage.append(["field":"Mobile Number", "message" : ErrorAndValidationMsg.mobileNumber.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if !self.newUserObj.userMobileNumber.validiateMobile(for: self.newUserObj.userCountryCode).isValidate {
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.mobileNumber) {
                let indexPath = IndexPath(row: index, section: 0)
                let msg = self.newUserObj.userMobileNumber.validiateMobile(for: self.newUserObj.userCountryCode).erroMessage
                self.errorData = (indexPath.row, msg)
                validationMessage.append(["field":"Mobile Number", "message" : msg])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if self.newUserObj.userlocationModal.name.count == 0{
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.currentLocation) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.CurrentLocationError.rawValue)
                validationMessage.append(["field":"Current Location", "message" : ErrorAndValidationMsg.CurrentLocationError.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        } else if self.newUserObj.userlocationModal.name.lowercased().contains("other") && self.newUserObj.cityName.isEmpty {
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.cityName) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.CurrentCityError.rawValue)
                validationMessage.append(["field":"Current Location", "message" : ErrorAndValidationMsg.CurrentCityError.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            
        }else if self.newUserObj.nationalityModal.name.isEmpty && (sourceCountryISO.lowercased() != "in")  {
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.nationality) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, PersonalTitleConstant.NationalityEmpty)
                validationMessage.append(["field":"Nationality", "message" : PersonalTitleConstant.NationalityEmpty])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        } else if (self.checkRegionForCountryISO() == .VisaTypeSelect && self.newUserObj.visaType.name.isEmpty){
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.visaTypeField) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.visaTypeEmpty.rawValue)
                validationMessage.append(["field":"Visa Type", "message" : ErrorAndValidationMsg.visaTypeEmpty.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if self.newUserObj.userProfessionalType == .None {
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.totalExperience) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.emptyExperienceLevel.rawValue)
                validationMessage.append(["field":"Total Experience", "message" : ErrorAndValidationMsg.emptyExperienceLevel.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if self.newUserObj.userSkills?.count == 0 {
            if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.skills) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.skillEmpty.rawValue)
                validationMessage.append(["field":"Key Skills", "message" : ErrorAndValidationMsg.skillEmpty.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if self.newUserObj.userJobPreference?.preferredIndustrys.count == 0 {
            if let index = self.listFields.firstIndex(of: MIJobPreferenceViewControllerConstant.preferredIndu) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.preferedIndustryEmpty.rawValue)
                validationMessage.append(["field":"Preferred Industry", "message" : ErrorAndValidationMsg.preferedIndustryEmpty.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }else if self.newUserObj.userJobPreference?.preferredFunctions.count == 0 {
            if let index = self.listFields.firstIndex(of: MIJobPreferenceViewControllerConstant.preferredFunc) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, ErrorAndValidationMsg.preferedFunctionEmpty.rawValue)
                validationMessage.append(["field":"Preferred Function", "message" : ErrorAndValidationMsg.preferedFunctionEmpty.rawValue])
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        } else {//If all validation is correct user will be resistered
            
            if self.registerViaType == .Google {
                if let user = GIDSignIn.sharedInstance()?.currentUser, user.authentication.accessTokenExpirationDate.getSecondDifferenceBetweenDates() >= 0 {
                    
                    user.authentication.refreshTokens { (auth, error) in
                        guard let token = auth?.idToken else {
                            GIDSignIn.sharedInstance()?.signIn()
                            return
                        }
                        self.newUserObj.userSocialAccessToken = token
                        self.callAPIForRegisterPersonalDetail()
                    }
                    return
                }
            }
            
            self.callAPIForRegisterPersonalDetail()
            
        }
    }
    func navigationToNextController() {
        //If otp code is avaliable then user will claim by otp else will put its resume for its profile.
        if self.otpCode.isEmpty {
            let mobileChange = MIOTPViewController()
            mobileChange.openMode = .register
            mobileChange.countryCode = MIUserModel.userSharedInstance.userCountryCode.replacingOccurrences(of: "+", with: "")
            mobileChange.userName = MIUserModel.userSharedInstance.userMobileNumber
            self.navigationController?.pushViewController(mobileChange, animated: true)
            
        } else {
            if self.newUserObj.userProfessionalType == .Fresher {
                let vc = MIEducationByUserVC()
                vc.isFreshOrExper = .Fresher
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                if self.newUserObj.userExperienceInYear == "0" && self.newUserObj.userExperienceInMonth == "0"  {
                    let vc = MIEducationByUserVC()
                    vc.isFreshOrExper = .Fresher
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = MIEmployementForUserVC()
                    vc.isFreshOrExper = .Experienced
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    func callAPIForRegisterPersonalDetail() {
        MIActivityLoader.showLoader()
        
        let params = MIUserModel.getParmsFromModelForUserRegisteration(userModal: self.newUserObj, otpCode: self.otpCode, otpID: self.otpID, visaOption: self.checkRegionForCountryISO(), registerType: self.registerViaType)
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            //Convert Json to string for form data request
            let jsonStrig = String(data: jsonData, encoding: .utf8)
            if let json = jsonStrig {
                printDebug(json)
                
                MIApiManager.callAPIForRegisterPersonalDetail(path: APIPath.registerPersonalDetailVersion_2_ApiEndpoint, params: [APIKeys.detailsAPIKey: json]) { (success, response, error, code) in
                    //Handle Response
                    DispatchQueue.main.async {
                        MIActivityLoader.hideLoader()
                        if error == nil && (code >= 200) && (code <= 299) {
                            
                            //GA Event
                            
                            if self.newUserObj.userProfessionalType == .Experienced {
                                
                                if self.newUserObj.userExperienceInYear == "0" && self.newUserObj.userExperienceInMonth == "0" {
                                    self.newUserObj.userProfessionalType = .Fresher
                                }
                            }
                            
                            MIUserModel.userSharedInstance = self.newUserObj
                            
                            if let responseData = response as? [String:Any] {
                                if let accessToken = responseData["accessToken"] as? String {
                                    let expires = (responseData["expires"] as? Int ) ?? Int(Date().plus(years: 1).timeIntervalSince1970)
                                    let authModel = LoginAuth.init(accessToken: accessToken, tokenType: "Bearer", expiresIn: expires, scope: nil, jti: nil)
                                    AppDelegate.instance.authInfo = authModel
                                    
                                    AppDelegate.instance.authInfo.commit()
                                    self.navigationToNextController()
                                }
                            }
                        }else{
                            self.otpCode = ""
                            self.otpID = ""
                            if let responseData = response as? [String:Any] {
                                if let errorCode = responseData["errorCode"] as? String {
                                    //Case to handle mobile number exists or claim case.
                                    if errorCode == kMOBILE_NUMBER_EXISTS {
                                        self.existingMobilePopup()
                                        
                                    } else if errorCode == kEMAIL_ID_EXISTS {
                                        self.existingEmailPopup()
                                        
                                    } else {
                                        self.handleAPIError(errorParams: response, error: error)
                                    }
                                }else{
                                    self.handleAPIError(errorParams: response, error: error)
                                }
                            }else{
                                self.handleAPIError(errorParams: response, error: error)
                            }
                        }
                    }
                }
            }
            
        }catch {
            MIActivityLoader.hideLoader()
            print(error.localizedDescription)
        }
    }
    //    func callAPIForChannelBasedLocation(groupName:String) {
    //
    //        MIApiManager.callAPIForRegionBasedLocation(groupName: groupName, funcType: MasterDataType.LOCATION.rawValue, methodType: .get, limit: "500") { (isSuccess, response, error, code) in
    //            DispatchQueue.main.async {
    //                if error == nil && (code >= 200) && (code <= 299) {
    //                    if let result = response as? [String:Any] {
    //                        if  let data = result["data"] as? [[String:Any]],data.count > 0 {
    //                            self.regionBasedLocation = data
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    func existingEmailPopup() {
        self.view.endEditing(true)
        
        self.vPopup.setViewWithTitle(title: "", viewDescriptionText: "The Email ID is already registered with us. Please register using a different Email ID.", or: "OR", primaryBtnTitle: "Login Using Same Email ID", secondaryBtnTitle: "Forgot Password")
        self.vPopup.delegate = self
        self.vPopup.addMe(onView: self.view, onCompletion: nil)
    }
    
    func existingMobilePopup() {
        self.view.endEditing(true)
        
        self.hPopup.setViewWithTitle(title: "", viewDescriptionText: "This number belongs to another account. Please claim this number via OTP.", primaryBtnTitle: "Claim Number", secondaryBtnTitle: "Change Number")
        self.hPopup.delegate = self
        self.hPopup.addMe(onView: self.view, onCompletion: nil)
    }
    @objc private func backBtnAction() {
        CommonClass.googleEventTrcking("registration_screen", action: "back", label: "page_1_personal")
        self.navigationController?.popViewController(animated: false)
    }
}

extension MIBasicRegisterVC : UITableViewDelegate,UITableViewDataSource,GIDSignInDelegate,GIDSignInUIDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listFields.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let title = listFields[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
        cell.primaryTextField.tag = indexPath.row
        cell.primaryTextField.isUserInteractionEnabled = true
        cell.primaryTextField.isSecureTextEntry = false
        cell.primaryTextField.delegate = self
        cell.secondryTextField.isHidden = true
        cell.titleLabel.text = title
        cell.btnCovidSituation.isHidden = true
        cell.heightbtnCovidSituation.constant = 0
        cell.bottomBtnCovidSituation.constant = 0
        cell.primaryTextField.isEnabled = true
        cell.primaryTextField.alpha = 1.0
        cell.primaryTextField.rightView = nil
        
        let error = (self.errorData.index == indexPath.row) ? self.errorData.errorMessage : ""
        cell.showError(with: error, animated: false)
        
        if title == RegisterViewStoryBoardConstant.mobileNumber {
            cell.secondryTextField.adjustsFontSizeToFitWidth = true
            cell.secondryTextField.minimumFontSize = 12
            
            cell.secondryTextField.text = self.newUserObj.userCountryNameCode + "  " + newUserObj.userCountryCode
            cell.primaryTextField.text = newUserObj.userMobileNumber
            cell.secondryTextField.placeholder = "ISD"
            cell.primaryTextField.placeholder = "Your number for employers to reach you"
            cell.secondryTextField.isHidden = false
            
            cell.secondryTextFieldAction = { txtFld in
                let vc = MICountryCodePickerVC()
                vc.countryCodeSeleted = { country in
                    CommonClass.googleEventTrcking("registration_screen", action: "country_code", label: country.langOne?.first?.name.lowercased() ?? "")
                    let code = "+" + country.callPrefix.stringValue
                    self.newUserObj.userCountryCode = code
                    self.newUserObj.userCountryNameCode = country.isoCode
                    
                    txtFld.text = country.isoCode + "  " + code
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
                return false
            }
            
            return cell
            
        } else if title == MIJobPreferenceViewControllerConstant.preferredIndu || title == MIJobPreferenceViewControllerConstant.preferredFunc || title == RegisterViewStoryBoardConstant.skills {
            
            let tvCell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
            tvCell.titleLabel.text = title
            tvCell.textView.placeholder = title as NSString
            tvCell.textView.isUserInteractionEnabled = false
            
            tvCell.showError(with: error, animated: false)
            
            if title == MIJobPreferenceViewControllerConstant.preferredIndu {
                tvCell.showPopUpCallBack = {
                    tvCell.showInfoPopup(infoMsg: "Select a maximum of two industries where you want to work.")
                }
                self.showJobPreferenceInfoData(in: tvCell, title: title, jobPreferences: self.newUserObj.userJobPreference ?? MIJobPreferencesModel())
            } else if title == MIJobPreferenceViewControllerConstant.preferredFunc {
                self.showJobPreferenceInfoData(in: tvCell, title: title, jobPreferences: self.newUserObj.userJobPreference ?? MIJobPreferencesModel())
                tvCell.showPopUpCallBack = {
                    tvCell.showInfoPopup(infoMsg: "Select a maximum of two functions e.g. that your skills are suited for.")
                }
            } else {
                self.showSkills(in: tvCell, skillData: newUserObj.userSkills ?? [], title: title)
            }
            return tvCell
            
        } else if title == RegisterViewStoryBoardConstant.currentLocation {
            
            cell.primaryTextField.setRightViewForTextField("darkRightArrow")
            
            cell.primaryTextField.text = newUserObj.userlocationModal.name
            cell.primaryTextField.placeholder = "Please select your current location"
            // locationCell.txt_value.tag = indexPath.row
            return cell
            
        } else if title == RegisterViewStoryBoardConstant.password {
            cell.primaryTextField.isUserInteractionEnabled = true
            
            cell.primaryTextField.placeholder = "Password should be minimum 6 characters"
            cell.primaryTextField.text = newUserObj.userPassword
            
            cell.primaryTextField.rightViewMode = .always
            cell.primaryTextField.rightView = cell.eyeIcon
            
            cell.primaryTextField.isSecureTextEntry = hidePassword
            cell.eyeIcon?.isSelected = !hidePassword
            
            cell.hidePasswordCallBack = { show in
                self.hidePassword = !show
                cell.primaryTextField.isSecureTextEntry = !show
            }
            
            return cell
            
        } else if title == RegisterViewStoryBoardConstant.fieldSpace {
            return tableView.dequeueReusableCell(withClass: MISepratorCell.self, for: indexPath)
            
        } else if title == RegisterViewStoryBoardConstant.visaTypeField {
            guard let visaCell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIVisaTypeCell.self), for: indexPath) as? MIVisaTypeCell else {
                return UITableViewCell()
            }
            
            visaCell.showError(with: error, animated: false)
            
            visaCell.txt_SelectVisa.tag = indexPath.row
            visaCell.txt_SelectVisa.delegate = self
            visaCell.txt_SelectVisa.placeholder = "Visa Status"
            
            visaCell.show(info: self.newUserObj) 
            return visaCell
            
        } else if title == RegisterViewStoryBoardConstant.uploadResume {
            guard let resumeUpload = tableView.dequeueReusableCell(withIdentifier: String(describing: MIUploadResumeCell.self), for: indexPath) as? MIUploadResumeCell else {
                return UITableViewCell()
            }
            resumeUpload.showResumeName(modal: self.newUserObj)
            resumeUpload.uploadEditCallBack = { forUpload in
                self.view.endEditing(true)
                let vc = MIUploadResumeViewController()
                vc.flowVia = .ViaRegister
                vc.resumeUploadedAction = { (uploaded,fileName,result) in
                    self.newUserObj.userResume = MIUserResume(with: result )
                    
                    if self.newUserObj.userSkills?.count == 0 {
                        self.newUserObj.userSkills = MIUserModel.userSharedInstance.userSkills
                    }
                    if MIUserModel.userSharedInstance.userEmploymentDataList?.count ?? 0 > 0 {
                        self.newUserObj.userEmploymentDataList = MIUserModel.userSharedInstance.userEmploymentDataList
                    }
                    if MIUserModel.userSharedInstance.userEducationDataList?.count ?? 0 > 0 {
                        
                        var sectionFields = [String]()
                        
                        if MIUserModel.userSharedInstance.userEducationDataList!.first!.isEducationDegree {
                            
                            sectionFields = [
                                MIEducationDetailViewControllerConstant.highestQualification,
                                MIEducationDetailViewControllerConstant.specialisation,
                                MIEducationDetailViewControllerConstant.instituteName,
                                MIEducationDetailViewControllerConstant.passignYear,
                                MIEducationDetailViewControllerConstant.educationType
                            ]
                        }else {
                            sectionFields = [
                                MIEducationDetailViewControllerConstant.highestQualification,
                                MIEducationDetailViewControllerConstant.board,
                                MIEducationDetailViewControllerConstant.passignYear,
                                MIEducationDetailViewControllerConstant.educationType,
                                MIEducationDetailViewControllerConstant.medium
                            ]
                        }
                        
                        self.newUserObj.educationsByUser = [SectionModel(name: "Add Education", dataSource: MIUserModel.userSharedInstance.userEducationDataList?.first ?? MIEducationInfo(qualification: "", specialisation: "", instituteName: "", year: ""), sectionFields: sectionFields, number: 0)]
                        
                    }
                    self.newUserObj.userResume.resumeName = fileName.isEmpty ? (self.newUserObj.userFullName.isEmpty ? "Resume.pdf" : "Resume_\(self.newUserObj.userFullName).pdf") : fileName
                    self.newUserObj.userResume.resumeViaImages = fileName.isEmpty ? true : false
                }
                self.navigationController?.pushViewController(vc, animated: false)
            }
            return resumeUpload
        } else {
            cell.primaryTextField.placeholder = title
            
            switch title {
            case RegisterViewStoryBoardConstant.fullName:
                cell.primaryTextField.text = newUserObj.userFullName
                cell.primaryTextField.placeholder = "Enter your full name"
            case RegisterViewStoryBoardConstant.cityName:
                cell.titleLabel.text = "City"
                cell.primaryTextField.text = newUserObj.cityName
            case RegisterViewStoryBoardConstant.email:
                cell.primaryTextField.text = newUserObj.userEmail
                cell.primaryTextField.placeholder = "Enter your email ID"
                if self.registerViaType != .None && newUserObj.userEmail.count != 0 {
                    cell.primaryTextField.isEnabled = false
                    cell.primaryTextField.alpha =  0.5
                    cell.primaryTextField.isUserInteractionEnabled = false
                }
            case RegisterViewStoryBoardConstant.totalExperience:
                cell.primaryTextField.setRightViewForTextField("darkRightArrow")
                cell.primaryTextField.placeholder = "Please specify your total experience"
                
                if newUserObj.userProfessionalType == .Fresher {
                    cell.primaryTextField.text = newUserObj.userProfessionalType.rawValue
                    
                    if CommonClass.covidFlagMobile {
                        cell.btnCovidSituation.isHidden = true
                        cell.heightbtnCovidSituation.constant = 0
                        cell.bottomBtnCovidSituation.constant = 0
                        covid19Flag = false
                        cell.btnCovidSituation.setImage(#imageLiteral(resourceName: "checkbox_default"), for: .normal)
                    }
                    
                }else if newUserObj.userProfessionalType == .Experienced {
                    
                    cell.primaryTextField.text = self.getExperienceInYearMonth(user: newUserObj)
                    
                    //Add covid flag
                    if CommonClass.covidFlagMobile {
                        let year = newUserObj.userExperienceInYear
                        let month = newUserObj.userExperienceInMonth
                        
                        if  year.isNumeric && month.isNumeric {
                            if year > "0" || month > "0" {
                                
                                cell.btnCovidSituation.isHidden = false
                                cell.heightbtnCovidSituation.constant = 35
                                cell.bottomBtnCovidSituation.constant = 5
                                
                                covid19Flag ? cell.btnCovidSituation.setImage(#imageLiteral(resourceName: "checkbox_clicked"), for: .normal) : cell.btnCovidSituation.setImage(#imageLiteral(resourceName: "checkbox_default"), for: .normal)
                                
                                cell.covidSituationCallBack = { (isSelected) in
                                    isSelected ? cell.btnCovidSituation.setImage(#imageLiteral(resourceName: "checkbox_clicked"), for: .selected) : cell.btnCovidSituation.setImage(#imageLiteral(resourceName: "checkbox_default"), for: .normal)
                                }
                                
                            } else {
                                covid19Flag = false
                                cell.btnCovidSituation.setImage(#imageLiteral(resourceName: "checkbox_default"), for: .normal)
                                
                                cell.btnCovidSituation.isHidden = true
                                cell.heightbtnCovidSituation.constant = 0
                                cell.bottomBtnCovidSituation.constant = 0
                            }
                            
                        }
                    }
                    
                }else{
                    cell.primaryTextField.text = ""
                }
                cell.primaryTextField.isUserInteractionEnabled = false
                
                
            case RegisterViewStoryBoardConstant.nationality:
                cell.primaryTextField.setRightViewForTextField("darkRightArrow")
                cell.primaryTextField.text = newUserObj.nationalityModal.name
            default:
                cell.primaryTextField.text = ""
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if CommonClass.showSocialLogin {
            let headerView = MISocialView.header
            headerView.createBorderForSocialBtn()
            headerView.callBackForSocial = { socailType in
                self.view.endEditing(true)
                
                switch socailType {
                    
                case "facebook":
                    CommonClass.googleEventTrcking("registration_screen", action: "social", label: "facebook")
                    self.socialClickEvent("Facebook")
                    
                    FBSDKAccessToken.setCurrent(nil)
                    MISocialHelper.getFacebookUserProfile(vc: self)
                    MISocialHelper.socialShareInstance.socialCallBack = { result,error in
                        if error == nil {
                            self.registerViaType = .Facebook
                            self.manageFieldTitle()
                            self.socialLoginUser(result ?? [String:Any](), providerToken: result?.stringFor(key: "token") ?? "")
                        }
                    }
                    
                case "google":
                    self.socialClickEvent("Google")
                    self.gmailClicked()
                    
                case "apple":
                    self.socialClickEvent("Apple")
                    if #available(iOS 13.0, *) {
                        self.appleClicked()
                    }
                default: break
                }
                
            }
            headerView.callBackForToolTip = { v in
                CommonClass.googleEventTrcking("registration_screen", action: "social", label: "info_icon")
                self.showInfoPopup(sourceView: v, infoMsg: "Use this option to skip filling name, email id, password and phone number. Nothing gets published without your permission.")
            }
            return headerView
        }else{
            return nil
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = MIRegisterBottomView.footerView
        footerView.showPrivacyPolicyContent()
        let site = AppDelegate.instance.site
        let sourceCountryISO = site?.defaultCountryDetails.isoCode ?? ""
        
        footerView.checkboxButton.isSelected = self.newUserObj.allowPromotionOfferMails
        if !(sourceCountryISO.lowercased() == "sg" || sourceCountryISO.lowercased() == "ph" || sourceCountryISO.lowercased() == "my" || sourceCountryISO.lowercased() == "hk") {
            footerView.checkboxButton.isHidden = true
        } else {
            footerView.checkboxButton.isHidden = false
        }
        
        
        footerView.register_Btn.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
        //    footerView.register_Btn.tintColor
        
        switch self.newUserObj.userProfessionalType {
        case .Fresher:
            footerView.register_Btn.setTitle("Next: Education Details", for: .normal)
            
        case .Experienced:
            if self.newUserObj.userExperienceInYear == "0" && self.newUserObj.userExperienceInMonth == "0"  {
                footerView.register_Btn.setTitle("Next: Education Details", for: .normal)
            }else{
                footerView.register_Btn.setTitle("Next: Work Experience", for: .normal)
            }
        default:
            footerView.register_Btn.setTitle("Next: Education Details", for: .normal)
        }
        
        if let domainName=AppDelegate.instance.site?.domain {
            footerView.checkboxButton.setTitle("Receive promotions from \(domainName.replacingOccurrences(of: "www.", with: ""))", for: .normal)
        }
        footerView.checkBoxSelectionAction = { (isSelected, v) in
            v.checkboxButton.isSelected = isSelected
            self.newUserObj.allowPromotionOfferMails = isSelected
        }
        
        footerView.didTapOnlabl = { (status , termType) in
            
            self.view.endEditing(true)
            let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
            
            if termType == .Terms {
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.TERMS_CONDITION_SCREEN)
                CommonClass.googleEventTrcking("registration_screen", action: "t&c", label: "t&c")
                vc.url = WebURl.termsConditionsUrl
                vc.ttl = "Terms & Conditions"
            }
            
            if termType == .Default {
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.TERMS_CONDITION_SCREEN)
                
                vc.url = WebURl.termsConditionsUrl
                vc.ttl = "Terms & Conditions"
                
            }
            if termType == .Privacy {
                JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.PRIVACY_POLICY_SCREEN)
                
                CommonClass.googleEventTrcking("registration_screen", action: "t&c", label: "privacy_policy")
                vc.url = WebURl.privacyPolicyUrl
                vc.ttl = "Privacy Policy"
            }
            let nav = MINavigationViewController(rootViewController:vc)
            nav.modalPresentationStyle = .fullScreen
            
            self.present(nav, animated: true, completion: nil)
        }
        footerView.registerBtnCallBack = { btn in
            self.view.endEditing(true)
            
            self.validateFields()
        }
        
        return footerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.view.endEditing(true)
        self.errorData = (-1, "")
        let title = listFields[indexPath.row]
        if title == RegisterViewStoryBoardConstant.totalExperience {
            let workExp = MIWorkExperienceVC()
            if newUserObj.userProfessionalType != .None {
                workExp.professionalType = newUserObj.userProfessionalType
                if newUserObj.userProfessionalType == .Experienced {
                    workExp.experienceInYear = newUserObj.userExperienceInYear
                    workExp.experienceInMonth = newUserObj.userExperienceInMonth
                }
            }
            workExp.workExperienceSelected = { (expType,yearOfExp,monthOfExp) in
                self.newUserObj.userProfessionalType = expType
                
                CommonClass.googleEventTrcking("registration_screen", action: "total_experience", label: expType.rawValue)
                if let year = yearOfExp {
                    self.newUserObj.userExperienceInYear = "\(year)"
                }
                if let month = monthOfExp {
                    self.newUserObj.userExperienceInMonth = "\(month)"
                }
                
            }
            self.navigationController?.pushViewController(workExp, animated: true)
        }
        if title == RegisterViewStoryBoardConstant.skills {
            let vc = MISkillAddViewController(nibName: String(describing: MISkillAddViewController.self), bundle: Bundle.main)
            vc.flowVia = .ViaRegister
            vc.selectedSkills = self.newUserObj.userSkills ?? [MIUserSkills]()
            vc.callBackAfterResponse = { skills in
                self.newUserObj.userSkills = skills
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if title == MIJobPreferenceViewControllerConstant.preferredIndu {
            self.pushToMasterDataSelection(masterType: MasterDataType.INDUSTRY.rawValue, fieldName: title, selectionLimit: 2)
        }
        if title == MIJobPreferenceViewControllerConstant.preferredFunc {
            self.pushToMasterDataSelection(masterType: MasterDataType.FUNCTION.rawValue, fieldName: title, selectionLimit: 2)
        }
    }
    
    func gmailClicked() {
        CommonClass.googleEventTrcking("registration_screen", action: "social", label: "google")
        
        GIDSignIn.sharedInstance()?.signOut()
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            // Perform any operations on signed in user here.
            guard let token = user?.authentication.idToken else { return }
            var userName = ""
            
        
            if let firstName = user.profile.givenName {
                userName = firstName.capitalizedFirstLetter()
            }
            if let lastName = user.profile.familyName {
                userName = userName + " " + lastName.capitalizedFirstLetter()
            }
            
            self.registerViaType = .Google
            self.manageFieldTitle()
            self.socialLoginUser(["name"  : userName,
                                  "email" : user.profile.email as Any
            ] , providerToken: token)
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func socialClickEvent(_ socialPlatformName: String) {
        let eventData = [
            "eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK,
            "socialPlatformName" : socialPlatformName
        ]
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_PERSONAL, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_PERSONAL) { (success, response, error, code) in
        }
    }
    
    func socialLoginUser(_ param: [String: Any], providerToken:String) {
        MIActivityLoader.showLoader()
        var paramData = [
            "username"   : providerToken,
            "social_provider" : self.registerViaType.rawValue
        ]
        
        MIApiManager.socialLoginAPI(&paramData) { (result, error) in
            MIActivityLoader.hideLoader()
            guard let data = result else {
                
                if (error?.code ?? 0) != 400 {
                    self.populateSocialUserData(paramData: param, withToken: providerToken)
                } else {
                    self.showAlert(title:"Error", message:error?.localizedDescription)
                }
                return
            }
            AppDelegate.instance.authInfo = data
            AppDelegate.instance.authInfo.commit()
            
            let home = MIHomeTabbarViewController()
            home.modalPresentationStyle = .fullScreen
            self.present(home, animated: true, completion: nil)
        }
    }
  
    func populateSocialUserData(paramData:[String:Any],withToken token:String) {
        self.newUserObj.userFullName = paramData.stringFor(key: "name")
        self.newUserObj.userEmail = paramData.stringFor(key: "email")
        self.newUserObj.userSocialAccessToken = token
        self.manageFieldTitle()
        self.tblView.reloadData()
    }
    
    func configDropDown(){
        var dataSource=[String]()
        
        //        for item in ManageSubscriptionDropDownData.allCases{
        //            dataSource.append(item.rawValue)
        //        }
        let emailDomain : [String] = ["gmail.com","yahoo.com","hotmail.com","aol.com","live.com","outlook.com"]
        
        for data in emailDomain {
            dataSource.append(data)
        }
        
        dropDown.dataSource = dataSource
        dropDown.selectionAction = {  (index: Int, item: String) in
            self.view.endEditing(true)
            self.newUserObj.userEmail = self.newUserObj.userEmail + item
            self.tblView.reloadData()
            
        }
        dropDown.cellConfiguration = {(_, item) in
            return "\(item)"
        }
    }
}

extension MIBasicRegisterVC : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" { return true }
        guard let indexPath = textField.tableViewIndexPath(self.tblView) else { return true }
        
        let title = listFields[indexPath.row]
        
        let searchTxt = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if title == RegisterViewStoryBoardConstant.mobileNumber {
            if string == "" { return true }
            return (searchTxt.count <= searchTxt.validiateMobile(for: self.newUserObj.userCountryCode).thresholdValue)
        }
        if title == RegisterViewStoryBoardConstant.email {
            
            if searchTxt.last == "@" {
                self.dropDown.show()
            }else{
                self.dropDown.hide()
            }
        }
        if title == RegisterViewStoryBoardConstant.fullName {
            let letters = NSCharacterSet.letters
            let range = string.rangeOfCharacter(from: letters)
            if string == " " {
                return true
            }
            // range will be nil if no letters is found
            if range == nil {
                return false
            }
            
        }
        if title == RegisterViewStoryBoardConstant.password {
            if string == "" {
                return true
            }
            if searchTxt.count > 20 {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let indexPath = textField.tableViewIndexPath(self.tblView) else { return true }
        self.errorData = (-1,"")
        
        let title = listFields[indexPath.row]
        textField.returnKeyType = .done
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .none
        
        if title == RegisterViewStoryBoardConstant.fullName {
            textField.autocapitalizationType = .words
            textField.returnKeyType = .next
        }
        if title == RegisterViewStoryBoardConstant.email {
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .next
            self.dropDown.anchorView = textField
            self.dropDown.bottomOffset = CGPoint(x: 0, y:((self.dropDown.anchorView?.plainView.bounds.height)!))
            self.dropDown.topOffset = CGPoint(x: 0, y:-((self.dropDown.anchorView?.plainView.bounds.height)!))
        }
        if title == RegisterViewStoryBoardConstant.password {
            textField.returnKeyType = .next
            
        }
        if title == RegisterViewStoryBoardConstant.mobileNumber {
            textField.keyboardType = .numberPad
            textField.addDoneButtonOnKeyboard()
        }
        if title == RegisterViewStoryBoardConstant.currentLocation {
            self.pushToMasterDataSelection(masterType: MasterDataType.LOCATION.rawValue, fieldName: title, selectionLimit: 1)
            return false
        }
        if title == RegisterViewStoryBoardConstant.visaTypeField {
            self.pushToMasterDataSelection(masterType: MasterDataType.VISA_TYPE.rawValue, fieldName: title, selectionLimit: 1)
            return false        }
        if title == RegisterViewStoryBoardConstant.nationality {
            self.pushToMasterDataSelection(masterType: MasterDataType.NATIONALITY.rawValue, fieldName: title, selectionLimit: 1)
            return false
        }
        DispatchQueue.main.async {
            self.setMainViewFrame(originY: 0)
            let movingHeight = textField.movingHeightIn(view : self.view) + 30
            if movingHeight > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.setMainViewFrame(originY: -movingHeight)
                }
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // guard let indexPath = textField.tableViewIndexPath(self.tblView) else { return  }
        
        let title = listFields[textField.tag]
        
        if title == RegisterViewStoryBoardConstant.fullName {
            newUserObj.userFullName = textField.text?.withoutWhiteSpace() ?? ""
        }
        if title == RegisterViewStoryBoardConstant.email {
            newUserObj.userEmail = textField.text?.withoutWhiteSpace() ?? ""
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                self.callApiForEmailValidation()
            })
        }
        if title == RegisterViewStoryBoardConstant.mobileNumber {
            newUserObj.userMobileNumber = textField.text?.withoutWhiteSpace() ?? ""
            self.callApiForMobileValidation()
        }
        if title == RegisterViewStoryBoardConstant.password {
            newUserObj.userPassword = textField.text?.withoutWhiteSpace() ?? ""
        }
        if title == RegisterViewStoryBoardConstant.cityName {
            newUserObj.cityName = textField.text?.withoutWhiteSpace() ?? ""
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: 0)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.returnKeyType == .next {
            self.view.viewWithTag(textField.tag+1)?.becomeFirstResponder()
        }
        
        if textField.returnKeyType == .done  {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    func callApiForEmailValidation() {
        if self.newUserObj.userEmail.isEmpty { return }
        guard let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.email) else { return }
        
        guard self.newUserObj.userEmail.isValidEmail else {
            self.errorData = (index, ErrorAndValidationMsg.validEmail.rawValue)
            return
        }
        
        MIApiManager.validiateEmail(newUserObj.userEmail) { (result, error) in
            if result?.message == "EXISTS" {
                self.existingEmailPopup()
            }
        }
    }
    
    func callApiForMobileValidation() {
        if self.newUserObj.userMobileNumber.isEmpty { return }
        guard let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.mobileNumber) else { return }
        
        let data = self.newUserObj.userMobileNumber.validiateMobile(for: self.newUserObj.userCountryCode)
        guard data.isValidate else {
            self.errorData = (index, data.erroMessage)
            return
        }
        
        let param = [
            "countryCode" : self.newUserObj.userCountryCode.replacingOccurrences(of: "+", with: ""),
            "mobileNumber" : newUserObj.userMobileNumber
        ]
        
        MIApiManager.validiateMobile(param) { (result, error) in
            if result?.message == "EXISTS" {
                self.existingMobilePopup()
            }
        }
    }
}

extension MIBasicRegisterVC : MIMasterDataSelectionViewControllerDelegate {
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        
        if enumName == MasterDataType.LOCATION.rawValue {
            self.newUserObj.userlocationModal = selectedCategoryInfo.first ?? MICategorySelectionInfo()
            self.manageFieldTitle()
            self.newUserObj.visaType = MICategorySelectionInfo()
        }
        if enumName == MasterDataType.NATIONALITY.rawValue {
            self.newUserObj.nationalityModal = selectedCategoryInfo.first ?? MICategorySelectionInfo()
            self.manageFieldTitle()
            self.newUserObj.visaType = MICategorySelectionInfo()
            
        }
        if enumName == MasterDataType.VISA_TYPE.rawValue {
            self.newUserObj.visaType = selectedCategoryInfo.first ?? MICategorySelectionInfo()
            
            CommonClass.googleEventTrcking("registration_screen", action: "work_visa", label: self.newUserObj.visaType.name)
        }
        if enumName == MasterDataType.FUNCTION.rawValue {
            self.newUserObj.userJobPreference?.preferredFunctions = selectedCategoryInfo
        }
        if enumName == MasterDataType.INDUSTRY.rawValue {
            self.newUserObj.userJobPreference?.preferredIndustrys = selectedCategoryInfo
        }
        self.tblView.reloadData()
    }
    
    func showInfoPopup(sourceView: UIView, infoMsg:String) {
        let controller = MIInfoPopOverController()
        controller.message = infoMsg
        controller.delegate = self
        controller.preferredContentSize = CGSize(width: self.view.bounds.size.width, height: 110)
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
}

extension MIBasicRegisterVC: DismissPopOverControllerDelegate {
    func dismissInfoPopOverController() {
        let headerView = MISocialView.header
        headerView.helpButton.setImage(#imageLiteral(resourceName: "helpgray"), for: .normal)
        self.tblView.reloadData()
    }
}

extension MIBasicRegisterVC : PendingActionDelegate {
    func otpDetailData(otp: String, otpId: String) {
        self.otpID = otpId
        self.otpCode = otp
        self.validateFields()
    }
    
}

extension MIBasicRegisterVC : JobPreferencePopUpDelegate {
    
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {
        
        var time: DispatchTime = .now()
        if self.navigationController?.viewControllers.last is MIBasicRegisterVC == false {
            self.navigationController?.popToViewController(self, animated: false)
            time = time + 0.5
        }
        
        DispatchQueue.main.asyncAfter(deadline: time) {
            
            var eventData = [
                "eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK,
                ] as [String : Any]
            defer {
                if self.registerViaType != .None {
                    eventData["socialPlatformName"] = self.registerViaType.rawValue
                }
                
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_PERSONAL, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_PERSONAL) { (success, response, error, code) in
                }
            }
            
            if popup == self.hPopup {
                if popSelection == .Ignored {
                    //Scroll To Mobile Number
                    CommonClass.googleEventTrcking("registration_screen", action: "claim_number_popup", label: "change_number")
                    eventData["claimNumber"] = false
                    eventData["changeNumber"] = true
                    
                    if let index = self.listFields.firstIndex(of: RegisterViewStoryBoardConstant.mobileNumber) {
                        let indexPath = IndexPath(row: index, section: 0)
                        
                        self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                        
                        let cell = self.tblView.cellForRow(at: indexPath) as? MITextFieldTableViewCell
                        cell?.primaryTextField.becomeFirstResponder()
                    }
                }else if popSelection == .Close {
                    CommonClass.googleEventTrcking("registration_screen", action: "claim_number_popup", label: "close")
                }else{
                    eventData["claimNumber"] = true
                    eventData["changeNumber"] = false
                    
                    CommonClass.googleEventTrcking("registration_screen", action: "claim_number_popup", label: "claim_number")
                    let mobileChange = MIOTPViewController()
                    mobileChange.openMode = .viaRegisterClaim
                    mobileChange.countryCode = self.newUserObj.userCountryCode.replacingOccurrences(of: "+", with: "")
                    mobileChange.delegate = self
                    mobileChange.userName = self.newUserObj.userMobileNumber
                    self.navigationController?.pushViewController(mobileChange, animated: true)
                }
            } else {
                if popSelection == .Ignored {
                    CommonClass.googleEventTrcking("registration_screen", action: "already_registered_popup", label: "forgot_password")
                    eventData["forgotPassword"] = true
                    eventData["loginWithSameEmailId"] = false
                    
                    let vc = MIForgotPasswordViewController.newInstance
                    vc.openMode = .forgotPassword
                    vc.userName = self.newUserObj.userEmail
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                } else if popSelection == .Close {
                    CommonClass.googleEventTrcking("registration_screen", action: "already_registered_popup", label: "close")
                }else {
                    CommonClass.googleEventTrcking("registration_screen", action: "already_registered_popup", label: "login")
                    eventData["forgotPassword"] = false
                    eventData["loginWithSameEmailId"] = true
                    
                    let vc = MILoginViewController.newInstance
                    vc.userName = self.newUserObj.userEmail
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

extension MIBasicRegisterVC {
    func getExperienceInYearMonth(user:MIUserModel) -> String {
        var workExp = ""
        
        if user.userExperienceInYear == "0" || user.userExperienceInYear == "1"  {
            workExp = user.userExperienceInYear + " " + "Year"
        }else{
            workExp = user.userExperienceInYear + " " + "Years"
            
        }
        if user.userExperienceInMonth == "0" || user.userExperienceInMonth == "1"  {
            workExp = workExp + " " + user.userExperienceInMonth + " " + "Month"
        }else{
            workExp = workExp + " " + user.userExperienceInMonth + " " + "Months"
            
            
        }
        return workExp
    }
    
    
    // Cells Initiliazations
    func showJobPreferenceInfoData(in cell: MITextViewTableViewCell, title:String, jobPreferences:MIJobPreferencesModel) {
        var value = ""
        cell.helpButton.isHidden = false
        //cell.accessoryImageView.isHidden = false
        
        cell.textView.textContainer.maximumNumberOfLines = 0
        
        if title == MIJobPreferenceViewControllerConstant.preferredIndu {
            cell.textView.placeholder = "Maximum 2 industries can be selected."
            value = (jobPreferences.preferredIndustrys.map { $0.name }).joined(separator: ", ")
            
        }else if title == MIJobPreferenceViewControllerConstant.preferredFunc {
            cell.textView.placeholder = "Maximum 2 functions can be selected."
            value = (jobPreferences.preferredFunctions.map { $0.name }).joined(separator: ", ")
        }
        
        cell.textView.text = value
        
    }
    func showSkills(in cell: MITextViewTableViewCell, skillData: [MIUserSkills], title:String) {
        cell.textView.text = (skillData.map { $0.skillName }).joined(separator: ",")
        cell.helpButton.isHidden = true
        cell.textView.placeholder = "Enter or select your skills"
        //cell.accessoryImageView.isHidden = true
        //   cell.textView.textContainer.maximumNumberOfLines = 2
    }
    
}

class RegisterFlowInstances {
    private init() {}
    static let instance = RegisterFlowInstances()
    
    var controllers = [UIViewController]()
}


@available(iOS 13.0, *)
extension MIBasicRegisterVC: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func appleClicked() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [ .fullName, .email ]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Handle error here
        print(error)
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account in your system.
            //            let userIdentifier = appleIDCredential.user
            //            let authorizationCode = appleIDCredential.authorizationCode
            let userFirstName = appleIDCredential.fullName?.givenName ?? ""
            let userLastName = appleIDCredential.fullName?.familyName ?? ""
            let userEmail = appleIDCredential.email
            
            
            guard
                let code = appleIDCredential.authorizationCode,
                let token = String(data: code, encoding: .utf8)
                else { return }
            
            let param = [
                "name"  : userFirstName + " " + userLastName,
                "email" : userEmail as Any
            ]
            
            MIApiManager.appleLoginRefreshTokenAPI(token) { (result, error) in
                guard let data = result else { return }

                self.registerViaType = .Apple
                self.socialLoginUser(param, providerToken: data.refreshToken)
            }
            //Navigate to other view controller
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            // let username = passwordCredential.user
            // let password = passwordCredential.password
            
            //Navigate to other view controller
            
        }
    }
    
}


//
//  MIJobPreferenceVC.swift
//  MonsteriOS
//
//  Created by Anushka on 04/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//  From: Sign up

import UIKit
import Photos

class MIJobPreferenceVC: MIBaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView : UIView!
    
    let popup = MIJobPreferencePopup.popup()
    var isPopOnView = false
    var userImg : UIImage?
    var isFreshOrExper:ProfessionalDetailsEnum = .Fresher
    var progView = MIProgressView.header
    
    var selectedCountryFieldType: String = ""

    
    var fieldTitleDataSource : [SectionModel] = [
        SectionModel(name: SectionNameConstant.jobPerences, dataSource: MIJobPreferencesModel(), sectionFields:  [ MIJobPreferenceViewControllerConstant.profileImage, MIJobPreferenceViewControllerConstant.profileTitle, MIJobPreferenceViewControllerConstant.preferredLoc, MIJobPreferenceViewControllerConstant.residentStatus, MIJobPreferenceViewControllerConstant.workAuthorization, MIJobPreferenceViewControllerConstant.preferredRole, MIJobPreferenceViewControllerConstant.preferredJobType ], number: 0),
        SectionModel(name: SectionNameConstant.itSkill, dataSource: [MIProfileITSkills](), sectionFields:[], number: 1),
        SectionModel(name: SectionNameConstant.personalDetails, dataSource:MIPersonalDetail(), sectionFields: [ PersonalTitleConstant.Gender, PersonalTitleConstant.DOB, PersonalTitleConstant.MaritalStatus ], number: 2),//, PersonalTitleConstant.countriesAuthorized
        SectionModel(name: SectionNameConstant.languages, dataSource:[MIProfileLanguageInfo](), sectionFields:[], number: 3)]
    
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initialSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Job Preference"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_JOB_PREFERENCE, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING], source: "", destination: CONSTANT_SCREEN_NAME.REGISTER_JOB_PREFERENCE) { (success, response, error, code) in
        }

        if !self.progressView.subviews.contains(progView) {
            progView.frame = CGRect(x: 0, y: 0, width: kScreenSize.width, height: 44)
            if isFreshOrExper == .Fresher {
                progView.progressViewStatus(num: 2, completed: 1, current: 1 )
            }else{
                progView.progressViewStatus(num: 3, completed: 2, current: 2 )
            }
            self.progressView.addSubview(progView)
        }
    }
    
    func initialSetup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Register Cell
        self.tableView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        self.tableView.register(UINib(nibName:String(describing: MI3RadioButtonTableCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MI3RadioButtonTableCell.self))
        self.tableView.register(UINib(nibName:String(describing: MITextViewTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
        self.tableView.register(UINib(nibName: "MIProfileITSkillCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.ITSkill.rawValue)
        self.tableView.register(UINib(nibName: "MIProfileLanguageCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.language.rawValue)
        self.tableView.register(UINib(nibName: "MIJobPreferenceImgCell", bundle: nil), forCellReuseIdentifier: "MIJobPreferenceImgCell")
        
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.estimatedRowHeight = tableView.rowHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.sectionHeaderHeight = tableView.sectionHeaderHeight
        self.tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.tableView.sectionFooterHeight = tableView.sectionFooterHeight
        self.tableView.estimatedSectionFooterHeight = UITableView.automaticDimension
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(MIJobPreferenceVC.backBtnAction))

        
        let footer = MISingleButtonView.singleBtnView
        footer.btn_delete.showPrimaryBtn()
        footer.btn_delete.setTitle("Start Applying Now", for: .normal)
        self.tableView.tableFooterView = footer
        footer.btnActionCallBack = { sectionCount in
            self.callAPIForUpdateUserPersonalDetail()
            
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_JOB_PREFERENCE, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "validationErrorMessages" : []], source: "", destination: CONSTANT_SCREEN_NAME.REGISTER_JOB_PREFERENCE) { (success, response, error, code) in
                
            }
            CommonClass.googleEventTrcking("registration_screen", action: "next", label: "page_4_job_preferences")
        }
       
        if isFreshOrExper == .Fresher{
            
            if let educationFirst = MIUserModel.userSharedInstance.educationsByUser?.first?.sectionDataSource as? MIEducationInfo {
                if let sectionModel = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.jobPerences}).last?.sectionDataSource as? MIJobPreferencesModel {
                    if educationFirst.isEducationDegree {
                        sectionModel.profileTitle = " Fresher with " +  educationFirst.highestQualificationObj.name + " from " + educationFirst.collegeObj.name + " living in " + MIUserModel.userSharedInstance.userlocationModal.name
                        
                    }else{
                        sectionModel.profileTitle = "Fresher living in " + MIUserModel.userSharedInstance.userlocationModal.name
                    }
                }
                
            }
        }else{
            
            if let employment = MIUserModel.userSharedInstance.userEmploymentDataList?.first {
                if let sectionModel = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.jobPerences}).last?.sectionDataSource as? MIJobPreferencesModel {
                    sectionModel.profileTitle = employment.designationObj.name + " at " + employment.companyObj.name + " having " + MIUserModel.userSharedInstance.userExperienceInYear + " yrs " + MIUserModel.userSharedInstance.userExperienceInMonth + " months work experience currently living in " + MIUserModel.userSharedInstance.userlocationModal.name
                }
                
            }
        }
        
        self.callApi()
    }
    @objc func skipBtnClicked(_ sender:UIBarButtonItem){
        self.view.endEditing(true)
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_JOB_PREFERENCE, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK, "skipThisStep" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: "", destination: CONSTANT_SCREEN_NAME.REGISTER_JOB_PREFERENCE) { (success, response, error, code) in
        }
      
        isPopOnView = !isPopOnView
        if isPopOnView {
            isPopOnView = false
            popup.delegate = self
            popup.addMe(onView: self.view, onCompletion: nil)
        }
    }
    func getSelectedMasterDataFor(dataSource:[MICategorySelectionInfo]) -> (masterDataNames:[String],masterDataObject:[MICategorySelectionInfo]) {
        var selectedInfoArray = [String]()
        var selectDataArray = [MICategorySelectionInfo]()
        if (dataSource.count) > 0 {
            selectedInfoArray = (dataSource.map({ $0.name}))
            selectDataArray = dataSource
        }
        return (selectedInfoArray,selectDataArray)
        
    }
    func pushToMasterDataSelection(fieldName:String,selectionLimit:Int,sectionName:String) {
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.delegate = self
        if sectionName == SectionNameConstant.jobPerences {
            if let sectionModel = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.jobPerences}).last?.sectionDataSource as? MIJobPreferencesModel {
                
                if fieldName == MIJobPreferenceViewControllerConstant.preferredLoc {
                    vc.masterType = .LOCATION
                    vc.limitSelectionCount = 5
                    if sectionModel.preferredLocationList.count > 0 {
                        let tuples = self.getSelectedMasterDataFor(dataSource: sectionModel.preferredLocationList)
                        vc.selectedInfoArray = tuples.masterDataNames
                        vc.selectDataArray = tuples.masterDataObject
                    }
                    self.navigationController?.pushViewController(vc, animated: false)
                    
                }
                if fieldName == MIJobPreferenceViewControllerConstant.residentStatus {
                    self.selectedCountryFieldType = MIJobPreferenceViewControllerConstant.residentStatus
                    vc.masterType = .COUNTRY
                    vc.limitSelectionCount = 50
                    if sectionModel.residentList.count > 0 {
                        let tuples = self.getSelectedMasterDataFor(dataSource: sectionModel.residentList)
                        vc.selectedInfoArray = tuples.masterDataNames
                        vc.selectDataArray = tuples.masterDataObject
                    }
                    self.navigationController?.pushViewController(vc, animated: false)
                    
                }
                if fieldName == MIJobPreferenceViewControllerConstant.workAuthorization {
                    self.selectedCountryFieldType = MIJobPreferenceViewControllerConstant.workAuthorization
                    vc.masterType = .COUNTRY
                    vc.limitSelectionCount = 50
                    if sectionModel.workAuthorizationList.count > 0 {
                        let tuples = self.getSelectedMasterDataFor(dataSource: sectionModel.workAuthorizationList)
                        vc.selectedInfoArray = tuples.masterDataNames
                        vc.selectDataArray = tuples.masterDataObject
                    }
                    self.navigationController?.pushViewController(vc, animated: false)
                    
                }
                if fieldName == MIJobPreferenceViewControllerConstant.preferredRole {
                    vc.masterType = .ROLE
                    vc.limitSelectionCount = 2
                    if sectionModel.preferredRoles.count > 0 {
                        let tuples = self.getSelectedMasterDataFor(dataSource: sectionModel.preferredRoles)
                        vc.selectedInfoArray = tuples.masterDataNames
                        vc.selectDataArray = tuples.masterDataObject
                    }
                    vc.parentId = MICategorySelectionInfo.getParentUUIDs(modalDataSource: MIUserModel.userSharedInstance.userJobPreference?.preferredFunctions ?? [MICategorySelectionInfo]()) //self.getParentUUIDs()
                    self.navigationController?.pushViewController(vc, animated: false)
                    
                }
            }
            
        }else if sectionName == SectionNameConstant.personalDetails {
            if let sectionModel = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.personalDetails}).last?.sectionDataSource as? MIPersonalDetail {
                if fieldName == PersonalTitleConstant.MaritalStatus {
                    vc.masterType = .MARITIAL_STATUS
                    vc.limitSelectionCount = 1
                    if sectionModel.maretialStatus.name.count > 0 {
                        let tuples = self.getSelectedMasterDataFor(dataSource: [sectionModel.maretialStatus])
                        vc.selectedInfoArray = tuples.masterDataNames
                        vc.selectDataArray = tuples.masterDataObject
                    }
                    // vc.parentId = MICategorySelectionInfo.getParentUUIDs(modalDataSource: MIUserModel.userSharedInstance.userJobPreference?.preferredFunctions ?? [MICategorySelectionInfo]()) //self.getParentUUIDs()
                    self.navigationController?.pushViewController(vc, animated: false)
                }
//                if fieldName == PersonalTitleConstant.countriesAuthorized {
//                    vc.masterType = .COUNTRY
//                    vc.limitSelectionCount = 10
//                    if sectionModel.workPermits.count > 0 {
//                        let tuples = self.getSelectedMasterDataFor(dataSource: sectionModel.workPermits)
//                        vc.selectedInfoArray = tuples.masterDataNames
//                        vc.selectDataArray = tuples.masterDataObject
//                    }
//                    // vc.parentId = MICategorySelectionInfo.getParentUUIDs(modalDataSource: MIUserModel.userSharedInstance.userJobPreference?.preferredFunctions ?? [MICategorySelectionInfo]()) //self.getParentUUIDs()
//                    self.navigationController?.pushViewController(vc, animated: false)
//                }
            }
        }
    }
    func callApi() {
        MIActivityLoader.showLoader()
        MIApiManager.callGetProfileApi{ [weak wSelf = self] (isSuccess, response, error, code) in
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                if error == nil && (code >= 200) && (code <= 299) {
                    if let res = response as? [String:Any]  {
                        wSelf?.parseJson(res: res)
                        
                    }
                }
            }
            
        }
    }
    
    func parseJson(res:[String:Any]) {
        // print(res)
        
//        if let jobPreferenceSection=res["jobPreferenceSection"] as? [String:Any],let data = jobPreferenceSection["jobPreference"] as? [String:Any] {
//
//
//        }
        
        for name in MIProfileEnums.list {
            if name == MIProfileEnums.ITSkill.rawValue {
                if let dic = res[name] as? [String:Any] {
                    let profileModel = MIProfileModels.init(with: dic, moduleName: name)
                    let section = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.itSkill})
                    if let itSkills = profileModel.dicModel[name] as? [MIProfileITSkills] , itSkills.count > 0 {
                        section.first?.sectionDataSource = itSkills
                        
                    }
                }
            } else if name == MIProfileEnums.language.rawValue {
                if let dic = res[name] as? [String:Any] {
                    let profileModel = MIProfileModels.init(with: dic, moduleName: name)
                    let section = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.languages})
                    if let languages = profileModel.dicModel[name] as? [MIProfileLanguageInfo] , languages.count > 0 {
                        section.first?.sectionDataSource = languages
                    }
                }
            } else if name == MIProfileEnums.personalDetail.rawValue {
                if let dic = res["personalDetailSection"] as? [String:Any] ,let personalData =  dic["personalDetails"] as? [String:Any] {
                    if let additionalPersonalDetail = personalData["additionalPersonalDetail"] as? [String:Any] {
                        if let currentLocation = additionalPersonalDetail["currentLocation"] as?  [String:Any] {
                                              MIUserModel.userSharedInstance.userlocationModal =  MICategorySelectionInfo(dictionary:currentLocation)!
                                              MIUserModel.userSharedInstance.cityName        =  currentLocation.stringFor(key: "otherText")
                                          }
                                          if let workVisa = additionalPersonalDetail["workVisaType"] as?  [String:Any] {
                                              MIUserModel.userSharedInstance.visaType = MICategorySelectionInfo(dictionary: workVisa) ?? MICategorySelectionInfo()
                                          }
                    }
                  
                }
            }
        }
        self.tableView.reloadData()
    }
    func callApiforJobPreference(){
        if let jobPreferenceModel = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.jobPerences}).last?.sectionDataSource as? MIJobPreferencesModel {
           
            let params = MIJobPreferencesModel.getParamsForJobPreferenceViaRegister(obj: jobPreferenceModel)
            
            MIApiManager.callAPIForJobPreference(path: APIPath.jobPreferenceVer_2_ApiEndpoint, method: .post, params: params, headerDict: [:]) { (success, response, error, code) in
                DispatchQueue.main.async {
                    MIActivityLoader.hideLoader()
                    if error == nil && (code >= 200) && (code <= 299) {
                        MIUserModel.resetUserResumeData()
                        
                        let home = MIHomeTabbarViewController()
                        home.modalPresentationStyle = .fullScreen
                        self.present(home, animated: true, completion: nil)

                        RegisterFlowInstances.instance.controllers.removeAll()
                    }else{
                        self.handleAPIError(errorParams: response, error: error)
                    }
                }
            }
        }
        
    }
    func callAPIForUpdateUserPersonalDetail() {
        
        if let personal = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.personalDetails}).first?.sectionDataSource as? MIPersonalDetail {
           
            let parms = MIPersonalDetail.getParamsForRegisterPersonalDetail(personalData: personal)
            MIActivityLoader.showLoader()
            
            MIApiManager.callAPIForUpdatePersonalDetail(methodType: .put, path:APIPath.personalDetailPUTAPIEndpoint, params: parms) { (success, response, error, code) in
                DispatchQueue.main.async {
                    if error == nil && (code >= 200) && (code <= 299) {
                        self.callApiforJobPreference()
                    }else{
                        MIActivityLoader.hideLoader()
                        self.handleAPIError(errorParams: response, error: error)
                    }
                }
            }
        }
        
    }
    @objc private func backBtnAction() {
        CommonClass.googleEventTrcking("registration_screen", action: "back", label: "page_4_job_preferences")
        self.navigationController?.popViewController(animated: false)
    }
}

//MARK:- TAble view delegate and data source
extension MIJobPreferenceVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fieldTitleDataSource.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fieldTitleDataSource[section].sectionRowFieldTitle.count > 0 {
            return fieldTitleDataSource[section].sectionRowFieldTitle.count
        }else{
            var rowCount = 3
            if fieldTitleDataSource[section].isSectionExpand {
                rowCount  = (fieldTitleDataSource[section].sectionDataSource as? [Any])?.count ?? 0
            }else{
                rowCount = ((fieldTitleDataSource[section].sectionDataSource as? [Any])?.count ?? 0) > rowCount ? rowCount : (fieldTitleDataSource[section].sectionDataSource as? [Any])?.count ?? 0
            }
            return rowCount
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionName = fieldTitleDataSource[indexPath.section].sectionName
        
        if sectionName == SectionNameConstant.jobPerences {
            let title = fieldTitleDataSource[indexPath.section].sectionRowFieldTitle[indexPath.row]
            if title == MIJobPreferenceViewControllerConstant.profileImage {
                if let profileImgCell = tableView.dequeueReusableCell(withIdentifier: "MIJobPreferenceImgCell") as? MIJobPreferenceImgCell  {
                    profileImgCell.profileImgActivityIndicator.isHidden = true
                    if let img = userImg {
                        profileImgCell.imgJobPreference.image = img
                    }
                    profileImgCell.imageUploadCallBack = {
                        self.showActionSheetForUserSelection()
                    }
                    return profileImgCell
                }
            }else {
                let tvCell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
                tvCell.showCounterLabel = false
                tvCell.textView.isScrollEnabled = false
                tvCell.titleLabel.text = title
                tvCell.textView.isUserInteractionEnabled = false
                tvCell.accessoryImageView.isHidden = false
                tvCell.showCounterLabel = false
                tvCell.helpButton.isHidden = true
                if let model = fieldTitleDataSource[indexPath.section].sectionDataSource as? MIJobPreferencesModel {
                    if title == MIJobPreferenceViewControllerConstant.profileTitle {
                        tvCell.textView.keyboardType = .asciiCapable
                        tvCell.helpButton.isHidden = false
                        tvCell.textView.isUserInteractionEnabled = true
                        tvCell.textView.placeholder = "Profile Title" as NSString
                        tvCell.textView.text = model.profileTitle
                        tvCell.showCounterLabel = true
                        tvCell.textView.delegate = self
                        tvCell.showPopUpCallBack = {
                            tvCell.showInfoPopup(infoMsg: "The Profile title appears as a resume heading when viewed by recruiters.")
                        }
                        //tvCell.textView.isScrollEnabled = true
                        tvCell.accessoryImageView.isHidden = true
                        return tvCell
                        
                    }else if title == MIJobPreferenceViewControllerConstant.preferredLoc {
                        tvCell.textView.placeholder = "Please select one or more preferred location(s)" as NSString
                        tvCell.textView.text = (model.preferredLocationList.map { $0.name }).joined(separator: ",")
                        return tvCell
                        
                    }else if title == MIJobPreferenceViewControllerConstant.residentStatus {
                        tvCell.textView.placeholder = "Select Country of Residence" as NSString
                        tvCell.textView.text = (model.residentList.map { $0.name }).joined(separator: ",")
                        tvCell.helpButton.isHidden = false
                        tvCell.showPopUpCallBack = {
                            tvCell.showInfoPopup(infoMsg: "Select all countries where you have citizenship or PR status available.")
                        }
                        
                        return tvCell
                        
                    } else if title == MIJobPreferenceViewControllerConstant.workAuthorization {
                        tvCell.textView.placeholder = "Select countries where you have work authorization" as NSString
                        tvCell.textView.text = (model.workAuthorizationList.map { $0.name }).joined(separator: ",")
                        tvCell.helpButton.isHidden = false
                        tvCell.showPopUpCallBack = {
                            tvCell.showInfoPopup(infoMsg: "Select all countries where you are authorized to work.")
                        }
                        
                        return tvCell
                        
                    } else if title == MIJobPreferenceViewControllerConstant.preferredRole {
                        tvCell.textView.placeholder = "Maximum 2 roles can be selected" as NSString
                        tvCell.textView.text = (model.preferredRoles.map { $0.name }).joined(separator: ",")
                        return tvCell
                        
                    }else if title == MIJobPreferenceViewControllerConstant.preferredJobType {
                        let cell = tableView.dequeueReusableCell(withClass: MI3RadioButtonTableCell.self, for: indexPath)
                        cell.titleLabel.text = title
                        cell.setButtons("Permanent", button2: "Temporary/Contract", button3: "Both")
                        switch model.preferredJobType.name.lowercased() {
                        case "Permanent".lowercased():
                            cell.selectRadioButton(at: 0)
                        case "Temporary/Contract".lowercased():
                            cell.selectRadioButton(at: 1)
                        case "Both".lowercased():
                            cell.selectRadioButton(at: 2)
                        default:
                            break
                        }
                        cell.radioBtnSelection = { index, title in
                            
                            //   let model = self.fieldTitleDataSource.first?.sectionDataSource as? MIJobPreferencesModel
                            
                            switch index {
                            case 0: //Full Time
                                model.preferredJobType = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"a93cd4f6-fc6a-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                                
                            case 1: //Part Time
                                model.preferredJobType = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"c252778a-fc6a-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                                
                            default: //Correspondence
                                model.preferredJobType = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"be8605a7-22e8-11e9-9330-1418775c7275"]) ?? MICategorySelectionInfo()
                            }
                        }
                        
                        return cell
                    }
                }
                
            }
        }else if sectionName == SectionNameConstant.itSkill {
            if let modelDataSource = fieldTitleDataSource[indexPath.section].sectionDataSource as? [MIProfileITSkills] {
                let model = modelDataSource[indexPath.row]
                if let cell = tableView.dequeueReusableCell(withIdentifier: MIProfileEnums.ITSkill.rawValue) as? MIProfileITSkillCell {
                    cell.delgate = self
                    cell.showITSkill(info: model)
                    return cell
                    
                }
            }
        }else if sectionName == SectionNameConstant.personalDetails {
            let title = fieldTitleDataSource[indexPath.section].sectionRowFieldTitle[indexPath.row]
            if let model = fieldTitleDataSource[indexPath.section].sectionDataSource as? MIPersonalDetail {
                if title == PersonalTitleConstant.Gender {
                    let cell = tableView.dequeueReusableCell(withClass: MI3RadioButtonTableCell.self, for: indexPath)
                    cell.titleLabel.text = title
                    cell.setButtons("Male", button2: "Female", button3: "Perfer not to specify")
                   
                    switch model.gender.name.lowercased() {
                        case "Male".lowercased():
                            cell.selectRadioButton(at: 0)
                        case "Female".lowercased():
                            cell.selectRadioButton(at: 1)
                        case "Perfer not to specify".lowercased():
                            cell.selectRadioButton(at: 2)
                        default:
                            break
                    }

                    cell.radioBtnSelection = { index, title in
                        
                        // let model = self.fieldTitleDataSource.filter({$0.sectionName == "Personal Details"}).first?.sectionDataSource
                        
                        switch index {
                        case 0: //Full Time
                            model.gender = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"bd5a224c-fc69-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                            
                        case 1: //Part Time
                            model.gender = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"ccc7faa0-fc69-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                            
                        default: //Correspondence
                            model.gender = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"c7f21630-2480-11e9-aabd-70106fbef856"]) ?? MICategorySelectionInfo()
                        }
                    }
                    
                    return cell
//                } else if title == PersonalTitleConstant.countriesAuthorized {
//                    let tvCell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
//                    tvCell.showCounterLabel = false
//                    tvCell.accessoryImageView.isHidden = false
//                    tvCell.helpButton.isHidden = true
//                    tvCell.titleLabel.text = title
//                    tvCell.textView.isUserInteractionEnabled = false
//                    tvCell.textView.placeholder = "Select" as NSString
//                    tvCell.textView.text = (model.workPermits.map({ $0.name})).joined(separator: ",")
//                    return tvCell
                }else {
                    let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
                    cell.primaryTextField.isUserInteractionEnabled = true
                    cell.secondryTextField.isHidden = true
                    cell.titleLabel.text = title
                    cell.primaryTextField.placeholder = "Select"
                    cell.primaryTextField.delegate = self
                    cell.primaryTextField.setRightViewForTextField("right_direction_arrow")
                    if title == PersonalTitleConstant.DOB {
                        cell.primaryTextField.setRightViewForTextField("calendarBlue")
                        cell.primaryTextField.text = model.dob?.getStringWithFormat(format: "dd MMM, yyyy")
                    }else if title == PersonalTitleConstant.MaritalStatus {
                        cell.primaryTextField.text = model.maretialStatus.name
                        cell.primaryTextField.isUserInteractionEnabled = false
                    }
                    return cell
                }
            }
            
        }else if sectionName == SectionNameConstant.languages {
            if let cell = tableView.dequeueReusableCell(withIdentifier: MIProfileEnums.language.rawValue) as? MIProfileLanguageCell {
                if let modelDataSource = fieldTitleDataSource[indexPath.section].sectionDataSource as? [MIProfileLanguageInfo] {
                    let model = modelDataSource[indexPath.row]
                    cell.delegate = self
                    cell.showLanguageData(info:model)
                    cell.leadingConstraint.constant = 4
                }
                return cell
            }
        }else{
            return UITableViewCell()
        }
        
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rows = fieldTitleDataSource[indexPath.section].sectionRowFieldTitle
        if rows.count > 0 {
            self.pushToMasterDataSelection(
                fieldName: rows[indexPath.row],
                selectionLimit: 1,
                sectionName : fieldTitleDataSource[indexPath.section].sectionName )
        }
    }
    
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    //        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height: 15))
    //        headerView.backgroundColor = UIColor(hex: "f4f6f8")
    //        return headerView
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionName = fieldTitleDataSource[section].sectionName
        let header = MIProfileHeaderView.header
        header.lblTtl.text = sectionName
        header.lblTtl.font = UIFont.customFont(type: .Semibold, size: 16)
        header.delegate = self
        header.showHideAddEditBtn()
        if sectionName == SectionNameConstant.itSkill {
            header.showAddBtn()
            header.profileType = .ITSkill
        }else if sectionName == SectionNameConstant.languages {
            header.showAddBtn()
            header.profileType = .language
        }
        
        if sectionName == SectionNameConstant.jobPerences {
            return  UIView.init(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height: 15))
        }
        //        else if sectionName == "IT Skills" {
        //
        //        }else if sectionName == "Personal Details" {
        //
        //        }else if sectionName == "Languages" {
        //
        //        }
        return header
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if fieldTitleDataSource[section].sectionRowFieldTitle.count == 0 {
            if let modelsInfo = fieldTitleDataSource[section].sectionDataSource as? [Any],modelsInfo.count > 3 {
                let footer = MIProfileSeeMoreFooter.view
                footer.delegate = self
                footer.tag = 10 + section
                footer.showSeeMore(shouldShowSeeMore: fieldTitleDataSource[section].isSectionExpand)
                return footer
            }
        }
        
        return MIEmptyHeader.header
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if fieldTitleDataSource[section].sectionRowFieldTitle.count == 0 {
            if let modelsInfo = fieldTitleDataSource[section].sectionDataSource as? [Any],modelsInfo.count > 3 {
                return 60
            }
        }
        
        return 8
    }
}
extension MIJobPreferenceVC : MIProfileTableHeaderDelegate {
//    func settingBtnAction() {
//
//    }
//
//    func imageOptionAction() {
//
//    }
//
//    func enlargeImgeAction() {
//
//    }
//
//    func emailVerifyClicked() {
//
//    }
//
//    func mobileVerifyClicked() {
//
//    }
//
    
    func headerAddEditClicked(headerType: MIProfileEnums) {
        if headerType == MIProfileEnums.language {
            let vc = MIProfileLanguageVC()
            vc.callBackAfterSuccess = {[weak self] model in
                if let wself = self {
                    if model.language?.name.count ?? 0 > 0 {
                       wself.callApi()
                    }
                }
                
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if headerType == MIProfileEnums.ITSkill {
            let vc = MIITSkillsVC()
            vc.callBackAfterSuccess = {[weak self] model in
                if let wself = self {
                    if model.skill?.name.count ?? 0 > 0 {
                        wself.callApi()
                    }
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}

extension MIJobPreferenceVC : MIMasterDataSelectionViewControllerDelegate {
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        
        if MasterDataType.ROLE.rawValue == enumName {
            if let sectionModel = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.jobPerences}).last?.sectionDataSource as? MIJobPreferencesModel {
                sectionModel.preferredRoles = selectedCategoryInfo
            }
        }else if MasterDataType.MARITIAL_STATUS.rawValue == enumName {
            if let sectionModel = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.personalDetails}).last?.sectionDataSource as? MIPersonalDetail {
                sectionModel.maretialStatus = selectedCategoryInfo.last ?? MICategorySelectionInfo()
            }
        }else if MasterDataType.LOCATION.rawValue == enumName {
            if let sectionModel = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.jobPerences}).last?.sectionDataSource as? MIJobPreferencesModel {
                sectionModel.preferredLocationList = selectedCategoryInfo
            }
        }else if MasterDataType.COUNTRY.rawValue == enumName {
            if let sectionModel = self.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.jobPerences}).last?.sectionDataSource as? MIJobPreferencesModel {
               
                if self.selectedCountryFieldType == MIJobPreferenceViewControllerConstant.residentStatus {
                    sectionModel.residentList = selectedCategoryInfo
                    if sectionModel.workAuthorizationList.isEmpty {
                        sectionModel.workAuthorizationList = selectedCategoryInfo
                    }
                } else if self.selectedCountryFieldType == MIJobPreferenceViewControllerConstant.workAuthorization {
                    sectionModel.workAuthorizationList = selectedCategoryInfo
                }
                
            }
        }
        

        self.tableView.reloadData()
    }
    
}
extension MIJobPreferenceVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        let txtfldPosition:CGPoint = textField.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: txtfldPosition) {
            if self.fieldTitleDataSource[indexPath.section].sectionName == SectionNameConstant.personalDetails  {
                if let mode = self.fieldTitleDataSource[indexPath.section].sectionDataSource as? MIPersonalDetail {
                   
                    let fields = self.fieldTitleDataSource[indexPath.section].sectionRowFieldTitle
                    if fields.count > 0, fields[indexPath.row] == PersonalTitleConstant.DOB  {
                        let date = Calendar.current.date(byAdding: .year, value: -15, to: Date())

                        MIDatePicker.selectDate(title: "", hideCancel: false, datePickerMode: .date, selectedDate: date, minDate: nil, maxDate: date) { (dateSelected) in
                            mode.dob = dateSelected
                            textField.text =  dateSelected.getStringWithFormat(format: "dd MMM, yyyy")
                        }
                        return false
                        
                    }
                }
                
                
            }
        }
        
        
        
        return true
    }
}

extension MIJobPreferenceVC : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let txtfldPosition:CGPoint = textView.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: txtfldPosition) {
            if self.fieldTitleDataSource[indexPath.section].sectionName == SectionNameConstant.jobPerences  {
                let fields = self.fieldTitleDataSource[indexPath.section].sectionRowFieldTitle
                if  fields.count > 0 ,fields[indexPath.row] == MIJobPreferenceViewControllerConstant.profileTitle  {
                    UIView.setAnimationsEnabled(false)
                    self.tableView.beginUpdates()
                    let fixedWidth: CGFloat = textView.frame.size.width
                    //  let txtFldPosition = textView.convert(CGPoint.zero, to: self.tableView)
                    let cell = self.tableView.cellForRow(at: IndexPath(row: indexPath.row , section:indexPath.section)) as! MITextViewTableViewCell
                    let newSize: CGSize = textView.sizeThatFits(CGSize(width:fixedWidth,height:.greatestFiniteMagnitude))
                    
                    var frame = cell.textView.frame
                    frame.size.height = newSize.height
                    cell.textView.frame = frame

                    
                    //cell.textView.frame.size = newSize
                    //    cell.backgroundColor = .red
                    self.tableView.endUpdates()
                    
                    UIView.setAnimationsEnabled(true)
                    
                }
                
                
            }
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        let txtfldPosition:CGPoint = textView.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: txtfldPosition) {
            if self.fieldTitleDataSource[indexPath.section].sectionName == SectionNameConstant.jobPerences  {
                let fields = self.fieldTitleDataSource[indexPath.section].sectionRowFieldTitle
              
                if  fields.count > 0 ,fields[indexPath.row] == MIJobPreferenceViewControllerConstant.profileTitle  {
                    DispatchQueue.main.async {
                        self.setMainViewFrame(originY: 0)
                        let movingHeight = textView.movingHeightIn(view : self.view) + 40
                        //  + ((kScreenSize.height <= 667) ? 40 : 130)
                        
                        if movingHeight > 0 {
                            //                if kScreenSize.height <= 667 {
                            //                    movingHeight = movingHeight - 100
                            //
                            //                }
                            UIView.animate(withDuration: 0.3) {
                                self.setMainViewFrame(originY: -movingHeight)
                            }
                        }
                    }
                }
            }
        }

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: 0)
            }
        }
        let txtfldPosition:CGPoint = textView.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: txtfldPosition) {
            if self.fieldTitleDataSource[indexPath.section].sectionName == SectionNameConstant.jobPerences  {
                if let model = self.fieldTitleDataSource[indexPath.section].sectionDataSource as? MIJobPreferencesModel {
                    let fields = self.fieldTitleDataSource[indexPath.section].sectionRowFieldTitle
                    if fields.count > 0 ,fields[indexPath.row] == MIJobPreferenceViewControllerConstant.profileTitle  {
                        model.profileTitle = textView.text
                    }
                }
            }
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "" {
            return true
        }
        let txtfldPosition:CGPoint = textView.convert(CGPoint.zero, to:self.tableView)
        if let indexPath = self.tableView.indexPathForRow(at: txtfldPosition) {
            if self.fieldTitleDataSource[indexPath.section].sectionName == SectionNameConstant.jobPerences  {
                let fields = self.fieldTitleDataSource[indexPath.section].sectionRowFieldTitle
                if  fields.count > 0 ,fields[indexPath.row] == MIJobPreferenceViewControllerConstant.profileTitle  {
                    let profileTitle = textView.text.appending(text)
                    if profileTitle.count > 250 {
//                        DispatchQueue.main.async {
//                         // self.showAlert(title: "", message: "Profile title can't exceed 250 charaters.")
//                        //    self.showAlert(title: "", message: "Profile title can't exceed 250 charaters.", isErrorOccured: true)
//                        }
                        return false
                    }
//                    else{
//                        let txtFldPosition = textView.convert(CGPoint.zero, to: self.tableView)
//                        if  let indexPath = self.tableView.indexPathForRow(at: txtFldPosition) {
////                            if let cell = self.tableView.cellForRow(at: IndexPath(row: indexPath.row , section:indexPath.section)) as? MITextViewTableViewCell {
////                                // cell.charaterCount_Lbl.text = "\(profileTitle.count)/250"
////                         //       charaterTyped =  profileTitle.count
////
////                            }
//                        }
//                    }
                    if(text == "\n") {
                        textView.resignFirstResponder()
                        return false
                    }
                }
            }
        }
        
        return true
    }
}

extension MIJobPreferenceVC : JobPreferencePopUpDelegate {
  
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {
        isPopOnView = false
        
        if popSelection == .Ignored {
            self.callAPIForUpdateUserPersonalDetail()
        }
    }
    
}

extension MIJobPreferenceVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func showActionSheetForUserSelection() {
        
        AKAlertController.actionSheet("Choose Option", message: "", sourceView: self, buttons: ["Capture photo from camera","Select photo from gallery","Cancel"]) { (vc, action, tag) in
            
            if tag == 0 {
                self.openMediaOption(type:UIImagePickerController.SourceType.camera)
            }else if tag == 1 {
                self.openMediaOption(type: UIImagePickerController.SourceType.photoLibrary)
                
            } else if action.title == "Remove profile picture" {
                // self.callAPIToRemoveProfilePic()
            }
        }
    }
    
    func openMediaOption(type:UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(type) {
            let pickerController = UIImagePickerController()
            pickerController.sourceType = type
            pickerController.delegate = self
            pickerController.allowsEditing = false
            if (type == .camera) ? AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied : PHPhotoLibrary.authorizationStatus() == .denied {
                
                self.showPopUpView(message: "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.", primaryBtnTitle: "Setting", secondaryBtnTitle: "Later") { (isPrimary) in
                        
                        if isPrimary {
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                        print("Settings opened: \(success)") // Prints true
                                    })
                                } else {
                                    // Fallback on earlier versions
                                    UIApplication.shared.openURL(settingsUrl)
                                    
                                }
                            }
                        }
                }
                
//                AKAlertController.alert("", message: "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.", buttons: ["Later","Setting"]) { (alertVC, alertAction, index) in
//
//                    if index == 1 {
//                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
//                            return
//                        }
//
//                        if UIApplication.shared.canOpenURL(settingsUrl) {
//                            if #available(iOS 10.0, *) {
//                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
//                                    print("Settings opened: \(success)") // Prints true
//                                })
//                            } else {
//                                // Fallback on earlier versions
//                                UIApplication.shared.openURL(settingsUrl)
//
//                            }
//                        }
//                    }
//                }
                //   self.showAlert(title: "", message: "You have to authorized Monster App to access photos/camera from your iPhone/iPad. Go to settings and authorize Monster app.")
                
            }else{
                present(pickerController, animated: true, completion: nil)
                
            }
            
        }
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //  dismiss(animated: true, completion: nil)
        
        if let image=info[UIImagePickerController.InfoKey.originalImage]as?UIImage {
            
            let cropController = CropViewController(croppingStyle: CropViewCroppingStyle.default, image: image)
            cropController.delegate = self
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
            })
            
        }
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Service Helper Method
    
    func callAPIForUploadAvatar(userAvatar:UIImage) {
       
        if let profileCell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MIJobPreferenceImgCell {
            profileCell.profileImgActivityIndicator.isHidden = false
            profileCell.profileImgActivityIndicator.startAnimating()
            let params = ["file" : userAvatar.resizeImage().jpegData(compressionQuality: 1) ?? Data()]
            let extenstion = "png"
            if !extenstion.isEmpty {
                imageCache.removeAllObjects()
                
                MIApiManager.callAPIForUploadAvatarResume(path: APIPath.uploadAvtarAPIEndpoint, params: params, extenstion: extenstion, filename: nil, customHeaderParams: [:]) {  (success, response, error, code) in
                    DispatchQueue.main.async {
                        profileCell.profileImgActivityIndicator.isHidden = true
                        profileCell.profileImgActivityIndicator.stopAnimating()
                        
                        if error == nil && (code >= 200) && (code <= 299) {
                            self.showAlert(title: "", message: "Your avatar updated successfully.",isErrorOccured: false)
                            self.userImg = userAvatar
                            self.tableView.reloadData()
                            
                            
                        }else{
                            self.handleAPIError(errorParams: response, error: error)
                        }
                    }
                }
            }else {
                self.showAlert(title: "", message: "File format is not correct.")
            }
        }
        
    }
}

extension MIJobPreferenceVC : CropViewControllerDelegate {
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        
        self.callAPIForUploadAvatar(userAvatar: image)
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        
    }
    
}
extension MIJobPreferenceVC : MIProifleITSkillCellDelegate,MIProfileLanguageCellDelegate,MIPopOverControllerDelegate,MIProfileSeeMoreFooterDelegate {
    func itSkillClicked(info: MIProfileITSkills, sender: UIView) {
        let controller = MIPopOverController()
        controller.profileType  = MIProfileEnums.ITSkill
        controller.preferredContentSize = CGSize(width: 140, height: 80)
        controller.delegate = self
        controller.info     = [info]
        showPopup(controller, sourceView: sender)
    }
    
    func languageEditClicked(modelInfo: Any, sender: UIView) {
        
        let controller = MIPopOverController()
        controller.profileType  = MIProfileEnums.language
        controller.preferredContentSize = CGSize(width: 140, height: 80)
        controller.delegate = self
        if let info = modelInfo as? MIProfileLanguageInfo {
            controller.info     = [info]
        }
        showPopup(controller, sourceView: sender)
    }
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        print(sourceView.bounds)
        presentationController.sourceRect = CGRect(x: 14, y: 0, width: 4, height: 30)
        
        presentationController.canOverlapSourceViewRect = true
        presentationController.permittedArrowDirections = [.up]
        
        self.present(controller, animated: true)
    }
    func popOverClicked(actionType: MIProfileActionEnum, info: Any, profileType: MIProfileEnums) {
        
        if profileType == MIProfileEnums.ITSkill {
            if actionType == .edit {
                
                let vc = MIITSkillsVC()
                if let itSkillInfo = info as? MIProfileITSkills {
                    vc.itSkillInfo = itSkillInfo
                }
                vc.addITSkillSuccess = { status in
                    
                    if status {
                        self.tableView.reloadData()
                    }
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                
                self.showDeleteAlert { (action) in
                    if action {
                        var id = ""
                        if let itSkillInfo = info as? MIProfileITSkills {
                            id = itSkillInfo.id
                        }
                        let param = [ "ids" : [id] ]
                        
                        MIApiManager.deleteSkill(param) { [weak self](result, error) in
                            guard let wkSelf=self else {return}
                            guard let data = result else { return }
                            let section = wkSelf.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.itSkill})
                            if let dataSource = section.last?.sectionDataSource as? [MIProfileITSkills] {
                                var newdata = dataSource
                                if let itSkillInfo = info as? MIProfileITSkills {
                                    if let index = newdata.firstIndex(of: itSkillInfo) {
                                        newdata.remove(at:index)
                                        section.last?.sectionDataSource = newdata
                                    }
                                    
                                }
                                // dataSource.append(model)
                                wkSelf.tableView.reloadData()
                            }
                            
                            wkSelf.showAlert(title: "", message: data.successMessage,isErrorOccured:false)
                            // self.callApi()
                            // self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
                
            }
        }
        if profileType  == MIProfileEnums.language {
            if actionType == .edit {
                let vc = MIProfileLanguageVC()
                if let modelInfo = info as? MIProfileLanguageInfo {
                    vc.languageInfo = modelInfo.copy() as? MIProfileLanguageInfo
                    vc.isUpdating   = true
                }
                vc.callBackAfterSuccess = { model in
                    self.callApi()
                    //self.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.showDeleteAlert { (action) in
                    if action {
                        var id = ""
                        if let langInfo = info as? MIProfileLanguageInfo {
                            id = langInfo.languageId
                        }
                        
                        let param = [
                            "id" : id
                            ] as [String : Any]
                        
                        MIApiManager.deleteProfileLanguage(param) { [weak self] (result, error) in
                            guard let wkSelf=self else {return}
                            guard let data = result else { return }
                            
                            let section = wkSelf.fieldTitleDataSource.filter({$0.sectionName == SectionNameConstant.languages})
                            if let dataSource = section.last?.sectionDataSource as? [MIProfileLanguageInfo] {
                                var newdata = dataSource
                                if let langInfo = info as? MIProfileLanguageInfo {
                                    if let index = newdata.index(of: langInfo) {
                                        newdata.remove(at:index)
                                        section.last?.sectionDataSource = newdata
                                    }
                                    
                                }
                                // dataSource.append(model)
                                wkSelf.tableView.reloadData()
                            }
                            wkSelf.showAlert(title: nil, message: data.successMessage,isErrorOccured:false)
                            
                            // wkSelf.callApi()
                        }
                    }
                }
            }
        }
    }
    func showDeleteAlert(completion:@escaping ((Bool)) -> Void) {
        
        self.showPopUpView( message: ExtraResponse.deleteAlert, primaryBtnTitle: "Yes", secondaryBtnTitle: "No") { (isPrimarBtnClicked) in
                       if isPrimarBtnClicked {
                            completion(true)
                       }else{
                            completion(false)
                       }
            }
                   
        
//               let vPopup = MIJobPreferencePopup.popup()
//               vPopup.setViewWithTitle(title: "", viewDescriptionText:  ExtraResponse.deleteAlert, or: "", primaryBtnTitle: "Yes", secondaryBtnTitle: "No")
//               vPopup.completionHandeler = {
//                   completion(true)
//               }
//               vPopup.cancelHandeler = {
//                   completion(false)
//               }
//               vPopup.addMe(onView: self.view, onCompletion: nil)
        
        
        // if let popOver = self.navigationController?.topViewController as?
        
//        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this ?", preferredStyle: UIAlertController.Style.alert)
//        let cancelBtn = UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction) in
//            //acceptBlock()
//            completion(false)
//        })
//        alert.addAction(cancelBtn)
//        
//        let okBtn = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
//            // acceptBlock()
//            completion(true)
//            
//        })
//        alert.addAction(okBtn)
//        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
//            self.present(alert, animated: true, completion: nil)
//            
//        }
    }
    func footerClicked(modelIndex: Int) {
        let selectedModelIndex = modelIndex - 10
        if self.fieldTitleDataSource.count > selectedModelIndex {
            let info  = self.fieldTitleDataSource[selectedModelIndex]
            info.isSectionExpand = !info.isSectionExpand
            //          self.tblView.reloadSections(IndexSet(integer: selectedModelIndex), with: .top)
            UIView.animate(withDuration: 0.3) {
                self.tableView.reloadData()
            }
        }
        
    }
}

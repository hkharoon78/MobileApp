//
//  MIEducationByUserVC.swift
//  MonsteriOS
//
//  Created by Rakesh on 22/07/19.
//  Copyright © 2019 Monster. All rights reserved.
//  From: Signup

import UIKit

class MIEducationByUserVC: MIBaseViewController {

//    var fieldDataSource = [String]()
    var userEducationDataSource = [SectionModel]()
    var tblFooter = MIDoubleButtonView.doubleBtnView
    var selectedIndexPath : IndexPath?
    var isFreshOrExper:ProfessionalDetailsEnum = .Fresher
    var itemSectionIndexForDelete = -1
    let popup = MIJobPreferencePopup.popup()
    var progView = MIProgressView.header

    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var progressView : UIView!

    private var errorData : (index:Int,errorMessage:String) = (-1,"") {
        didSet {
            guard errorData.index >= 0 else { return }
            self.tblView.reloadData()
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initilizeDataOnLoad()
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationItem.title = MIEducationDetailViewControllerConstant.title
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        let eventData = [
            "eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING,
            ] as [String : Any]
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EDUCATION, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_EDUCATION) { (success, response, error, code) in
        }

        
        if MIUserModel.userSharedInstance.isEducationUploaded {
            tblFooter.nxtBtnBgView_TopConstraint.constant = 0
            userEducationDataSource = MIUserModel.userSharedInstance.educationsByUser ??  []
            
            self.tblView.reloadData()
        }
        if !self.progressView.subviews.contains(progView) {

            progView.frame = CGRect(x: 0, y: 0, width: kScreenSize.width, height: 44)
            
            if isFreshOrExper == .Fresher {
                progView.progressViewStatus(num: 2, completed: 0, current: 0)
            }else{
                progView.progressViewStatus(num: 3, completed: 1, current: 1 )
            }
                self.progressView.addSubview(progView)

        }
    }
   
    func initilizeDataOnLoad() {
        
        //Register Cell
        
        tblView.register(UINib(nibName:String(describing: MICompletedEduEmpTableCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MICompletedEduEmpTableCell.self))
        tblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        tblView.register(UINib(nibName:String(describing: MI3RadioButtonTableCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MI3RadioButtonTableCell.self))
        tblView.register(UINib(nibName: String(describing: MIEduEmpHeaderView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: MIEduEmpHeaderView.self))

        //Set tableview Attribute property
        self.tblView.keyboardDismissMode = .onDrag
        self.tblView.estimatedRowHeight = tblView.rowHeight
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.sectionHeaderHeight = tblView.sectionHeaderHeight
        self.tblView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.tblView.sectionFooterHeight = tblView.sectionFooterHeight
        self.tblView.estimatedSectionFooterHeight = UITableView.automaticDimension
        
        //Manage Modal and title
        if let section = MIUserModel.userSharedInstance.educationsByUser {
            userEducationDataSource = section
        } else {
            userEducationDataSource.append(SectionModel(name: "Add Education", dataSource: MIEducationInfo(qualification: "", specialisation: "", instituteName: "", year: ""), sectionFields: self.manageTitleForSectionRowModel(modal: MIEducationInfo(qualification: "", specialisation: "", instituteName: "", year: ""), sectionNumber: 0), number: 0))
        }
        
        tblFooter.btn_next.showPrimaryBtn()
        tblFooter.btn_next.setImage(UIImage(named: "whiteRightArrow"), for: .normal)
        tblFooter.btn_next.setTitle("Next: Job Preferences", for: .normal)
        tblFooter.setTitleForAddAnother(title: "+ Add Previous Education")
        self.tblView.tableFooterView = tblFooter
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(MIEducationByUserVC.backBtnAction))

        
        tblFooter.addAnotherCallBack = {

            if let obj = self.userEducationDataSource.last,
                self.validateEducationData(sectionModel: obj, addPrevious: true) {
                
//                let eventData = [
//                    "eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_SUBMIT,
//                    "addOtherEducation" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK
//                    ] as [String : Any]
//
//                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EDUCATION, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_EDUCATION) { (success, response, error, code) in
//                }

                self.userEducationDataSource.append(SectionModel(name: "Add Other Education", dataSource: MIEducationInfo(qualification: "", specialisation: "", instituteName: "", year: ""), sectionFields: self.manageTitleForSectionRowModel(modal: MIEducationInfo(qualification: "", specialisation: "", instituteName: "", year: ""), sectionNumber: self.userEducationDataSource.count), number: self.userEducationDataSource.count))
            }
    
            self.tblView.reloadData()
        }
        
        tblFooter.nextBtnCallBack = {
            if self.isFreshOrExper == .Fresher {
                CommonClass.googleEventTrcking("registration_screen", action: "next", label: "page_2_education")
            }else{
                CommonClass.googleEventTrcking("registration_screen", action: "next", label: "page_3_education")
            }
            self.validationEducationByUser()
        }
        //Manage progress view
       // let progView = MIProgressView.header
        if isFreshOrExper == .Fresher {
         //   progView.progressViewStatus(num: 2, completed: 0, current: 0)

            if let vcs=self.navigationController?.viewControllers{
                for (index,vc) in vcs.enumerated(){
                    if let _ = vc as? MIOTPViewController{
                        self.navigationController?.viewControllers.remove(at: index)
                        break
                    }
                }
            }
        }else{
          //  progView.progressViewStatus(num: 3, completed: 1, current: 1 )
        }
       // self.progressView.addSubview(progView)

    }
    
    func manageTitleForSectionRowModel(modal:MIEducationInfo,sectionNumber:Int) -> [String]{
        if modal.isEducationDegree {
           return [ MIEducationDetailViewControllerConstant.highestQualification,
                    MIEducationDetailViewControllerConstant.specialisation,
                    MIEducationDetailViewControllerConstant.instituteName,
                    MIEducationDetailViewControllerConstant.passignYear,
                    MIEducationDetailViewControllerConstant.educationType]
        }else {
            return [ MIEducationDetailViewControllerConstant.highestQualification,
                     MIEducationDetailViewControllerConstant.board,
                     MIEducationDetailViewControllerConstant.medium,
                     MIEducationDetailViewControllerConstant.passignYear,
                     MIEducationDetailViewControllerConstant.educationType]
        }
        
    }

    func pushToMasterDataSelection(fieldName:String,selectionLimit:Int,model:MIEducationInfo) {
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.delegate = self
        vc.limitSelectionCount = selectionLimit
        
        if fieldName == MIEducationDetailViewControllerConstant.highestQualification {
            vc.masterType = .HIGHEST_QUALIFICATION
            if !model.highestQualificationObj.name.isEmpty {
                vc.selectDataArray  = [model.highestQualificationObj]
                vc.selectedInfoArray = [model.highestQualificationObj.name]
            }
        }
        if fieldName == MIEducationDetailViewControllerConstant.specialisation {
            vc.masterType = .SPECIALIZATION
            if model.highestQualificationObj.name.isEmpty {
                self.showAlert(title: "", message:"Please select your highest qualification first.")
                return
            }else{
                if !model.specialisationObj.name.isEmpty {
                    vc.selectedInfoArray = [model.specialisationObj.name]
                    vc.selectDataArray   =  [model.specialisationObj]
                }
                vc.parentId = MICategorySelectionInfo.getParentUUIDs(modalDataSource:[model.highestQualificationObj])
            }
        }
        if fieldName == MIEducationDetailViewControllerConstant.instituteName {
            vc.masterType = .COLLEGE
            if !model.collegeObj.name.isEmpty {
                vc.selectDataArray  = [model.collegeObj]
                vc.selectedInfoArray = [model.collegeObj.name]
            }
        }
        if fieldName == MIEducationDetailViewControllerConstant.educationType {
            vc.masterType = .EDUCATION_TYPE
            if !model.educationTypeObj.name.isEmpty {
                vc.selectDataArray  = [model.educationTypeObj]
                vc.selectedInfoArray = [model.educationTypeObj.name]
            }
        }
        if fieldName == MIEducationDetailViewControllerConstant.medium {
            vc.masterType = .MEDIUM
            if !model.mediumObj.name.isEmpty {
                vc.selectDataArray  = [model.mediumObj]
                vc.selectedInfoArray = [model.mediumObj.name]
            }
        }
        if fieldName == MIEducationDetailViewControllerConstant.board {
            vc.masterType = .BOARD
            if !model.mediumObj.name.isEmpty {
                vc.selectDataArray  = [model.boardObj]
                vc.selectedInfoArray = [model.boardObj.name]
            }
        }
       
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func pushStaticMasterController(type: StaticMasterData,  data: [String], educationModelModel: MIEducationInfo, title: String) {
        let staticMasterVC = MIStaticMasterDataViewController.newInstance
        staticMasterVC.title = "Selection"
        staticMasterVC.staticMasterType = type
        staticMasterVC.selectedDataArray = data
        staticMasterVC.selectedData = { value in
            
            educationModelModel.year = value
            self.tblView.reloadData()
            
        }
        self.navigationController?.pushViewController(staticMasterVC, animated: true)
    }

    func pushJobPreference() {
        if let instance = RegisterFlowInstances.instance.controllers
            .filter({ $0 is MIJobPreferenceVC }).first {
            self.navigationController?.pushViewController(instance, animated: true)
        } else {
            let jobPreference = MIJobPreferenceVC()
            jobPreference.isFreshOrExper = self.isFreshOrExper
            self.navigationController?.pushViewController(jobPreference, animated: true)
            RegisterFlowInstances.instance.controllers.append(jobPreference)
        }
    }
    
    func validationEducationByUser(){
        if self.userEducationDataSource.count == 1 {
            if !self.validateEducationData(sectionModel: self.userEducationDataSource[0]) { return }
        }
        
        var isAllEducationVerified = true
        //Validate eductaion data
        for obj in self.userEducationDataSource {
            if let edu = obj.sectionDataSource as? MIEducationInfo {
                if self.userEducationDataSource.last == obj && edu.highestQualificationObj.name.isEmpty {
                    self.userEducationDataSource.last?.sectionDataSource = MIEducationInfo(qualification: "", specialisation: "", instituteName: "", year: "")
                    self.tblView.reloadData()
                    if self.userEducationDataSource.count == 1 { return }
                    continue
                }
                if !self.validateEducationData(sectionModel: obj){
                    isAllEducationVerified = false
                    
                    let isLastSection = (self.userEducationDataSource.last == obj)
                    if !isLastSection {
                        self.navigateToEditEducationVC(at: obj.sectionNumber)
                    }
                    
                    return
                }
            }
        }
        if isAllEducationVerified {
            if MIUserModel.userSharedInstance.isEducationUploaded {
                self.pushJobPreference()

            }else{
                self.callAPIForSubmitUserEducation()

            }
        }
    }
    
    func validateEducationData(sectionModel : SectionModel, addPrevious: Bool = false) -> Bool {
        
        guard let modelObj = sectionModel.sectionDataSource as? MIEducationInfo else { return true }
        let arr = sectionModel.sectionRowFieldTitle
        let isLastSection = (self.userEducationDataSource.last == sectionModel)
        
        var validationMessage = [[String: Any]]()
        defer {
            var eventData = [
                "validationErrorMessages" : validationMessage
                ] as [String : Any]
            if addPrevious {
                eventData["addOtherEducation"] = CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK
            } else {
                eventData["eventValue"] = CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK
            }
            
            if addPrevious || (!(!addPrevious && validationMessage.isEmpty) || isLastSection) {
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EDUCATION, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_EDUCATION) { (success, response, error, code) in
                }
            }
        }

        
        if modelObj.highestQualificationObj.name.isEmpty {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.highestQualification), isLastSection {
                let indexPath = IndexPath(row: index, section: sectionModel.sectionNumber)

                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptyHighestQualification)
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                
                validationMessage.append(["field":MIEducationDetailViewControllerConstant.highestQualification, "message" : MIEducationDetailViewControllerConstant.emptyHighestQualification])
            }
            return false
        }
        if modelObj.specialisationObj.name.isEmpty && modelObj.isEducationDegree {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.specialisation), isLastSection {
                let indexPath = IndexPath(row: index, section: sectionModel.sectionNumber)

                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptySpecialisation)
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                
                validationMessage.append(["field":MIEducationDetailViewControllerConstant.specialisation, "message" : MIEducationDetailViewControllerConstant.emptySpecialisation])
            }
            return false
        }
        if modelObj.boardObj.name.isEmpty  && !modelObj.isEducationDegree {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.board), isLastSection {
                let indexPath = IndexPath(row: index, section: sectionModel.sectionNumber)

                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptyBoard)
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                
                validationMessage.append(["field":MIEducationDetailViewControllerConstant.board, "message" : MIEducationDetailViewControllerConstant.emptyBoard])
            }
            return false
        }
        if modelObj.collegeObj.name.isEmpty && modelObj.isEducationDegree {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.instituteName), isLastSection {
                let indexPath = IndexPath(row: index, section: sectionModel.sectionNumber)

                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptyInstitueName)
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                
                validationMessage.append(["field":MIEducationDetailViewControllerConstant.instituteName, "message" : MIEducationDetailViewControllerConstant.emptyInstitueName])

            }
            return false
        }
        if modelObj.year.isEmpty {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.passignYear), isLastSection {
                let indexPath = IndexPath(row: index, section: sectionModel.sectionNumber)

                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptyYear)
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                
                validationMessage.append(["field":MIEducationDetailViewControllerConstant.passignYear, "message" : MIEducationDetailViewControllerConstant.emptyYear])

            }
            return false
        }
        if modelObj.educationTypeObj.name.isEmpty {
            self.toastView(messsage: MIEducationDetailViewControllerConstant.emptyEducationType)
            
            validationMessage.append(["field":MIEducationDetailViewControllerConstant.educationType, "message" : MIEducationDetailViewControllerConstant.emptyEducationType])

            return false
        }
        if modelObj.mediumObj.name.isEmpty && !modelObj.isEducationDegree {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.medium), isLastSection {
                let indexPath = IndexPath(row: index, section: sectionModel.sectionNumber)

                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptyMedium)
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
                
                validationMessage.append(["field":MIEducationDetailViewControllerConstant.medium, "message" : MIEducationDetailViewControllerConstant.emptyMedium])
            }
            return false
        }

        return true
        
    }
    
    func callAPIForSubmitUserEducation() {
        var params = [String:Any]()
        
        guard var educationByUser = self.userEducationDataSource.map({($0.sectionDataSource as? MIEducationInfo)}) as? [MIEducationInfo] else { return }
        educationByUser = educationByUser.filter({ !$0.highestQualificationObj.name.isEmpty })
        
        params = MIEducationInfo.getDictFromModelDataList(educationList: educationByUser, isForRegister: true)
        MIActivityLoader.showLoader()
        
        MIApiManager.callAPIForEmploymentEducationSkillDetail(method:.post,apiPath: APIPath.educationalDetail_Version2_ApiEndpoint  , params: params) { (success, response, error, code) in
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                
                if error == nil && (code >= 200) && (code <= 299) {
                    
                    if let result = response as? [String:Any],let educationDetailSection = result["educationDetailSection"] as? [String:Any],let dataList = educationDetailSection["educations"] as? [[String:Any]] , dataList.count > 0 {
                        
                        self.userEducationDataSource = self.userEducationDataSource
                            .filter({ ($0.sectionDataSource as? MIEducationInfo)?.highestQualificationObj.name.isEmpty == false })
                        if dataList.count == self.userEducationDataSource.count {
                            // var educationTempData = [MIEducationInfo]()
                            MIUserModel.userSharedInstance.isEducationUploaded = true
                            for (index,modal) in self.userEducationDataSource.enumerated() {
                                if let eduObj = modal.sectionDataSource as? MIEducationInfo {
                                    eduObj.educationId = dataList[index].stringFor(key: "id")
                                    //   educationTempData.append(eduObj)
                                }
                            }
                            
                            MIUserModel.userSharedInstance.educationsByUser = self.userEducationDataSource
                        }
                    }
                    
                    self.pushJobPreference()
                    
                }else{
                    //   self.stopActivityIndicator()
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
            
        }
        
    }
    
    @objc private func backBtnAction(sender:UIBarButtonItem) {
        if isFreshOrExper == .Fresher {
            CommonClass.googleEventTrcking("registration_screen", action: "back", label: "page_2_education")
        }else {
            CommonClass.googleEventTrcking("registration_screen", action: "back", label: "page_3_education")
        }
        self.navigationController?.popViewController(animated: false)
    }
}

extension MIEducationByUserVC : UITableViewDelegate,UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return userEducationDataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var isLastSection = (section == self.userEducationDataSource.count - 1)
        if MIUserModel.userSharedInstance.isEducationUploaded { isLastSection = false }

        return isLastSection ? self.userEducationDataSource[section].sectionRowFieldTitle.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let sectionModel = self.userEducationDataSource[indexPath.section]
        let title = sectionModel.sectionRowFieldTitle[indexPath.row]
        
        var isLastSection = (indexPath.section == self.userEducationDataSource.count - 1)
        if MIUserModel.userSharedInstance.isEducationUploaded { isLastSection = false }

        guard let userEducation = sectionModel.sectionDataSource as? MIEducationInfo else {
            return UITableViewCell()
        }
        
        if isLastSection  {
            let error = (self.errorData.index == indexPath.row) ? self.errorData.errorMessage : ""

            if title == MIEducationDetailViewControllerConstant.educationType {
                let cell = tableView.dequeueReusableCell(withClass: MI3RadioButtonTableCell.self, for: indexPath)
                cell.titleLabel.text = title
                cell.setButtons("Full Time", button2: "Part Time", button3: "Correspondence")

                
                switch userEducation.educationTypeObj.name {
                case "Full Time":
                    cell.selectRadioButton(at: 0)
                case "Part Time":
                    cell.selectRadioButton(at: 1)
                case "Correspondence":
                    cell.selectRadioButton(at: 2)
                default: break
                }
                
                cell.radioBtnSelection = { index, title in
                    
                     let model = self.userEducationDataSource.last?.sectionDataSource as? MIEducationInfo

                    switch index {
                    case 0: //Full Time
                        model?.educationTypeObj = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"f583b140-fc6b-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()

                    case 1: //Part Time
                        model?.educationTypeObj = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"00d78ad2-fc6c-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                    
                    default: //Correspondence
                        model?.educationTypeObj = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"1a9600f6-fc6c-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                    }
                }
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
                cell.secondryTextField.isHidden = true
                cell.primaryTextField.tag = indexPath.row
                cell.primaryTextField.isUserInteractionEnabled = false
                
                cell.showError(with: error, animated: false)
                self.showEducationData(in: cell, title: title, obj: userEducation, sectionIndex: sectionModel.sectionNumber)
                
                let hideButton = self.userEducationDataSource.count == 1 && indexPath.row == 0
                cell.helpButton.isHidden = !hideButton
                
                cell.showPopUpCallBack = {
                    cell.showInfoPopup(infoMsg: "Most recent degree/course either completed or being pursued by you.")
                }
                
                return cell
            }
       
        } else {
            
            let cell = tableView.dequeueReusableCell(withClass: MICompletedEduEmpTableCell.self, for: indexPath)

            cell.titleLabel.text = userEducation.highestQualificationObj.name
            cell.descLabel.text  = [userEducation.year, userEducation.educationTypeObj.name].joined(separator: " | ")
            
            cell.optionClicked = { sender in
                let controller = MIPopOverController()
                controller.profileType  = MIProfileEnums.eduExperience
                controller.preferredContentSize = CGSize(width: 140, height: indexPath.section == 0 ? 40 : 80)
                controller.delegate = self
                controller.info     = [indexPath.section]
                self.showPopup(controller, sourceView: sender)

                controller.tableView.isScrollEnabled = (indexPath.section != 0)
            }
            
            return cell
        }

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var isLastSection = (indexPath.section == self.userEducationDataSource.count - 1)
        if MIUserModel.userSharedInstance.isEducationUploaded { isLastSection = false }
        guard isLastSection else { return }
        
        let sectionModel = self.userEducationDataSource[indexPath.section]
        if let userEducation = sectionModel.sectionDataSource as? MIEducationInfo {
            selectedIndexPath = indexPath
            let title = sectionModel.sectionRowFieldTitle[indexPath.row]
            if title == MIEducationDetailViewControllerConstant.educationType { return }
            self.errorData = (-1, "")
            if title == MIEducationDetailViewControllerConstant.passignYear {
                self.pushStaticMasterController(type: .PASSINGYEAR
                    , data: userEducation.year.isEmpty ? [] : [userEducation.year], educationModelModel: userEducation, title: title)
            }else{
                self.pushToMasterDataSelection(fieldName: title, selectionLimit: 1, model: userEducation)
                
            }
        }
    }

//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if section == 0 {
//            return UIView()
//        }
//
//        //  let model = userEducationsDataSource[section]
//        let footer = MISingleButtonView.singleBtnView
//        footer.sectionIndex = section
//        footer.setBtnAttributes(cornerRadius: 5, borderWidth: 1, borderColor:AppTheme.defaltTheme)
//
//        footer.btnActionCallBack = { sectionCount in
//
//            if MIUserModel.userSharedInstance.isEducationUploaded {
//                 self.itemSectionIndexForDelete = sectionCount
//                self.popup.setViewWithTitle(title: "Delete Education", viewDescriptionText:"Are you sure you want to delete this detail ?" , primaryBtnTitle: "Yes", secondaryBtnTitle: "No", secondaryBtnTextColor: UIColor(hex: "5c4aae"))
//                self.popup.delegate = self
//                self.popup.addMe(onView: self.view, onCompletion: nil)
//
//            }else{
//                if sectionCount < self.userEducationDataSource.count {
//                    self.userEducationDataSource.remove(at: section)
//                    self.tblView.reloadData()
//
//                }
//            }
//        }
//        return footer
//
//    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == 0 {
//            return 1
//        }
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var isLastSection = (section == self.userEducationDataSource.count - 1)
        if MIUserModel.userSharedInstance.isEducationUploaded { isLastSection = false }

        return isLastSection ? UITableView.automaticDimension : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MIEduEmpHeaderView.self)) as? MIEduEmpHeaderView
        
        headerView?.titleLabel.text = self.userEducationDataSource[section].sectionName
        headerView?.deleteButton.isHidden = (section == 0)
        
        headerView?.deleteButton.addTarget(self, action: #selector(deleteLastItem), for: .touchUpInside)
        
        return headerView
    }
    
    @objc func deleteLastItem() {
        
        self.popup.setViewWithTitle(title: "", viewDescriptionText:  ExtraResponse.deleteAlert, or: "", primaryBtnTitle: "Yes", secondaryBtnTitle: "No")
        self.popup.delegate = self
        self.popup.tag = 1
        self.popup.closeBtn.isHidden = true
        self.popup.addMe(onView: self.view, onCompletion: nil)
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EDUCATION, data: ["remove":"click"], destination: self.screenName) { (success, response, error, code) in
                   
               }
    }
    
    func callAPIForDeleteEducation(itemIndex:Int) {
        if let education = self.userEducationDataSource[itemIndex].sectionDataSource as? MIEducationInfo {
            // self.startActivityIndicator()
            MIActivityLoader.showLoader()

            let param = [
                "id" : education.educationId
                ] as [String : Any]
            
            MIApiManager.deleteEducationDetails(.delete, param: param) { [weak self] (result, error) in
                defer {  MIActivityLoader.hideLoader() }
                guard let `self` = self else { return }
                
                //  guard let data = result else { return }
                DispatchQueue.main.async {
                    self.itemSectionIndexForDelete = -1
                    if itemIndex < self.userEducationDataSource.count {
                        self.userEducationDataSource.remove(at: itemIndex)
                        self.tblView.reloadData()
                    }
                }
                
            }
        }
        
//        let eventData = [
//            "eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_SUBMIT,
//            "remove" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK
//            ] as [String : Any]
//        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EDUCATION, data: eventData, destination: CONSTANT_SCREEN_NAME.REGISTER_EDUCATION) { (success, response, error, code) in
//        }
        
    }
}

extension MIEducationByUserVC: JobPreferencePopUpDelegate{
    
    func optionCompleteIgnoredSelected(popSelection: PopUpOptionSelection, popup: MIPopupView) {
        if popSelection == .Completed {
            if popup.tag == 0 {
                self.callAPIForDeleteEducation(itemIndex: self.itemSectionIndexForDelete)
            } else {
                self.userEducationDataSource.last?.sectionDataSource = MIEducationInfo(qualification: "", specialisation: "", instituteName: "", year: "")
                self.tblView.reloadData()
            }
        }
    }
}

extension MIEducationByUserVC: MIPopOverControllerDelegate {
   
    func popOverClicked(actionType: MIProfileActionEnum, info: Any, profileType: MIProfileEnums) {
        
        switch actionType {
        case .edit:
            if let section = info as? Int {
                self.navigateToEditEducationVC(at: section)
            }
        case .delete:
            
            if MIUserModel.userSharedInstance.isEducationUploaded {
                if let section = info as? Int {
                    self.itemSectionIndexForDelete = section
                    self.popup.setViewWithTitle(title: "Delete Education", viewDescriptionText:"Are you sure you want to delete this detail ?" , primaryBtnTitle: "Yes", secondaryBtnTitle: "No", secondaryBtnTextColor: UIColor(hex: "5c4aae"))
                    self.popup.tag = 0
                    self.popup.delegate = self
                    self.popup.addMe(onView: self.view, onCompletion: nil)
                }
                
            }else{
                if let section = info as? Int {
                    self.userEducationDataSource.remove(at: section)
                    self.tblView.reloadData()
                }
            }
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.REGISTER_EDUCATION, data: ["remove":"click"], destination: self.screenName) { (success, response, error, code) in
                       
                   }
        }
    }
    
    func navigateToEditEducationVC(at index: Int) {
        let vc = MIEducationDetailViewController()
        vc.educationFlow = .ViaRegister
        
        if let eduInfo = self.userEducationDataSource[index].sectionDataSource as? MIEducationInfo, let eduInfoCopy = eduInfo.copy() as? MIEducationInfo {
            vc.qualificationArray = [eduInfoCopy]
        }
        vc.updateDataCompletion = { data in
            self.userEducationDataSource[index].sectionDataSource = data.first
            self.tblView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = CGRect(x: 14, y: 0, width: 4, height: 30)
        
        presentationController.canOverlapSourceViewRect = true
        presentationController.permittedArrowDirections = [.up]
        
        self.present(controller, animated: true)
    }    
}

extension MIEducationByUserVC {
    
    func showEducationData(in cell: MITextFieldTableViewCell, title: String, obj: MIEducationInfo, sectionIndex:Int){
        
        cell.titleLabel.text = title
        cell.primaryTextField.placeholder = "Select"

        if title == MIEducationDetailViewControllerConstant.highestQualification  {
            cell.primaryTextField.text =  obj.highestQualificationObj.name
            // cell.primaryTextField.placeholder = (sectionIndex == 0) ? "Highest Qualification" : "Other Qualification"
        }else if title == MIEducationDetailViewControllerConstant.specialisation {
            cell.primaryTextField.text = obj.specialisationObj.name
            
        }else  if title == MIEducationDetailViewControllerConstant.instituteName {
            cell.primaryTextField.text = obj.collegeObj.name
            
        }else if title == MIEducationDetailViewControllerConstant.passignYear {
            cell.primaryTextField.text = obj.year
            
        }else if title == MIEducationDetailViewControllerConstant.educationType {
            cell.primaryTextField.text = obj.educationTypeObj.name
            
        }else if title == MIEducationDetailViewControllerConstant.board {
            cell.primaryTextField.text = obj.boardObj.name
            
        }else if title == MIEducationDetailViewControllerConstant.percentage {
            cell.primaryTextField.text = obj.percentage
        }else if title == MIEducationDetailViewControllerConstant.medium {
            cell.primaryTextField.text = obj.mediumObj.name
        }
    }
}

extension MIEducationByUserVC : MIMasterDataSelectionViewControllerDelegate {
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
       
        if let index = selectedIndexPath {
        
            let sectionModel = self.userEducationDataSource[index.section]
            
          //  let title = sectionModel.sectionRowFieldTitle[index.row]
            if let model = sectionModel.sectionDataSource as? MIEducationInfo {
            
                let dataIds = (selectedCategoryInfo.map { $0.uuid }).joined(separator: ",")
                if MasterDataType.HIGHEST_QUALIFICATION.rawValue == enumName {
                    if model.highestQualificationObj.uuid != (selectedCategoryInfo.last ?? MICategorySelectionInfo()).uuid {
                        model.specialisationObj = MICategorySelectionInfo()
                    }
                    if dataIds == kClass12Id || dataIds == kHighSchool || dataIds == kCLASS10 {
                        model.isEducationDegree = false
                    }else{
                        model.isEducationDegree = true
                    }
                    model.highestQualificationObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()

                    sectionModel.sectionRowFieldTitle = self.manageTitleForSectionRowModel(modal: model, sectionNumber: sectionModel.sectionNumber)
                    
                }else if MasterDataType.SPECIALIZATION.rawValue == enumName {
                    model.specialisationObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()
                }else if MasterDataType.COLLEGE.rawValue == enumName {
                    model.collegeObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()
                    
                }else if MasterDataType.BOARD.rawValue == enumName {
                    model.boardObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()
                    
                }else if MasterDataType.EDUCATION_TYPE.rawValue == enumName {
                    model.educationTypeObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()
                    
                }else if MasterDataType.MEDIUM.rawValue == enumName {
                    model.mediumObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()
                }
            }
            
            selectedIndexPath = nil
            self.tblView.reloadData()
        }
    }
}

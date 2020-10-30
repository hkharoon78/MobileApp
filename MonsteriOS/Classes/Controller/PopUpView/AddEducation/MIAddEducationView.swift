//
//  MIAddEducationView.swift
//  MonsteriOS
//
//  Created by Anushka on 10/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIAddEducationView: UIView {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRemindMe: UIButton!
    
    var card: Card? {
        didSet {
            self.manageModalOnView()
        }
    }
  
    var viewController: UIViewController?
    var educationInfo = MIEducationInfo(qualification: "", specialisation: "", instituteName: "", year: "")
    var indexRow: IndexPath?
    var previousQualification = MIEducationInfo(qualification: "", specialisation: "", instituteName: "", year: "")
    var userEducationTitle = [String]()
    
    var error: (message:String, index:Int) = ("", -1)
    var oldValue = JSONDICT()
    var newValue = JSONDICT()
    var viewLoadDate: Date!
    
    let footer = MIDoubleButtonView.doubleBtnView


    

    lazy var tableHeaderView: MIAddEducationHeaderView = {
        let headerViewdata=MIAddEducationHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 270))
        headerViewdata.switchONOffLocation.isHidden = true
      
        //headerViewdata.switchONOffLocation.transform = CGAffineTransform(scaleX: 0, y: 0)
        headerViewdata.topConstraintSwitch.constant = 0
        headerViewdata.bottomConstraintSwitch.constant = 0
        headerViewdata.heightConstraintSwitch.constant = 0
        
        headerViewdata.lblName.text = "Add Education"
        headerViewdata.lblLocation.text = "It’s not just a piece of paper. You worked for it, now use it"
        headerViewdata.imgLocation.image = #imageLiteral(resourceName: "group-2")
        return headerViewdata
    }()
    
    lazy var tableFooterView: MIAddEducationFooterView = {
        let footerViewdata=MIAddEducationFooterView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80))
        //footerViewdata.btnUpdate.addTarget(self, action: #selector(btnUpdatePressed(_:)), for: .touchUpInside)
        return footerViewdata
    }()
    
    //MARK:Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configure()
    }
    
    
    func configure() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
       // self.tableView.bounces = false
        
        self.viewLoadDate = Date()
        
        self.tableView.estimatedRowHeight = 830.0
        self.tableView.rowHeight = UITableView.automaticDimension
       
        //Register TableView Cell
        tableView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
       
        tableView.tableHeaderView = tableHeaderView
        //tableView.tableFooterView = tableFooterView
        
        self.footer.backgroundColor = .white
        self.footer.btn_next.setTitle("UPDATE", for: .normal)
        self.footer.btn_addAnother.setTitle("NO CHANGE REQUIRED", for: .normal)
        self.footer.btn_next.showSecondaryBtnLayout()
        self.footer.btn_addAnother.showSecondaryBtnLayout(fontSize: 16, bgColor: UIColor(hex: "727272"))
        self.footer.btnSecondryHtConstraint.constant = 44
        self.footer.btn_leadingConstraint.constant = 15
        self.footer.btn_trailingConstairnt.constant = 15
        self.footer.nxtBtnTopConsttaint.constant = 16
        footer.btnAddAnother_leadingConstraint.constant = 13
        footer.btnAddAnother_trailingConstairnt.constant = 13

        self.tableView.tableFooterView = self.footer
        
        footer.addAnotherCallBack = {[weak self] in
            if let wSelf  = self {
                wSelf.callAPIForAddUpdateEduDetail(true)
                
            }
        }
        footer.nextBtnCallBack = { [weak self] in
            if let wSelf  = self {
                if wSelf.validateEducationData(modelObj: wSelf.educationInfo) {
                    wSelf.callAPIForAddUpdateEduDetail(false)
                }
            }
        }
       
        

        userEducationTitle = [MIEducationDetailViewControllerConstant.highestQualification]

      //  self.manageTitle(modal: educationInfo)

    }
    func manageModalOnView() {
        if let data = card?.data as? jsonArr , data.count > 0{
            if let first = data.first {
                previousQualification = MIEducationInfo(educationDict: first)
                educationInfo.educationId = previousQualification.educationId
                educationInfo.highestQualificationObj = previousQualification.highestQualificationObj
                educationInfo.specialisationObj = previousQualification.specialisationObj
                educationInfo.boardObj = previousQualification.boardObj
                educationInfo.mediumObj = previousQualification.mediumObj
                educationInfo.educationTypeObj = previousQualification.educationTypeObj
                educationInfo.collegeObj = previousQualification.collegeObj
                educationInfo.isEducationDegree = previousQualification.isEducationDegree
                
                // for old value
                self.oldValue = ["education" : data ]
                self.tableView.reloadData()
                
            }
            
        }
    }

    
    @IBAction func btnRemindMeLeterPressed(_ sender: UIButton) {
        
        self.callRemindMeLaterApi(self.card?.type ?? "Non-Intrusive", userActions: self.card?.text ?? "EDUCATION")
        
        self.callTrackingevtentsApi("EDUCATION", updated: 0, remindMeLater: 1, oldValue: [:], newValue: [:])
    }
    
    
}

extension MIAddEducationView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userEducationTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MITextFieldTableViewCell.self)) as? MITextFieldTableViewCell else {
            return UITableViewCell()
        }
        
        let rowName =  self.userEducationTitle[indexPath.row]
        cell.primaryTextField.delegate = self
        cell.primaryTextField.tag = indexPath.row
        cell.primaryTextField.placeholder = rowName
        cell.primaryTextField.isUserInteractionEnabled = false
        
        cell.secondryTextField.isHidden = true
        cell.titleLabel.text = ""
        
        if self.error.index == indexPath.row {
            cell.showError(with: self.error.message, animated: false)
        } else {
            cell.showError(with: "")
        }

        
        switch rowName {
        case MIEducationDetailViewControllerConstant.highestQualification:
            cell.primaryTextField.text = educationInfo.highestQualificationObj.name
        case MIEducationDetailViewControllerConstant.board:
            cell.primaryTextField.text = educationInfo.boardObj.name
        case MIEducationDetailViewControllerConstant.passignYear:
             cell.primaryTextField.text = educationInfo.year
        case MIEducationDetailViewControllerConstant.educationType:
            cell.primaryTextField.text = educationInfo.educationTypeObj.name
        case MIEducationDetailViewControllerConstant.medium:
            cell.primaryTextField.text = educationInfo.mediumObj.name
        case MIEducationDetailViewControllerConstant.specialisation:
            cell.primaryTextField.text = educationInfo.specialisationObj.name
        case MIEducationDetailViewControllerConstant.instituteName:
            cell.primaryTextField.text = educationInfo.collegeObj.name
        default:
            break
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // self.indexRow = indexPath

        self.viewController!.view.endEditing(true)
        
        let rowName = self.userEducationTitle[indexPath.row]
        
        switch rowName {
        case MIEducationDetailViewControllerConstant.highestQualification:
            self.masterType(MasterDataType.HIGHEST_QUALIFICATION)
        case MIEducationDetailViewControllerConstant.board:
            self.masterType(MasterDataType.BOARD)
        case MIEducationDetailViewControllerConstant.passignYear:
            
            let staticMasterVC = MIStaticMasterDataViewController.newInstance
            staticMasterVC.title = "Selection"
            staticMasterVC.staticMasterType = .PASSINGYEAR
            staticMasterVC.selectedDataArray = (self.educationInfo.year.count > 0) ? [self.educationInfo.year] : []
            staticMasterVC.selectedData = { value in
                
                let cell = tableView.cellForRow(at: indexPath) as? MITextFieldTableViewCell
                cell?.primaryTextField.text = value
                
                self.educationInfo.year = value
                
            }
            self.viewController?.navigationController?.pushViewController(staticMasterVC, animated: true)
            
        case MIEducationDetailViewControllerConstant.educationType:
            self.masterType(MasterDataType.EDUCATION_TYPE)
        case MIEducationDetailViewControllerConstant.medium:
             self.masterType(MasterDataType.MEDIUM)
        case MIEducationDetailViewControllerConstant.specialisation:
            self.masterType(MasterDataType.SPECIALIZATION)
        case MIEducationDetailViewControllerConstant.instituteName:
            self.masterType(MasterDataType.COLLEGE)
        default:
            break
        }

    }
    
    
}

extension MIAddEducationView: UITextFieldDelegate, MIMasterDataSelectionViewControllerDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func masterType(_ masterType: MasterDataType){
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.delegate = self
        vc.limitSelectionCount = 1
        vc.masterType = masterType
        vc.shouldShowAdd = false
        
        switch masterType {
        case .HIGHEST_QUALIFICATION:
            if educationInfo.highestQualificationObj.name.count > 0 {
                vc.selectDataArray = [educationInfo.highestQualificationObj]
                vc.selectedInfoArray = [educationInfo.highestQualificationObj.name]
            }
        case .BOARD:
            if educationInfo.boardObj.name.count > 0 {
                vc.selectDataArray = [educationInfo.boardObj]
                vc.selectedInfoArray = [educationInfo.boardObj.name]
            }
        case .EDUCATION_TYPE:
            if educationInfo.educationTypeObj.name.count > 0 {
                vc.selectDataArray = [educationInfo.educationTypeObj]
                vc.selectedInfoArray = [educationInfo.educationTypeObj.name]
            }
        case .MEDIUM:
            if educationInfo.mediumObj.name.count > 0 {
                vc.selectDataArray = [educationInfo.mediumObj]
                vc.selectedInfoArray = [educationInfo.mediumObj.name]
            }
        case .SPECIALIZATION:
            if educationInfo.highestQualificationObj.name.isEmpty {
                self.viewController?.showAlert(title: "", message:"Please select your highest qualification first.")
                return
            }else{
                if !educationInfo.specialisationObj.name.isEmpty {
                    vc.selectedInfoArray = [educationInfo.specialisationObj.name]
                    vc.selectDataArray   =  [educationInfo.specialisationObj]
                }
                vc.parentId = MICategorySelectionInfo.getParentUUIDs(modalDataSource:[educationInfo.highestQualificationObj])
            }
//            if educationInfo.specialisationObj.name.count > 0 {
//                vc.selectDataArray = [educationInfo.specialisationObj]
//                vc.selectedInfoArray = [educationInfo.specialisationObj.name]
//            }
        case .COLLEGE:
            if educationInfo.collegeObj.name.count > 0 {
                vc.selectDataArray = [educationInfo.collegeObj]
                vc.selectedInfoArray = [educationInfo.collegeObj.name]
            }
        default:
            break
            
        }

        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        //self.previousQualification = selectedCategoryInfo
        
         let model = self.educationInfo
            let dataIds = (selectedCategoryInfo.map { $0.uuid }).joined(separator: ",")
            if dataIds.count > 0 {
                self.error = ("", -1)

            }

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

            self.manageTitle(modal: model)

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

        self.tableView.reloadData()
        
    }
    
    
    func manageTitle(modal: MIEducationInfo) {

        if previousQualification.highestQualificationObj.uuid == educationInfo.highestQualificationObj.uuid {
            userEducationTitle = [MIEducationDetailViewControllerConstant.highestQualification]

        }else{
            if modal.isEducationDegree {
                userEducationTitle = [MIEducationDetailViewControllerConstant.highestQualification,MIEducationDetailViewControllerConstant.specialisation,MIEducationDetailViewControllerConstant.instituteName,MIEducationDetailViewControllerConstant.passignYear,MIEducationDetailViewControllerConstant.educationType]
            }else {
                userEducationTitle = [MIEducationDetailViewControllerConstant.highestQualification,MIEducationDetailViewControllerConstant.board,MIEducationDetailViewControllerConstant.passignYear,MIEducationDetailViewControllerConstant.educationType,MIEducationDetailViewControllerConstant.medium]
            }
        }
       
    }
    
}

//API CAll
extension MIAddEducationView {
    
    
    func showErrorOnTableViewIndex(indexPath:IndexPath, errorMsg:String,isPrimary:Bool) {
        
        self.error = (errorMsg, indexPath.row)
        if indexPath.row > -1 {
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0), at: .top, animated: false)
        }
    }
    
    func validateEducationData(modelObj : MIEducationInfo) -> Bool {
        self.error = ("", -1)
       
//        let index = IndexPath(row: self.indexRow?.row ?? 0, section: 0)
//        guard let cell = tableView.cellForRow(at: index) as? MITextFieldTableViewCell else { return false }
        
        if modelObj.highestQualificationObj.name.isEmpty {
             if let index = self.userEducationTitle.firstIndex(of: MIEducationDetailViewControllerConstant.highestQualification){
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: MIEmploymentDetailViewControllerConstant.emptyMostRecentDesignation, isPrimary: true)
            }
           return false
        }
        if self.userEducationTitle.count == 1 {
            return true
        }
    
        if modelObj.specialisationObj.name.isEmpty && modelObj.isEducationDegree {
    
            if let index = self.userEducationTitle.firstIndex(of: MIEducationDetailViewControllerConstant.specialisation){
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: MIEducationDetailViewControllerConstant.emptySpecialisation, isPrimary: true)
            }
            return false
        }
    
        if modelObj.boardObj.name.isEmpty  && !modelObj.isEducationDegree {
            
            if let index = self.userEducationTitle.firstIndex(of: MIEducationDetailViewControllerConstant.board){
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: MIEducationDetailViewControllerConstant.emptyBoard, isPrimary: true)
            }

            return false
        }
        
        if modelObj.collegeObj.name.isEmpty && modelObj.isEducationDegree {
            
            if let index = self.userEducationTitle.firstIndex(of: MIEducationDetailViewControllerConstant.instituteName){
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: MIEducationDetailViewControllerConstant.emptyInstitueName, isPrimary: true)
            }

            return false
        }
        if modelObj.mediumObj.name.isEmpty && !modelObj.isEducationDegree {
            
            if let index = self.userEducationTitle.firstIndex(of: MIEducationDetailViewControllerConstant.medium){
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: MIEducationDetailViewControllerConstant.emptyMedium, isPrimary: true)
            }

            return false
        }
        
        if modelObj.year.isEmpty {
            
            if let index = self.userEducationTitle.firstIndex(of: MIEducationDetailViewControllerConstant.passignYear) {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: MIEducationDetailViewControllerConstant.emptyYear, isPrimary: true)
            }

            return false
        }
        
        if modelObj.educationTypeObj.name.isEmpty {
            
            if let index = self.userEducationTitle.firstIndex(of: MIEducationDetailViewControllerConstant.educationType) {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: MIEducationDetailViewControllerConstant.emptyEducationType, isPrimary: true)
            }

            return false
        }

        return true
        
    }
    
    
    func callAPIForAddUpdateEduDetail(_ isNoChange: Bool) {
        
        var paramData = [[String:Any]]()
        var serviceType : ServiceMethod = .put
        var paramModal  = self.previousQualification
        
        if !isNoChange {
            serviceType = .post
            self.educationInfo.educationId = ""
            if educationInfo.highestQualificationObj.uuid == previousQualification.highestQualificationObj.uuid &&  educationInfo.specialisationObj.uuid == previousQualification.specialisationObj.uuid {
                serviceType = .put
                    self.educationInfo.educationId = self.previousQualification.educationId
            }
            paramModal = self.educationInfo
        }
        paramData = MIEducationInfo.getEducationDataListParams(educationList: [paramModal], isforResgister: false)

        //set data for new value
        let newyear = self.educationInfo.year.isNumeric ? (Int(self.educationInfo.year))  : nil
        
        self.newValue = ["education" : ["highQualification":self.educationInfo.highestQualificationObj.name,"specializaiton":self.educationInfo.specialisationObj.name,MIEducationDetailViewControllerConstant.boardAPIKey:self.educationInfo.boardObj.name,MIEducationDetailViewControllerConstant.mediumAPIKey:self.educationInfo.mediumObj.name,"institute":self.educationInfo.collegeObj.name,MIEducationDetailViewControllerConstant.educationTypeAPIKey:self.educationInfo.educationTypeObj.name,"passingYear":newyear ]]
        let oldyear = previousQualification.year.isNumeric ? (Int(previousQualification.year) as! Int)  : nil
      //  oldyear = (oldyear == nil) ? nil : oldyear!

        self.oldValue = ["education" : ["highQualification":previousQualification.highestQualificationObj.name,"specializaiton":previousQualification.specialisationObj.name,MIEducationDetailViewControllerConstant.boardAPIKey:previousQualification.boardObj.name,MIEducationDetailViewControllerConstant.mediumAPIKey:previousQualification.mediumObj.name,"institute":previousQualification.collegeObj.name,"passingYear":oldyear,MIEducationDetailViewControllerConstant.educationTypeAPIKey:previousQualification.educationTypeObj.name ]]

        
        let added = self.viewController?.addTaskToDispatchGroup() ?? false
        self.viewController?.skipProfileEngagementPopup()
       
        let headerDict = [
            "x-rule-applied": card?.ruleApplied ?? "",
            "x-rule-version": card?.ruleVersion ?? ""
        ]
        MIApiManager.callAPIForUpdateEmploymentEducation(methodType: serviceType, path: APIPath.updateEducationalDetailApiEndpoint, params: paramData, customHeaderParams: headerDict) { (success, response, error, code) in

            DispatchQueue.main.async {
                defer { self.viewController?.leaveDispatchGroup(added) }

                if error == nil && (code >= 200) && (code <= 299) {
                    JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.EDUCATION]

                    if let tabbar = self.viewController?.tabbarController {
                        tabbar.handlePopFinalState(isErrorHappen: false)
                    }
             
                } else{
                    if let tabbar = self.viewController?.tabbarController {
                        tabbar.isErrorOccuredOnProfileEngagement = true
                    }
                }
                
                //event tracking
                if !isNoChange {
                    self.callTrackingevtentsApi("EDUCATION", updated: 1, remindMeLater: 0, oldValue: self.oldValue, newValue: self.newValue)
                } else {
                    self.callTrackingevtentsApi("EDUCATION", updated: 0, remindMeLater: 0, oldValue: [:], newValue: [:])
                }
                
            }
        }
    }
    
    func callRemindMeLaterApi(_ type: String, userActions: String) {
        self.viewController?.skipProfileEngagementPopup()

        let headerDict = [
            "x-rule-applied": card?.ruleApplied ?? "",
            "x-rule-version": card?.ruleVersion ?? ""
        ]

        MIApiManager.hitRemindMeLaterApi(type, userActions: userActions, headerDict: headerDict) { (success, response, error, code) in
           
             DispatchQueue.main.async {
                if error == nil && (code >= 200) && (code <= 299) {
                } else {
                }
            }

        }
        
    }
    
    func callTrackingevtentsApi(_ attribute: String, updated: Int, remindMeLater: Int, oldValue: JSONDICT, newValue: JSONDICT) {
        
        MIApiManager.hitTrackingEventsApi(attribute, updated: updated, remindMeLater: remindMeLater, oldValue: oldValue, newValue: newValue, timeSpent: viewLoadDate.getSecondDifferenceBetweenDates(), cardRule: card) { (success, response, error, code) in
       
        }
        
    }
    
    
}

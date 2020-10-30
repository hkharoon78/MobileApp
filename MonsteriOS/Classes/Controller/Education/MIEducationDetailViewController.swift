//
//  MIEducationBackgroundViewController.swift
//  MonsteriOS
//
//  Created by Monster on 30/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//  From: Profile

import UIKit

class MIEducationDetailViewController: MIBaseViewController {
   
    @IBOutlet weak private var progressView : UIView!
    @IBOutlet weak private var tblView      : UITableView!
    @IBOutlet weak private var nextBtn      : UIButton!
    @IBOutlet weak private var headerSegmentProcessHtConstraint: NSLayoutConstraint!

    private var tFooter          = MILoginFooterView.header
    var qualificationArray       = [MIEducationInfo]()
    private var fieldsDataSource = [String:[String]]()
    var educationAddedSuccess    : ((Bool) -> Void)?
    var educationFlow : FlowVia  = .ViaRegister
    var selectedIndex            : IndexPath?
   // var isFormFreshOrExper:ProfessionalDetailsEnum = .Fresher

    var updateDataCompletion: (([MIEducationInfo])->Void)?
    
    private var errorData : (index:Int,errorMessage:String) = (-1,"") {
        didSet {
            guard errorData.index >= 0 else { return }
            self.tblView.reloadData()
        }
    }
    
    // MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.createFieldsForDegreeOrSchoolHolder()
        self.setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Educational Experience"
        
       if educationFlow == .ViaRegister {
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.REGISTER_EDIT_EDUCATION)
        }else{
            JobSeekerSingleton.sharedInstance.addScreenName(screenName: CONSTANT_SCREEN_NAME.EDUCATION_SCREEN)
        }

    }
    
    // MARK:- Helper Methods
    func setUI() {
        //Check if user appear to this screen via register process or update/Add from its profile

        nextBtn.setTitle("UPDATE", for: .normal)
        self.headerSegmentProcessHtConstraint.constant = 0
        if educationFlow == .ViaProfileAdd {
            self.addEducationSection()
            nextBtn.setTitle("Save", for: .normal)
            
        }
        nextBtn.showPrimaryBtn()

        //Setting TableView appearence
        tblView.separatorStyle = .none
        tblView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        self.tblView.keyboardDismissMode = .onDrag

        tblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        tblView.register(UINib(nibName:String(describing: MI3RadioButtonTableCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MI3RadioButtonTableCell.self))

        //Setting Table Footer Appearence
        tFooter.btn.showSecondaryBtn(ttl: MIEducationDetailViewControllerConstant.addAnother)
        tFooter.btn.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        tFooter.show(ttl: MIEducationDetailViewControllerConstant.addAnother)
        tFooter.set(lead:5, trail:5)
        tFooter.delegate = self
        
        self.tblView.reloadData()
        
        if self.educationFlow == .ViaRegister {
            for d in self.qualificationArray {
                _=self.validateEducationData(modelObj: d)
            }
        }

    }
    
    func addEducationSection() {
        //Add a new section for education hold for future use
        qualificationArray.append(MIEducationInfo(qualification: "", specialisation: "", instituteName: "", year: ""))
        self.tblView.reloadData()
    }
    
    func createFieldsForDegreeOrSchoolHolder() {
        
        //Key Value pair set for degree and school holder users
        fieldsDataSource["degree"] = [ MIEducationDetailViewControllerConstant.highestQualification,
                                       MIEducationDetailViewControllerConstant.specialisation,
                                       MIEducationDetailViewControllerConstant.instituteName,
                                       MIEducationDetailViewControllerConstant.passignYear,
                                       MIEducationDetailViewControllerConstant.educationType]
        fieldsDataSource["school"] = [ MIEducationDetailViewControllerConstant.highestQualification,
                                       MIEducationDetailViewControllerConstant.board,
                                       MIEducationDetailViewControllerConstant.medium,
                                       MIEducationDetailViewControllerConstant.passignYear,
                                       MIEducationDetailViewControllerConstant.educationType]
    }
    
    func validateEducationData(modelObj : MIEducationInfo) -> Bool {
       
        let arr = ((modelObj.isEducationDegree) ? self.fieldsDataSource["degree"] : self.fieldsDataSource["school"]) ?? []

        
        if modelObj.highestQualificationObj.name.isEmpty {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.highestQualification) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptyHighestQualification)
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return false
        }
        if modelObj.specialisationObj.name.isEmpty && modelObj.isEducationDegree {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.specialisation) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptySpecialisation)
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return false
        }
        if modelObj.boardObj.name.isEmpty  && !modelObj.isEducationDegree {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.board) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptyBoard)
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return false
        }
        if modelObj.collegeObj.name.isEmpty && modelObj.isEducationDegree {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.instituteName) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptyInstitueName)
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return false
        }
        if modelObj.year.isEmpty {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.passignYear) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptyYear)
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return false
        }
        if modelObj.educationTypeObj.name.isEmpty {
            self.toastView(messsage: MIEducationDetailViewControllerConstant.emptyEducationType)
            return false
        }
        if modelObj.mediumObj.name.isEmpty && !modelObj.isEducationDegree {
            if let index = arr.firstIndex(of: MIEducationDetailViewControllerConstant.medium) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, MIEducationDetailViewControllerConstant.emptyMedium)
                
                self.tblView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
            return false
        }
        return true
        
    }
    //MARK: - API Helper Methods
    
    func callAPIForAddUpdateEduDetail() {
        
        var paramData = [[String:Any]]()
        var serviceType : ServiceMethod = .put
        if self.educationFlow == .ViaProfileAdd {
            serviceType = .post
        }
        paramData = MIEducationInfo.getEducationDataListParams(educationList: qualificationArray, isforResgister: false)

        self.startActivityIndicator()
        MIApiManager.callAPIForUpdateEmploymentEducation(methodType:serviceType, path: APIPath.updateEducationalDetailApiEndpoint, params: paramData, customHeaderParams: [:]) { (success, response, error, code) in
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                
                if error == nil && (code >= 200) && (code <= 299) {
                    JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.EDUCATION]
                    shouldRunProfileApi = true
                  //  self.showAlert(title: "", message: self.educationFlow.educationSuccessMessage,isErrorOccured:false)
                    
                    if let action = self.educationAddedSuccess {
                        action(true)
                    }
                    self.updateDataCompletion?(self.qualificationArray)
                    self.showAlert(title: "", message: self.educationFlow.educationSuccessMessage, isErrorOccured: false) {
                        self.navigationController?.popViewController(animated: true)

                    }
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
        }
    }
    
    
    //MARK: - IBAction Helper Methods
    @IBAction func nextClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        var isAllEducationVerified = true
        //Validate eductaion data
        for obj in self.qualificationArray {
            if !self.validateEducationData(modelObj: obj){
                isAllEducationVerified = false
                return
            }
        }
        
        if isAllEducationVerified {
            let educationId = self.qualificationArray.first?.educationId ?? ""
            if educationId.isEmpty && educationFlow == .ViaRegister {
                self.updateDataCompletion?(qualificationArray)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.callAPIForAddUpdateEduDetail()
            }
        }
    }
}

extension MIEducationDetailViewController: UITableViewDataSource,UITableViewDelegate,MILoginFooterViewDelegate {

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.qualificationArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = self.qualificationArray[section]
        return  (model.isEducationDegree ?  self.fieldsDataSource["degree"]?.count :  self.fieldsDataSource["school"]?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let sectionModel = self.qualificationArray[indexPath.section]
        let fieldName = ((sectionModel.isEducationDegree) ? self.fieldsDataSource["degree"]![indexPath.row] : self.fieldsDataSource["school"]![indexPath.row])

        let error = (self.errorData.index == indexPath.row) ? self.errorData.errorMessage : ""
        
        if fieldName == MIEducationDetailViewControllerConstant.educationType {
            let cell = tableView.dequeueReusableCell(withClass: MI3RadioButtonTableCell.self, for: indexPath)
            cell.titleLabel.text = fieldName

            cell.setButtons("Full Time", button2: "Part Time", button3: "Correspondence")
            
            switch sectionModel.educationTypeObj.name.lowercased() {
                case "Full Time".lowercased():
                    cell.selectRadioButton(at: 0)
                case "Part Time".lowercased():
                    cell.selectRadioButton(at: 1)
                case "Correspondence".lowercased():
                    cell.selectRadioButton(at: 2)
                default: break
            }
            
            cell.radioBtnSelection = { index, title in
                
                switch index {
                case 0: //Full Time
                    sectionModel.educationTypeObj = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"f583b140-fc6b-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()

                case 1: //Part Time
                    sectionModel.educationTypeObj = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"00d78ad2-fc6c-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()

                default: //Correspondence
                    sectionModel.educationTypeObj = MICategorySelectionInfo(dictionary: ["name":title,"uuid":"1a9600f6-fc6c-11e8-92d8-000c290b6677"]) ?? MICategorySelectionInfo()
                }
            }

            return cell
        } else {
            let eduCell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            eduCell.secondryTextField.isHidden = true
            eduCell.primaryTextField.isUserInteractionEnabled = false
            
            eduCell.primaryTextField.placeholder = fieldName
            
            eduCell.showError(with: error, animated: false)
            self.showEducationData(in: eduCell, title: fieldName, obj: sectionModel, sectionIndex: 0)
            
            return eduCell
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return MIEmptyHeader.header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        selectedIndex  = indexPath

        let secObj = self.qualificationArray[indexPath.section]
        let fieldName = ((secObj.isEducationDegree) ? self.fieldsDataSource["degree"]![indexPath.row] : self.fieldsDataSource["school"]![indexPath.row])

        if fieldName == MIEducationDetailViewControllerConstant.educationType { return }
        self.errorData = (-1, "")
        
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.title = MIEducationDetailViewControllerConstant.search
        vc.delegate = self
        vc.limitSelectionCount = 1

        if fieldName == MIEducationDetailViewControllerConstant.highestQualification {
            vc.masterType = MasterDataType.HIGHEST_QUALIFICATION
            if !secObj.highestQualificationObj.name.isEmpty {
               
                let tuple = self.getSelectedMasterDataFor(dataSource:[secObj.highestQualificationObj])
                vc.selectedInfoArray = tuple.masterDataNames
                vc.selectDataArray   =  tuple.masterDataObject
            }
        }else if fieldName == MIEducationDetailViewControllerConstant.specialisation {
            vc.masterType = MasterDataType.SPECIALIZATION
            if secObj.highestQualificationObj.name.isEmpty {
                self.showAlert(title: "", message:"Please select your highest qualification first.")
                return
            }else{
                if !secObj.specialisationObj.name.isEmpty {
                    let tuple = self.getSelectedMasterDataFor(dataSource: [secObj.specialisationObj])
                    vc.selectedInfoArray = tuple.masterDataNames
                    vc.selectDataArray   =  tuple.masterDataObject
                }
                vc.parentId = MICategorySelectionInfo.getParentUUIDs(modalDataSource:[secObj.highestQualificationObj])
            }
           
        }else if fieldName == MIEducationDetailViewControllerConstant.instituteName {
            vc.masterType = MasterDataType.COLLEGE
            if !secObj.collegeObj.name.isEmpty {
                let tuple = self.getSelectedMasterDataFor(dataSource: [secObj.collegeObj])
                vc.selectedInfoArray = tuple.masterDataNames
                vc.selectDataArray   =  tuple.masterDataObject
            }
        }else if fieldName == MIEducationDetailViewControllerConstant.board {
            vc.masterType = MasterDataType.BOARD
            if !secObj.boardObj.name.isEmpty {
                let tuple = self.getSelectedMasterDataFor(dataSource: [secObj.boardObj])
                vc.selectedInfoArray = tuple.masterDataNames
                vc.selectDataArray   =  tuple.masterDataObject
            }
        }else if fieldName == MIEducationDetailViewControllerConstant.medium {
            vc.masterType = MasterDataType.MEDIUM
            if !secObj.mediumObj.name.isEmpty {
                let tuple = self.getSelectedMasterDataFor(dataSource: [secObj.mediumObj])
                vc.selectedInfoArray = tuple.masterDataNames
                vc.selectDataArray   =  tuple.masterDataObject
            }
        }else{
            let staticMasterVC = MIStaticMasterDataViewController.newInstance
            staticMasterVC.title = "Selection"
            if fieldName == MIEducationDetailViewControllerConstant.passignYear {
                staticMasterVC.staticMasterType = .PASSINGYEAR
                if !secObj.year.isEmpty {
                    staticMasterVC.selectedDataArray = secObj.year.components(separatedBy: ",")
                }

            }else if fieldName == MIEducationDetailViewControllerConstant.percentage{
                staticMasterVC.staticMasterType = .PERCENTAGE
                if !secObj.percentage.isEmpty {
                    staticMasterVC.selectedDataArray = secObj.percentage.components(separatedBy: ",")
                }
            }
            staticMasterVC.delagate = self
            self.navigationController?.pushViewController(staticMasterVC, animated: true)
            return

        }
        self.navigationController?.pushViewController(vc, animated: true)

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
    func footerBtnClicked(_ sender: AKLoadingButton) {
        self.addEducationSection()
        self.tblView.reloadData()
    }
    
}

extension MIEducationDetailViewController : MIMasterDataSelectionViewControllerDelegate {

    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
    
        if let section = selectedIndex {
            let sectionModel = qualificationArray[section.section]
            let dataIds = (selectedCategoryInfo.map { $0.uuid }).joined(separator: ",")
        
            if MasterDataType.HIGHEST_QUALIFICATION.rawValue == enumName {
                sectionModel.highestQualificationObj = selectedCategoryInfo.last!
                if dataIds == kClass12Id || dataIds == kHighSchool || dataIds == kCLASS10 {
                    sectionModel.isEducationDegree = false
                }else{
                    sectionModel.isEducationDegree = true
                }
                sectionModel.specialisationObj = MICategorySelectionInfo()
                
            } else if MasterDataType.SPECIALIZATION.rawValue == enumName {
                sectionModel.specialisationObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()
            }else if MasterDataType.COLLEGE.rawValue == enumName {
                sectionModel.collegeObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()
                
            }else if MasterDataType.BOARD.rawValue == enumName {
                sectionModel.boardObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()
                
            }else if MasterDataType.EDUCATION_TYPE.rawValue == enumName {
                sectionModel.educationTypeObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()
                
            }else if MasterDataType.MEDIUM.rawValue == enumName {
                sectionModel.mediumObj = selectedCategoryInfo.last ?? MICategorySelectionInfo()
                
            }
        }
        self.tblView.reloadData()
    }
    
}

extension MIEducationDetailViewController {
    
    func showEducationData(in cell: MITextFieldTableViewCell, title: String, obj: MIEducationInfo, sectionIndex:Int){
        
        cell.titleLabel.text = title
        cell.primaryTextField.placeholder = "Select"
        
        if title == MIEducationDetailViewControllerConstant.highestQualification  {
            cell.primaryTextField.text =  obj.highestQualificationObj.name
            cell.primaryTextField.placeholder = (sectionIndex == 0) ? "Highest Qualification" : "Other Qualification"
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


extension MIEducationDetailViewController : MIStaticMasterDataSelectionDelegate {
    func staticMasterDataSelected(selectedData: [String], masterType: String) {
        let data =   selectedData.joined(separator: ",").withoutWhiteSpace()
        if let section = selectedIndex {
            let sectionModel = qualificationArray[section.section]
            if StaticMasterData.PASSINGYEAR.rawValue == masterType {
                sectionModel.year = data
            }else if StaticMasterData.PERCENTAGE.rawValue == masterType {
                sectionModel.percentage = data
            }
        }
        self.tblView.reloadData()
    }

}


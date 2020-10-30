//
//  MIAdvanceSearchViewController.swift
//  MonsteriOS
//
//  Created by Piyush Dwivedi on 21/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
class SalaryDetail : NSObject,NSCopying {
    
    
    var salaryInLakh = "" {
        didSet {
            absoluteValue = 0
        }
    }
    var salaryThousand = "" {
        didSet {
            absoluteValue = 0
        }
    }
    var salaryCurrency = "" {
        didSet {
            absoluteValue = 0
        }
    }
    var absoluteValue = 0
    var salaryModeAnually = true
    var isConfidential = false

    var salaryMode = MICategorySelectionInfo(dictionary: ["name":"Annually","uuid":kannuallyModeSalaryUUID]) ?? MICategorySelectionInfo()
    
    override init() {
        super.init()
        
    }
    init(salaryLakh:String,salaryThousnd:String,salaryCurrency:String,absoluteValue:Int,salaryModeAnually:Bool,salaryMode:MICategorySelectionInfo,confidential:Bool) {
        self.salaryInLakh = salaryLakh
        self.salaryThousand = salaryThousnd
        self.salaryCurrency = salaryCurrency
        self.absoluteValue = absoluteValue
        self.salaryModeAnually = salaryModeAnually
        self.isConfidential = confidential
        self.salaryMode = salaryMode.copy() as! MICategorySelectionInfo

    }
    func copy(with zone: NSZone? = nil) -> Any {
        let copyobj = SalaryDetail(salaryLakh: self.salaryInLakh, salaryThousnd: self.salaryThousand, salaryCurrency: self.salaryCurrency, absoluteValue: self.absoluteValue, salaryModeAnually: self.salaryModeAnually, salaryMode: self.salaryMode, confidential: isConfidential)
        return copyobj
    }
    
    
    class func getAbsoulateValueData(salaryData:SalaryDetail) -> Int {
        if salaryData.salaryCurrency == "INR" {
            if !salaryData.salaryInLakh.isEmpty && salaryData.salaryInLakh.isNumeric {
                salaryData.absoluteValue = (Int(salaryData.salaryInLakh) ?? 0) * 100000
                
            }
            if !salaryData.salaryThousand.isEmpty && salaryData.salaryThousand.isNumeric {
                salaryData.absoluteValue = salaryData.absoluteValue +   (Int(salaryData.salaryThousand) ?? 0)
                
            }
        }else{
            if !salaryData.salaryInLakh.isEmpty && salaryData.salaryInLakh.isNumeric {
                salaryData.absoluteValue = Int(salaryData.salaryInLakh) ?? 0
                
            }
        }
        return salaryData.absoluteValue
    }
    
    class func getSalaryParam(salary:SalaryDetail, withConfidential:Bool) -> [String:Any]?{
        
        var salaryParams = [String:Any]()
        
//        if (basicProfileInfo.additionPersonalInfo?.salarylakh.isEmpty ?? true) {
//            basicProfileInfo.additionPersonalInfo?.salarylakh = "0"
//        }
//        if (basicProfileInfo.additionPersonalInfo?.salaryThousand.isEmpty ?? true) {
//            basicProfileInfo.additionPersonalInfo?.salaryThousand = "0"
//        }
//        var lakhAmount = Int(basicProfileInfo.additionPersonalInfo?.salarylakh ?? "0")
//        let thousandAmount = Int(basicProfileInfo.additionPersonalInfo?.salaryThousand ?? "0")
//        if basicProfileInfo.additionPersonalInfo?.salaryCurreny == "INR" {
//            lakhAmount = (lakhAmount ?? 0)*100000 + (thousandAmount ?? 0)
//        }
        salaryParams[APIKeys.absoluteValueAPIKey] = SalaryDetail.getAbsoulateValueData(salaryData: salary)

        salaryParams[APIKeys.currencyAPIKey] = salary.salaryCurrency
//        var salaryMode = [String:Any]()
//        salaryMode[APIKeys.textAPIKey] = "ANNUALLY"
        salaryParams[APIKeys.salaryModeAPIKey] = MIUserModel.getParamForIdText(id: salary.salaryMode.uuid, value: salary.salaryMode.name)

        if withConfidential {
            salaryParams[APIKeys.confidentialAPIKey] = salary.isConfidential

        }
        return  (salary.salaryInLakh.isEmpty && salary.salaryThousand.isEmpty) ? nil :  salaryParams

    }
    
    required public init?(salary:[String:Any]) {
        
        salaryCurrency =  salary.stringFor(key: "currency")
        if salaryCurrency == "INR" {
            let salary = salary.intFor(key: "absoluteValue")
            if salary > 0 {
                
                let salaryLkh = salary/100000
                salaryInLakh = (salaryLkh > 0 ) ? "\(salaryLkh)" : ""
                salaryThousand = (salary%100000) > 0 ?  "\(salary%100000)" : ""
            }
            
        }else{
            let salary = salary.intFor(key: "absoluteValue")
            if salary > 0 {
                salaryInLakh =  String(salary)
            }
            salaryThousand =  ""
        }
        
        isConfidential = salary.booleanFor(key: "confidential")

        if let mode = salary["salaryMode"] as? [String:Any] {
            salaryMode = MICategorySelectionInfo(dictionary: mode) ?? MICategorySelectionInfo()
            if salaryMode.uuid.count > 0 {
                if salaryMode.uuid == kmonthlyModeSalaryUUID {
                    salaryModeAnually = false
                }
            }else{
                salaryMode = MICategorySelectionInfo(dictionary: ["name":"Annually","uuid":kannuallyModeSalaryUUID])!
            }
           
        }
    }
    
}

class MIAdvanceSearchlDetail:NSObject {
    
    var skill          = [String]()
    var location       = [MICategorySelectionInfo]()
    var workExperience = ""
    var currentSalary  = SalaryDetail()
    var industry       = [MICategorySelectionInfo]()
    var function       = [MICategorySelectionInfo]()
}

class MIAdvanceSearchViewController: MIBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var searchModel = MIAdvanceSearchlDetail()
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var searchBtn: UIButton!
    private var dataSource = [String]()
    
    var errorData : (index:Int,errorMessage:String) = (-1,"") {
        didSet {
            guard errorData.index >= 0 else { return }
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Advanced Search"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    func setUI() {
        searchBtn.showPrimaryBtn()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor  = UIColor.clear
        
        self.tableView.register(nib: MITextViewTableViewCell.loadNib(), withCellClass: MITextViewTableViewCell.self)
        self.tableView.register(nib: MIEmploymentSalaryTableCell.loadNib(), withCellClass: MIEmploymentSalaryTableCell.self)
        
        if let site = AppDelegate.instance.site {
            searchModel.currentSalary.salaryCurrency = site.defaultCurrencyDetails.currency?.isoCode ?? "INR"
            
        }
        self.populateDataSource()
        
    }
    
    func populateDataSource() {
        dataSource = [ PersonalTitleConstant.jobKeyword,
                       PersonalTitleConstant.location,
                       PersonalTitleConstant.year,
                       PersonalTitleConstant.salary,
                       PersonalTitleConstant.industry,
                       PersonalTitleConstant.function
        ]
        self.tableView.reloadData()
    }
    
    //MARK:Search Btn Action
    @IBAction func searchBtnAction(_ sender: UIButton) {

        if self.searchModel.skill.count == 0 {
            if let index = self.dataSource.firstIndex(of: PersonalTitleConstant.jobKeyword) {
                let indexPath = IndexPath(row: index, section: 0)
                self.errorData = (indexPath.row, "Key Skill can not be blank")
                self.callAPIForJobSeekerMapEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_SUBMIT,"validationErrorMessages":[["field":"key_skills","message":"Key Skill can not be blank"]]])
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        } else {
            self.callAPIForJobSeekerMapEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_SUBMIT])

            if let vcs=self.navigationController?.viewControllers{
                for (index,vc) in vcs.enumerated(){
                    if let _ = vc as? MISRPJobListingViewController{
                        self.navigationController?.viewControllers.remove(at: index)
                    }
                    
                }
            }
            let prevView = MISRPJobListingViewController()
            if searchModel.skill.count > 0{
                prevView.selectedSkills = searchModel.skill.joined(separator: ",")
            }else{
                prevView.selectedSkills = ""
            }
            if searchModel.location.count > 0 {
                prevView.selectedLocation = searchModel.location.map({$0.name}).joined(separator: ",")
            }
            if searchModel.industry.count > 0 {
                prevView.param[SRPListingDictKey.industries.rawValue] = searchModel.industry.map({$0.name})
            }
            if searchModel.function.count > 0 {
                prevView.param[SRPListingDictKey.functions.rawValue] = searchModel.function.map({$0.name})
            }
            if searchModel.workExperience.count > 0 {
                prevView.param[SRPListingDictKey.experienceRanges.rawValue] = ["\(searchModel.workExperience)~\(searchModel.workExperience)"]
            }
            if searchModel.currentSalary.salaryInLakh.count > 0 || searchModel.currentSalary.salaryThousand.count > 0  {
                prevView.param[SRPListingDictKey.salary.rawValue] = ["\(SalaryDetail.getAbsoulateValueData(salaryData: searchModel.currentSalary))~\(SalaryDetail.getAbsoulateValueData(salaryData: searchModel.currentSalary))"]
            }
            self.navigationItem.title = ""
            self.navigationController?.pushViewController(prevView, animated: false)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = dataSource[indexPath.row]
        if title == PersonalTitleConstant.salary {
            
            let currentSalryCell = tableView.dequeueReusableCell(withClass: MIEmploymentSalaryTableCell.self, for: indexPath)
            currentSalryCell.stackViewForSalryMode.isHidden = true
            currentSalryCell.showCalulatedSalary = false
            currentSalryCell.showDataForSalar(salaryIakh: searchModel.currentSalary.salaryInLakh, salaryInThousand: searchModel.currentSalary.salaryThousand, salaryCurrency: searchModel.currentSalary.salaryCurrency, salaryMode: searchModel.currentSalary.salaryModeAnually)
            
            currentSalryCell.currencyCallBack = { (cell, type) in
                self.view.endEditing(true)
                if type == "CURRENCY" {
                    self.currencyOptionSelected(indexPath)
                } else if type == "LAKH" {
                    self.lakhOptionSelected(indexPath)
                } else if type == "THOUSAND" {
                    self.thousandOptionSelected(indexPath)
                }
            }
            return currentSalryCell
        } else {
            
            let cell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
            
            let error = (self.errorData.index == indexPath.row) ? self.errorData.errorMessage : ""
            cell.showError(with: error, animated: false)
            
            cell.showDataForAdvanceSearch(title: title, advanceSearch: searchModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.errorData = (-1, "")
        
        let dataModel = self.dataSource[indexPath.row]
        if dataModel == PersonalTitleConstant.jobKeyword {
            let vc = MIAdvanceSearchJobViewController()
            vc.delegate          = self
            vc.selectedInfoArray = searchModel.skill
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if dataModel == PersonalTitleConstant.industry {
            self.showMasterdataController(masterType: .INDUSTRY, valueObj: searchModel.industry, limitCount: 2)
        }
        if dataModel == PersonalTitleConstant.function {
            self.showMasterdataController(masterType: .FUNCTION, valueObj: searchModel.function, limitCount: 2)
        }
        if dataModel == PersonalTitleConstant.location {
            self.showMasterdataController(masterType: .LOCATION, valueObj: searchModel.location, limitCount: 5)
        }
        if dataModel  == PersonalTitleConstant.year {
            let staticMasterVC = MIStaticMasterDataViewController.newInstance
            staticMasterVC.staticMasterType = .EXPEREINCEINYEAR
            staticMasterVC.selectedDataArray = [self.searchModel.workExperience]
            staticMasterVC.title = "Experience in Year"
            staticMasterVC.delagate = self
            self.navigationController?.pushViewController(staticMasterVC, animated: true)
        }
    }
    
    
    func showMasterdataController(masterType: MasterDataType, valueObj: [MICategorySelectionInfo], additinalData: String? = nil, limitCount:Int) {
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.title = MIEducationDetailViewControllerConstant.search
        vc.delegate = self
        vc.limitSelectionCount = limitCount
        vc.masterType = masterType
        if masterType == .VISA_TYPE {
            vc.isoCountryCode = "US"
        }
        let tuples = self.getSelectedMasterDataFor(dataSource: valueObj)
        vc.selectDataArray = tuples.masterDataObject
        vc.selectedInfoArray = tuples.masterDataNames
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getSelectedMasterDataFor(dataSource: [MICategorySelectionInfo]) -> (masterDataNames:[String], masterDataObject: [MICategorySelectionInfo]) {
        var selectedInfoArray = [String]()
        var selectDataArray = [MICategorySelectionInfo]()
        if (dataSource.count) > 0 {
            let dataNames = dataSource.filter{$0.name.isEmpty == false}
            if dataNames.count > 0 {
                selectedInfoArray = (dataSource.map({ $0.name}))
                selectDataArray = dataSource
                
            }
        }
        return (selectedInfoArray,selectDataArray)
        
    }
    
    //IBAction for salry cell
    @objc func currencyOptionSelected(_ indexPath : IndexPath) {
        let title = dataSource[indexPath.row]
        var dataList = [String]()
        if title == PersonalTitleConstant.salary  {
            if !searchModel.currentSalary.salaryCurrency.isEmpty {
                dataList = [searchModel.currentSalary.salaryCurrency]
            }
        }
        if dataList.count == 0{
            let currName = AppDelegate.instance.splashModel.currencies?.map({ $0.name }) ?? []
            dataList = currName
        }
        self.pushStaticMasterController(type: .CURRENCY, data: dataList)
    }
    
    @objc func lakhOptionSelected(_ indexPath : IndexPath) {
        let title = dataSource[indexPath.row]
        var dataList = [String]()
        
        if title == PersonalTitleConstant.salary  {
            if !searchModel.currentSalary.salaryInLakh.isEmpty {
                dataList = [searchModel.currentSalary.salaryInLakh]
            }
        }
        self.pushStaticMasterController(type: .SALARYINLAKH, data: dataList)
    }
   
    @objc func thousandOptionSelected(_ indexPath : IndexPath) {
        let title = dataSource[indexPath.row]
        var dataList = [String]()
        
        if title == PersonalTitleConstant.salary  {
            if !searchModel.currentSalary.salaryThousand.isEmpty {
                dataList = [searchModel.currentSalary.salaryThousand]
            }
        }
        self.pushStaticMasterController(type: .SALARYINTHOUSAND, data: dataList)
    }

    func pushStaticMasterController(type:StaticMasterData,data:[String]) {
        let staticMasterVC = MIStaticMasterDataViewController.newInstance
        staticMasterVC.title = "Selection"
        staticMasterVC.staticMasterType = type
        staticMasterVC.selectedDataArray = data
        staticMasterVC.delagate = self
        self.navigationController?.pushViewController(staticMasterVC, animated: true)
    }
    
    func callAPIForJobSeekerMapEvent(data:[String:Any]) {
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.ADVANCED_SEARCH, data: data, source: CONSTANT_SCREEN_NAME.SEARCH, destination: CONSTANT_SCREEN_NAME.ADVANCESEARCH) { (success, response, error, code) in
            
        }
    }
}

extension MIAdvanceSearchViewController: MIMasterDataSelectionViewControllerDelegate, MIStaticMasterDataSelectionDelegate, MIAdvanceSearchJobViewControllerDelegate {
    
    func skillSelected(skills: [String]) {
        searchModel.skill = skills
        self.tableView.reloadData()
    }

    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        
        if enumName == MasterDataType.INDUSTRY.rawValue {
            searchModel.industry = selectedCategoryInfo //?? MICategorySelectionInfo()
        }
        if enumName == MasterDataType.FUNCTION.rawValue {
            searchModel.function = selectedCategoryInfo //?? MICategorySelectionInfo()
        }
        if enumName == MasterDataType.LOCATION.rawValue {
            searchModel.location = selectedCategoryInfo
        }
        if enumName == MasterDataType.JOB_TYPE.rawValue {
            // personalModel.workPermitUSA = selectedCategoryInfo.first ?? MICategorySelectionInfo()
        }
        
        self.tableView.reloadData()
    }
    
    func staticMasterDataSelected(selectedData: [String], masterType: String) {
        if selectedData.count > 0 {
            let value = selectedData.first ?? ""
            if masterType == StaticMasterData.EXPEREINCEINYEAR.rawValue {
                searchModel.workExperience = value
            }
            if masterType == StaticMasterData.SALARYINLAKH.rawValue {
                searchModel.currentSalary.salaryInLakh = value
                searchModel.currentSalary.absoluteValue = 0
            }
            if masterType == StaticMasterData.SALARYINTHOUSAND.rawValue {
                searchModel.currentSalary.salaryThousand = value
                searchModel.currentSalary.absoluteValue = 0
            }
            if masterType == StaticMasterData.CURRENCY.rawValue {
                searchModel.currentSalary.salaryCurrency = value
                searchModel.currentSalary.absoluteValue = 0

            }
        }
        self.tableView.reloadData()
    }
}


extension MITextViewTableViewCell {
    
    func showDataForAdvanceSearch(title:String, advanceSearch:MIAdvanceSearchlDetail) {
        
        self.textView.isUserInteractionEnabled = false
        self.titleLabel.text = title
        self.textView.textContainer.maximumNumberOfLines = 0

        var infoData = title
        var value = ""
        
        switch title {
        case PersonalTitleConstant.jobKeyword:
            value = (advanceSearch.skill.map { $0 }).joined(separator: ",")
        case PersonalTitleConstant.location:
            value = (advanceSearch.location.map { $0.name }).joined(separator: ",")
            infoData = "You can add max 5 locations"
        case PersonalTitleConstant.year:
            if advanceSearch.workExperience.count > 0 {
                value = advanceSearch.workExperience + " year"
            }
        case PersonalTitleConstant.industry:
            value = (advanceSearch.industry.map { $0.name }).joined(separator: ",")
            infoData = "You can add max 2 industries"
        case PersonalTitleConstant.function:
            value = (advanceSearch.function.map { $0.name }).joined(separator: ",")
            infoData = "You can add max 2 function"
        default: break
        }
        
        self.textView.placeholder = infoData as NSString
        textView.text = value
    }

}

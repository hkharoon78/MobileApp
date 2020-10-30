//
//  MIBlockCompanyVIew.swift
//  MonsteriOS
//
//  Created by ishteyaque on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIBlockCompanyVIew: UIView {
    
    //MARK:Outlets and Variable
    @IBOutlet weak var tableViewBlockcompany: UITableView!
    
    private var blockCompanies = [[String: Any]]()
    var selectDataArray   = [MICategorySelectionInfo]()
    var viewController: UIViewController?
    var skillName = ""
    var error: (message: String, index: Int) = ("", -1)
    
    
    
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
   
    
    func configure(){
        CommonClass.googleAnalyticsScreen(self) //GA for screen
        
        self.tableViewBlockcompany.delegate = self
        self.tableViewBlockcompany.dataSource = self
        
        //Register TableView Cell
        self.tableViewBlockcompany.register(UINib(nibName:String(describing: MITextViewTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
        self.tableViewBlockcompany.register(UINib(nibName:String(describing: MIManageSubsNotificationDesTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MIManageSubsNotificationDesTableViewCell.self))
        
//        self.tableViewBlockcompany.register(UINib(nibName: "MIBlockCompaniesFieldCell", bundle: nil), forCellReuseIdentifier: "MIBlockCompaniesFieldCell")
        
        self.tableViewBlockcompany.register(UINib(nibName: "MIProfileSkillCell", bundle: nil), forCellReuseIdentifier: "MIProfileSkillCell")
        
       self.tableViewBlockcompany.register(UINib(nibName: "MIBlockCompaniesCell", bundle: nil), forCellReuseIdentifier: "MIBlockCompaniesCell")

        
        self.getBlockCompanyList()
        
        DispatchQueue.main.async {
            self.tableViewBlockcompany.reloadData()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        self.endEditing(true)
    }
    

    
}




//MARk:- table view delegate and data source
extension MIBlockCompanyVIew: UITableViewDelegate, UITableViewDataSource {
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        switch indexPath.row {
        case 0:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIManageSubsNotificationDesTableViewCell.self)) as? MIManageSubsNotificationDesTableViewCell else {
                return UITableViewCell()
            }
            
            cell.lblNotificationDes.textColor = AppTheme.textColor
            cell.lblNotificationDes.font = UIFont.customFont(type: .Regular, size: 14)
            cell.lblNotificationDes.text = BlockCompanyContant.title
            
            return cell

        case 1:

            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MITextViewTableViewCell.self)) as? MITextViewTableViewCell else {
                return UITableViewCell()
            }
            
            //set placeholder
//            let companyNameAttriburedString = NSMutableAttributedString(string:BlockCompanyContant.placeHolder)
//            let asterix = NSAttributedString(string: " *", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
//            companyNameAttriburedString.append(asterix)
            cell.textView.placeholder = "Enter Company Name" as NSString
            
            cell.textView.delegate = self
            cell.selectionStyle = .none
            cell.titleLabel.text = "Enter Company Name"
            
            cell.textView.text = self.selectDataArray.map({ $0.name }).joined(separator: ", ")
            //cell.textView.isUserInteractionEnabled = false
            
            if self.error.index ==  indexPath.row {
                cell.showError(with: ExtraResponse.blockCompany)
            } else {
                cell.showError(with: "")
            }
            
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIManageSubsNotificationDesTableViewCell.self)) as? MIManageSubsNotificationDesTableViewCell else {
                return UITableViewCell()
            }
            
            cell.lblNotificationDes.textColor = UIColor.black
            cell.lblNotificationDes.font = UIFont.customFont(type: .Semibold, size: 14)
         
            if self.blockCompanies.count == 0 {
                cell.lblNotificationDes.text = ""
                cell.topConstraint.constant = 0
            } else {
                cell.lblNotificationDes.text = BlockCompanyContant.blockCompaniesList
            }
            
            return cell
            
        case 3:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "MIProfileSkillCell") as! MIProfileSkillCell
            cell.delegate = self
            cell.selectionStyle = .none

            cell.addSuggestionListString(list: self.blockCompanies.map({ $0["text"] as? String ?? "" }))
            return cell
        
        default:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "MIBlockCompaniesCell") as! MIBlockCompaniesCell
            cell.selectionStyle = .none
            cell.blockButton.addTarget(self, action: #selector(blockButtonPressed(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    
    @objc func blockButtonPressed(_ sender: UIButton){
        self.blockCompaniesAPI()
    }
    

    
}
//MARK:- TextView delegate
extension MIBlockCompanyVIew: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
       print("textViewDidBeginEditing")
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {

        let vc = MIMasterDataSelectionViewController.newInstance
        vc.title = "Companies"
        vc.delegate = self
        vc.limitSelectionCount = 50
        vc.masterType = MasterDataType.COMPANY
      //  vc.masterType.exc
        vc.shouldShowAdd = false
        vc.excludedData = MICategorySelectionInfo.modelsFromDictionaryArray(array: self.blockCompanies)
        let selectedArr = self.selectDataArray.map({$0.name})
        if self.selectDataArray.count > 0 {
            vc.selectDataArray = self.selectDataArray
        }
//        var arr = [String]()
//        for a in self.blockCompanies {
//           arr.append(a["text"] as! String)
//        }
        vc.selectedInfoArray = selectedArr //+ arr
        
        //vc.selectDataArray = self.selectDataArray
        self.viewController?.navigationController?.pushViewController(vc, animated: true)

        return false
    }
}

//MARK:- API and validations
extension MIBlockCompanyVIew {
    
    func showErrorOnTableViewIndex(IndexPath: IndexPath, errorMsg: String){
        self.error = (errorMsg, IndexPath.row)
        self.tableViewBlockcompany.reloadData()
    }
    
    
    func blockCompaniesAPI() {
        self.endEditing(true)
        
        if self.selectDataArray.count == 0 {
          
            let index = IndexPath(row: 1, section: 0)
            guard let cell = tableViewBlockcompany.cellForRow(at: index) as? MITextViewTableViewCell else { return }
            
            cell.showError(with: ExtraResponse.blockCompany)
            return
            
        }
        
        var blockCompanyIDs = [[String:Any]]()
        for obj in self.selectDataArray {
            blockCompanyIDs.append(MIUserModel.getParamForIdText(id: obj.uuid, value: obj.name))
        }
        
        MIActivityLoader.showLoader()
        MIApiManager.hitBlockCompaniesAPI(blockCompanyIDs) { (success, response, error, code) in
            
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                
                if let responseData = response as? JSONDICT {
                    if let successMessage = responseData["successMessage"] as? String {
                        self.viewController?.toastView(messsage: successMessage,isErrorOccured:false)
                        
                        
                        self.selectDataArray = self.selectDataArray.filter({ (data) -> Bool in
                            return !self.blockCompanies.contains(where: { $0["text"] as? String == data.name })
                        })
                        

                        CommonClass.googleEventTrcking("settings_screen", action: "block_companies", label: "block") //GA
                        
                        let blockedItems = self.selectDataArray.map({ ["id": $0.uuid,"text":$0.name] })
                        self.blockCompanies.append(contentsOf: blockedItems)
                        
                        self.selectDataArray.removeAll()
                        self.tableViewBlockcompany.reloadData()
                        
                        
                        
                    } else if let errMessage = responseData["errorMessage"] as? String {
                        self.viewController?.toastView(messsage: errMessage)
                    }
                } else {
                    if (!MIReachability.isConnectedToNetwork()){
                        self.viewController?.toastView(messsage: ExtraResponse.noInternet)
                    }
                }
            }
        }
        
    }
    
    func getBlockCompanyList() {
        
        MIActivityLoader.showLoader()
        MIApiManager.hitGetBlockCompanyAPi { (succes, response, error, code) in
            
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()
                
                if
                    let responseData = response as? JSONDICT,
                    let companies = responseData["companies"] as? jsonArr
                {
                    self.blockCompanies = companies
                    self.tableViewBlockcompany.reloadData()
                } else {
                    if (!MIReachability.isConnectedToNetwork()){
                        self.viewController?.toastView(messsage: ExtraResponse.noInternet)
                    }
                }
            }
        }
    }
    
    func unblockCompany(_ id: String) {
        
        MIApiManager.hitUnblockCompanyAPI(id) { (succes, response, error, code) in
            
            DispatchQueue.main.async {
                if let responseData = response as? JSONDICT {
                    if let successMessage = responseData["successMessage"] as? String {
                        CommonClass.googleEventTrcking("settings_screen", action: "block_companies", label: "cross") //GA
                        
                        self.viewController?.toastView(messsage: successMessage,isErrorOccured:false)
                        
                        self.blockCompanies = self.blockCompanies.filter({ $0["text"] as? String != self.skillName })
                        self.tableViewBlockcompany.reloadData()
                        
                    } else if let errMessage = responseData["errorMessage"] as? String {
                        self.viewController?.toastView(messsage: errMessage)
                    }else{
                        if let err = error {
                            self.viewController?.handleAPIError(errorParams: response, error: err)
                        }
                    }
                }
            }
        }
        
    }
    
    
}

extension MIBlockCompanyVIew: MIMasterDataSelectionViewControllerDelegate, MIProfileSkillCellDelegate {
  
    func skillRemoved(skillName: String) {
        self.skillName = skillName
        
        guard let companyId = self.blockCompanies
            .filter({ $0["text"] as? String == skillName })
            .first?["id"] as? String else { return }
        
        self.unblockCompany(companyId)
        
//        self.blockCompanies = self.blockCompanies.filter({ $0["text"] as? String != skillName })
//        self.tableViewBlockcompany.reloadData()
    }
    
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {

        self.selectDataArray = selectedCategoryInfo

        self.tableViewBlockcompany.reloadData()        
    }
    
}

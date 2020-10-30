//
//  MIAddPreferredLocation.swift
//  MonsteriOS
//
//  Created by Anushka on 10/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIAddPreferredLocation: UIView {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnRemindMe: UIButton!

    var numberOfRows = 0
    var viewController: UIViewController?
    var selectDataArray   = [MICategorySelectionInfo]() 
    var error: (message: String, index: Int) = ("", -1)
    
    var card: Card? {
        didSet {
            self.manageModalOnView()
        }
    }
    
    var oldValue = JSONDICT()
    var newValue = JSONDICT()
    var viewLoadDate: Date!

    
    lazy var tableHeaderView: MIAddEducationHeaderView = {
        let headerViewdata=MIAddEducationHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 350))
        headerViewdata.lblName.text = "Add Preferred Location"
        headerViewdata.imgLocation.image = #imageLiteral(resourceName: "group-4")
        
        headerViewdata.bottomConstraintSwitch.constant = 0

        return headerViewdata
    }()
    
    lazy var tableFooterView: MIAddEducationFooterView = {
        let footerViewdata=MIAddEducationFooterView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80))
        footerViewdata.btnUpdate.addTarget(self, action: #selector(btnUpdatePressed(_:)), for: .touchUpInside)
        footerViewdata.btnUpdate.setTitle("CONTINUE", for: .normal)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       // self.updateLocationName()
    }
    
    
    func configure() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        self.viewLoadDate = Date()

        
        //Register TableView Cell
        tableView.register(UINib(nibName:String(describing: MITextViewTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
        
        tableView.tableHeaderView = tableHeaderView
        tableView.tableFooterView = tableFooterView
      
        tableHeaderView.switchAction = {[weak self] (isOn) in
            if isOn{
                self?.tableFooterView.btnUpdate.setTitle("UPDATE", for: .normal)
                self?.numberOfRows = 1
               self!.tableHeaderView.switchImg.image = #imageLiteral(resourceName: "group-3")
            } else{
                self?.tableFooterView.btnUpdate.setTitle("CONTINUE", for: .normal)
                self?.numberOfRows = 0
                self!.tableHeaderView.switchImg.image = #imageLiteral(resourceName: "group-6")
            }
            self?.tableView.reloadData()
        }
        
        
    }
    
    
    
    
    //MARK:- IBAction
    @objc func btnUpdatePressed(_ sender: UIButton){
        
        if self.numberOfRows == 1 {
            if self.ValidationTxtField(){
                self.callAddPreferredLocationAPI()
            }
        }else {
            self.callAddPreferredLocationAPI()
        }
        
    }
    
    
    @IBAction func btnRemindMeLeterPressed(_ sender: UIButton) {
        let catName = "profileUpdate_\(UserEngagementConstant.instance.sourceTraffic)_\( UserEngagementConstant.instance.sourcePage)"        
        
        self.callRemindMeLaterApi(self.card?.type ?? "Non-Intrusive", userActions: self.card?.text ?? "PREFERRED_LOCATION")
        
        self.callTrackingevtentsApi("LOCATION", updated: 0, remindMeLater: 1, oldValue: [:], newValue: [:])
    }
    
    func ValidationTxtField() -> Bool {
        
        guard let cellTxtField = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MITextViewTableViewCell else { return false }
        
        if cellTxtField.textView.text!.isEmpty {
            cellTxtField.showError(with: "Please enter at least one Location")
            return false
        }
        return true
        
    }
    
    func showErrorOnTableViewIndex(indexPath: IndexPath, errorMsg: String) {
        self.error = (errorMsg, indexPath.row)
        self.tableView.reloadData()
    }
    
    
    func manageModalOnView() {
        if let data = card?.data as? jsonArr, data.count > 0 {
           
            //add location in model
            for params in data {
                selectDataArray.append(MICategorySelectionInfo(dictionary: params)!)
            }
            
            if let nameText = data.map({$0["text"] as? String}) as? [String] {
                //let idText = data.map({$0["id"] as? String}) as? [String]
                
                let locName =  nameText.joined(separator: ", ")
                
                ////set old value
                self.oldValue = ["preLocation" : [locName]]
                
                
                //set location name
                let attributed = NSMutableAttributedString(string: "Would you like to change your preferred location from ", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: "505050"), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 13)])
                
                if  locName != "" {
                    attributed.append(NSAttributedString(string:  "\(locName + "?")", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "505050"), NSAttributedString.Key.font: UIFont.customFont(type: .Semibold, size: 13)]))
                    
//                    //add location in model
//                    if let data = card?.data as? jsonArr, data.count > 0 {
//                        for params in data {
//                            selectDataArray.append(MICategorySelectionInfo(dictionary: params)!)
//                        }
//                    }
                } else {
                    attributed.append(NSAttributedString(string: " anyWhere?", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: "505050"), NSAttributedString.Key.font: UIFont.customFont(type: .Semibold, size: 13)]))
                }
                self.tableHeaderView.lblLocation.attributedText = attributed
                
                
                guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MITextViewTableViewCell else { return }
                cell.textView.text = locName
                self.tableView.reloadData()
            }
        } else {
            //set location name
            let attributed = NSMutableAttributedString(string: "Would you like to change your preferred location from ", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: "505050"), NSAttributedString.Key.font: UIFont.customFont(type: .Regular, size: 13)])
            
            attributed.append(NSAttributedString(string: " anyWhere?", attributes: [NSAttributedString.Key.foregroundColor : UIColor(hex: "505050"), NSAttributedString.Key.font: UIFont.customFont(type: .Semibold, size: 13)]))
            
            self.tableHeaderView.lblLocation.attributedText = attributed
        }
    }


}

extension MIAddPreferredLocation: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MITextViewTableViewCell.self)) as? MITextViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.textView.delegate = self
        cell.textView.tag = indexPath.row
        cell.textView.placeholder = "Select Preferred Location"
        cell.textView.isUserInteractionEnabled = false
        cell.titleLabel.text = ""

        cell.textView.text =  self.selectDataArray.map({ $0.name }).joined(separator: ", ")
        
        if self.error.index == indexPath.row {
            cell.showError(with: self.error.message)
        } else {
            cell.showError(with: "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MIMasterDataSelectionViewController.newInstance
        vc.delegate = self
        vc.limitSelectionCount = 5
        vc.masterType = MasterDataType.LOCATION
        vc.shouldShowAdd = false
        
        vc.selectedInfoArray = self.selectDataArray.map({$0.name})
        vc.selectDataArray = self.selectDataArray
        
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}


extension MIAddPreferredLocation: UITextFieldDelegate, UITextViewDelegate, MIMasterDataSelectionViewControllerDelegate {
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        
        self.selectDataArray = selectedCategoryInfo
        
//        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! MITextViewTableViewCell
//        cell.textView.text = self.selectDataArray.map({ $0.name }).joined(separator: ", ")
        
        self.tableView.reloadData()

    }
    
}

//API CAll
extension MIAddPreferredLocation {
    
    func callAddPreferredLocationAPI() {
        self.endEditing(true)
        
   
        var params = [String:Any]()
        var dataParams = [[String:Any]]()

        
        //set param for continue
        if self.numberOfRows == 1 {
         
            if selectDataArray.count != 0  {
                for locationModel in selectDataArray {
                    dataParams.append(MIUserModel.getParamForIdText(id: locationModel.uuid, value:locationModel.name))
                }
            }

           params["preferredLocations"] = dataParams
        } else {
            dataParams = []
            params["preferredLocations"] = dataParams
////set data accroding card come or not
//            if let data = card?.data as? jsonArr, data.count > 0 {
//                for newParams in data {
//                    dataParams.append(newParams)
//                }
//                params["preferredLocations"] = dataParams
//            } else {
//                dataParams = []
//                params["preferredLocations"] = dataParams
//            }
        }
        
        //params["preferredLocations"] = dataParams
        
        let path = APIPath.preferredLocation
        let methodType: ServiceMethod = .put
        let added = self.viewController?.addTaskToDispatchGroup() ?? false
        self.viewController?.skipProfileEngagementPopup()
        
        let headerDict = [
            "x-rule-applied": card?.ruleApplied ?? "",
            "x-rule-version": card?.ruleVersion ?? ""
        ]
    
        MIApiManager.callAPIForJobPreference(path: path, method: methodType, params: params, headerDict: headerDict) { (success, response, error, code) in
            DispatchQueue.main.async {
                defer { self.viewController?.leaveDispatchGroup(added) }

                if error == nil && (code >= 200) && (code <= 299) {
                    if let data = self.card?.data as? jsonArr, data.count > 0 {
                        
                        
                        if let nameText = data.map({($0["text"] as? String)?.lowercased()}) as? [String] {
                            let newValue = self.selectDataArray.map({$0.name.lowercased()})
                            if !nameText.containsSameElements(as: newValue) {
                                JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.PREF_LOCATION]
                                
                            }
                        }
                    }else{
                        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.PREF_LOCATION]
                    }
                    //event tracking
                    if let tabbar = self.viewController?.tabbarController {
                        tabbar.handlePopFinalState(isErrorHappen: false)
                    }
                }else{
                    if let tabbar = self.viewController?.tabbarController {
                        tabbar.isErrorOccuredOnProfileEngagement = true
                    }
                }
                
                if self.numberOfRows == 1 {
                    let newData = self.selectDataArray.map({ $0.name }).joined(separator: ",")
                    self.newValue = ["preLocation": [newData]]
                    self.callTrackingevtentsApi("LOCATION", updated: 1, remindMeLater: 0, oldValue: self.oldValue, newValue: self.newValue)
                } else {
                    self.callTrackingevtentsApi("LOCATION", updated: 0, remindMeLater: 0, oldValue: [:], newValue: [:])
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
                }else{
                }
            }

        }
        
    }
    
    func callTrackingevtentsApi(_ attribute: String, updated: Int, remindMeLater: Int, oldValue: JSONDICT, newValue: JSONDICT) {
        
        MIApiManager.hitTrackingEventsApi(attribute, updated: updated, remindMeLater: remindMeLater, oldValue: oldValue, newValue: newValue, timeSpent: viewLoadDate.getSecondDifferenceBetweenDates(), cardRule: card) { (success, response, error, code) in
            
        }
    }
    
}



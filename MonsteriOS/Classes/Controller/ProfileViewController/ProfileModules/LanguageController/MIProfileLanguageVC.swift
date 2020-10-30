//
//  MIProfileLanguageVC.swift
//  MonsteriOS
//
//  Created by Piyush on 13/05/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

enum MILanguageEnumType:String {
    case language       = "Language"
    case proficiency    = "Proficiency"
    case expertise      = "Expertise"
    case save           = "Save"
}

class MILanguageModel:NSObject {
    var placeHolder  = ""
    var type         = MILanguageEnumType.language
    var value1       = ""
    var value2       = ""
    
    init(with type: MILanguageEnumType, placeholder: String = "", value1: String, value2: String)
    {
        self.placeHolder = placeholder.isEmpty ? type.rawValue : placeholder
        
        self.type = type
        self.value1 = value1
        self.value2 = value2
    }
}


class MIProfileLanguageVC: MIBaseViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    var error: (message: String, index: Int) = ("", -1)
    private var tableDataArray = [MILanguageModel]()
    var languageInfo   = MIProfileLanguageInfo(dictionary: [:])
    var isUpdating     = false
    var callBackAfterSuccess : ((MIProfileLanguageInfo)->Void)?
    @IBOutlet weak private var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Language Known"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    func setUI() {
        // Do any additional setup after loading the view.
      //  self.tblView.register(nib: MIFloatingTextFieldTableCell.loadNib(), withCellClass: MIFloatingTextFieldTableCell.self)
        self.tblView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))

        self.tblView.register(nib: MI3CheckBoxTableCell.loadNib(), withCellClass: MI3CheckBoxTableCell.self)
        self.tblView.register(nib: MICheckboxTableCell.loadNib(), withCellClass: MICheckboxTableCell.self)
        self.tblView.tableFooterView = UIView()
        self.tblView.separatorColor = .clear
        self.populateDataSource()
    }
    
    func populateDataSource() {
        self.tableDataArray.append(MILanguageModel.init(with: .language, value1: languageInfo?.language?.name ?? "", value2: ""))
        self.tableDataArray.append(MILanguageModel.init(with: .proficiency, value1: languageInfo?.proficiency?.name ?? "", value2: ""))
        self.tableDataArray.append(MILanguageModel.init(with: .expertise, value1: "", value2: ""))
        self.tableDataArray.append(MILanguageModel.init(with: .save, value1: "", value2: ""))
        self.tblView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.tableDataArray[indexPath.row].type {
        case .language, .proficiency:
            let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            cell.secondryTextField.isHidden = true
            
            let msg = (self.error.index == indexPath.row) ? self.error.message : ""
            cell.showError(with: msg)

            cell.primaryTextField.delegate = self
            cell.primaryTextField.keyboardType = .numberPad
            cell.primaryTextField.placeholder = self.tableDataArray[indexPath.row].placeHolder
            cell.primaryTextField.text = self.tableDataArray[indexPath.row].value1
            cell.titleLabel.text = self.tableDataArray[indexPath.row].placeHolder
            cell.primaryTextField.isEnabled = true
            cell.primaryTextField.alpha = 1.0
            cell.primaryTextField.setRightViewForTextField("darkRightArrow")
//            if self.tableDataArray[indexPath.row].type == .language {
//                if !self.tableDataArray[indexPath.row].value1.isEmpty {
//                    cell.primaryTextField.isEnabled = false
//                    cell.primaryTextField.alpha = 0.5
//                    cell.primaryTextField.setRightViewForTextField("")
//                }
//            }
            return cell
        case .expertise:
            let cell = tableView.dequeueReusableCell(withClass: MI3CheckBoxTableCell.self, for: indexPath)
            cell.languageInfo  = self.languageInfo
            cell.delegate      = self
            cell.show()
            return cell
        case .save:
            let cell = tableView.dequeueReusableCell(withClass: MICheckboxTableCell.self, for: indexPath)
            cell.checkboxButtn.isHidden = true
            cell.delegate = self
            return cell
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let indexPath = textField.tableViewIndexPath(self.tblView) else { return true }
        error = ("",-1)

        switch self.tableDataArray[indexPath.row].type {
        case .language:
            
            let vc = MIMasterDataSelectionViewController.newInstance
            vc.title = "Language"
            vc.delegate = self
            vc.limitSelectionCount = 1
            vc.masterType = MasterDataType.LANGUAGE
            vc.selectedInfoArray = [self.tableDataArray[indexPath.row].value1]
            self.navigationController?.pushViewController(vc, animated: true)
            
            return false
        case .proficiency:
            let vc = MIMasterDataSelectionViewController.newInstance
            vc.title = "Language Proficiency"
            vc.delegate = self
            vc.limitSelectionCount = 1
            vc.masterType = MasterDataType.LANGUAGE_PROFICIENCY
            vc.selectedInfoArray = [self.tableDataArray[indexPath.row].value1]
            self.navigationController?.pushViewController(vc, animated: true)
            return false
        case .expertise:
            return false
        case .save:
            return false

        }
    }
    
    func saveClicked() {
        if self.languageInfo?.language?.name.isEmpty ?? true {
            error = ("Please Select Language",0)
            self.tblView.reloadData()
//            self.showAlert(title: "", message: "Please Select Language")
            return
        }else if self.languageInfo?.proficiency?.name.isEmpty ?? true {
            error = ("Please Select Proficiency",1)
            self.tblView.reloadData()
            return
        }
        
        let languageId =  ["id":self.languageInfo?.language?.uuid]
        let proficiencyId =  ["id":self.languageInfo?.proficiency?.uuid]
        var read = 0
        var write = 0
        var speak = 0
        if self.languageInfo?.read ?? false {
            read = 1
        }
        if self.languageInfo?.write ?? false {
            write = 1
        }
        if self.languageInfo?.speak ?? false {
            speak = 1
        }
        
        var languageDic = ["language":languageId,"read": read,"write":write,"speak":speak,"proficiency":proficiencyId] as [String : Any]
        self.startActivityIndicator()
        var requestType = ServiceMethod.post
        if isUpdating {
            requestType = .put
            languageDic["id"] = languageInfo?.languageId ?? ""
        }
       

        MIApiManager.callCreateProfileLanguage(requestType: requestType, params: [languageDic]) { (issuccess, response, error, code) in
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                if error == nil && (code >= 200) && (code <= 299) {
                        shouldRunProfileApi = true
                        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.LANG_KNOWN]
                        if let callBack = self.callBackAfterSuccess {
                            callBack(self.languageInfo ?? MIProfileLanguageInfo(dictionary: [:])!)
                        }
                        self.navigationController?.popViewController(animated: true)
                    
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
                
            }
        }
        
    }
    
}

extension MIProfileLanguageVC:MIMasterDataSelectionViewControllerDelegate,MILanguageCheckBoxClickedDelegate,SaveActionDelegate {
    
    
    func saveUserProfile() {
        // save  clicked
        self.saveClicked()
    }
    
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        error = ("",-1)

        if MasterDataType.LANGUAGE == MasterDataType(rawValue: enumName) {

            self.tableDataArray[0].value1 = selectedListInfo.first ?? ""
            
            languageInfo?.language        = selectedCategoryInfo.first
        }
        if MasterDataType.LANGUAGE_PROFICIENCY == MasterDataType(rawValue: enumName) {
            self.tableDataArray[1].value1 = selectedListInfo.first ?? ""
            languageInfo?.proficiency     = selectedCategoryInfo.first
        }
        
        self.tblView.reloadData()
    }
    
    func checkBoxClicked(info: MIProfileLanguageInfo?) {
        if let model = info {
            self.languageInfo = model
        }
    }

}

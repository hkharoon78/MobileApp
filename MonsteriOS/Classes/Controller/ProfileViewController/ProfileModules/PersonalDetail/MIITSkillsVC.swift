
//
//  MIITSkillsVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 24/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

enum ITSkillEnumType:String {
    case skill      = "Skill"
    case version    = "Version"
    case lastUsed   = "Last Used"
    case experience = "Experience"
    
    case doneButton = ""
}

class ITSkillModel:NSObject {
    var placeHolder  = ""
    var type         = ITSkillEnumType.skill
    var value1      = ""
    var value2      = ""
    
    init(with type: ITSkillEnumType, placeholder: String = "", value1: String, value2: String)
    {
        self.placeHolder = placeholder.isEmpty ? type.rawValue : placeholder
        
        self.type = type
        self.value1 = value1
        self.value2 = value2
    }
}


class MIITSkillsVC: UIViewController {
    
    let tableView   = UITableView()
    var itSkillInfo = MIProfileITSkills(dictionary: [:])
    var addITSkillSuccess : ((Bool)->Void)?
    var callBackAfterSuccess : ((MIProfileITSkills)->Void)?
    var error: (message: String, index: Int) = ("", -1)

    private var tableDataArray = [ITSkillModel]()
    private var selectedITSkills = [MICategorySelectionInfo]()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.populateDataSource()
        
        self.title = "IT Skills"
        
        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self) , bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))

  //      self.tableView.register(nib: MIFloatingTextFieldTableCell.loadNib(), withCellClass: MIFloatingTextFieldTableCell.self)
        self.tableView.register(nib: MICheckboxTableCell.loadNib(), withCellClass: MICheckboxTableCell.self)
        //self.tableView.register(nib: MIProjectDateTableCell.loadNib(), withCellClass: MIProjectDateTableCell.self)
        if let itskill = self.itSkillInfo ,let skill = itskill.skill , skill.name.count > 0 {
            self.selectedITSkills = [skill]
        }
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.tableFooterView?.backgroundColor=UIColor.colorWith(r: 244, g: 246, b: 248, a: 1)
        
//        if itSkillInfo?.id != "" {
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteSkill))
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    func populateDataSource() {
        let buttonText = self.itSkillInfo?.id == "" ? "Save" : "Update"
        
        self.tableDataArray.append(ITSkillModel.init(with: .skill, value1: self.itSkillInfo?.skill?.name ?? "", value2: ""))
        self.tableDataArray.append(ITSkillModel.init(with: .version, value1: self.itSkillInfo?.version ?? "", value2: ""))
        var lastused = ""
        if let date = self.itSkillInfo?.lastUsed.dateWith(PersonalTitleConstant.dateFormatePattern)?.getStringWithFormat(format: "yyyy") {
            lastused = date
        }
        self.tableDataArray.append(ITSkillModel.init(with: .lastUsed, value1: lastused , value2: ""))
        self.tableDataArray.append(ITSkillModel.init(with: .experience, value1: self.itSkillInfo?.expYear  ?? "", value2: self.itSkillInfo?.expMonth ?? ""))
        self.tableDataArray.append(ITSkillModel.init(with: .doneButton, placeholder: buttonText, value1: "", value2: ""))
    }
    
    @objc func updateITSkills() {
        self.view.endEditing(true)
        self.error = ("", -1)
        if self.selectedITSkills.count == 0 || self.selectedITSkills.first?.name.count == 0{
            self.error = ("Please select a skill", 0)
            self.tableView.reloadData()
           // self.toastView(messsage: "Please select a skill")
            return
        }
        // if self.tableDataArray[1].value1.isEmpty {
        //   self.toastView(messsage: "Please enter version")
        //   return
        // }
//        if self.tableDataArray[2].value1.isEmpty {
//            self.toastView(messsage: "Please select last used")
//            return
//        }
//        if self.tableDataArray[3].value1.isEmpty {
//            self.toastView(messsage: "Please select experience in month")
//            return
//        }
//        if self.tableDataArray[3].value2.isEmpty {
//            self.toastView(messsage: "Please select experience in year")
//            return
//        }
        //getParamForIdTextForUUIDNil
        if let skill = self.selectedITSkills.first , skill.name.count > 0{
            self.itSkillInfo?.skill?.name = skill.name
            self.itSkillInfo?.skill?.uuid   = skill.uuid
        }

        let masterParam = MIUserModel.getParamForIdTextForUUIDNil(id: self.itSkillInfo?.skill?.uuid ?? "", value: self.itSkillInfo?.skill?.name.withoutWhiteSpace() ?? "")
        
        var param = [
            "skill": masterParam
            ] as [String : Any]

        if let id = self.itSkillInfo?.id, !id.isEmpty {
            param["id"] = id
        }
        
        if !self.tableDataArray[1].value1.isEmpty {
            param["version"] = self.tableDataArray[1].value1.withoutWhiteSpace()
            self.itSkillInfo?.version = self.tableDataArray[1].value1.withoutWhiteSpace()
        }

        if !self.tableDataArray[2].value1.isEmpty {
            param["lastUsed"] = self.tableDataArray[2].value1 + "-" + "01" + "-" + "01" //"yyyy-MM-dd"
            self.itSkillInfo?.lastUsed = self.tableDataArray[2].value1

        }
        
        if !self.tableDataArray[3].value1.isEmpty && !self.tableDataArray[3].value2.isEmpty {
            param["experience"] = [
                "years" : self.tableDataArray[3].value1,
                "months": self.tableDataArray[3].value2
            ]
            self.itSkillInfo?.expYear = self.tableDataArray[3].value1
            self.itSkillInfo?.expMonth = self.tableDataArray[3].value2

        }else if !self.tableDataArray[3].value2.isEmpty {
            param["experience"] = [
                "months": self.tableDataArray[3].value2
            ]
            self.itSkillInfo?.expMonth = self.tableDataArray[3].value2

        }else if !self.tableDataArray[3].value1.isEmpty {
            param["experience"] = [
                "years" : self.tableDataArray[3].value1
            ]
            self.itSkillInfo?.expYear = self.tableDataArray[3].value1

        }
      

        MIActivityLoader.showLoader()
        let method: ServiceMethod = (self.itSkillInfo?.id == "") ? .post : .put
        
        MIApiManager.updateSkill(method, param: param) { (success, response, error, code) in
            DispatchQueue.main.async {
                MIActivityLoader.hideLoader()

                if code >= 200 && code <= 299 {
                    self.fieldTrackingIfFucntionIsIT()
                    if let itSkillSuccess = self.addITSkillSuccess {
                        itSkillSuccess(true)
                    }
                    shouldRunProfileApi = true
                    if let callBack = self.callBackAfterSuccess {
                        callBack(self.itSkillInfo ?? MIProfileITSkills(dictionary: [:])!)
                    }

                    //self.showAlert(title: "", message: (self.itSkillInfo?.id == "") ? "IT skill added successfully." : "IT skill updated successfully.", isErrorOccured: false)
                    
                    self.showAlert(title: "", message: (self.itSkillInfo?.id == "") ? "IT skill added successfully." : "IT skill updated successfully.", isErrorOccured: false) {
                        self.navigationController?.popViewController(animated: true)

                    }
                    
//                    self.showPopUpView(title: "Success", message: (self.itSkillInfo?.id == "") ? "IT skill added successfully." : "IT skill updated successfully.", primaryBtnTitle: "OK") { (_) in
//                        self.navigationController?.popViewController(animated: true)
//
//                    }
//                    AKAlertController.alert("Success", message: (self.itSkillInfo?.id == "") ? "IT skill added successfully." : "IT skill updated successfully.", acceptMessage: "OK") {
//                        self.navigationController?.popViewController(animated: true)
//                    }
                }else{
                    self.handleAPIError(errorParams: response, error: error)
                }
            }
            
            
        }
        

        
    }
    func fieldTrackingIfFucntionIsIT(){
        if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
            if tabBar.jobPreferenceInfo.preferredFunctions.filter({ $0.name.withoutWhiteSpace().hasPrefix("IT")}).count > 0 {
                JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.IT_SKILLS]

            }
//            if tabBar.jobPreferenceInfo.preferredFunctions.filter { $0.name } {
//
//            }
                    
        }
        
        
    }
    @objc func deleteSkill() {
        
        guard let id = self.itSkillInfo?.id else { return }
        let param = [ "ids" : [id] ]
        
        MIApiManager.deleteSkill(param) { (result, error) in
            guard let data = result else { return }
            self.fieldTrackingIfFucntionIsIT()

          //  self.showAlert(title: "", message: data.successMessage,isErrorOccured:false)
            shouldRunProfileApi = true

            self.showAlert(title: "", message: data.successMessage, isErrorOccured: false) {
                self.navigationController?.popViewController(animated: true)

            }
        }
    }
}

extension MIITSkillsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
        cell.secondryTextField.isHidden = true
        cell.showError(with: "")
        cell.showErrorOnSecondryTF(with:"")

        switch self.tableDataArray[indexPath.row].type {
        case .skill, .version, .lastUsed:
            if self.tableDataArray[indexPath.row].type == .skill {
                cell.showError(with: self.error.message)
            }
          
         //   let cell = tableView.dequeueReusableCell(withClass: MIFloatingTextFieldTableCell.self, for: indexPath)
            cell.primaryTextField.delegate = self
            cell.primaryTextField.keyboardType = .asciiCapable
            cell.primaryTextField.placeholder = self.tableDataArray[indexPath.row].placeHolder
            cell.primaryTextField.text = self.tableDataArray[indexPath.row].value1
            cell.titleLabel.text = self.tableDataArray[indexPath.row].placeHolder
            cell.primaryTextField.setRightViewForTextField("darkRightArrow")
            if self.tableDataArray[indexPath.row].type == .version {
                cell.primaryTextField.setRightViewForTextField()
            }
            return cell
            
        case .experience:
            cell.secondryTextField.placeholder = "Select Year"
            cell.primaryTextField.placeholder = "Select Month"
            cell.secondryTextField.isHidden = false
            cell.makeEqualTextFields()
            cell.secondryTextField.delegate = self
            cell.primaryTextField.delegate  = self
            cell.titleLabel.text = self.tableDataArray[indexPath.row].placeHolder
            cell.primaryTextField.text = (self.tableDataArray[indexPath.row].value2.count > 0) ?  self.tableDataArray[indexPath.row].value2 + " Month" : self.tableDataArray[indexPath.row].value2
            cell.secondryTextField.text = (self.tableDataArray[indexPath.row].value1.count > 0) ?  self.tableDataArray[indexPath.row].value1 + " Year" : self.tableDataArray[indexPath.row].value1
            return cell
            
        case .doneButton:
            let cell = tableView.dequeueReusableCell(withClass: MICheckboxTableCell.self, for: indexPath)
            cell.saveButton.setTitle(self.tableDataArray[indexPath.row].placeHolder, for: .normal)
            cell.saveButton.addTarget(self, action: #selector(updateITSkills), for: .touchUpInside)
            cell.checkboxButtn.isHidden = true
            return cell
        }
    }
    
}

extension MIITSkillsVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let indexPath = textField.tableViewIndexPath(tableView) else { return true }

        switch self.tableDataArray[indexPath.row].type {
        case .skill:
            
            let vc = MIMasterDataSelectionViewController.newInstance
            vc.title = "IT Skills"
            vc.delegate = self
            vc.limitSelectionCount = 1
            vc.masterType = MasterDataType.ITSkill
            vc.selectedInfoArray = [self.tableDataArray[indexPath.row].value1]
            self.navigationController?.pushViewController(vc, animated: true)
            
            return false
            
        case .lastUsed:
            self.view.endEditing(true)
            let staticMasterVC = MIStaticMasterDataViewController.newInstance
            staticMasterVC.title = "Selection"
            if self.tableDataArray[indexPath.row].value1.count > 0 {
                staticMasterVC.selectedDataArray = [self.tableDataArray[indexPath.row].value1]
            }
            //staticMasterVC.delagate = self
            staticMasterVC.staticMasterType = .LAST_USED
            
            staticMasterVC.selectedData = { value in
               self.tableDataArray[indexPath.row].value1 = value
                self.tableView.reloadData()
                
            }
            
            self.navigationController?.pushViewController(staticMasterVC, animated: true)
//            MIDatePicker.selectDate(title: "",
//                                    datePickerMode: .date,
//                                    selectedDate: textField.text?.dateWith("yyyy-MM-dd"),
//                                    minDate: nil,
//                                    maxDate: Date()) { (date) in
//
//                                        textField.text = date.getStringWithFormat(format: "yyyy-MM-dd")
//                                        self.tableDataArray[indexPath.row].value1 = textField.text!
//            }
            return false
  

        case .experience:
            guard let cell = textField.tableViewCell() as? MITextFieldTableViewCell else { return true }
            let staticMasterVC = MIStaticMasterDataViewController.newInstance
            staticMasterVC.title = "Selection"
            staticMasterVC.selectedDataArray = [textField.text!]
            //staticMasterVC.delagate = self
            
            if cell.primaryTextField == textField {
                staticMasterVC.staticMasterType = .EXPEREINCEINMONTH
            } else {
                staticMasterVC.staticMasterType = .EXPEREINCEINYEAR
            }
            
            staticMasterVC.selectedData = { value in
                if cell.primaryTextField == textField {
                   // textField.text = value
                    self.tableDataArray[indexPath.row].value2 = value
                    
                } else {
                    //textField.text = value
                    self.tableDataArray[indexPath.row].value1 = value
                }
                self.tableView.reloadData()

                
            }
            
            self.navigationController?.pushViewController(staticMasterVC, animated: true)
            return false
            
        default:
           // textField.keyboardType = .decimalPad
            break
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let indexPath = textField.tableViewIndexPath(tableView) else { return }
        
        switch self.tableDataArray[indexPath.row].type {
        case .version:
            self.tableDataArray[indexPath.row].value1 = textField.text ?? ""
            
        default:
            break
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        let searchTxt = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if searchTxt.count == 11 {
            return false
        }
        return true
    }
    
}


extension MIITSkillsVC: MIMasterDataSelectionViewControllerDelegate {
    
    func masterDataSelected(selectedCategoryInfo: [MICategorySelectionInfo], selectedListInfo: [String], enumName: String) {
        self.selectedITSkills = selectedCategoryInfo
        self.tableDataArray[0].value1 = selectedListInfo.first ?? ""
        
//        self.itSkillInfo?.skill?.name = selectedCategoryInfo.first?.name ?? ""
//        self.itSkillInfo?.skill?.uuid   = selectedCategoryInfo.first?.uuid ?? ""
        self.error = ("", -1)

        self.tableView.reloadData()
    }
    
}

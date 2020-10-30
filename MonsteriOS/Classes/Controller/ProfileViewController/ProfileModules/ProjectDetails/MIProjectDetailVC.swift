//
//  MIProjectDetailVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 19/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

enum ProjectDetailEum: String {
    case title          = "Project Title"
    case client         = "Client"
    case projectStatus  = "Project Status"
    case startDate      = "Start Date"
    case endDate        = "End Date"
    case projectDetail  = "Detail of Project"
    case projectLoc     = "Project Location"
    case uploadImage    = "Upload Image"
    case link           = "Link URL"
}

struct ProjectCellModel {
    var type: ProjectDetailEum
    var placeholder: String
    
    init(_ type: ProjectDetailEum, placeholder: String = "") {
        self.type = type
        self.placeholder = placeholder
    }
    
}

class MIProjectDetailVC: MIBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: AKLoadingButton!
    
    var projectInfo = MIProfileProjectInfo(dictionary: [:])

    private var projectDetailArr = [ProjectCellModel]()
    var projectAddedSuccess : ((Bool) -> Void)?

    static var instance: MIProjectDetailVC {
        return MIProjectDetailVC(nibName: "MIProjectDetailVC", bundle: Bundle.main)
    }
   
    var error: (message: String, index: Int, isPrimaryError: Bool) = ("", -1, false)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(nib: MITextFieldTableViewCell.loadNib(), withCellClass: MITextFieldTableViewCell.self)
        self.tableView.register(nib: MITextViewTableViewCell.loadNib(), withCellClass: MITextViewTableViewCell.self)
        
        self.tableView.register(nib: MIProjectTitleTableCell.loadNib(), withCellClass: MIProjectTitleTableCell.self)
        self.tableView.register(nib: MIProjectRadioButtonTableCell.loadNib(), withCellClass: MIProjectRadioButtonTableCell.self)
        self.tableView.register(nib: MIProjectDateTableCell.loadNib(), withCellClass: MIProjectDateTableCell.self)
        self.tableView.register(nib: MIProjectDetailTableCell.loadNib(), withCellClass: MIProjectDetailTableCell.self)
        self.tableView.register(nib: MIProjectImagesTableCell.loadNib(), withCellClass: MIProjectImagesTableCell.self)
        
        self.tableView.dataSource = self
        self.tableView.delegate   = self
        
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        
        //self.title = "Projects"
        
        let buttonTitle = (projectInfo?.id ?? "").isEmpty ? "Save" : "Update"
        self.saveButton.setTitle(buttonTitle, for: .normal)
        self.saveButton.showPrimaryBtn()
        self.populateDataSource()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        if projectInfo?.id != "" {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteNaviBtnPressed))
        }
        

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Projects"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }
    
    // MARK: Keyboard Notifications
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
    }
    
    func populateDataSource() {
        self.projectDetailArr.append(ProjectCellModel.init(.title, placeholder: "Enter Title"))
        self.projectDetailArr.append( ProjectCellModel.init(.client, placeholder: "Enter Client"))
        //self.projectDetailArr.append( ProjectCellModel.init(.projectStatus))
        self.projectDetailArr.append( ProjectCellModel.init(.startDate))
        self.projectDetailArr.append( ProjectCellModel.init(.endDate))
        self.projectDetailArr.append( ProjectCellModel.init(.projectDetail))
        self.projectDetailArr.append( ProjectCellModel.init(.projectLoc, placeholder: "Enter Location"))
        self.projectDetailArr.append( ProjectCellModel.init(.link, placeholder: "Enter URL"))

    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        if validation() {
            self.updateProject()
        }
 
    }
    
    @objc func deleteNaviBtnPressed() {
        self.deleteProject()
    }
    
}

extension MIProjectDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.projectDetailArr.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        switch self.projectDetailArr[indexPath.row].type {
        case .uploadImage:
            let numberOfLines: CGFloat = CGFloat(10.truncatingRemainder(dividingBy: 3) + 10/3)
            return (numberOfLines) * (UIScreen.width/3)
        default:
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowItem = self.projectDetailArr[indexPath.row]
        
        switch rowItem.type {
        case .title, .client, .projectLoc, .link:
            
            let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)

            cell.primaryTextField.delegate = self
            cell.primaryTextField.placeholder = rowItem.placeholder
            cell.primaryTextField.tag = indexPath.row
            cell.primaryTextField.setRightViewForTextField()
            cell.titleLabel.text = rowItem.type.rawValue
            cell.secondryTextField.isHidden = true
            
            switch rowItem.type {
            case .title:
                cell.primaryTextField.text = self.projectInfo?.title
            case .client:
                cell.primaryTextField.text = self.projectInfo?.client
            case .projectLoc:
                cell.primaryTextField.text = self.projectInfo?.projLocation
            case .link:
                cell.primaryTextField.text = self.projectInfo?.url
            default:
                break
            }
            
            if self.error.index == indexPath.row {
                cell.showError(with: self.error.message, animated: false)
            } else {
                cell.showError(with: "", animated: false)
            }
            
            return cell

        case .projectStatus:
            let cell = tableView.dequeueReusableCell(withClass: MIProjectRadioButtonTableCell.self, for: indexPath)
            cell.titlelabel.text = rowItem.type.rawValue
            return cell

        case .startDate, .endDate:
            let cell = tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
           
            cell.primaryTextField.delegate = self
            cell.secondryTextField.delegate = self
            
            cell.secondryTextField.placeholder = "Month"
            cell.primaryTextField.placeholder = "Year"
            
            cell.primaryTextField.setRightViewForTextField("calendarBlue")
            cell.secondryTextField.setRightViewForTextField("calendarBlue")
            
            cell.secondryTextField.isHidden = false
            cell.primaryTextField.isHidden = false
            
            cell.titleLabel.text = rowItem.type.rawValue
            cell.makeEqualTextFields()
            
            let date = (rowItem.type == .startDate) ? self.projectInfo?.startDate : self.projectInfo?.endDate
            let newDate: Date?
            
            if date == "" {
                cell.secondryTextField.text =  ""
                cell.primaryTextField.text = ""
            } else {
                if date?.components(separatedBy: "-")[0].count == 0 {
                    newDate = date?.dateWith("-MM-dd")
                    cell.primaryTextField.text = "" //newDate?.getStringWithFormat(format: "yyyy")
                    cell.secondryTextField.text = newDate?.getStringWithFormat(format: "MM")
                } else if date?.components(separatedBy: "-")[1].count == 0 {
                    newDate = date?.dateWith("yyyy--dd")
                    cell.primaryTextField.text = newDate?.getStringWithFormat(format: "yyyy")
                     cell.secondryTextField.text = "" //newDate?.getStringWithFormat(format: "MM")
                } else {
                    newDate = date?.dateWith(PersonalTitleConstant.dateFormatePattern)
                    cell.secondryTextField.text =  newDate?.getStringWithFormat(format: "MM")
                    cell.primaryTextField.text = newDate?.getStringWithFormat(format: "yyyy")
                }
                // cell.secondryTextField.text =  newDate?.getStringWithFormat(format: "MM")
                // cell.primaryTextField.text = newDate?.getStringWithFormat(format: "yyyy")
            }

            if self.error.index == indexPath.row {
                if error.isPrimaryError {
                    cell.showError(with: self.error.message, animated: false)
                }else{
                    cell.showErrorOnSecondryTF(with: self.error.message, animated: false)
                }
            } else {
                cell.showError(with: "", animated: false)
                cell.showErrorOnSecondryTF(with:"", animated: false)
            }
            
            return cell
            
        case .projectDetail:
            let cell = tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
            
            cell.textView.isScrollEnabled = true
            cell.tvContainerViewHtConstraint.constant = 80
            cell.maxCharaterCount = 4000
            
            cell.accessoryImageView.isHidden = true
            cell.textView.delegate = self
            cell.titleLabel.text = rowItem.type.rawValue
            cell.textView.placeholder = "Description"
            cell.textView.text =  self.projectInfo?.projDesctipion
            cell.selectionStyle = .none
            cell.showCounterLabel = true
            
            if self.error.index == indexPath.row {
                cell.showError(with: self.error.message, animated: false)
            } else {
                cell.showError(with: "", animated: false)
            }

            return cell
       
        case .uploadImage:
            let cell = tableView.dequeueReusableCell(withClass: MIProjectImagesTableCell.self, for: indexPath)
            cell.titleLabel.text = rowItem.type.rawValue
            return cell
            
        }
    }
    
}

extension MIProjectDetailVC: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let cell = textView.tableViewCell() as? MITextViewTableViewCell else { return false }
        guard cell.textView == textView else { return false }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        self.projectInfo?.projDesctipion = newText
        
        let numberOfChracter = newText.count
        return numberOfChracter <= 4000
        
    }
    
//    func textViewDidChange(_ textView: UITextView) {
//        guard let cell = textView.tableViewCell()  else { return }
//        textView.isScrollEnabled = false
//
//        let newHeight = cell.frame.size.height + textView.contentSize.height
//        if textView.contentSize.height < 80 {
//            cell.frame.size.height = newHeight
//            updateTableViewContentOffsetForTextView()
//        } else {
//            textView.isScrollEnabled = true
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//            textView.isScrollEnabled = true
//        }
//
//        textView.layoutIfNeeded()
//        if textView.frame.size.height >= 80 {
//            return
//        }
//
//    }
//
//    // Animate cell, the cell frame will follow textView content
//    func updateTableViewContentOffsetForTextView() {
//        let currentOffset = tableView.contentOffset
//        UIView.setAnimationsEnabled(false)
//        tableView.beginUpdates()
//        tableView.endUpdates()
//        UIView.setAnimationsEnabled(true)
//        tableView.setContentOffset(currentOffset, animated: false)
//    }

}

extension MIProjectDetailVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard let indexPath = textField.tableViewIndexPath(tableView) else { return true }
        let rowItem = self.projectDetailArr[indexPath.row]

        switch rowItem.type {
        case .startDate:
            guard let cell = textField.tableViewCell() as? MITextFieldTableViewCell else { return true }
            
           // guard let cell = textField.tableViewCell() as? MIProjectDateTableCell else { return true }
            let staticMasterVC = MIStaticMasterDataViewController.newInstance
            staticMasterVC.title = "Start Date"
            staticMasterVC.selectedDataArray = [textField.text!]
            
            if cell.secondryTextField == textField {
                staticMasterVC.staticMasterType = .TILL_MONTH
            } else {
                staticMasterVC.staticMasterType = .TILL_YEAR
            }
            
            staticMasterVC.selectedData = { value in
                if cell.secondryTextField == textField {
                    cell.secondryTextField.text = value
                    
                    var data = "0"
                    if value.count == 1 {
                        data.append(value)
                    } else {
                        data = value
                    }
                    
                    self.projectInfo?.startDate = cell.primaryTextField.text! + "-" + data + "-01"
                } else {
                    cell.primaryTextField.text = value
                    self.projectInfo?.startDate = cell.primaryTextField.text! + "-" + cell.secondryTextField.text! + "-01"
                }
                
                //self.projectInfo?.startDate = cell.primaryTextField.text! + "-" + cell.secondryTextField.text! + "-01"
                self.error = ("", -1, false)
                self.tableView.reloadData()
            }
            
            self.navigationController?.pushViewController(staticMasterVC, animated: true)
            return false
            
        case .endDate:
            guard let cell = textField.tableViewCell() as? MITextFieldTableViewCell else { return true }
            
            //guard let cell = textField.tableViewCell() as? MIProjectDateTableCell else { return true }
            let staticMasterVC = MIStaticMasterDataViewController.newInstance
            staticMasterVC.title = "End Date"
            staticMasterVC.selectedDataArray = [textField.text!]
            
            if cell.secondryTextField == textField {
                staticMasterVC.staticMasterType = .TILL_MONTH
            } else {
                staticMasterVC.staticMasterType = .TILL_YEAR
            }

            staticMasterVC.selectedData = { value in
                
                if cell.secondryTextField == textField {
                    cell.secondryTextField.text = value
                    
                    var data = "0"
                    if value.count == 1 {
                        data.append(value)
                    } else {
                        data = value
                    }
                    
                    self.projectInfo?.endDate = cell.primaryTextField.text! + "-" + data + "-01"
                } else {
                    cell.primaryTextField.text = value
                    self.projectInfo?.endDate = cell.primaryTextField.text! + "-" + cell.secondryTextField.text! + "-01"
                }

                //self.projectInfo?.endDate = cell.primaryTextField.text! + "-" + cell.secondryTextField.text! + "-01"
                self.error = ("", -1, false)
                self.tableView.reloadData()
            }
            
            self.navigationController?.pushViewController(staticMasterVC, animated: true)
            return false

        case .projectLoc:
            let vc = MIMasterDataSelectionViewController()
            vc.masterType = .LOCATION
            vc.limitSelectionCount = 1
            self.navigationController?.pushViewController(vc, animated: true)
            
            vc.selectionHandler = { data in
                self.projectInfo?.projLocation = data.first?.name ?? ""
                self.projectInfo?.projLocationID = data.first?.uuid ?? ""
                textField.text = data.first?.name
                
                self.error = ("", -1, false)
                self.tableView.reloadData()
            }
            
            return false
            
        default:
            textField.addDoneButtonOnKeyboard()
            break
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        switch textField.returnKeyType {
        case .default:
            self.view.endEditing(true)
        case .next:
            self.view.viewWithTag(textField.tag+1)?.becomeFirstResponder()
        case .done:
            if validation() { self.updateProject() }
        default:
            break
        }
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
           
            guard let indexPath = textField.tableViewIndexPath(self.tableView) else { return }
            let rowItem = self.projectDetailArr[indexPath.row]
            
            switch rowItem.type {
            case .title:
                self.projectInfo?.title = textField.text ?? ""
            case .client:
                self.projectInfo?.client = textField.text ?? ""
            case .projectLoc:
                self.projectInfo?.projLocation = textField.text ?? ""
            case .link:
                self.projectInfo?.url = textField.text ?? ""
            default:
                break
            }
        }

        return true
    }
    
}


//Network Call
extension MIProjectDetailVC {
    
    func showErrorOnTableViewIndex(indexPath: IndexPath, errorMsg:String, isPrimary:Bool ) {
        self.error = (errorMsg, indexPath.row, isPrimary)
        if indexPath.row > -1 {
           
            self.tableView.reloadData()
          //self.tableView.reloadRows(at: [indexPath], with: .none)
            self.tableView.scrollToRow(at: IndexPath(row: indexPath.row, section: 0), at: .top, animated: false)
        }
       
    }
    
    func validation() -> Bool {
        self.error = ("", -1, false)
        
        let startDate = self.projectInfo?.startDate ?? ""
        let endDate   = self.projectInfo?.endDate ?? ""
        
        if self.projectInfo?.title.isEmpty ?? true {
            if let index = self.projectDetailArr.firstIndex(where: {$0.type == .title }) {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please enter project title", isPrimary: true)
                return false

            }
        }
       
        if self.projectInfo?.client.isEmpty ?? true {
            if let index = self.projectDetailArr.firstIndex(where: {$0.type == .client}) {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please enter client name", isPrimary: true)
                return false
            }
        }
        
        if startDate.isEmpty  {
            if let index = self.projectDetailArr.firstIndex(where: {$0.type == .startDate}) {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please enter start month", isPrimary: false)
                return false
            }
            
        } else {
            if startDate.components(separatedBy: "-")[1].count == 0  {
                if let index = self.projectDetailArr.firstIndex(where: {$0.type == .startDate}) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please enter start month", isPrimary: false)
                    return false
                }
            }
            if startDate.components(separatedBy: "-")[0].count == 0  {
                if let index = self.projectDetailArr.firstIndex(where: {$0.type == .startDate}) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please enter start year", isPrimary: true)
                    return false
                }
            }
  
        }
        
        if endDate.isEmpty {
            if let index = self.projectDetailArr.firstIndex(where: {$0.type == .endDate}) {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please enter end month", isPrimary: false)
                return false
            }
        } else {
            
            if endDate.components(separatedBy: "-")[1].count == 0  {
                if let index = self.projectDetailArr.firstIndex(where: {$0.type == .endDate}) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please enter end month", isPrimary: false)
                    return false
                }
            }
            
            if endDate.components(separatedBy: "-")[0].count == 0 {
                if let index = self.projectDetailArr.firstIndex(where: {$0.type == .endDate}) {
                    let indexPath = IndexPath(row: index, section: 0)
                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please enter end year", isPrimary: true)
                    return false
                }
            }
            
            if endDate.components(separatedBy: "-")[0] == startDate.components(separatedBy: "-")[0] {
                if endDate.components(separatedBy: "-")[1] < startDate.components(separatedBy: "-")[1] {
                    if let index = self.projectDetailArr.firstIndex(where: {$0.type == .endDate}) {
                        let indexPath = IndexPath(row: index, section: 0)
                        self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "End Date cannot be before Start Date", isPrimary: false)
                        return false
                    }
                }
            }
            
            if endDate.components(separatedBy: "-")[0] < startDate.components(separatedBy: "-")[0]{
             
                    if endDate.components(separatedBy: "-")[0] < startDate.components(separatedBy: "-")[0] {
                        if let index = self.projectDetailArr.firstIndex(where: {$0.type == .endDate}) {
                            let indexPath = IndexPath(row: index, section: 0)
                            self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "End Date cannot be before Start Date", isPrimary: true)
                            return false
                    }
                }
            }
        }
        
        if self.projectInfo?.projDesctipion.isEmpty ?? true {
            if let index = self.projectDetailArr.firstIndex(where: {$0.type == .projectDetail}) {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please enter details", isPrimary: true)
                return false
            }
        }
        
        if self.projectInfo?.projLocation.isEmpty ?? true {
            if let index = self.projectDetailArr.firstIndex(where: {$0.type == .projectLoc}) {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please enter project location", isPrimary: true)
                return false
            }
        }
        
        return true
        
    }
    
    func updateProject() {
    
        let startDate = self.projectInfo?.startDate ?? ""
        let endDate   = self.projectInfo?.endDate ?? ""

        let param =  [
            "id"            : self.projectInfo?.id ?? "",
            "profileType"   : "projects",
            "title"         : self.projectInfo?.title ?? "",
            "client"        : self.projectInfo?.client ?? "",
            "description"   : self.projectInfo?.projDesctipion ?? "",
            "startDate"     : startDate,
            "endDate"       : endDate,
            "location"      : ["id" : self.projectInfo?.projLocationID ?? ""],
            "url"           : self.projectInfo?.url ?? ""
            //"mediaUUID"   : ["5aebd5b6-36b4-4688-bd89-617d4126f988","69cf4625-9525-40f3-af84-757c3ad6ae4d"]
            ] as [String : Any]
 
 
        MIActivityLoader.showLoader()

        let method: ServiceMethod = (projectInfo?.id ?? "").isEmpty ? .post : .put
        MIApiManager.updateProject(method, param: param) { (result, error) in
          
            MIActivityLoader.hideLoader()
            
            guard let data = result else { return }
            shouldRunProfileApi = true
            JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.PROJECTS]
            if let projectSuccess = self.projectAddedSuccess {
                projectSuccess(true)
            }
            
            self.navigationController?.popViewController(animated: true)
            
//            self.showAlert(title: "", message: data.successMessage, isErrorOccured: false) {
//                self.navigationController?.popViewController(animated: true)
//            }
            
//            self.showPopUpView(title: "Success", message:data.successMessage, primaryBtnTitle: "OK") { (_) in
//                                   self.navigationController?.popViewController(animated: true)
//
//                               }
            
//            AKAlertController.alert("Success", message: data.successMessage, acceptMessage: "OK") {
//                self.navigationController?.popViewController(animated: true)
//            }
            
        }

    }
    
    func deleteProject() {
        let id = projectInfo?.id
        
        let param = [
            "id" : id!
        ] as [String : Any]
        
        MIApiManager.deleteProject(.delete, param: param) { (result, error) in
             guard let data = result else { return }
            // self.showAlert(title: nil, message: data.successMessage)
            shouldRunProfileApi = true

            self.showAlert(title: "", message: data.successMessage, isErrorOccured: false) {
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    
    
}

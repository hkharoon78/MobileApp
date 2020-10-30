//
//  MICoursesCertificatinVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 24/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MICoursesCertificatinVC: UIViewController {

    let tableView = UITableView()
    
    private var placeholderArray = [
        "Certification Name",
        "Issued By",
        "Validity",
        ]
    
    var textFieldDic = [
        "name"    : "",
        "issuer"  : "",
        "lastUsedMonth" : "",
        "lastUsedYear" : ""

    ]
    var data = MIProfileCoursesInfo(dictionary: [:])
    var courseAddedSuccess:((Bool)->Void)?
    var error: (message: String, index: Int, isPrimaryError: Bool) = ("", -1, false)
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CommonClass.googleAnalyticsScreen(self) //GA for screen

        
        self.title = "Courses & Certification"
        
        // Do any additional setup after loading the view.
        self.tableView.register(nib: MITextFieldTableViewCell.loadNib(), withCellClass: MITextFieldTableViewCell.self)
       // self.tableView.register(nib: MIFloatingTextFieldTableCell.loadNib(), withCellClass: MIFloatingTextFieldTableCell.self)
        self.tableView.register(nib: MICheckboxTableCell.loadNib(), withCellClass: MICheckboxTableCell.self)
        self.tableView.register(nib: MIProjectDateTableCell.loadNib(), withCellClass: MIProjectDateTableCell.self)

        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.tableFooterView?.backgroundColor=UIColor.colorWith(r: 244, g: 246, b: 248, a: 1)

        
        self.textFieldDic["name"] = self.data?.name
        self.textFieldDic["issuer"] = self.data?.issuer
        
        var month = ""
        var year  = ""
        if let date = self.data?.expiryDate.dateWith(PersonalTitleConstant.dateFormatePattern)?.getStringWithFormat(format: "MM yyyy"),date.count > 3 {
            let data = date.components(separatedBy: " ")
            if data.count > 1 {
                month = data.first ?? ""
                year  = data.last  ?? ""
            }
            
        }
        
        self.textFieldDic["lastUsedMonth"] = month
        self.textFieldDic["lastUsedYear"]  = year
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
}

extension MICoursesCertificatinVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeholderArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case self.placeholderArray.count:
            let cell = tableView.dequeueReusableCell(withClass: MICheckboxTableCell.self, for: indexPath)
           
            cell.checkboxButtn.isHidden = true
            cell.saveButton.addTarget(self, action: #selector(btnSavePressed(_:)), for: .touchUpInside)
            
            if self.data?.id == "" {
                cell.saveButton.setTitle("Save", for: .normal)
            } else {
                cell.saveButton.setTitle("Update", for: .normal)
            }
            
            return cell
            
        default:
            let cell =  tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            
            cell.primaryTextField.delegate = self
            cell.secondryTextField.delegate = self
            cell.primaryTextField.placeholder = self.placeholderArray[indexPath.row]
            cell.primaryTextField.tag = indexPath.row

            
            cell.titleLabel.text = self.placeholderArray[indexPath.row]
            
            if self.error.index == indexPath.row {
                if error.isPrimaryError {
                    cell.showError(with: self.error.message)
                }else{
                    cell.showErrorOnSecondryTF(with: self.error.message)
                }
            } else {
                cell.showError(with: "")
                cell.showErrorOnSecondryTF(with:"")
            }

            
            switch indexPath.row {
            case 0:
                cell.secondryTextField.isHidden = true
                cell.primaryTextField.setRightViewForTextField()
                cell.primaryTextField.text = self.textFieldDic["name"]
                cell.primaryTextField.returnKeyType = .next
            case 1:
                cell.secondryTextField.isHidden = true
                cell.primaryTextField.setRightViewForTextField()
                cell.primaryTextField.text = self.textFieldDic["issuer"]
                cell.primaryTextField.returnKeyType = .done

            default:
                cell.makeEqualTextFields()
                cell.secondryTextField.isHidden = false
                cell.secondryTextField.text = self.textFieldDic["lastUsedMonth"]
                cell.primaryTextField.text = self.textFieldDic["lastUsedYear"]
                cell.secondryTextField.placeholder = "Month"
                cell.primaryTextField.placeholder = "Year"
                
                
                cell.primaryTextField.setRightViewForTextField("calendarBlue")
                cell.secondryTextField.setRightViewForTextField("calendarBlue")

                cell.titleLabel.text = "Expiry Date"
            }
            
            return cell
            
        }
    }
    
    @objc func btnSavePressed(_ sender: UIButton){
        self.view.endEditing(true)
        if validation() {
            self.coursesCertification()
        }
    }
    
}

//MARK:- uitextfield delegate
extension MICoursesCertificatinVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let index = textField.tableViewIndexPath(self.tableView) {
        
        switch index.row {
            case self.placeholderArray.count:
                break
            default:
                switch index.row {
                case 2:
                    guard let cell = textField.tableViewCell() as? MITextFieldTableViewCell else { return true }
                   
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
                            self.textFieldDic["lastUsedMonth"] = textField.text
                            self.error = ("", -1, false)
                        } else {
                            cell.primaryTextField.text = value
                            self.textFieldDic["lastUsedYear"] = textField.text
                            self.error = ("", -1, false)
                        }
                        
                        //self.projectInfo?.startDate = cell.yearTF.text! + "-" + cell.monthTF.text! + "-01"
                    }
                    
                    self.navigationController?.pushViewController(staticMasterVC, animated: true)
                    return false
                default:
                    return true
                }
        }
        }
        return true

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
       guard let index = textField.tableViewIndexPath(self.tableView) else { return }
        
        switch index.row {
        case 0:
            self.textFieldDic["name"] = textField.text
        default:
            self.textFieldDic["issuer"] = textField.text
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField.returnKeyType {
        case .default:
            self.view.endEditing(true)
        case .next:
            self.view.viewWithTag(textField.tag+1)?.becomeFirstResponder()
        case .done:
            if self.validation() { self.coursesCertification() }
        default:
            break
        }
        
        return true
    }
    
}

//MARk:- API and Validations
extension MICoursesCertificatinVC {
 
    func showErrorOnTableViewIndex(indexPath:IndexPath, errorMsg:String, isPrimary:Bool ) {
        self.error = (errorMsg, indexPath.row, isPrimary)
        self.tableView.reloadData()
    }
    
    func validation() -> Bool {
        self.view.endEditing(true)
        
        if (self.textFieldDic["name"]?.isBlank)! {
            if let index = self.placeholderArray.firstIndex(of: "Certification Name") {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: CoursesCertifications.name, isPrimary: true)
            }
           // self.toastView(messsage: CoursesCertifications.name)
            return false
        }
        
        if (self.textFieldDic["issuer"]?.isBlank)! {
            if let index = self.placeholderArray.firstIndex(of: "Issued By") {
                let indexPath = IndexPath(row: index, section: 0)
                self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: CoursesCertifications.issuer, isPrimary: true)
            }
            //self.toastView(messsage: CoursesCertifications.issuer)
            return false
        }
        let year = self.textFieldDic["lastUsedYear"]
        let month = self.textFieldDic["lastUsedMonth"]

        if  year?.count ?? 0 > 0 || month?.count ?? 0 > 0  {

            if year?.count == 0 {
//                if let index = self.placeholderArray.firstIndex(of: "Validity") {
//                    let indexPath = IndexPath(row: index, section: 0)
//                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please select year.", isPrimary: true)
//                }
//                //self.toastView(messsage: "Please select year.")
                return false

            }
            if month?.count == 0 {
//                if let index = self.placeholderArray.firstIndex(of: "Validity") {
//                    let indexPath = IndexPath(row: index, section: 0)
//                    self.showErrorOnTableViewIndex(indexPath: indexPath, errorMsg: "Please select month.", isPrimary: false)
//                }
//               // self.toastView(messsage: "Please select month.")
                return false

            }
            
        }
        
        return true
        
    }
    
    
    func coursesCertification() {
        
        let method: ServiceMethod = (self.data?.id == "") ? .post : .put
        let id = (self.data?.id) ?? ""
        let year = self.textFieldDic["lastUsedYear"]
        let month = self.textFieldDic["lastUsedMonth"]
        var lastUsed : String?
        if year?.count ?? 0 > 0 && month?.count ?? 0 > 0 {
            lastUsed = year! + "-" + month! + "-01"
        }

        MIApiManager.hitCoursesCertificationAPI(method, id: id, name: self.textFieldDic["name"]!, lastUsed: lastUsed, issuer: self.textFieldDic["issuer"]!) { (success, response, error, code) in
            
                DispatchQueue.main.async {
                
                    shouldRunProfileApi = true
                    if let responseData = response as? JSONDICT {
                        
                        if let successMessage = responseData["successMessage"] as? String {
                            JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.COURES_CERTS]
                            if let successDone = self.courseAddedSuccess {
                                successDone(true)
                            }
                            self.navigationController?.popViewController(animated: true)
                            
                        } else if let errorMessage = responseData["errorMessage"] as? String {
                            self.toastView(messsage: errorMessage)
                        }
                        
                    } else {
                        if (!MIReachability.isConnectedToNetwork()){
                            self.toastView(messsage: ExtraResponse.noInternet)
                        }
                    }
                }
            }
        }
        
}


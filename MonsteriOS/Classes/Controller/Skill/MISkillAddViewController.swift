//
//  MISkillAddViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 05/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import DropDown
//import WSTagsField
import TagListView

class tagView:WSTagsField {
    
}
class MISkillAddViewController: MIBaseViewController {
    
    @IBOutlet weak var tblView_bottomConstrint: NSLayoutConstraint!
    @IBOutlet weak var segmentHtConstrint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var progressView: UIView!
    var keyboardHeight  = 0.0
    let dropDown = DropDown()
    var suggestedSkillData     = [MIAutoSuggestInfo]()
    var skillInfo = [String:Any]()
    var isFormFreshOrExper:ProfessionalDetailsEnum = .Fresher
    var flowVia : FlowVia = .ViaRegister
    var lastSkillTyped = ""
    var addSkillSuccess : ((Bool)->Void)?
    var selectedSkills     = [MIUserSkills]()
    var callBackAfterResponse : (([MIUserSkills])->Void)?
    var isOnLoadOnly = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(MISkillAddViewController.dismissKeyoard(_:)))
        tapGesture.numberOfTapsRequired=1
        self.tableView.addGestureRecognizer(tapGesture)
        self.setUpDropDown()
        self.configureDropDown(dropDown: dropDown)
        if selectedSkills.count > 0 && self.flowVia != .ViaJobDetail{
            if let lastobject = selectedSkills.last,!lastobject.skillName.withoutWhiteSpace().isEmpty {
                self.callSuggestedKeywordApi(suggestTxt: lastobject.skillName.withoutWhiteSpace() )
            }
        }else if self.flowVia == .ViaJobDetail {
            for (_,data) in self.suggestedSkillData.enumerated() {
                if !data.id.isEmpty {
                    self.skillInfo[data.name] = data.id
                    self.skillInfo[data.id] = (data.suggestedType == SkillCategory.ITSkill.rawValue) ? "IT" : "Non-IT"
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "Skills"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.title = ""
        self.navigationItem.title = ""
        NotificationCenter.default.removeObserver(self)
        if self.flowVia == .ViaJobDetail {
            self.navigationItem.backBarButtonItem = nil
            self.navigationItem.backBarButtonItem?.title = ""
        }
    }
    
    func setUpUI(){
        self.segmentHtConstrint.constant = 0
        if flowVia == .ViaRegister {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(rightBarDonePressed(_:)))
            nextButton.isHidden = true
            nextButtonView.isHidden = true
        }else if flowVia == .ViaJobDetail{
            self.navigationItem.backBarButtonItem =  UIBarButtonItem(image: #imageLiteral(resourceName: "back_bl"), style: .done, target: self, action:#selector(MISkillAddViewController.backButtonAction(_:)))
            nextButton.setTitle("Save", for: .normal)
        }else{
            nextButton.setTitle("Save", for: .normal)
        }
        
        nextButton.showPrimaryBtn()
        //MITagViewCell
        tableView.register(UINib(nibName:String(describing: MISkillAddTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MISkillAddTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MITagViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MITagViewCell.self))
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection=false
        tableView.bounces=true
        self.tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.tableFooterView?.backgroundColor=UIColor.colorWith(r: 244, g: 246, b: 248, a: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func setUpDropDown(){
        dropDown.selectionAction = {  [weak self] (index: Int, item: String) in
            guard let wself = self else {return}
            if let newCell=wself.tableView?.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
                if let idSkill = wself.skillInfo[item] as? String {
                    wself.addNewSkill(name: item, skillID: idSkill, cell: newCell)
                }
            }
        }
        dropDown.cellConfiguration = {(_, item) in
            return "\(item)"
        }
    }
    func addNewSkill(name:String,skillID:String,cell:MISkillAddTableViewCell) {
        let exitingObjs = selectedSkills.filter { $0.skillName.withoutWhiteSpace().lowercased() == name.withoutWhiteSpace().lowercased()}
        if exitingObjs.count == 0 {
            selectedSkills.append(MIUserSkills(name: name.withoutWhiteSpace(), skillId: skillID))
            cell.tagsField.addTag(name.withoutWhiteSpace())
            self.lastSkillTyped = ""
        }
        
    }
    func showNextController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:Keyboard Notification Observer Method
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        if let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = Double(keyboardFrame.height)
            //  let keyboardEndPoint = myheight - keyboardFrame.height
           // self.moveKeyboard()
            
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.tableView.contentOffset.y = 0
        //   isKeyboardOnView = false
    }
    // Helper Methods Manage TableVIew Off set
    func moveKeyboard(){
        var sectionSecndHt : CGFloat = 0.0
        if let newCell1=self.tableView?.cellForRow(at: IndexPath(row: 0, section: 1))as?MITagViewCell{
            sectionSecndHt = newCell1.tagView.frame.height
        }
        
        if let newCell=self.tableView?.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
            if !newCell.tagsField.textField.isFirstResponder {
                return
            }
            if let pointInTable = newCell.tagsField.superview?.convert(newCell.tagsField.frame.origin, to: tableView) {
                let textFieldBottomPoint = pointInTable.y + newCell.tagsField.frame.size.height + sectionSecndHt //+ CGFloat(80)
                if keyboardHeight <= Double(textFieldBottomPoint) {
                    // UIView.animate(withDuration: 0.2) {
                    self.tableView.layoutIfNeeded()
                    DispatchQueue.main.async {
                        if CGFloat(Double(textFieldBottomPoint) - self.keyboardHeight) >= 150 {
                            self.tableView.contentOffset.y = 150
                        }else{
                            self.tableView.contentOffset.y = CGFloat(Double(textFieldBottomPoint) - self.keyboardHeight)
                        }
                    }
                } else {
                    self.tableView.contentOffset.y = 0
                }
            }
        }
    }
    func updateTableViewOffSet(axisValue:CGFloat) {
        self.moveKeyboard()
    }
    
    //MARK: - API Helper Method
    func callAPIForDeleteSkill(skillObj:MIUserSkills) {
        var skillparam = [String:Any]()
        skillparam["ids"] = [skillObj.id]
        
        MIApiManager.callAPIForDeleteSkills(methodType: .delete, path: APIPath.skillAddUpdateDeleteAPIEndpoint, params: skillparam) { [weak self](success, response, error, code) in
            DispatchQueue.main.async {
                guard let wself = self else {return}
                if error == nil && (code >= 200) && (code <= 299) {
                    
                    //Add/Edit Skill & IT Skill for job detail matchd data
                    if let tabVC = wself.tabbarController {
                        let skills = tabVC.userITPlusNonItSkill.filter({$0.id.lowercased() != skillObj.id.lowercased()})
                        tabVC.userITPlusNonItSkill = skills
                    }
                    
                    let tagDataList = wself.selectedSkills.filter({ ($0.skillName.withoutWhiteSpace().lowercased() != skillObj.skillName.withoutWhiteSpace().lowercased())})
                    wself.selectedSkills = tagDataList
                    
                    if let skill = wself.selectedSkills.last , skill.skillName.withoutWhiteSpace().count > 0 {
                        if wself.flowVia != .ViaJobDetail {
                            wself.callSuggestedKeywordApi(suggestTxt: skill.skillName.withoutWhiteSpace())
                        }
                    }
                    if wself.flowVia == .ViaProfileAdd || wself.flowVia == .ViaJobDetail {
                        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.KEY_SKILLS]
                        shouldRunProfileApi = true
                        wself.showAlert(title: "", message: "Skill was deleted successfully.",isErrorOccured: false)
                    }
                    
                }else{
                    //Case if user try to delete but api failed than same skill will shown on the list again
                    //                    if let newCell = wself.tableView?.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
                    //                        let exitingObjs = wself.selectedSkills.filter { $0.skillName.withoutWhiteSpace().lowercased() == skillObj.skillName.withoutWhiteSpace().lowercased()}
                    //                        if exitingObjs.count == 1 {
                    //                          //  wself.selectedSkills.append(skillObj)
                    //                            newCell.tagsField.addTag(skillObj.skillName.withoutWhiteSpace())
                    //                            wself.handleAPIError(errorParams: response, error: error)
                    //                        }
                    //                    }
                }
            }
        }
    }
    
    func callAPIForAddUpdateSKills() {
        //var paramData = [String:Any]()
        var skillData = [[String:Any]]()
        var serviceType  = ServiceMethod(rawValue: "POST")
        
        if flowVia == .ViaProfileEdit {
            serviceType  = ServiceMethod(rawValue: "PUT")
        }
        
        var itSkillCount = 0;
        var skill = 0;
        for tag in selectedSkills {
            var skillparam = [String:Any]()
            var skillparamId = [String:Any]()
            
            if tag.skillId.isEmpty {
                skillparamId[MIEducationDetailViewControllerConstant.textAPIKey] = tag.skillName.withoutWhiteSpace()
            }else{
                skillparamId[MIEducationDetailViewControllerConstant.idAPIKey] = tag.skillId
            }
            skillparam[MIEducationDetailViewControllerConstant.skillAPIKey] = skillparamId
            
            if tag.id.isEmpty {
                if let skillType = self.skillInfo[tag.skillId] as? String, skillType == "IT" {
                    itSkillCount = itSkillCount+1
                }else{
                    skill = skill + 1
                }
                skillData.append(skillparam)
            }
            
        }
        
        if skillData.count == 0 {
            self.navigationController?.popViewController(animated: true)
            return
        }
        self.startActivityIndicator()
        
        MIApiManager.callAPIForUpdateAddSkill(methodType: serviceType!, path: (self.flowVia == .ViaJobDetail) ? APIPath.skillItImprovementEndpoint : APIPath.skillAddUpdateDeleteAPIEndpoint, params: skillData,customHeader: [:]) {[weak self] (success, response, error, code) in
            
            DispatchQueue.main.async {
                guard let wself = self else { return}
                wself.stopActivityIndicator()
                
                if error == nil && (code >= 200) && (code <= 299) {
                    if let addSuccess = wself.addSkillSuccess {
                        addSuccess(true)
                    }
                    shouldRunProfileApi = true
                    JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.KEY_SKILLS]
                    var message = ""
                    if itSkillCount > 0 && skill > 0 {
                        message = "You have added \(itSkillCount) IT Skill and \(skill) skill."
                        
                    }else if itSkillCount > 0 {
                        message = "You have added \(itSkillCount) IT Skill."
                        
                    }else {
                        message = "You have added \(skill) skill."
                        
                    }
                    
                    wself.showAlert(title: "", message: message,isErrorOccured:false)
                    //Add/Edit Skill & IT Skill for job detail matchd data
                    if let tabBar = wself.tabbarController {
                        if let result = response as? [String:Any] {
                            tabBar.userITPlusNonItSkill.removeAll()
                            tabBar.userITPlusNonItSkill = MIUserSkills.getITNonItSkill(params: result)
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        if wself.flowVia == .ViaJobDetail {
                            if let callBack = wself.callBackAfterResponse {
                                callBack(wself.tabbarController?.userITPlusNonItSkill ?? [MIUserSkills]())
                            }
                        }
                        wself.navigationController?.popViewController(animated: true)
                    })
                    
                }else{
                    wself.handleAPIError(errorParams: response, error: error)
                }
            }
        }
    }
 
    
    @objc func dismissKeyoard(_ sender:UITapGestureRecognizer){
        self.tableView.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.tableView.endEditing(true)
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem) {
        if let callBack = self.callBackAfterResponse {
            callBack(self.tabbarController?.userITPlusNonItSkill ?? [MIUserSkills]())
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightBarDonePressed(_ sender: UIBarButtonItem) {
        if let newCell=self.tableView?.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
            if !self.lastSkillTyped.isEmpty {
                self.addNewSkill(name: self.lastSkillTyped, skillID: "", cell: newCell)
            }
            if let callBack = self.callBackAfterResponse {
                callBack(selectedSkills)
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        self.tableView.scrollToTop(animated: false)
        
        if let newCell=self.tableView?.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
            if !self.lastSkillTyped.isEmpty {
                self.addNewSkill(name: self.lastSkillTyped, skillID: "", cell: newCell)
            }
            if newCell.tagsField.tags.count > 0 {
                if self.flowVia != .ViaRegister {
                    self.callAPIForAddUpdateSKills()

                }
            }else{
                self.showAlert(title: "", message: "Please enter skills. At least one skill is required.")
            }
        }
    }
}
extension MISkillAddViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MISkillAddTableViewCell.self), for: indexPath)as?MISkillAddTableViewCell else {return UITableViewCell()}
            
            cell.skillLabel.textColor = AppTheme.appGreyColor
            if isOnLoadOnly {
                cell.configureView(config: ConfigureTagView(topViewRadius: 4, titleLabelText: "Skills", cornerRadius: 15.25, contentInset: UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 10), placeholder: "Please type here", placeholderColor: .darkGray, placeholderAlwaysVisible: true, textColor: .white, tintColor: AppTheme.defaltBlueColor, fieldTextColor: .black, selectedColor: .black, font: UIFont.customFont(type: .Regular, size: 12),backgroundColor:.white,borderColor:nil,borderWidth:0.0,isDelimiterVisible:true))
                isOnLoadOnly = false
            }
            cell.tagsField.roundCorner(1, borderColor: .lightGray, rad: 8)
            
            cell.doneActionClicked = { [weak self] status in
                guard let wself = self else {return}
                DispatchQueue.main.async {
                    if status {
//                        if wself.lastSkillTyped.withoutWhiteSpace().count > 40 {
//                          // wself.lastSkillTyped = ""
//                            wself.showAlert(title: "", message: "The skill entered is too long.")
//                            return
//
//                        }else{
//                        }
                        if !wself.lastSkillTyped.isEmpty {
                            let exitingObjs = wself.selectedSkills.filter { $0.skillName.withoutWhiteSpace().lowercased() == wself.lastSkillTyped.withoutWhiteSpace().lowercased()}
                            if exitingObjs.count == 0 {
                                wself.selectedSkills.append(MIUserSkills(name: wself.lastSkillTyped.withoutWhiteSpace(), skillId: ""))
                                cell.tagsField.addTag(wself.lastSkillTyped.withoutWhiteSpace())
                                wself.lastSkillTyped = ""
                            }else{
                                wself.showAlert(title: "", message: "\(wself.lastSkillTyped) is already in your skills.")
                            }
                        }
                    }
                }

            }
            cell.tagsField.onDidChangeHeightTo = { [weak tableView,weak self] tagF, height in
                guard let wself = self , let wtbl = tableView else {return}
                DispatchQueue.main.async {
                    UIView.setAnimationsEnabled(false)
                    wtbl.beginUpdates()
                    wtbl.setNeedsLayout()
                    wtbl.layoutIfNeeded()
                    wtbl.endUpdates()
                    UIView.setAnimationsEnabled(true)
                    
                                   wself.dropDown.anchorView = tagF
                                   wself.dropDown.width=tableView?.frame.width
                                   wself.dropDown.bottomOffset = CGPoint(x: 0, y:((wself.dropDown.anchorView?.plainView.bounds.height)!-10))
                                   wself.dropDown.topOffset = CGPoint(x: 0, y:-(height-(wself.dropDown.anchorView?.plainView.bounds.height)!+70))
                }
                
               
            }
            if (selectedSkills.count) > 0  {
                let skillsname  = self.selectedSkills.map { $0.skillName.withoutWhiteSpace() }
                cell.tagsField.addTags(skillsname)
            }
            cell.tagsField.onDidRemoveTag = { [weak self] tagfield,tag in
                guard let wself = self else {return}
                let tagDataList = wself.selectedSkills.filter({ ($0.skillName.withoutWhiteSpace().lowercased() == tag.text.withoutWhiteSpace().lowercased())})
                if tagDataList.count > 0 {
                    if let obj = tagDataList.first {
                        if !obj.id.isEmpty {
                            wself.callAPIForDeleteSkill(skillObj: obj)
                        }else{
                            wself.selectedSkills = wself.selectedSkills.filter({ ($0.skillName.withoutWhiteSpace().lowercased() != tag.text.withoutWhiteSpace().lowercased())})
                            if wself.flowVia != .ViaJobDetail {
                                if let skill = wself.selectedSkills.last , skill.skillName.withoutWhiteSpace().count > 0 {
                                    wself.callSuggestedKeywordApi(suggestTxt: skill.skillName.withoutWhiteSpace())
                                }else{
                                    wself.callSuggestedKeywordApi(suggestTxt: "")
                                    
                                }
                            }else if wself.flowVia == .ViaJobDetail {
                                if let suggestedcell=tableView.cellForRow(at: IndexPath(row: 0, section: 1))as?MITagViewCell{
                                    if let suggestedData = suggestedcell.tagView.tagViews.filter({$0.currentTitle?.withoutWhiteSpace().lowercased() == tag.text.withoutWhiteSpace().lowercased() }) as? [TagView] {
                                        
                                        if suggestedData.count > 0 {
                                            
                                            if let objTagView = suggestedData.first as? TagView {
                                                objTagView.tagBackgroundColor = AppTheme.defaltLightBlueColor
                                                objTagView.textColor = AppTheme.appGreyColor
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }else{
                    wself.selectedSkills = wself.selectedSkills.filter({ ($0.skillName.withoutWhiteSpace().lowercased() != tag.text.withoutWhiteSpace().lowercased())})
                    
                }
            }
            cell.tagsField.onDidSelectTagView = {tagField,tagView in
                tagField.removeTag(tagView.displayText)
            }
            
            cell.tagsField.onDidAddTag = { [weak self] tagFld,tag in
                guard let wself = self else {return}
                if (cell.tagsField.tags.count ) > 20 {
                    cell.tagsField.removeTag(tag)
                    wself.showAlert(title: "", message: "You can add maximum 20 skills.")
                }else{
                    wself.dropDown.hide()
                    if tagFld.bounds.size.height >= 180 {
                        let bottomOffset = CGPoint(x:0,y:(tagFld.contentSize.height - tagFld.bounds.size.height + tagFld.contentInset.bottom) + 45)
                        
                        tagFld.setContentOffset(bottomOffset , animated: false)
                    }
                    
                    let exitingObjs = wself.selectedSkills.filter { $0.skillName.withoutWhiteSpace().lowercased() == tag.text.withoutWhiteSpace().lowercased()}
                    if exitingObjs.count == 0 {
                        if let idSkill = wself.skillInfo[tag.text] as? String {
                            wself.selectedSkills.append(MIUserSkills(name: tag.text.withoutWhiteSpace(), skillId: idSkill))
                        }else{
                            wself.selectedSkills.append(MIUserSkills(name: tag.text.withoutWhiteSpace(), skillId: ""))
                        }
                    }
                    if wself.flowVia != .ViaJobDetail {
                        wself.callSuggestedKeywordApi(suggestTxt: tag.text.withoutWhiteSpace())
                    }
                }
            }
            cell.tagsField.onDidChangeText = { [weak self] _,text in
                guard let wself = self else {return}
                wself.dropDown.hide()
                // self.isKeyboardOnView = true
                
                if text?.count ?? 0 > 1 {
                    wself.lastSkillTyped = text ?? ""
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                        wself.callAutoSuggestApi(suggestKeyword: text ?? "")
                    })
                }
            }
            return cell
        }else{
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MITagViewCell.self), for: indexPath)as?MITagViewCell else {return UITableViewCell()}
            
            cell.configureView(config: ConfigureTagView(topViewRadius: 0, titleLabelText: nil, cornerRadius: 3.0, contentInset: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10), placeholder: "", placeholderColor: .red, placeholderAlwaysVisible: false, textColor: AppTheme.appGreyColor, tintColor: AppTheme.defaltLightBlueColor, fieldTextColor: .white, selectedColor: AppTheme.defaltLightBlueColor, font: UIFont.customFont(type: .Regular, size:12),backgroundColor:AppTheme.defaltLightBlueColor,borderColor:AppTheme.defaltLightBlueColor,borderWidth:1.0,isDelimiterVisible:false))
            cell.bgView.backgroundColor = (self.suggestedSkillData.count == 0) ? .clear : UIColor(hex: "f6f8fa")
            cell.bgView.roundCorner(0, borderColor: nil, rad: 8)
            cell.contentView.backgroundColor = .white
            var suggestNameList = [String]()
            for obj in suggestedSkillData {
                suggestNameList.append(obj.name.withoutWhiteSpace())
            }
            
            cell.addTags(suggestNameList)
            cell.tagTapAction = {[weak tableView, weak self](text,tagView) in
                guard let wself = self ,let wtbl = tableView else {return}
                if let newCell=wtbl.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
                    if newCell.tagsField.tags.count >= 20 {
                        wself.showAlert(title: "", message: "You can add maximum 20 skills.")
                    }else{
                        
                        let dataTags = newCell.tagsField.tags.filter({ ($0.text.withoutWhiteSpace() == text.withoutWhiteSpace())})
                        if dataTags.count == 0 {
                            if !text.isEmpty {
                                newCell.tagsField.addTag(text.withoutWhiteSpace())
                                tagView.tagBackgroundColor = AppTheme.defaltBlueColor //Color.colorLightDefault
                                tagView.textColor          = .white
                            }
                        }else{
                            if !text.isEmpty {
                                tagView.tagBackgroundColor = AppTheme.defaltLightBlueColor
                                tagView.textColor          = AppTheme.appGreyColor
                                newCell.tagsField.removeTag(text)
                            }
                        }
                    }
                    
                }
            }
            var searchArray=[String]()
            if let newCell=self.tableView?.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
                for tag in newCell.tagsField.tags{
                    searchArray.append(tag.text)
                }
            }
           
            for tagView in cell.tagView.tagViews {
                tagView.textColor              = AppTheme.appGreyColor
                if searchArray.contains(tagView.titleLabel?.text ?? "") {
                    tagView.tagBackgroundColor =  AppTheme.defaltBlueColor //Color.colorLightDefault
                    tagView.textColor          = .white
                } else {
                    tagView.tagBackgroundColor = AppTheme.defaltLightBlueColor
                    tagView.textColor          = AppTheme.appGreyColor
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return (self.suggestedSkillData.count == 0) ? 1 : 30
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let headerView = UIView()
            let innerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kScreenSize.width, height: 30))
            innerView.backgroundColor =  .white
            let headerLabel = UILabel(frame: CGRect(x: 24, y: 8, width:
                tableView.bounds.size.width, height: 22))
            headerLabel.font = UIFont.customFont(type: .Medium, size: 12)
            headerLabel.textColor = AppTheme.appGreyColor
            headerLabel.text = (self.suggestedSkillData.count == 0) ? "" : "Suggested Skills"
            headerLabel.sizeToFit()
            headerView.addSubview(innerView)
            headerView.addSubview(headerLabel)
            return headerView
        default:
            return nil
        }
    }
    
    func callAutoSuggestApi(suggestKeyword:String) {
        var additionalParams = [String:Any]()
        if self.flowVia == .ViaRegister || self.flowVia == .ViaJobDetail {
            additionalParams = ["type":"SKILL","name":suggestKeyword,"limit":50]
        }else{
            additionalParams = ["type":"SKILL","name":suggestKeyword,"category":"Non-IT","limit":50]
        }
        MIAPIClient.sharedClient.load(path: APIPath.searchSuggestedSkill, method: .get, params: additionalParams) { [weak self] (response, error,code) in
            guard let wself = self else {return}
            if error != nil {
                return
            }else{
                if let jsonData=response as? [String:Any]{
                    var dataSource=[String]()
                    if let dataDict=jsonData["data"]as?[[String:Any]]{
                        
                        for dict in dataDict{
                            if let name = (dict["name"] as? String)?.withoutWhiteSpace(){
                                dataSource.append(name)
                                if let skillId = (dict["uuid"] as? String)?.withoutWhiteSpace(){
                                    wself.skillInfo[name] = skillId
                                    if let category = (dict["category"] as? String)?.withoutWhiteSpace(){
                                        wself.skillInfo[skillId] = category
                                    }
                                }
                            }
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                        wself.dropDown.dataSource=dataSource
                        wself.dropDown.show()
                    })
                }
            }
        }
    }
    
    func getExcludeKeywords() -> String {
        var excludeString = ""
        if selectedSkills.count > 0 {
            for i in 0 ..< selectedSkills.count {
                excludeString = excludeString + "&excludeKeywords=\(selectedSkills[i].skillName.withoutWhiteSpace())"
            }
        }
        return excludeString
    }
    func getPathForSuggestedData(suggestTxt:String)->String {
        var urlPath = ""
        if self.flowVia == .ViaRegister || self.flowVia == .ViaJobDetail {
            urlPath = "\(kBaseUrl)/raven/api/public/search/v1/suggested-keywords?type=SKILL&query=\(suggestTxt)\(self.getExcludeKeywords())&limit=40"
        }else{
            urlPath = "\(kBaseUrl)/raven/api/public/search/v1/suggested-keywords?type=SKILL&category=Non-IT&query=\(suggestTxt)\(self.getExcludeKeywords())&limit=40"
        }
        return urlPath.encodedUrl()
    }
    func callSuggestedKeywordApi(suggestTxt:String) {
        // self.suggestedSkillData.removeAll()
        ServiceManager.execute(method: .get, path:self.getPathForSuggestedData(suggestTxt: suggestTxt), param: nil, header: MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil), isJsonType: true) {[weak self] (success, response, error, code) in
            DispatchQueue.main.async {
                
                guard let wself = self else {return}
                if error != nil{
                    return
                }
                if code >= 200 && code <= 299 {
                    if let jsonData=response as? [String:Any]{
                        if let data=jsonData["data"]as?[[String:Any]]{
                            var arr = [MIAutoSuggestInfo]()
                            for dic in data {
                                let objSkill = MIAutoSuggestInfo.init(with: dic)
                                if let skillId = dic["uuid"] as? String{
                                    wself.skillInfo[objSkill.name] = skillId
                                }
                                arr.append(objSkill)
                                if arr.count == 10{
                                    break
                                }
                            }
                            wself.suggestedSkillData.removeAll()
                            
                            if arr.count > 0 {
                                wself.suggestedSkillData = arr
                            }
                        }
                    }
                }
                wself.tableView.reloadSections(IndexSet(integer: 1), with: .none)
            }
        }
    }
}

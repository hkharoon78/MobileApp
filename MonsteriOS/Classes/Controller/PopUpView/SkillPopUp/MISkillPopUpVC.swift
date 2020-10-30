//
//  MISkillPopUpVC.swift
//  MonsteriOS
//
//  Created by Rakesh on 19/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import DropDown
//import WSTagsField

class MISkillPopUpVC: UIViewController {
    
    var headerView = MIProfileImprovementHeader.header
    let footer = MISingleButtonView.singleBtnView
    let dropDown = DropDown()
    var lastSkillTyped = ""
    var tagArray     = [MIAutoSuggestInfo]() {
        didSet {
            self.manageTableViewToCenter()
        }
    }
    var skillInfo = [String:Any]()
    var selectedSkills = [MIUserSkills]()
    var oldSkills = [MIUserSkills]()
 //   var deletedSkills     = [String]()
    var deletedSkillsData     = [MIUserSkills]()

    var keyboardHeight  = 0.0
    var card: Card?
    var viewLoadDate:Date!
    var isOnLoadOnly = true

    @IBOutlet weak var skillTblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        viewLoadDate = Date()
        self.setUpViewOnLoad()
        self.manageTableViewToCenter()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.title = ""
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = ""
        self.navigationItem.hidesBackButton = false
        self.navigationController?.isNavigationBarHidden = false
    }
    func setUpViewOnLoad(){
        headerView.setHeaderViewWithTitle(title: "Update Skills", imgName: "fountain-pen")
        skillTblView.tableHeaderView = headerView
        footer.btn_delete.setTitle("UPDATE", for: .normal)
        footer.btn_delete.showSecondaryBtnLayout()
        footer.btn_leadingConstraint.constant = 15
        footer.btn_trailingConstairnt.constant = 15
        skillTblView.tableFooterView = footer
        
        footer.btnActionCallBack = { [weak self] sectionCount in
            if let wSelf = self {
                if  !wSelf.deletedSkillsData.isEmpty {
                    wSelf.callAPIForDeleteSkill()
                }else{
                    wSelf.callAPIForUpdateSKills()
                }
            }
            
        }
        skillTblView.register(UINib(nibName:String(describing: MITagViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MITagViewCell.self))
        skillTblView.register(UINib(nibName:String(describing: MISkillAddTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MISkillAddTableViewCell.self))
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(MISkillPopUpVC.dismissKeyoard(_:)))
        tapGesture.numberOfTapsRequired=1
        self.skillTblView.addGestureRecognizer(tapGesture)
        self.setUpDropDown()
        
        self.configureDropDown(dropDown: dropDown)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.showAttributtedForResume()
        
        if let cardData = card?.data as? [[String:Any]],cardData.count > 0 {
            selectedSkills.append(contentsOf: MIUserSkills.modelsFromDictionaryArray(array: cardData))
            oldSkills.append(contentsOf: MIUserSkills.modelsFromDictionaryArray(array: cardData))
            
            self.callSuggestedKeywordApi(suggestTxt: selectedSkills.last?.skillName ?? "")
            
        }
        //self.manageFieldData()
        //    fieldSource = ["I am currently working as","at","since","having notice peroid of","my last day is"]
    }
    func showAttributtedForResume(){
        let resume = NSMutableAttributedString(string:"It's the ", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
        let mostImp = NSAttributedString(string:"biggest ", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Semibold, size: 13)])
        let document = NSMutableAttributedString(string:"decision maker. You have it, so flaunt it", attributes: [NSAttributedString.Key.foregroundColor:UIColor(hex: "505050"),NSAttributedString.Key.font:UIFont.customFont(type: .Regular, size: 13)])
        
        resume.append(mostImp)
        resume.append(document)
        headerView.lbl_description.attributedText = resume
        
    }
    func setUpDropDown(){
        dropDown.selectionAction = {  (index: Int, item: String) in
            if let newCell=self.skillTblView?.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
                if let idSkill = self.skillInfo[item] as? String {
                    self.addNewSkill(name: item, skillID: idSkill, cell: newCell)
                    //  self.selectedSkills.append(MIUserSkills(name: item, skillId: idSkill))
                    
                }
                newCell.tagsField.addTag(item)
                
            }
        }
        dropDown.cellConfiguration = {(_, item) in
            return "\(item)"
        }
    }
    func manageTableViewToCenter() {
        let viewHeight: CGFloat = view.frame.size.height
        let tableViewContentHeight: CGFloat = skillTblView.contentSize.height
        let marginHeight: CGFloat = (viewHeight - tableViewContentHeight) / 4.0
        var edgeInsets : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom:0, right: 0)
        if tagArray.isEmpty {
            edgeInsets = UIEdgeInsets(top: marginHeight, left: 0, bottom:  -marginHeight, right: 0)
        }
        self.skillTblView.contentInset = edgeInsets
        
        
    }
    //MARK:Keyboard Notification Observer Method
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo!
        if let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            //  isKeyboardOnView = true
            // let myheight = tableView.frame.height
            keyboardHeight = Double(keyboardFrame.height)
            //  let keyboardEndPoint = myheight - keyboardFrame.height
            self.moveKeyboard()
            
        }
    }
    func moveKeyboard(){
        var sectionSecndHt : CGFloat = 0.0
        if let newCell1=self.skillTblView.cellForRow(at: IndexPath(row: 0, section: 1))as?MITagViewCell{
            sectionSecndHt = newCell1.tagView.frame.height
        }
        
        if let newCell=self.skillTblView.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
            
            if let pointInTable = newCell.tagsField.superview?.convert(newCell.tagsField.frame.origin, to: skillTblView) {
                let textFieldBottomPoint = pointInTable.y + newCell.tagsField.frame.size.height + sectionSecndHt //+ CGFloat(80)
                if keyboardHeight <= Double(textFieldBottomPoint) {
                    // UIView.animate(withDuration: 0.2) {
                    self.skillTblView.layoutIfNeeded()
                    DispatchQueue.main.async {
                        if CGFloat(Double(textFieldBottomPoint) - self.keyboardHeight) >= 150 {
                            self.skillTblView.contentOffset.y = 150
                            
                        }else{
                            self.skillTblView.contentOffset.y = CGFloat(Double(textFieldBottomPoint) - self.keyboardHeight)
                            
                        }
                        
                    }
                    
                } else {
                    //    isKeyboardOnView = false
                    self.skillTblView.contentOffset.y = 0
                    
                }
            }
        }
        
    }
    func updateTableViewOffSet(axisValue:CGFloat) {
        self.moveKeyboard()
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        self.skillTblView.contentOffset.y = 0
        //   isKeyboardOnView = false
    }
    
    func addNewSkill(name:String,skillID:String,cell:MISkillAddTableViewCell) {
        let exitingObjs = selectedSkills.filter { $0.skillName.lowercased() == name.lowercased()}
        if exitingObjs.count == 0 {
            selectedSkills.append(MIUserSkills(name: name, skillId: skillID))
            cell.tagsField.addTag(name)
            self.lastSkillTyped = ""
        }
        
    }
    @objc func dismissKeyoard(_ sender:UITapGestureRecognizer){
        self.skillTblView.endEditing(true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.skillTblView.endEditing(true)
    }
    @IBAction func remindMeLater(_ sender:UIButton) {
        self.callAPIForSkip()
    }
    
}


extension MISkillPopUpVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (section == 0) ? 1 : ((self.tagArray.count == 0) ? 0 : 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MISkillAddTableViewCell.self), for: indexPath) as? MISkillAddTableViewCell
            
            
            if isOnLoadOnly {
                cell!.configureView(config: ConfigureTagView(topViewRadius: 4, titleLabelText: "Skills", cornerRadius: 15.25, contentInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), placeholder: "Please type here", placeholderColor: .darkGray, placeholderAlwaysVisible: true, textColor: .white, tintColor: AppTheme.defaltBlueColor, fieldTextColor: .black, selectedColor: .black, font: UIFont.customFont(type: .Regular, size: 12),backgroundColor:.white,borderColor:nil,borderWidth:0.0,isDelimiterVisible:true))
                isOnLoadOnly = false

            }
            cell!.manageLayoutForPopUp()
            cell!.doneActionClicked = { status in
                if status {
                    if !self.lastSkillTyped.isEmpty {
                        let exitingObjs = self.selectedSkills.filter { $0.skillName.lowercased() == self.lastSkillTyped.lowercased()}
                        if exitingObjs.count == 0 {
                            self.selectedSkills.append(MIUserSkills(name: self.lastSkillTyped, skillId: ""))
                            cell?.tagsField.addTag(self.lastSkillTyped)
                            self.lastSkillTyped = ""
                        }else{
                            self.showAlert(title: "", message: "\(self.lastSkillTyped) is already in your skills.")
                        }
                    }
                }
            }
            cell!.tagsField.onDidChangeHeightTo = { [weak tableView] tagF, height in
                DispatchQueue.main.async {
                    UIView.setAnimationsEnabled(false)
                    tableView?.beginUpdates()
                    tableView?.setNeedsLayout()
                    tableView?.layoutIfNeeded()
                    tableView?.endUpdates()
                    UIView.setAnimationsEnabled(true)
                    self.dropDown.anchorView = tagF
                    self.dropDown.width=tableView?.frame.width
                    self.dropDown.bottomOffset = CGPoint(x: 0, y:((self.dropDown.anchorView?.plainView.bounds.height)!-10))
                    self.dropDown.topOffset = CGPoint(x: 0, y:-(height-(self.dropDown.anchorView?.plainView.bounds.height)!+70))
                }
            }
            if (selectedSkills.count ) > 0  {
                let skillsname  = self.selectedSkills.map { $0.skillName }
                cell!.tagsField.addTags(skillsname)
                
            }
            cell!.tagsField.onDidRemoveTag = {tagfield,tag in
                if self.selectedSkills.filter({ ($0.skillName == tag.text)}).count > 0 {
                    let dataList = self.selectedSkills.filter({ ($0.skillName == tag.text)})
                    if let obj = dataList.first {
                        self.selectedSkills = self.selectedSkills.filter({ ($0.skillName != tag.text)})
                        if !obj.id.isEmpty {
                           // self.deletedSkills.append(obj.id)
                            self.deletedSkillsData.append(obj)
                            // self.callAPIForDeleteSkill(skillId: obj.id, skillName: tag.text)
                        }
                        //   self.selectedSkills = self.selectedSkills.filter({ ($0.skillName != tag.text)})
                        if let skill = self.selectedSkills.last , skill.skillName.count > 0 {
                            self.callSuggestedKeywordApi(suggestTxt: skill.skillName)
                        }else{
                            self.callSuggestedKeywordApi(suggestTxt: "")
                            
                        }
                    }
                }else{
                    self.selectedSkills = self.selectedSkills.filter({ ($0.skillName != tag.text)})
                    
                }
            }
            cell!.tagsField.onDidSelectTagView = {tagField,tagView in
                tagField.removeTag(tagView.displayText)
            }
            
            cell!.tagsField.onDidAddTag={tagFld,tag in
                if (cell?.tagsField.tags.count)! > 20 {
                    cell?.tagsField.removeTag(tag)
                    self.showAlert(title: "", message: "You can add maximum 20 skills.")
                }else{
                    self.dropDown.hide()
                    if tagFld.bounds.size.height >= 150 {
                        let bottomOffset = CGPoint(x:0,y:(tagFld.contentSize.height - tagFld.bounds.size.height + tagFld.contentInset.bottom) + 45)
                        
                        tagFld.setContentOffset(bottomOffset , animated: false)
                    }
                    
                    let exitingObjs = self.selectedSkills.filter { $0.skillName.lowercased() == tag.text.lowercased()}
                    if exitingObjs.count == 0 {
                        if let idSkill = self.skillInfo[tag.text] as? String {
                            self.selectedSkills.append(MIUserSkills(name: tag.text, skillId: idSkill))
                            
                        }else{
                            self.selectedSkills.append(MIUserSkills(name: tag.text, skillId: ""))
                        }
                    }
                    self.callSuggestedKeywordApi(suggestTxt: tag.text)
                    
                }
            }
            cell!.tagsField.onDidChangeText={_,text in
                self.dropDown.hide()
                //      self.isKeyboardOnView = true
                
                if text?.count ?? 0 > 1 {
                    self.lastSkillTyped = text ?? ""
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                        self.callAutoSuggestApi(suggestKeyword: text ?? "")
                    })
                }
            }
            return cell!
        }else{
            let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MITagViewCell.self), for: indexPath)as?MITagViewCell
            cell?.configureView(config: ConfigureTagView(topViewRadius: 0, titleLabelText: nil, cornerRadius: 3.0, contentInset: UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10), placeholder: "", placeholderColor: .red, placeholderAlwaysVisible: false, textColor: AppTheme.appGreyColor, tintColor: AppTheme.defaltLightBlueColor, fieldTextColor: .white, selectedColor: AppTheme.defaltLightBlueColor, font: UIFont.customFont(type: .Regular, size:12),backgroundColor:AppTheme.defaltLightBlueColor,borderColor:AppTheme.defaltLightBlueColor,borderWidth:1.0,isDelimiterVisible:false))
            cell?.bgView.backgroundColor = (self.tagArray.count == 0) ? .clear : UIColor(hex: "f6f8fa")
            cell?.bgView.roundCorner(0, borderColor: nil, rad: 8)
            cell?.contentView.backgroundColor = .white
            
            //            cell?.tagView.backgroundColor = (self.tagArray.count == 0) ? .white : AppTheme.viewBackgroundColor
            //            cell?.contentView.backgroundColor = (self.tagArray.count == 0) ? .white : AppTheme.viewBackgroundColor
            var suggestNameList = [String]()
            for obj in tagArray {
                suggestNameList.append(obj.name)
            }
            
            cell?.addTags(suggestNameList)
            cell?.tagTapAction = {[weak tableView](text,tagView) in
                
                if let newCell=tableView?.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
                    if newCell.tagsField.tags.count >= 20 {
                        self.showAlert(title: "", message: "You can add maximum 20 skills.")
                    }else{
                        
                        let dataTags = newCell.tagsField.tags.filter({ ($0.text == text)})
                        if dataTags.count == 0 {
                            if !text.isEmpty {
                                newCell.tagsField.addTag(text)
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
            var searchArray = [String]()
            if let newCell = self.skillTblView?.cellForRow(at: IndexPath(row: 0, section: 0))as?MISkillAddTableViewCell{
                for tag in newCell.tagsField.tags{
                    searchArray.append(tag.text)
                }
            }
            for tagView in cell!.tagView.tagViews {
                tagView.textColor              = AppTheme.appGreyColor
                if searchArray.contains((tagView.titleLabel?.text)!) {
                    tagView.tagBackgroundColor =  AppTheme.defaltBlueColor //Color.colorLightDefault
                    tagView.textColor          = .white
                } else {
                    tagView.tagBackgroundColor = AppTheme.defaltLightBlueColor
                    tagView.textColor          = AppTheme.appGreyColor
                }
            }
            
            return cell!
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return (self.tagArray.count == 0) ? 1 : 35
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
            
        case 1:
            if self.tagArray.count == 0 {
                let headerView = UIView()
                let innerView = UIView()
                innerView.backgroundColor = UIColor.white
                headerView.addSubview(innerView)
                headerView.backgroundColor = UIColor.white
                return headerView
            }else{
                let headerView = UIView()
                headerView.backgroundColor = UIColor.white
                let headerLabel = UILabel(frame: CGRect(x: 24, y: 15, width:
                    tableView.bounds.size.width, height: 20))
                headerLabel.font = UIFont.customFont(type: .Medium, size: 12)
                headerLabel.textColor = AppTheme.appGreyColor
                headerLabel.text = "Suggested Skills"
                headerLabel.sizeToFit()
                headerView.addSubview(headerLabel)
                return headerView
                
            }
        default:
            let headerView = UIView()
            let innerView = UIView()
            innerView.backgroundColor = UIColor.white
            headerView.addSubview(innerView)
            headerView.backgroundColor = UIColor.white
            return headerView
            
        }
    }
    func getExcludeKeywords() -> String {
        var excludeString = ""
        if self.selectedSkills.count > 0 {
            for i in 0 ..< selectedSkills.count {
                excludeString = excludeString + "&excludeKeywords=\(selectedSkills[i].skillName)"
            }
        }
        
        return excludeString
    }
    func getPathForSuggestedData(suggestTxt:String)->String {
        
        return "\(kBaseUrl)/raven/api/public/search/v1/suggested-keywords?type=SKILL&query=\(suggestTxt)\(self.getExcludeKeywords())&limit=40".encodedUrl()
    }
    func callSuggestedKeywordApi(suggestTxt:String) {
       
        
        ServiceManager.execute(method: .get, path:self.getPathForSuggestedData(suggestTxt: suggestTxt), param: nil, header: MIUtils.shared.apiHeaderWith(isToken: true, isContentType: true, isDeviceToken: true, extraDic: nil), isJsonType: true) { (success, response, error, code) in
            DispatchQueue.main.async {
                
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
                                    self.skillInfo[objSkill.name] = skillId
                                }
                                arr.append(objSkill)
                                if arr.count == 10{
                                    break
                                }
                            }
                            if arr.count > 0 {
                                self.tagArray = arr
                            }
                            self.skillTblView.reloadSections(IndexSet(integer: 1), with: .none)
                            
                        }
                        //   self.skillTblView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                        //  self.skillTblView.reloadSections(IndexSet(), with: .none)
                    }
                    
                }else{
                    self.tagArray.removeAll()
                    self.skillInfo.removeAll()
                    UIView.performWithoutAnimation {
                        self.skillTblView.reloadData()
                    }
                }
            }
        }
        
        
    }
    func callAutoSuggestApi(suggestKeyword:String) {
        
        MIAPIClient.sharedClient.load(path: APIPath.searchSuggestedSkill, method: .get, params: ["type":"SKILL","name":suggestKeyword,"limit":400]) { [weak wSelf = self] (response, error,code) in
            if error != nil {
                return
            }else{
                if let jsonData=response as? [String:Any]{
                    var dataSource=[String]()
                    if let dataDict=jsonData["data"]as?[[String:Any]]{
                        
                        for dict in dataDict{
                            if let name=dict["name"] as? String{
                                dataSource.append(name)
                                if let skillId = dict["uuid"] as? String{
                                    self.skillInfo[name] = skillId
                                    if let category = dict["category"] as? String{
                                        self.skillInfo[skillId] = category
                                    }
                                }
                                
                                
                            }
                        }
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                        wSelf?.dropDown.dataSource=dataSource
                        wSelf?.dropDown.show()
                    })
                }
            }
        }
    }
    
    func callAPIForUpdateSKills() {
        //var paramData = [String:Any]()
        var skillData = [[String:Any]]()
        
        let newSkills = selectedSkills.filter { $0.id.count == 0}
        
        for tag in newSkills {
            var skillparam = [String:Any]()
            var skillparamId = [String:Any]()
            
            if tag.skillId.isEmpty {
                skillparamId[MIEducationDetailViewControllerConstant.textAPIKey] = tag.skillName
            }else{
                skillparamId[MIEducationDetailViewControllerConstant.idAPIKey] = tag.skillId
            }
            skillparam[MIEducationDetailViewControllerConstant.skillAPIKey] = skillparamId
            skillData.append(skillparam)
        }
        let added = self.addTaskToDispatchGroup()
        let headerDict = [
            "x-rule-applied": card?.ruleApplied ?? "",
            "x-rule-version": card?.ruleVersion ?? ""
        ]
        MIApiManager.callAPIForUpdateAddSkill(methodType: .post, path: APIPath.skillItImprovementEndpoint, params: skillData,customHeader:headerDict ) { (success, response, error, code) in
            DispatchQueue.main.async {
                //    MIActivityLoader.hideLoader()
                //  }
                defer { self.leaveDispatchGroup(added) }
                
                if error == nil && (code >= 200) && (code <= 299) {
                    JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.KEY_SKILLS]
                    
                    if let tabbar = self.tabbarController {
                        tabbar.handlePopFinalState(isErrorHappen: false)
                        //Add/Edit Skill & IT Skill for job detail matchd data
                        if let result = response as? [String:Any] {
                            tabbar.userITPlusNonItSkill.removeAll()
                            tabbar.userITPlusNonItSkill = MIUserSkills.getITNonItSkill(params: result)
                        }
                    }
                    
                    //====add skill
                    //                    if let vc = self.tabBarController as? MIHomeTabbarViewController {
                    //                        for ss in self.selectedSkills{
                    //                            let name = ss.skillName
                    //                            vc.skillsNewArr.append(name)
                    //                        }
                    //                    }
                    
                }else{
                    if let tabbar = self.tabbarController {
                        tabbar.isErrorOccuredOnProfileEngagement = true
                    }
                    //    self.handleAPIError(errorParams: response, error: error)
                }
            }
        }
        self.callAPIForEventTracking(updated: 1, remindMeLater: 0)
        self.skipProfileEngagementPopup()
    }
    
    func callAPIForDeleteSkill() {
        var skillparam = [String:Any]()
        skillparam["ids"] = deletedSkillsData.map({$0.id})
        //  MIActivityLoader.showLoader()
        
        MIApiManager.callAPIForDeleteSkills(methodType: .delete, path: APIPath.skillAddUpdateDeleteAPIEndpoint, params: skillparam) { (success, response, error, code) in
            DispatchQueue.main.async {
                
                if error == nil && (code >= 200) && (code <= 299) {
                    shouldRunProfileApi = true
                    if let tabbar = self.tabbarController {
                        //Add/Edit Skill & IT Skill for job detail matchd data
                        let deleteObjSet : Set<MIUserSkills> = Set(self.deletedSkillsData)
                        let userSkillSet : Set<MIUserSkills> = Set(tabbar.userITPlusNonItSkill)
                        let objeAfterRemove = Set(userSkillSet).subtracting(Set(deleteObjSet))
                        tabbar.userITPlusNonItSkill = Array(objeAfterRemove)
                    }
                    shouldRunProfileApi = true
                   // self.deletedSkills.removeAll()
                    self.deletedSkillsData.removeAll()
                    self.callAPIForUpdateSKills()
                    
                }else{
                    
                }
            }
        }
    }
    
    func callAPIForSkip(){
        if let card = self.card {
            
            let headerDict = [
                "x-rule-applied": card.ruleApplied ?? "",
                "x-rule-version": card.ruleVersion ?? ""
            ]
            
            MIApiManager.hitRemindMeLaterApi(card.type, userActions: card.text, headerDict: headerDict) { (success, response, error, code) in
                //                DispatchQueue.main.async {
                //
                //                    if error == nil && (code >= 200) && (code <= 299) {
                //
                //                    }else{
                //                        // self.handleAPIError(errorParams: response, error: error)
                //                    }
                //                }
            }
            self.callAPIForEventTracking(updated: 0, remindMeLater: 1)
            self.skipProfileEngagementPopup()
            
        }
        
    }
    func callAPIForEventTracking(updated: Int, remindMeLater: Int) {
        // var attribute =  //(CV, EXPERIENCE, EDUCATION, SKILL, LOCATION, MOB, DESIGNATION
        var oldData = [String:Any]()
        var newData =  [String:Any]()
        oldData["skills"] = [String]()
        newData["skills"] = [String]()
        if updated == 1 {
            oldData["skills"] = oldSkills.map({$0.skillName})
            newData["skills"] = selectedSkills.map({$0.skillName})
        }
        
        MIApiManager.hitTrackingEventsApi("SKILL", updated: updated, remindMeLater: remindMeLater, oldValue: oldData, newValue: newData, timeSpent: viewLoadDate.getSecondDifferenceBetweenDates(), cardRule: card) { (success, response, error, code) in
            
        }
    }
}

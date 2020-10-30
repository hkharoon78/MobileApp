//
//  MIProfileViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 16/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

var shouldRunProfileApi = true

class MIProfileViewController: MIBaseViewController {
    
    @IBOutlet weak private var tblView:UITableView!
    
    @IBOutlet weak var tblViewTopConstraint: NSLayoutConstraint?
    var tblHeader = MIProfileTableHeaderView.header
    
    private var modulesArray = [MIProfileModels]()
    var personalDetailInfoDict : [String:Any]?
    var personalDetail = MIProfilePersonalDetailInfo(dictionary: [:])
    private var popOverContentSize:CGSize  = CGSize(width: 140, height: 80)
    var cellSelectedInfo = [Any]()
    private var tblHeaderDefaultHeight = 0
    private var showProfileMsgFirstTime  = true
    
    var profileAPISucced: (()->Void)?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MIProfileViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Color.colorDarkBlack
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        statusBarView?.backgroundColor = UIColor(red: 92, green: 72, blue: 174)
        if kIsiPhoneXS || kIsiPhoneXSMax {
            tblViewTopConstraint?.constant = 50
        }
        //        profileImgActivity.isHidden = true
        //for testing
        //        let vc = MICreateNewProfileController()
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        
        if self.modulesArray.count == 0 || shouldRunProfileApi {
            shouldRunProfileApi = false
            if let navView = self.tabBarController?.viewControllers?[0] as? MINavigationViewController {
                if let homeView = navView.viewControllers.first as? MIHomeViewController{
                    homeView.modulesArray.removeAll()
                    homeView.tblView.reloadData()
                }
            }
            self.callApi()
        }
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.stopActivityIndicator()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.callApi()
        refreshControl.endRefreshing()
    }
    
    override func initUI() {
        tblHeader.delegate = self
        
        self.tblView.tableHeaderView = tblHeader
        self.navigationController?.navigationBar.isHidden = true
        self.tblView.register(UINib(nibName: "MIProfileStrengthCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.strength.rawValue)
        self.tblView.register(UINib(nibName: "MIManageProfileCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.manageProfileSection.rawValue)
        self.tblView.register(UINib(nibName: "MIProfileResumeDetailCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.resumeSection.rawValue)
        self.tblView.register(UINib(nibName: "MIProfileExperienceDetailCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.workExperience.rawValue)
        self.tblView.register(UINib(nibName: "MIProfileConnectedCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.project.rawValue)
        self.tblView.register(UINib(nibName: "MIProfileSkillCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.skill.rawValue)
        self.tblView.register(UINib(nibName: "MIProfileITSkillCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.ITSkill.rawValue)
        self.tblView.register(UINib(nibName: "MIProfileJobPreferenceCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.jobPreference.rawValue)
        self.tblView.register(UINib(nibName: "MIProfileOtherDetailCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.otherDetail.rawValue)
        self.tblView.register(UINib(nibName: "MIProfileSocialLinkCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.onlinePresence.rawValue)
        self.tblView.register(UINib(nibName: "MIProfileLanguageCell", bundle: nil), forCellReuseIdentifier: MIProfileEnums.language.rawValue)
        
        self.personalDetail = AppDelegate.instance.userInfo
        tblHeader.show(info: self.personalDetail)
        
        //        let size = tblHeader.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        //        let height = size.height
        tblHeaderDefaultHeight = Int(tblHeader.frame.size.height)
        self.updateTableHeaderHeight()
        tblHeader.btnEditProfile.isHidden = false
        self.tblHeader.btnEditProfile.addTarget(self, action: #selector(btnEditProfilePressed), for: .touchUpInside)
        self.tblView.addSubview(self.refreshControl)
    }
    
    func updateTableHeaderHeight() {
        let defaultAndResumeLblHt = CGFloat(tblHeaderDefaultHeight) + tblHeader.lblResumeTitle.frame.size.height
        let contactDetailHt = tblHeader.lblEmail.frame.size.height + tblHeader.lblContact.frame.size.height
        let visaLocationHt = tblHeader.lblLocation.frame.size.height +  tblHeader.lblVisaType.frame.size.height
        let defaultContactDetailHt = defaultAndResumeLblHt + contactDetailHt
        let defaultContactVisaLocationHt = defaultContactDetailHt + visaLocationHt
        let totalheight = defaultContactVisaLocationHt - CGFloat(45)

   //     let totalheight = CGFloat(tblHeaderDefaultHeight) + tblHeader.lblResumeTitle.frame.size.height + tblHeader.lblEmail.frame.size.height + tblHeader.lblContact.frame.size.height + tblHeader.lblLocation.frame.size.height +  tblHeader.lblVisaType.frame.size.height - CGFloat(45)
        tblHeader.frame.size.height = totalheight
    }
    
    @objc func btnEditProfilePressed() {
      
        CommonClass.googleEventTrcking("profile_screen", action: "edit_icon", label: "")
        let vc = MIEditProfileVC()
        vc.basicProfileInfo = MIProfilePersonalDetailInfo(dictionary: self.personalDetail.dictionary)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func callApi() {
        self.startActivityIndicator()
        MIApiManager.callGetProfileApi{ [weak wSelf = self] (isSuccess, response, error, code) in
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                //                MIActivityLoader.hideLoader()
                
                if isSuccess, let res = response as? [String:Any] {
                    if let errorMsg = res["errorMessage"] as? String{
                       
                        self.showPopUpView(message: errorMsg, primaryBtnTitle: NSLocalizedString("mbdoccapture.createProfileTile", comment: ""), secondaryBtnTitle: NSLocalizedString("mbdoccapture.changeCountry", comment: "")) { (isPrimarBtnClicked) in
                            if isPrimarBtnClicked {
                                    let vc = MICreateProfileVC()
                                    shouldRunProfileApi = true
                                    self.navigationController?.pushViewController(vc, animated: true)

                            }else{
                                    let vc=MISettingHomeViewController()
                                    vc.selectedSettingType = .changecountry
                                    vc.isFromProfileVC = true
                                    self.navigationItem.title = ""
                                    self.navigationController?.pushViewController(vc, animated: true)

                            }
                                
                        }
                        
                        
                        
//                        let vPopup = MIJobPreferencePopup.popup()
//                        vPopup.closeBtn.isHidden = true
//
//                               vPopup.setViewWithTitle(title: "", viewDescriptionText:  errorMsg, or: "", primaryBtnTitle: NSLocalizedString("mbdoccapture.createProfileTile", comment: ""), secondaryBtnTitle:NSLocalizedString("mbdoccapture.changeCountry", comment: ""))
//                               vPopup.completionHandeler = {
//                                let vc = MICreateProfileVC()
//                                shouldRunProfileApi = true
//                                self.navigationController?.pushViewController(vc, animated: true)
//
//                        }
//                               vPopup.cancelHandeler = {
//                                let vc=MISettingHomeViewController()
//                                vc.selectedSettingType = .changecountry
//                                vc.isFromProfileVC = true
//                                self.navigationItem.title = ""
//                                self.navigationController?.pushViewController(vc, animated: true)
//
//                        }
//                               vPopup.addMe(onView: self.view, onCompletion: nil)
                        
                        
                        
                        
//                        
//                        let alert = UIAlertController(title: "", message: errorMsg, preferredStyle: UIAlertController.Style.alert)
//                        let createBtn = UIAlertAction(title: NSLocalizedString("mbdoccapture.createProfileTile", comment: ""), style: .default, handler: { (action: UIAlertAction) in
//                            let vc = MICreateProfileVC()
//                            shouldRunProfileApi = true
//                            self.navigationController?.pushViewController(vc, animated: true)
//                        })
//                        let changeCountryBtn = UIAlertAction(title: NSLocalizedString("mbdoccapture.changeCountry", comment: ""), style: .default, handler: { (action: UIAlertAction) in
//                            let vc=MISettingHomeViewController()
//                            vc.selectedSettingType = .changecountry
//                            vc.isFromProfileVC = true
//                            self.navigationItem.title = ""
//                            self.navigationController?.pushViewController(vc, animated: true)
//                            
//                            //                            vc.title = "Select Country"
//                        })
//                        alert.addAction(createBtn)
//                        alert.addAction(changeCountryBtn)
//                        
//                        // show the alert
//                        self.present(alert, animated: true, completion: nil)
                        //                            AKAlertController.alert("", message: errorMsg, acceptMessage: "Change Country") {
                        //                                let vc=MISettingHomeViewController()
                        //                                vc.selectedSettingType = .changecountry
                        //                                vc.isFromProfileVC = true
                        //                               wSelf?.navigationController?.pushViewController(vc, animated: true)
                        //                                //wSelf?.navigationController?.navigationBar.backItem?.backBarButtonItem
                        //                                //wSelf?.present(MINavigationViewController(rootViewController: vc), animated: true, completion: nil)
                        //                                vc.title = "Select Country"
                        //                            }
                        
                    }
                    wSelf?.parseJson(res: res)
                    wSelf?.personalDetailInfoDict = res
                    self.profileAPISucced?()
                }else{
                    if !MIReachability.isConnectedToNetwork() {
                        self.toastView(messsage: "Please check your internet connection.")
                    }
                }
            }
        }
    }
    
    func callLocalApi() {
        if let res = self.loadJson(filename: "profile_latest") {
            self.modulesArray.removeAll()
            self.parseJson(res: res)
        }
    }
    
    func parseJson(res:[String:Any]) {
        self.modulesArray.removeAll()
        if
            let pendingActionsSec = res["pendingActionSection"] as? [String:Any],
            let pendingActionsDic = pendingActionsSec["pendingActions"] as? [[String:Any]] {
            
            var progress = 100 - pendingActionsDic.reduce(0, { $0+$1.intFor(key: "weightage") })
            progress = progress < 0 ? 0 : progress
            AppUserDefaults.save(value: progress, forKey: .ProfileProgress)
            if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
                tabBar.progress = CGFloat(progress)/100
            }
        }
        if let personalDetailDic = res["personalDetailSection"] as? [String:Any] {
            personalDetail = MIProfilePersonalDetailInfo(dictionary: personalDetailDic)
           
//            if (personalDetail.nationality.countryUuId != personalDetail.additionPersonalInfo?.currentlocation.countryUuId && (personalDetail.additionPersonalInfo?.workVisaType.name ?? "").isEmpty && !personalDetail.nationality.name.isEmpty &&  !(personalDetail.additionPersonalInfo?.currentlocation.name ?? "").isEmpty){
//                personalDetail.additionPersonalInfo?.workVisaType = MICategorySelectionInfo.getDefaultVisaTypeForDontHaveAuthorization()
//            }
            
            AppDelegate.instance.userInfo = personalDetail
            AppDelegate.instance.userInfo.commit()
            
            tblHeader.show(info: self.personalDetail)
            self.updateTableHeaderHeight()
            
        }
        if let personalmanageDic = res["manageProfileSection"] as? [String:Any] {
            if let profile=personalmanageDic["profiles"]as?[[String:Any]]{
                let profileArray=MIExistingProfileInfo.modelsFromDictionaryArray(array: profile)
                let site = AppDelegate.instance.site
                let profileWithSite=profileArray.filter({$0.countryIsoCode==site?.defaultCountryDetails.isoCode && $0.active==true})
                if let first=profileWithSite.first{
                    UserDefaults.standard.set(first.id, forKey:"profileId")
                }
            }
        }
        if let jobPreferenceSection=res["jobPreferenceSection"] as? [String:Any],let data = jobPreferenceSection["jobPreference"] as? [String:Any] {
            if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
                tabBar.jobPreferenceInfo =    MIJobPreferencesModel.getObjectFromModel(params: data)
            }
            
            
        }
        //Add/Edit Skill & IT Skill for job detail matchd data
        if let tabBar = self.tabbarController {
            tabBar.userITPlusNonItSkill.removeAll()
            tabBar.userITPlusNonItSkill = MIUserSkills.getITNonItSkill(params: res)
        }
        
        self.personalDetail = AppDelegate.instance.userInfo
        
        for name in MIProfileEnums.list {
            if name == MIProfileEnums.personalDetail.rawValue {
                let profileModel = MIProfileModels.init(with: [:], moduleName: name)
                profileModel.moduleType = "Custom"
                profileModel.dicModel[name] = self.personalDetail.cellArray
                self.modulesArray.append(profileModel)
            } else if name == MIProfileEnums.strength.rawValue {
                let profileModel = MIProfileModels.init(with: [:], moduleName: name)
                profileModel.moduleType = "Static"
                self.modulesArray.append(profileModel)
            } else if  res.keys.contains(name), let dic = res[name] as? [String:Any] {
                let profileModel = MIProfileModels.init(with: dic, moduleName: name)
                self.modulesArray.append(profileModel)
            } else {
                let profileModel = MIProfileModels.init(with: [:], moduleName: name)
                self.modulesArray.append(profileModel)
            }
        }
        self.tblView.reloadData()
    }
    
}

extension MIProfileViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modulesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = self.modulesArray[section]
        if info.moduleType == "Static" {
            info.numberOfRows = 1
        }
        else if let models = info.dicModel[info.moduleName] as? [Any] {
            if let profileEnumType = MIProfileEnums(rawValue: info.moduleName), !profileEnumType.shouldShowSeeMore {
                info.numberOfRows = models.count
            } else if info.shouldShowAll {
                info.numberOfRows = models.count
            } else {
                let initialMaxCount = 3
                info.numberOfRows = models.count > initialMaxCount ? initialMaxCount : models.count
            }
        }
        
        return info.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let info = self.modulesArray[indexPath.section]
        let sectionTitle = info.moduleName
        
        if sectionTitle == MIProfileEnums.strength.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.strength.rawValue) as? MIProfileStrengthCell {
            let progress = AppUserDefaults.value(forKey: .ProfileProgress, fallBackValue: 0).intValue
            cell.showProgress(percent: progress)
            return cell
        }
        
        if sectionTitle == MIProfileEnums.manageProfileSection.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.manageProfileSection.rawValue) as? MIManageProfileCell {
            return cell
        }
        
        if sectionTitle == MIProfileEnums.resumeSection.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.resumeSection.rawValue) as? MIProfileResumeDetailCell {
            cell.delegate = self
            if let resumeInfo = info.dicModel[info.moduleName] as? MIProfileResumeInfo {
                cell.show(info: resumeInfo)
                cell.uploadResumeAction = { upload in
                    let vc = MIUploadResumeViewController()
                    vc.flowVia = .ViaPendingResume
                    self.navigationController?.pushViewController(vc, animated: false)
                    
                }
            } else {
                cell.showWhenResumeNotAvailabel()
                cell.uploadResumeAction = { upload in
                    let vc = MIUploadResumeViewController()
                    vc.flowVia = .ViaPendingResume
                    self.navigationController?.pushViewController(vc, animated: false)
                    
                }
            }
            
            return cell
        }
        
        if sectionTitle == MIProfileEnums.ITSkill.rawValue, let cell = self.tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.ITSkill.rawValue) as? MIProfileITSkillCell {
            
            if let modelsInfo = info.dicModel[info.moduleName] as? [MIProfileITSkills] {
                cell.show(info: modelsInfo[indexPath.row])
                
                if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
                    tabBar.skill=""
                    tabBar.skill! += modelsInfo.map({$0.skill?.name ?? ""}).joined(separator: ",")
                    
                    //                    //===add itskill
                    //                    tabBar.itSkillsNewArr = []
                    //                    let vc = self.tabBarController as? MIHomeTabbarViewController
                    //                    vc?.itSkillsNewArr = modelsInfo.map({$0.skill?.name ?? ""})
                    
                }
                
                cell.delgate = self
            }
            return cell
        }
        
        if sectionTitle == MIProfileEnums.jobPreference.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.jobPreference.rawValue) as? MIProfileJobPreferenceCell {
            
            if let modelsInfo = info.dicModel[info.moduleName] as? [MIProfileJobPreferenceCellInfo] {
                cell.showJobPreference(info: modelsInfo[indexPath.row])
            }
            return cell
        }
        
        if sectionTitle == MIProfileEnums.personalDetail.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.jobPreference.rawValue) as? MIProfileJobPreferenceCell {
            if let modelsInfo = info.dicModel[info.moduleName] as? [MIProfilePersonalCellInfo] {
                cell.showPersonalDetail(info: modelsInfo[indexPath.row])
            }
            return cell
        }
        
        if sectionTitle == MIProfileEnums.eduExperience.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.project.rawValue) as? MIProfileConnectedCell, let modelsInfo = info.dicModel[info.moduleName] as? [MIEducationInfo] {
            if !modelsInfo[indexPath.row].checkModelIsEmpty() {
                cell.showEducation(info: modelsInfo[indexPath.row])
                if indexPath.row == 0 {
                    cell.hideTopLine()
                }
                if indexPath.row == (info.numberOfRows - 1) {
                    cell.hideLine()
                }
                cell.delegate = self
                return cell
            }
        }
        
        if sectionTitle == MIProfileEnums.awards.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.project.rawValue) as? MIProfileConnectedCell {
            cell.delegate = self
            
            if let modelsInfo = info.dicModel[info.moduleName] as? [MIProfileAward] {
                cell.showAward(info: modelsInfo[indexPath.row])
                if indexPath.row == 0 {
                    cell.hideTopLine()
                }
                if indexPath.row == (info.numberOfRows - 1) {
                    cell.hideLine()
                }
            }
            return cell
        }
        
        if sectionTitle == MIProfileEnums.courses.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.project.rawValue) as? MIProfileConnectedCell {
            cell.delegate = self
            if let modelsInfo = info.dicModel[info.moduleName] as? [MIProfileCoursesInfo] {
                cell.showCourses(info: modelsInfo[indexPath.row])
                if indexPath.row == 0 {
                    cell.hideTopLine()
                }
                if indexPath.row == (info.numberOfRows - 1) {
                    cell.hideLine()
                }
            }
            return cell
        }
        
        if sectionTitle == MIProfileEnums.workExperience.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.project.rawValue) as? MIProfileConnectedCell {
            cell.delegate = self
            if let modelsInfo = info.dicModel[info.moduleName] as? [MIEmploymentDetailInfo] {
                cell.showEmployment(info: modelsInfo[indexPath.row])
                if indexPath.row == 0 {
                    cell.hideTopLine()
                }
                if indexPath.row == (info.numberOfRows - 1) {
                    cell.hideLine()
                }
            }
            return cell
        }
        
        if sectionTitle == MIProfileEnums.project.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.project.rawValue) as? MIProfileConnectedCell {
            cell.delegate = self
            if let modelsInfo = info.dicModel[info.moduleName] as? [MIProfileProjectInfo] {
                cell.showProjects(info: modelsInfo[indexPath.row])
                if indexPath.row == 0 {
                    cell.hideTopLine()
                }
                if indexPath.row == (info.numberOfRows - 1) {
                    cell.hideLine()
                }
            }
            return cell
        }
        
        
        if sectionTitle == MIProfileEnums.skill.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.skill.rawValue) as? MIProfileSkillCell {
            
            if let skills = info.dicModel[info.moduleName] as? [MIUserSkills] {
                
                cell.delegate = self
                let ss = skills.filter({$0.skillName != ""})
                
                
                if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
                    
                    //===add skill
                    //                    tabBar.skillsNewArr = []
                    //                    for s in ss {
                    //                        let n = s.skillName
                    //                        tabBar.skillsNewArr.append(n)
                    //                    }
                    
                    
                    if tabBar.skill == nil{
                        tabBar.skill = ""
                    }
                    for (index,item) in ss.enumerated(){
                        
                        
                        if tabBar.skill!.contains(item.skillName){
                            
                            tabBar.skill! += item.skillName
                            if index != ss.count-1{
                                tabBar.skill! += ","
                            }
                        }
                    }
                    
                }
                cell.addSuggestionList(list: ss)
                
            } else {
                cell.addSuggestionList(list: [MIUserSkills]())
            }
            
            return cell
        }
        
        if sectionTitle == MIProfileEnums.otherDetail.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.otherDetail.rawValue) as? MIProfileOtherDetailCell, let modelsInfo = info.dicModel[info.moduleName] as? [MIProfileInfo] {
            
            cell.show(info: modelsInfo[indexPath.row])
            return cell
        }
        
        if sectionTitle == MIProfileEnums.onlinePresence.rawValue,
            let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.onlinePresence.rawValue) as? MIProfileSocialLinkCell , let modelsInfo = info.dicModel[info.moduleName] as? [MIProfileOnlinePresence] {
            
            cell.show(info: modelsInfo[indexPath.row])
            if indexPath.row == 0 {
                cell.hideTopLine()
            }
            if indexPath.row == (info.numberOfRows - 1) {
                cell.hideLine()
            }
            cell.delegate = self
            cell.socialDelegate = self
            return cell
        }
        
        if sectionTitle == MIProfileEnums.language.rawValue, let cell = tblView.dequeueReusableCell(withIdentifier: MIProfileEnums.language.rawValue) as? MIProfileLanguageCell {
            if let modelsInfo = info.dicModel[info.moduleName] as? [MIProfileLanguageInfo] {
                cell.delegate = self
                cell.show(info: modelsInfo[indexPath.row])
                if indexPath.row == 0 {
                    cell.hideTopLine()
                }
                if indexPath.row == (info.numberOfRows - 1) {
                    cell.hideLine()
                }
            }
            
            return cell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let info = self.modulesArray[indexPath.section]
        if let headerEnum = MIProfileEnums(rawValue: info.moduleName) {
            if headerEnum == MIProfileEnums.manageProfileSection {
                CommonClass.googleEventTrcking("profile_screen", action: "manage_profiles", label: "")
                let vc = MIManageProfileViewController()
                if let modelsInfo = info.dicModel[info.moduleName] as? [MIExistingProfileInfo] {
                    vc.existingProfileModels = modelsInfo
                }
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let info = self.modulesArray[indexPath.section]
        
        if let eduInfo = info.dicModel[info.moduleName] as? [MIEducationInfo],
            eduInfo.count > indexPath.row,
            eduInfo[indexPath.row].checkModelIsEmpty() {
            return 0
        }
        
        if let workExpInfo = info.dicModel[info.moduleName] as? [MIEmploymentDetailInfo],
            workExpInfo.count > indexPath.row,
            workExpInfo[indexPath.row].checkModelIsEmpty() {
            return 0
        }
        
        if let modelInfo = info.dicModel[info.moduleName] as? [Any],modelInfo.count == 0 {
            return 0
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let info = self.modulesArray[section]
        let header = MIProfileHeaderView.header
        if let headerEnum = MIProfileEnums(rawValue: info.moduleName) {
            header.profileType = headerEnum
            header.delegate = self
            header.show(shouldShowSubTtl: info.numberOfRows > 0 ? false: true)
            if headerEnum == MIProfileEnums.jobPreference {
                if info.numberOfRows == 0 {
                    header.showAddBtn()
                } else {
                    header.showEditBtn()
                }
            }
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let info = self.modulesArray[section]
        let header = MIProfileHeaderView.header
        if let headerEnum = MIProfileEnums(rawValue: info.moduleName) {
            header.profileType = headerEnum
            header.show()
            if !headerEnum.headerTitle.isEmpty {
                return UITableView.automaticDimension
            }
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let info = self.modulesArray[section]
        if let headerEnum = MIProfileEnums(rawValue: info.moduleName), headerEnum.shouldShowSeeMore {
            if let modelsInfo = info.dicModel[info.moduleName] as? [Any],modelsInfo.count > 3 {
                let footer = MIProfileSeeMoreFooter.view
                footer.delegate = self
                footer.tag = 10 + section
                footer.showSeeMore(shouldShowSeeMore: info.shouldShowAll)
                return footer
            }
        }
        
        return MIEmptyHeader.header
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let info = self.modulesArray[section]
        if let headerEnum = MIProfileEnums(rawValue: info.moduleName) {
            if headerEnum.shouldShowSeeMore, let modelsInfo = info.dicModel[info.moduleName] as? [Any],modelsInfo.count > 3 {
                return 60
            }
            if headerEnum == MIProfileEnums.manageProfileSection {
                return 0
            }
        }
        
        return 8
    }
    
    
}


extension MIProfileViewController:MIProfileSkillCellDelegate,MIProfileSeeMoreFooterDelegate,MIProfileConnectedCellDelegate,MIProifleITSkillCellDelegate,MIPopOverControllerDelegate, MIProfileSocialLinkCellDelegate,MIProfileLanguageCellDelegate {
    
    // MARK :- MIProfileSocialLinkCellDelegate
    func socialLinkClicked(link: String) {
        
        let url = (link.hasPrefix("http://") || link.hasPrefix("https://") ) ? link : "http://" + link
        if let newUrl = URL(string: url) {
            UIApplication.shared.open(newUrl)
        }
        //        if !link.isEmpty {
        //            if url.canOpenURL() {
        //                let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
        //                vc.url = url
        //                vc.ttl = "Online Presence"
        //                let nav = MINavigationViewController(rootViewController: vc)
        //                nav.modalPresentationStyle = .fullScreen
        ////                self.present(nav, animated: true, completion: nil)
        //            } else {
        //                self.showAlert(title: "", message: "Not a valid url")
        //            }
        ////        }
    }
    
    func imageOptionAction() {
        
        if let homeTabBar = self.tabBarController as? MIHomeTabbarViewController {
            homeTabBar.showActionSheetForUserSelection(personalDetail: self.personalDetail)
        }
        
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        print(sourceView.bounds)
        presentationController.sourceRect = CGRect(x: 14, y: 0, width: 4, height: 30)
        
        presentationController.canOverlapSourceViewRect = true
        presentationController.permittedArrowDirections = [.up]
        
        self.present(controller, animated: true)
    }
    
    func showDeleteAlert(completion:@escaping ((Bool)) -> Void) {
        self.showPopUpView( message: ExtraResponse.deleteAlert, primaryBtnTitle: "Yes", secondaryBtnTitle: "No") { (isPrimarBtnClicked) in
                if isPrimarBtnClicked {
                    completion(true)

                }else{
                    completion(false)

                }
                  
        }
        
        
//        let vPopup = MIJobPreferencePopup.popup()
//        vPopup.setViewWithTitle(title: "", viewDescriptionText:  ExtraResponse.deleteAlert, or: "", primaryBtnTitle: "Yes", secondaryBtnTitle: "No")
//        vPopup.completionHandeler = {
//            completion(true)
//        }
//        vPopup.cancelHandeler = {
//            completion(false)
//        }
//        vPopup.addMe(onView: self.view, onCompletion: nil)
        
    }
    // MARK: MIPopOverControllerDelegate
    func popOverClicked(actionType: MIProfileActionEnum, info: Any, profileType: MIProfileEnums) {
        
        // ITSkill Clicked
        if profileType == MIProfileEnums.ITSkill {
            if actionType == .edit {
                CommonClass.googleEventTrcking("profile_screen", action: "it_skills", label: "edit")
                
                let vc = MIITSkillsVC()
                if let itSkillInfo = info as? MIProfileITSkills {
                    vc.itSkillInfo = itSkillInfo.copy() as? MIProfileITSkills
                }
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                CommonClass.googleEventTrcking("profile_screen", action: "it_skills", label: "delete")
                
                self.showDeleteAlert { (action) in
                    if action {
                       // var id = ""
                        if let itSkillInfo = info as? MIProfileITSkills {
                           // id = itSkillInfo.id
                            
                            //                            //===delete it skill
                            //                            let name = itSkillInfo.skill?.name
                            //                            let tabVC = self.tabBarController as? MIHomeTabbarViewController
                            //                            let n = tabVC?.itSkillsNewArr.filter({$0 != name})
                            //                            tabVC?.itSkillsNewArr = n ?? []
                            let param = [ "ids" : [itSkillInfo.id] ]
                            
                            MIApiManager.deleteSkill(param) { (result, error) in
                                guard let data = result else { return }
                                self.fieldTrackingIfFucntionIsIT()
                                //JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.IT_SKILLS]
                                self.showAlert(title: "", message: data.successMessage,isErrorOccured:false)
                                if let tabbar = self.tabbarController {
                                    let skills = tabbar.userITPlusNonItSkill.filter({$0.id.lowercased() != itSkillInfo.id })
                                    tabbar.userITPlusNonItSkill = skills
                                }
                                shouldRunProfileApi = true
                                self.callApi()
                           //     self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }
            }
        }
        // Project clicked
        if profileType  == MIProfileEnums.project {
            if actionType == .edit {
                CommonClass.googleEventTrcking("profile_screen", action: "projects", label: "edit")
                let vc = MIProjectDetailVC()
                if let info = info as? MIProfileProjectInfo {
                    vc.projectInfo = info
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                CommonClass.googleEventTrcking("profile_screen", action: "projects", label: "delete")
                self.showDeleteAlert { (action) in
                    if action {
                        var id = ""
                        if let projInfo = info as? MIProfileProjectInfo {
                            id = projInfo.id
                        }
                        
                        let param = [
                            "id" : id
                            ] as [String : Any]
                        
                        MIApiManager.deleteProject(.delete, param: param) {  (result, error) in
                            guard let data = result else { return }
                            JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.PROJECTS]
                            
                            self.showAlert(title: nil, message: data.successMessage,isErrorOccured:false)
                            shouldRunProfileApi = true
                            self.callApi()
                      //      self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        
        // eduExperience clicked
        if profileType  == MIProfileEnums.eduExperience {
            if actionType == .edit {
                CommonClass.googleEventTrcking("profile_screen", action: "educational_experience", label: "edit")
                let vc = MIEducationDetailViewController()
                vc.educationFlow = .ViaProfileEdit
                if let eduInfo = (info as? MIEducationInfo)?.copy() as? MIEducationInfo {
                    vc.qualificationArray = [eduInfo]
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                CommonClass.googleEventTrcking("profile_screen", action: "educational_experience", label: "delete")
                self.showDeleteAlert { (action) in
                    if action {
                        var id = ""
                        if let eduInfo = info as? MIEducationInfo {
                            id = eduInfo.educationId
                        }
                        
                        let param = [
                            "id" : id
                            ] as [String : Any]
                        
                        MIApiManager.deleteEducationDetails(.delete, param: param) { [weak self] (result, error) in
                            guard let wkSelf=self else {return}
                            guard let data = result else { return }
                            JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.EDUCATION]
                            
                            wkSelf.showAlert(title: nil, message: data.successMessage,isErrorOccured:false)
                            shouldRunProfileApi = true
                            wkSelf.callApi()
                          //  wkSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
            }
        }
        
        // workExperience clicked
        if profileType  == MIProfileEnums.workExperience {
            if actionType == .edit {
                CommonClass.googleEventTrcking("profile_screen", action: "work_experiences", label: "edit")
                let vc = MIEmploymentDetailViewController.newInstance
                vc.employementFlow = .ViaProfileEdit
                if let empInfo = (info as? MIEmploymentDetailInfo)?.copy() as? MIEmploymentDetailInfo {
                    vc.empDetailArray = [empInfo]
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                CommonClass.googleEventTrcking("profile_screen", action: "work_experiences", label: "delete")
                
                self.showDeleteAlert { (action) in
                    if action {
                        var id = ""
                        if let empInfo = info as? MIEmploymentDetailInfo {
                            id = empInfo.employmentId
                        }
                        
                        let param = [
                            "id" : id
                            ] as [String : Any]
                        
                        MIApiManager.deleteEmploymentDetails(.delete, param: param) { [weak self] (result, error) in
                            guard let wkSelf=self else {return}
                            guard let data = result else { return }
                            
                            if let empInfo = info as? MIEmploymentDetailInfo {
                                var fieldUpdate = [String]()
                                if empInfo.isCurrentEmplyement {
                                    fieldUpdate.append(CONSTANT_FIELD_LEVEL_NAME.CUR_DESIGNATION)
                                    fieldUpdate.append(CONSTANT_FIELD_LEVEL_NAME.CUR_SALARY)
                                    fieldUpdate.append(CONSTANT_FIELD_LEVEL_NAME.NOTICE_PERIOD)
                                    if empInfo.offeredSalaryModal.salaryInLakh.count > 0 ||  empInfo.offeredSalaryModal.salaryThousand.count > 0 {
                                        fieldUpdate.append(CONSTANT_FIELD_LEVEL_NAME.OFFERED_SALARY)
                                    }
                                    
                                }else{
                                    fieldUpdate.append(CONSTANT_FIELD_LEVEL_NAME.WORK_HISTORY)
                                }
                                JobSeekerSingleton.sharedInstance.fieldLevelDataArray = fieldUpdate
                            }
                            
                            wkSelf.showAlert(title: nil, message: data.successMessage,isErrorOccured:false)
                            shouldRunProfileApi = true
                            wkSelf.callApi()
                            
                        //    wkSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
            }
        }
        
        if profileType  == MIProfileEnums.onlinePresence {
            if actionType == .edit {
                CommonClass.googleEventTrcking("profile_screen", action: "online_presence", label: "edit")
                let vc = MIOnlinePresenceVC()
                if let onlineInfo = info as? MIProfileOnlinePresence {
                    vc.data = onlineInfo
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                CommonClass.googleEventTrcking("profile_screen", action: "online_presence", label: "delete")
                self.showDeleteAlert { (action) in
                    if action {
                        var id = ""
                        if let presenceInfo = info as? MIProfileOnlinePresence {
                            id = presenceInfo.id
                        }
                        
                        let param = [
                            "ids" : [id]
                            ] as [String : Any]
                        
                        MIApiManager.deleteOnlinePresence(param) { [weak self] (result, error) in
                            guard let wkSelf=self else {return}
                            guard let data = result else { return }
                            wkSelf.showAlert(title: nil, message: data.successMessage,isErrorOccured:false)
                            shouldRunProfileApi = true
                            wkSelf.callApi()
                     //       wkSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
            }
        }
        
        if profileType  == MIProfileEnums.awards {
            if actionType == .edit {
                CommonClass.googleEventTrcking("profile_screen", action: "awards_achievements", label: "edit")
                let vc = MIAwardsAchievementVC()
                if let awardInfo = info as? MIProfileAward {
                    vc.data = awardInfo
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                CommonClass.googleEventTrcking("profile_screen", action: "awards_achievements", label: "delete")
                
                self.showDeleteAlert { (action) in
                    if action {
                        var id = ""
                        if let awardInfo = info as? MIProfileAward {
                            id = awardInfo.id
                        }
                        
                        let param = [
                            "id" : id
                            ] as [String : Any]
                        
                        MIApiManager.deleteAwards(param) { [weak self] (result, error) in
                            guard let wkSelf=self else {return}
                            guard let data = result else { return }
                            wkSelf.showAlert(title: nil, message: data.successMessage,isErrorOccured:false)
                            shouldRunProfileApi = true
                            wkSelf.callApi()
                       //     wkSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
            }
        }
        
        if profileType  == MIProfileEnums.courses {
            if actionType == .edit {
                CommonClass.googleEventTrcking("profile_screen", action: "courses_certifications", label: "edit")
                
                let vc = MICoursesCertificatinVC()
                if let courseInfo = info as? MIProfileCoursesInfo {
                    vc.data = courseInfo
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                CommonClass.googleEventTrcking("profile_screen", action: "courses_certifications", label: "delete")
                self.showDeleteAlert { (action) in
                    if action {
                        var id = ""
                        if let courseInfo = info as? MIProfileCoursesInfo {
                            id = courseInfo.id
                        }
                        
                        let param = [
                            "id" : id
                            ] as [String : Any]
                        
                        MIApiManager.deleteCourseNCertification(param) { [weak self] (result, error) in
                            guard let wkSelf=self else {return}
                            guard let data = result else { return }
                            JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.COURES_CERTS]
                            
                            wkSelf.showAlert(title: nil, message: data.successMessage,isErrorOccured:false)
                            shouldRunProfileApi = true
                            wkSelf.callApi()
                        //    wkSelf.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
        
        if profileType  == MIProfileEnums.language {
            if actionType == .edit {
                CommonClass.googleEventTrcking("profile_screen", action: "language_known", label: "edit")
                let vc = MIProfileLanguageVC()
                if let modelInfo = info as? MIProfileLanguageInfo {
                    vc.languageInfo = modelInfo.copy() as? MIProfileLanguageInfo
                    vc.isUpdating   = true
                }
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                CommonClass.googleEventTrcking("profile_screen", action: "language_known", label: "delete")
                self.showDeleteAlert { (action) in
                    if action {
                        var id = ""
                        if let langInfo = info as? MIProfileLanguageInfo {
                            id = langInfo.languageId
                        }
                        
                        let param = [
                            "id" : id
                            ] as [String : Any]
                        
                        MIApiManager.deleteProfileLanguage(param) { [weak self] (result, error) in
                            guard let wkSelf=self else {return}
                            guard let data = result else { return }
                            JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.LANG_KNOWN]
                            
                            wkSelf.showAlert(title: nil, message: data.successMessage,isErrorOccured:false)
                            shouldRunProfileApi = true
                            wkSelf.callApi()
                        }
                    }
                }
            }
        }
    }
    func fieldTrackingIfFucntionIsIT(){
        if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
            if tabBar.jobPreferenceInfo.preferredFunctions.filter({ $0.name.withoutWhiteSpace().hasPrefix("IT")}).count > 0 {
                JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.IT_SKILLS]
            }
        }
    }
    // MARK:- MIProifleITSkillCellDelegate
    func itSkillClicked(info: MIProfileITSkills, sender: UIView) {
        let controller = MIPopOverController()
        controller.profileType  = MIProfileEnums.ITSkill
        controller.preferredContentSize = popOverContentSize
        controller.delegate = self
        controller.info     = [info]
        showPopup(controller, sourceView: sender)
    }
    
    func languageEditClicked(modelInfo: Any, sender: UIView) {
        
        let controller = MIPopOverController()
        controller.profileType  = MIProfileEnums.language
        controller.preferredContentSize = popOverContentSize
        controller.delegate = self
        if let info = modelInfo as? MIProfileLanguageInfo {
            controller.info     = [info]
        }
        showPopup(controller, sourceView: sender)
    }
    
    // MARK:- MIProfileConnectedCellDelegate
    func connectedCellEditClicked(type: MIProfileEnums, modelInfo: [Any], sender: UIView) {
        let controller = MIPopOverController()
        
        controller.preferredContentSize = popOverContentSize
        controller.delegate = self
        
        if type  == .project {
            controller.profileType  = MIProfileEnums.project
            if let info = modelInfo.first as? MIProfileProjectInfo {
                controller.info     = [info]
            }
        }
        
        if type  == .eduExperience {
            controller.profileType  = MIProfileEnums.eduExperience
            if let info = modelInfo.first as? MIEducationInfo {
                controller.info     = [info]
            }
        }
        if type  == .workExperience {
            controller.profileType  = MIProfileEnums.workExperience
            if let info = modelInfo.first as? MIEmploymentDetailInfo {
                controller.info     = [info]
            }
        }
        
        if type == .onlinePresence {
            controller.profileType  = MIProfileEnums.onlinePresence
            if let info = modelInfo.first as? MIProfileOnlinePresence {
                controller.info     = [info]
            }
            
        }
        
        if type == .awards {
            controller.profileType  = MIProfileEnums.awards
            if let info = modelInfo.first as? MIProfileAward {
                controller.info     = [info]
            }
        }
        
        if type == .courses {
            controller.profileType  = MIProfileEnums.courses
            if let info = modelInfo.first as? MIProfileCoursesInfo {
                controller.info     = [info]
            }
        }
        
        showPopup(controller, sourceView: sender)
    }
    
    
    
    func skillRemoved(skillName: String) {
        CommonClass.googleEventTrcking("profile_screen", action: "skills", label: "cross")
        
        var sectionIndex = 0
        for info in self.modulesArray {
            if info.moduleName == MIProfileEnums.skill.rawValue {
                break
            }
            sectionIndex = sectionIndex + 1
        }
        
        let info = self.modulesArray[sectionIndex]
        if let skills = info.dicModel[info.moduleName] as? [MIUserSkills] {
            var skillInfo = MIUserSkills(dictionary: [:])
            for skill in skills {
                if skill.skillName == skillName {
                    skillInfo = skill
                    break
                }
            }
            
            var skillparam = [String:Any]()
            skillparam["ids"] = [skillInfo?.id]
            
            
            self.startActivityIndicator()
            MIApiManager.callAPIForDeleteSkills(methodType: .delete, path: APIPath.skillAddUpdateDeleteAPIEndpoint, params: skillparam)  { (success, response, error, code) in
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    if error == nil && (code >= 200) && (code <= 299) {
                        
                        //Add+Edit Skill & IT Skill for job detail matched data
                        if let tabVC = self.tabbarController {
                            let skills = tabVC.userITPlusNonItSkill.filter({$0.id.lowercased() != skillInfo?.id.lowercased()})
                            tabVC.userITPlusNonItSkill = skills
                        }
                        shouldRunProfileApi = true
                        JobSeekerSingleton.sharedInstance.fieldLevelDataArray = [CONSTANT_FIELD_LEVEL_NAME.KEY_SKILLS]
                        if let  result = response as? [String:Any] {
                            if let message = result["successMessage"] as? String , message.count > 0  {
                                self.showAlert(title: "", message: message, isErrorOccured: false)
                            }
                        }
                        self.callApi()
                    } else if let res = response as? JSONDICT {
                        self.showAlert(title: "", message: res["errorMessage"] as? String ?? "",isErrorOccured:true)

                      //  AKAlertController.alert(res["errorCode"] as? String, message: res["errorMessage"] as? String ?? "")
                    }
                    
                }
            }
        }
        self.tblView.reloadSections(IndexSet(integer: sectionIndex), with: .none)
    }
    
    func footerClicked(modelIndex: Int) {
        let selectedModelIndex = modelIndex - 10
        if self.modulesArray.count > selectedModelIndex {
            let info  = self.modulesArray[selectedModelIndex]
            if info.moduleName == "personalDetailSection" {
                let vc = MIPersonalDetailVC.newInstance
                vc.personalDict = personalDetailInfoDict
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                info.shouldShowAll = !info.shouldShowAll
            }
            //          self.tblView.reloadSections(IndexSet(integer: selectedModelIndex), with: .top)
            UIView.animate(withDuration: 0.3) {
                self.tblView.reloadData()
            }
        }
        
    }
}

extension MIProfileViewController:MIProfileTableHeaderDelegate,PendingActionDelegate {
    
    // MARK:- PendingActionDelegate
    func verifiedUser(_ id: String, openMode: OpenMode) {
        //        if openMode == .verifyMobileNumber {
        //            self.personalDetail.mobileNumberVerifedStatus = true
        //        } else {
        //            self.personalDetail.emailVerifedStatus = true
        //        }
        //        self.tblHeader.show(info: self.personalDetail)
    }
    
    // MARK:- MIProfileTableHeaderDelegate
    func settingBtnAction() {
        CommonClass.googleEventTrcking("profile_screen", action: "settings", label: "")
        
        MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SETTINGS, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: "", destination: CONSTANT_SCREEN_NAME.PROFILE_SCREEN) { (success, response, error, code) in
        }
        
        let vc = MISettingMainViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func emailVerifyClicked() {
        CommonClass.googleEventTrcking("profile_screen", action: "email_verify", label: "")
        let emailVC = MIVerifyEmailTemplateViewController()
        emailVC.userEmail = self.personalDetail.primaryEmail
        self.navigationController?.pushViewController(emailVC, animated: true)
    }
    
    func mobileVerifyClicked() {
        CommonClass.googleEventTrcking("profile_screen", action: "mobile_verify", label: "")
        let mobileChange = MIOTPViewController()
        mobileChange.openMode = .verifyMobileNumber
        mobileChange.delegate = self
        mobileChange.countryCode = self.personalDetail.countryCode
        mobileChange.userName = self.personalDetail.mobileNumber
        self.navigationController?.pushViewController(mobileChange, animated: true)
        
    }
    
    func enlargeImgeAction() {
        if let image = self.tblHeader.profileImgView.image {


            let imgView = UIImageView(image: image)
            
            imgView.image = image
            imgView.contentMode = .scaleAspectFit
            imgView.clipsToBounds = true
         //   guard let cell = self.tableViewProfileVisibility.cellForRow(at: IndexPath(row: 0, section: 0)) as? MIProfileVisibilityTableViewCell else { return }

            let view = UIView(frame:CGRect(x: self.tblHeader.profileImgView.center.x-(self.tblHeader.profileImgView.frame.size.width/2), y: self.tblHeader.profileImgView.center.y-(self.tblHeader.profileImgView.frame.size.height/2), width: self.tblHeader.profileImgView.frame.size.width, height: self.tblHeader.profileImgView.frame.size.height))
            view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            view.isUserInteractionEnabled = true
            view.addTapGestureRecognizer { (tapsender) in
                
                view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
                UIView.animate(withDuration: 0.70, delay: 0.4, options: .allowUserInteraction, animations: {
                 //   imgView.circular(0, borderColor: UIColor(hex: "ffffff"))
                    imgView.alpha = 0.0
                    view.frame = CGRect(x: self.tblHeader.profileImgView.center.x-(self.tblHeader.profileImgView.frame.size.width/2), y: self.tblHeader.profileImgView.center.y-(self.tblHeader.profileImgView.frame.size.height/2), width: self.tblHeader.profileImgView.frame.size.width, height: self.tblHeader.profileImgView.frame.size.height)
                    view.circular(4, borderColor: UIColor(hex: "ffffff"))
                    view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                    imgView.frame = CGRect(x: self.tblHeader.profileImgView.center.x-(self.tblHeader.profileImgView.frame.size.width/2), y: self.tblHeader.profileImgView.center.y-(self.tblHeader.profileImgView.frame.size.height/2), width: self.tblHeader.profileImgView.frame.size.width, height: self.tblHeader.profileImgView.frame.size.height)
                    imgView.circular(4, borderColor: UIColor(hex: "ffffff"))

                }) { (status) in
                    view.removeFromSuperview()

                }

            }
            view.roundCorner(2, borderColor: UIColor(hex: "ffffff"), rad: 2)
            view.addSubview(imgView)
            let rootView = kAppDelegate.window
            rootView?.addSubview(view)
            UIView.animate(withDuration: 0.70) {
                
                if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
                    view.frame = CGRect(x: 0, y: 0, width: tabBar.view.frame.width, height: kAppDelegate.window?.frame.size.height ?? kScreenSize.height)
                    let yPosition = view.frame.height/2  - view.frame.width/2

                    imgView.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.width)
                    imgView.circular(4, borderColor: UIColor(hex: "ffffff"))
                    view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
                    
                }

                               }

            
//            let imgView = UIImageView(image: image)
//
//            imgView.image = image
//            imgView.contentMode = .scaleAspectFit
//            imgView.clipsToBounds = true
//
//            let view = UIView(frame:self.tblHeader.profileImgView.frame)
//            view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
//            view.isUserInteractionEnabled = true
//            view.addTapGestureRecognizer { (tapsender) in
//
//                view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
//                UIView.animate(withDuration: 0.70, delay: 0.4, options: .allowUserInteraction, animations: {
//
//                    view.frame = self.tblHeader.profileImgView.frame
//                    view.circular(4, borderColor: UIColor(hex: "ffffff"))
//                    view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//                    imgView.frame = self.tblHeader.profileImgView.frame
//
//                }) { (status) in
//                    view.removeFromSuperview()
//
//                }
//
//            }
//            view.roundCorner(2, borderColor: UIColor(hex: "ffffff"), rad: 2)
//            view.addSubview(imgView)
//            let rootView = kAppDelegate.window
//            rootView?.addSubview(view)
//            UIView.animate(withDuration: 0.70) {
//
//                if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
//                    view.frame = CGRect(x: 0, y: 0, width: tabBar.view.frame.width, height: kAppDelegate.window?.frame.size.height ?? kScreenSize.height)
//
//                    let yPosition = view.frame.height/2  - image.size.height/2
//
//                    imgView.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: image.size.height)
//                    view.backgroundColor = UIColor.black.withAlphaComponent(0.9)
//
//                }
//
//                               }
            }

    }
   
    func headerAddEditClicked(headerType: MIProfileEnums) {
        
        
        if headerType == MIProfileEnums.workExperience {
            CommonClass.googleEventTrcking("profile_screen", action: "work_experiences", label: "add")
            let vc = MIEmploymentDetailViewController.newInstance
            vc.employementFlow = .ViaProfileAdd
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if headerType == MIProfileEnums.eduExperience {
            CommonClass.googleEventTrcking("profile_screen", action: "educational_experience", label: "add")
            let vc = MIEducationDetailViewController()
            vc.educationFlow = .ViaProfileAdd
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if headerType == MIProfileEnums.project {
            CommonClass.googleEventTrcking("profile_screen", action: "projects", label: "add")
            let vc = MIProjectDetailVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if headerType == MIProfileEnums.ITSkill {
            CommonClass.googleEventTrcking("profile_screen", action: "it_skills", label: "add")
            let vc = MIITSkillsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if headerType == MIProfileEnums.courses {
            CommonClass.googleEventTrcking("profile_screen", action: "courses_certifications", label: "add")
            let vc = MICoursesCertificatinVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if headerType == MIProfileEnums.awards {
            CommonClass.googleEventTrcking("profile_screen", action: "awards_achievements", label: "add")
            let vc = MIAwardsAchievementVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if headerType == MIProfileEnums.onlinePresence {
            CommonClass.googleEventTrcking("profile_screen", action: "online_presence", label: "add")
            let vc = MIOnlinePresenceVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if headerType == MIProfileEnums.personalDetail {
            CommonClass.googleEventTrcking("profile_screen", action: "personal_details", label: "edit ")
            let vc = MIPersonalDetailVC.newInstance
            vc.personalDict = personalDetailInfoDict
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if headerType == MIProfileEnums.skill {
            CommonClass.googleEventTrcking("profile_screen", action: "skills", label: "add")
            let vc = MISkillAddViewController()
            vc.flowVia = .ViaProfileAdd
            var info = MIProfileModels(with: [:], moduleName: "Skill")
            for module in self.modulesArray {
                if module.moduleName == MIProfileEnums.skill.rawValue {
                    info = module
                    break
                }
            }
            if let skills = info.dicModel[info.moduleName] as? [MIUserSkills] {
                vc.selectedSkills = skills
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        if headerType == MIProfileEnums.jobPreference {
            CommonClass.googleEventTrcking("profile_screen", action: "job_preferences", label: "edit")
            var info = MIProfileModels(with: [:], moduleName: "Skill")
            for module in self.modulesArray {
                if module.moduleName == MIProfileEnums.jobPreference.rawValue {
                    info = module
                    break
                }
            }
            let vc = MIJobPreferenceViewController()
            vc.isFormFreshOrExper =  ProfessionalDetailsEnum.Experienced
            vc.flowVia            = .ViaProfileAdd
            if let jobPreference = info.model as? [MIProfilePreferenceInfo],jobPreference.count > 0 {
                if let preferenceInfo = jobPreference.first {
                    vc.jobPreferenceModel = MIJobPreferencesModel.getProfileJobPreferenceModel(obj: preferenceInfo)
                    vc.flowVia            = .ViaProfileEdit
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //MARK:- For Language
        if headerType == MIProfileEnums.language {
            CommonClass.googleEventTrcking("profile_screen", action: "language_known", label: "add")
            let vc = MIProfileLanguageVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
}



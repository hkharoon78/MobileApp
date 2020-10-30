//
//  MIHomeViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 26/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import AVKit
import MessageUI
import MaterialShowcase
import Firebase

let jobPostedOn="This job is posted on Company website.Would you like to Apply it from there?"
var isPendingActionUpdated = false
var covid19Flag = false

class homeModel: NSObject
{
    var position = "0"
    var moduleName = ""
    var placeHolder = ""
    var aliasName   = ""
    
    init(with dic:[String:Any]) {
        position = dic.stringFor(key: "position")
        placeHolder = dic.stringFor(key: "placeholder")
        aliasName = dic.stringFor(key: "alias")
        moduleName = dic.stringFor(key: "name")
    }
}


enum MIHomeModuleEnums:String,CaseIterable {
    
    case jobTrack          = "MODULE_USER_JOB_TRACK"
    case pendingAction     = "MODULE_USER_PENDING_ACTIONS"
    case recomondedJob     = "MODULE_USER_RECOMMENDED_JOBS2"
    case jobCategory       = "MODULE_JOBS_BY_CATEGORY_MENU"
    case employemnentIndex = "MODULE_EMPLOYMENT_INDEX"
    case careerService     = "MODULE_CAREER_SERVICES"
    case reports           = "MODULE_REPORTS"
    case monsterEducation  = "MODULE_COURSE_AND_CERTIFICATION"
    case videos            = "MODULE_VIDEOS"
    case article           = "MODULE_BLOG"
    case covid19           = "MODULE_COVID19"
    case GleacSkill        = "MODULE_USER_GLEAC_REPORT"
    case topCompanies      = "MODULE_JOBS_BY_TOP_COMPANIES"
    
    var headerTitle:String {
        switch self {
        case .pendingAction:
            return "Pending Action Items"
        case .jobCategory:
            return "Jobs by Category"
        case .recomondedJob:
            return "Recommended Jobs"
        case .jobTrack:
            return "Jobs by Category"
        case .careerService:
            return "Career Services"
        case .monsterEducation:
            return "Monster Education"
        case .videos:
            return "Expert Speaks"
        case .article:
            return "Career Advice & Tips"
        case .topCompanies:
            return "Jobs by Top Companies"
        default:
            return ""
        }
    }
    
    var showTitleNo:Bool {
        switch self {
        case .recomondedJob:
            return true
        default:
            return false
        }
    }
    
    var showViewAll:Bool {
        switch self {
        case .recomondedJob:
            return true
        case .videos:
            return true
        default:
            return false
        }
    }
    
    var font:UIFont {
        switch self {
        case .pendingAction:
            return UIFont(name: FontName.Medium.rawValue, size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        default:
            return UIFont(name: FontName.Semibold.rawValue, size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .semibold)
        }
    }
    
    var titleColor:UIColor {
        switch self {
        case .pendingAction:
            return UIColor(hex: "637381")
        default:
            return UIColor(hex: "212b36")
        }
    }
    
}

class MIHomeViewController: MIBaseViewController, CompanyDetailsDelegate {
    
    var isPushed = false
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MIHomeViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Color.colorDarkBlack
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        self.callApi()
        refreshControl.endRefreshing()
    }
    
    //override var myApplySuccessStoredProperty: String
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnCovid: UIButton!
    
    lazy var searchBarRect : CGRect = CGRect(x: 0, y: 0, width:Double(self.view.frame.size.width-150), height: 30)
    lazy var searchBar:MISearchBar = MISearchBar(frame:searchBarRect)
    
    let showcase = MaterialShowcase()
    let notificationTitleView          = MINotificationIconView()
    
    private let scrollCellId           = "homeScrollCell"
    private let pendingActionCellId    = "pendingActionCell"
    private let jobCellId              = "jobCell"
    private let kTitleKey              = "title"
    private let kTableRowHasData       = "TableContainData"
    
    var recomendedJobBySearch: JoblistingBaseModel?
    private let homeFooter             = MIHomeBeSafeHeaderView.header
    var modulesArray = [MIHomeModel]()
    private var jobInfo = MIJobStatusInfo.init(with: "20", ttlAppliedJobCount: "234", ttlJobAlertCont: "45")
    private var shouldAllowInteraction = false
    var spamMail = "spam@monsterindia.com"
    var navigateToJobDetailViaPushComes = ""
    //    {
    //        didSet {
    //             let vc = MIJobDetailsViewController()
    //             vc.delegate=self
    //             vc.jobId = navigateToJobDetailViaPushComes
    //             self.navigationController?.pushViewController(vc, animated: true)
    //             print(self.navigationController?.viewControllers)
    //        }
    //    }
    
    
    //MARK:- Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        isPushed = false
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        self.setLandingJobSeekerEvent()
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        self.title = "Home"
        
        searchBar.setImage(UIImage(), for: .clear, state: .normal)
        if modulesArray.count == 0 {
            self.tblView.reloadData()
            self.callApi()
        }
   
        self.btnCovid.isHidden = true
        if CommonClass.covidFlagMobile {
            self.callGetCovidFlag()
            self.btnCovidStatus()
        }
                        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // self.stopActivityIndicator()
    }
    
    @objc func notifcationViewAction(_ sender:UIBarButtonItem){
        let vc = MINotificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func initUI() {
        
        isAppliedFlag = true
        isSavedOrUnsaved = true
        isNetwork = true
        
        self.navigationItem.titleView = searchBar
        searchBar.miDelegate = self
        searchBar.delegate = self
       
        if #available(iOS 10.0, *) {
            searchBar.showVoiceSearch = true
        } else {
            searchBar.showVoiceSearch = false
        }
        searchBar.placeholder = "Search by keywords, skills etc."
        
        //notificationTitleVieww.circular(0, borderColor: nil)
        //        notificationTitleView.frame=CGRect(x: 0, y: 0, width: 140, height: 50)
        //        notificationTitleView.nitificationCountlabel.text="124"
        //        notificationTitleView.delegate=self
        //        self.navigationItem.rightBarButtonItem=UIBarButtonItem(customView: notificationTitleView)
        
        
        let chars = ["%","{","}","cms.hook.","ygggH"," "]
        var newStr = "%{cms.hook.HOOK_HEADER}%"
        
        newStr.removeChars(chars: chars)
        //  self.searchTopView.addShadow(opacity: 0.2)
      
        self.tblView.register(UINib(nibName: "MIHomeScrollCell", bundle: nil), forCellReuseIdentifier: scrollCellId)
        tblView.register(UINib(nibName:String(describing: MISwippingTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MISwippingTableViewCell.self))
        tblView.register(UINib(nibName:String(describing: MIHorizontalScrollTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIHorizontalScrollTableCell.self))
       
        self.tblView.register(UINib(nibName: "MIHomeJobCell", bundle: nil), forCellReuseIdentifier: jobCellId)
        self.tblView.register(UINib(nibName: "MIHomePendingActionCell", bundle: nil), forCellReuseIdentifier: pendingActionCellId)
        
        tblView.register(UINib(nibName:String(describing: MIGleacSkillIndexCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIGleacSkillIndexCell.self))
        
        self.tblView.register(UINib(nibName: String(describing: MICovid19TableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MICovid19TableViewCell.self))
        
        self.tblView.register(UINib(nibName: String(describing: MISwipeCollectionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MISwipeCollectionTableViewCell.self))
                       
        self.tblView.addSubview(self.refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: .CountryChanged, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(gleacDashBoardCallBack), name: .pendingActionGleacCall, object: nil)
        
        
     //   NotificationCenter.default.addObserver(self, selector: #selector(setLandingJobSeekerEvent), name: NSNotification.Name.sessionId, object: nil)

        if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
            tabBar.progress = tabBarProgress
        }
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        //print(appVersion ?? "")

        if let site =  AppDelegate.instance.site?.siteProps,site.count > 0 {
            let forceVersion = site.filter({ $0.name.lowercased() == "forceupdate"})
            if forceVersion.count > 0  {
                let versionObj = forceVersion.first
                
                if let versionDic = self.convertToDictionary(text: versionObj?.value ?? "") {
                    if !versionDic.stringFor(key: "updateMessage").isEmpty {
                        let latestVersion = versionDic.intFor(key: "currentVersion")
                        let appVers = Int(appVersion ?? "3300070")
                        if appVers ?? 3300071 < latestVersion {
                            self.showForceUpdateAlert(updateMsg: versionDic.stringFor(key: "updateMessage"))
                        }
                    }
                }
            }
        }
    }

    
    @IBAction func btnCovidPressed(_ sender: UIButton) {
        
        CommonClass.googleEventTrcking("dashboard_screen", action: "covid_button", label: "")
        
        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
        vc.url =  WebURl.covidUrl 
        vc.ttl = "Covid-19"
        vc.openWebVC = .fromHome
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func setLandingJobSeekerEvent(){
        self.callAPIForDashboardSeekerJourneyMapEvent(type: CONSTANT_JOB_SEEKER_TYPE.DASHBOARD_LANDING, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING])
    }
    func showForceUpdateAlert(updateMsg:String) {
        self.showPopUpView(title: "New Version Available", message: updateMsg, primaryBtnTitle: "Update", secondaryBtnTitle: "No Thanks") { (isPrimarBtnClicked) in
                if isPrimarBtnClicked {
                    if let url = URL(string: "https://apps.apple.com/in/app/monster-jobs/id525775161"),
                               UIApplication.shared.canOpenURL(url){
                               if #available(iOS 10.0, *) {
                                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
                               } else {
                                   UIApplication.shared.openURL(url)
                               }
                           }

                }
                 
        }
                
//        let vPopup = MIJobPreferencePopup.popup()
//        vPopup.closeBtn.isHidden = true
//        vPopup.setViewWithTitle(title: "New Version Available", viewDescriptionText:  updateMsg, or: "", primaryBtnTitle: "Update", secondaryBtnTitle:"No Thanks")
//        vPopup.completionHandeler = {
//        if let url = URL(string: "https://apps.apple.com/in/app/monster-jobs/id525775161"),
//                   UIApplication.shared.canOpenURL(url){
//                   if #available(iOS 10.0, *) {
//                       UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                   } else {
//                       UIApplication.shared.openURL(url)
//                   }
//               }
//
//        }
//        vPopup.cancelHandeler = {
//
//
//        }
//        vPopup.addMe(onView: self.view, onCompletion: nil)

        
//        let alertMessage = updateMsg
//        let alert = UIAlertController(title: "New Version Available", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
//
//        let okBtn = UIAlertAction(title: "Update", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//
//            //itms://itunes.apple.com/app/apple-store/id525775161?mt=8
//            if let url = URL(string: "https://apps.apple.com/in/app/monster-jobs/id525775161"),
//                UIApplication.shared.canOpenURL(url){
//                if #available(iOS 10.0, *) {
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                } else {
//                    UIApplication.shared.openURL(url)
//                }
//            }
//        })
//        let noBtn = UIAlertAction(title:"No Thanks" , style: .default, handler: {(_ action: UIAlertAction) -> Void in
//        })
//        alert.addAction(okBtn)
//        alert.addAction(noBtn)
//        self.present(alert, animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .CountryChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .sessionId, object: nil)
        NotificationCenter.default.removeObserver(self, name: .pendingActionGleacCall, object: nil)
    }
    
    @objc func locationChanged() {
        recomendedJobBySearch = nil
        self.tblView.reloadData()
        self.callApi()
        
    }
    
    @objc func gleacDashBoardCallBack() {
        self.callApi()
        
    }
    
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                printDebug(error.localizedDescription)
            }
        }
        return nil
    }
    
    func callApi() {
        
        self.startActivityIndicator()
        homeFooter.isHidden = true
        MIApiManager.callHomeService() {  (isSuccess, response, error, code) in
           
            DispatchQueue.main.async {
                self.recomendedJobBySearch = nil
                self.stopActivityIndicator()
                
                if isSuccess, let res = response as? [String:Any],let meta = res["meta"] as? [String:Any], let theme = meta["theme"] as? [String:Any] {
                    if !res.stringFor(key: "sessionId").isEmpty {
                     //   sessionId = res.stringFor(key: "sessionId")
                    }
                   // printDebug(theme)
                    self.modulesArray.removeAll()
                    userDefaults.set(theme, forKey: "homeTheme")
                    userDefaults.synchronize()
                    
                    self.parseData(theme: theme)
                } else {
                    //if wSelf?.modulesArray.count == 0 {
                    if !MIReachability.isConnectedToNetwork() {
                        self.toastView(messsage: "Please check your internet connection.")
                    }
                    self.modulesArray.removeAll()
                    if let theme = userDefaults.object(forKey: "homeTheme") as? [String:Any] {
                        self.parseData(theme: theme)
                    }
                    // }
                }
            }
        }
    }
    
    
    func parseData(theme:[String:Any]) {
        // recomendedJobBySearch=nil
        
        if var skeleton = theme["skeleton"] as? String {
            let chars = ["%","{","}","cms.hook.","."]
            skeleton.removeChars(chars: chars)
          
            let hooksArray = skeleton.components(separatedBy: "\n")
            if let hook = theme["hooks"] as? [[String:Any]] {
                
                for secHook in hooksArray {

                    for obj in hook {
                        var tempArray = [MIHomeModel]()
                        if secHook == obj["alias"] as? String {
                                                      
                            if let modules = obj["modules"] as? [[String:Any]] {
                                for dic in modules {
                                    
                                    if dic["alias"] as? String == MIHomeModuleEnums.reports.rawValue {
                                        let info = MIHomeModel.init(with: dic)
                                        tempArray.append(info)
                                    }
                                        
                                    else if dic["alias"] as? String == MIHomeModuleEnums.recomondedJob.rawValue{
                                        let info = MIHomeModel.init(with: dic)
                                        // if info.isDataAvailable {
                                        tempArray.append(info)
                                        //  }
                                    }
                                        
                                    // add gleac model
                                    else if dic["alias"] as? String == MIHomeModuleEnums.GleacSkill.rawValue {
                                        let info = MIHomeModel.init(with: dic)
                                        
                                        if let data = dic["data"] as? String {
                                            if data != "{}", !data.isEmpty, data.count > 0 {
                                                tempArray.append(info)
                                            }
                                        }
                                    }
                                        
                                    else if dic["alias"] as? String == MIHomeModuleEnums.topCompanies.rawValue {
                                        let info = MIHomeModel.init(with: dic)
                                        if let data = dic["data"] as? String {
                                            if data != "[]", !data.isEmpty,  data.count > 0{
                                                tempArray.append(info)
                                            }
                                        }
                                    }
                                        
                                    else{
                                        if let data = dic["data"] as? String , !data.isEmpty , data.count > 4 {
                                            
                                            let info = MIHomeModel.init(with: dic)
                                            if info.isDataAvailable {
                                                tempArray.append(info)
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        if tempArray.count > 0 {
                            tempArray =  tempArray.sorted(by: {$0.position < $1.position })
                            self.modulesArray.append(contentsOf: tempArray)
                        }
                    }
                }
            }
            self.addCovidData()  // Add covid dic
            
            //            if let tabbar = self.tabBarController as? MIHomeTabbarViewController {
            //                if var currentProgress = AppUserDefaults.value(forKey: .UserProgress) as? Int{
            //                    currentProgress = 100 - currentProgress
            //                    tabbar.progress = CGFloat(currentProgress/100)
            //
            //                }
            //            }
            
            
            homeFooter.delegate = self
            homeFooter.isHidden = false
            homeFooter.updateUI()
            self.spamMail = homeFooter.mailID
            self.tblView.tableFooterView = homeFooter
            self.tblView.reloadData()
            
            if navigateVc != nil{
                if navigateAction == .deepUrlCreateAlert{
                    if let vc=navigateVc as? MICreateJobAlertViewController{
                        self.deepURlCreateAlertAction(vc: vc)
                    }
                }else if navigateAction == .deepProfileUrl{
                    self.tabBarController?.selectedIndex = 2
                }
                else{
                    self.navigationController?.pushViewController(navigateVc!, animated: true)
                }
                navigateVc=nil
            }
            //            if navigateToJobDetailViaPushComes != ""{
            //                let vc=MIJobDetailsViewController()
            //                vc.jobId=navigateToJobDetailViaPushComes
            //                vc.delegate=self
            //                self.navigationController?.pushViewController(vc, animated: true)
            //                navigateToJobDetailViaPushComes=""
            //            }
        }
        
        //        self.view.bringSubviewToFront(showcase)
        
        //        let shouldhideTutorial = userDefaults.bool(forKey: "homeFirstTimeTutorial")
        //        if let tabBar = self.tabBarController as? MIHomeTabbarViewController,shouldhideTutorial == false {
        //
        //            userDefaults.set(true, forKey: "homeFirstTimeTutorial")
        //            showcase.setTargetView(tabBar: tabBar.tabBar, itemIndex: 2) // always required to set targetView
        //            showcase.targetHolderColor = UIColor.clear
        //            showcase.primaryText = "Profile Button"
        //            showcase.secondaryText = "Tap here to view your Profile"
        //            showcase.aniRippleColor = .clear
        //            showcase.delegate = self
        //            if self.view.window != nil{
        //                showcase.show(completion: {
        //                })
        //            }
        //
        //        }
        
    }
    
    // Add covid dic
    func addCovidData() {
        let covidDic = [
              "placeholder"      : "%{cms.module.MODULE_COVID19}%",
              "name"             : "COVID19",
              "alias"            : "MODULE_COVID19",
              "viewName"         : "COVID-19",
              "dataType"         : "Service",
              "data"             : [],
              "individualCache"  : 1,
              "methodType"       : "GET",
              "dataHandler"      : "",
              "position"         : 0
             ] as [String : Any]
        
        if CommonClass.covidFlagMobile {
            let info = MIHomeModel.init(with: covidDic)
            self.modulesArray = self.modulesArray.filter({ $0.aliasName != MIHomeModuleEnums.covid19.rawValue })
            covid19Flag ? self.modulesArray.insert(info, at: self.modulesArray.endIndex) : self.modulesArray.insert(info, at: self.modulesArray.startIndex)
            self.tblView.reloadData()
        }
        
    }
        
    func actionOnpendingItem(item:MIPendingItemModel, actionPerformed: String) {
        
        if item.pendingActionType != .NONE {
            self.callAPIForDashboardSeekerJourneyMapEvent(type: CONSTANT_JOB_SEEKER_TYPE.PENDING_ACTIONS, data: ["cardName":item.pendingActionType.jobSeekerCardName,"cardClickType":actionPerformed,"eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK])
        }
        
    }
    func callAPIForDashboardSeekerJourneyMapEvent(type:String,data:[String:Any]) {
        
        guard let nc = self.navigationController else { return }
        var referalURL = CONSTANT_SCREEN_NAME.REGISTER_PERSONAL
        if nc.viewControllers.last?.isKind(of: MIJobPreferenceVC.self) ?? false {
            referalURL = CONSTANT_SCREEN_NAME.REGISTER_JOB_PREFERENCE
        }else if nc.viewControllers.last?.isKind(of: MILoginViewController.self) ?? false {
            referalURL = CONSTANT_SCREEN_NAME.LOGIN

        }else if nc.viewControllers.last?.isKind(of: MIHomeViewController.self) ?? false {
            referalURL = CONSTANT_SCREEN_NAME.SPLASH_SCREEN
        }
        
        self.callAPIForDashBoadSeekerJourneyEvent(type: type, referalURL:referalURL, data: data)

    }
    
    func callAPIForDashBoadSeekerJourneyEvent(type:String,referalURL:String,data:[String:Any]) {
        
        MIApiManager.hitSeekerJourneyMapEvents(type, data: data, source: referalURL, destination: CONSTANT_SCREEN_NAME.HOME) { (success, response, error, code) in
            
        }
    }
    

    
}

//MARK:- UITableViewDataSource,UITableViewDelegate
extension MIHomeViewController: UITableViewDataSource, UITableViewDelegate {
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modulesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.modulesArray.count == 0 {
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let info = self.modulesArray[indexPath.section]
        let headerTitle = info.aliasName
        
        //add covid cell
        if headerTitle == MIHomeModuleEnums.covid19.rawValue {
            if let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MICovid19TableViewCell.self), for: indexPath) as? MICovid19TableViewCell {
                
                cell.covidFlagCallBack = {
                    if (!MIReachability.isConnectedToNetwork()){
                        self.toastView(messsage: ExtraResponse.noInternet)
                    } else {
                        self.btnCovidStatus()
                    }
                }
                
                cell.covidOnOff(covid19Flag)

                return cell
            }
        }
        
        if headerTitle == MIHomeModuleEnums.jobTrack.rawValue {
            if let cell = tblView.dequeueReusableCell(withIdentifier: jobCellId) as? MIHomeJobCell {
                cell.delegate = self
                cell.show(info: jobInfo)
                
                return cell
            }
        }
        
        // add gleac cell
        if headerTitle == MIHomeModuleEnums.GleacSkill.rawValue {
            if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIGleacSkillIndexCell.self), for: indexPath) as? MIGleacSkillIndexCell
            {
                cell.viewReportCallBack = {
                    
                    if (!MIReachability.isConnectedToNetwork()){
                        self.toastView(messsage: ExtraResponse.noInternet)
                    } else {
                        CommonClass.googleEventTrcking("dashboard_screen", action: "gleac_report", label: "view_report")
                        // self.btnViewGleacReport(url)
                        self.getGleacSkillReport()
                    }
                }
                
                return cell
            }
        }
        
//        //Add top companies cell
//        if headerTitle == MIHomeModuleEnums.topCompanies.rawValue {
//              if let cell = tblView.dequeueReusableCell(withIdentifier: "MISwipeCollectionTableViewCell") as? MISwipeCollectionTableViewCell {
//
//                if let itemsList = info.dicModel[headerTitle] as? [MIHomeJobTopCompanyModel] {
//                    cell.headerName = headerTitle
//                    cell.delegate = self
//                    cell.jobTopCompanyModel = itemsList
//                }
//                return cell
//            }
//        }
//
//        //add job category cell
//        if headerTitle == MIHomeModuleEnums.jobCategory.rawValue {
//            if let cell = tblView.dequeueReusableCell(withIdentifier: "MISwipeCollectionTableViewCell") as? MISwipeCollectionTableViewCell {
//
//                if let jobcategories = info.dicModel[headerTitle] as? [MIHomeJobCategory] {
//                    cell.headerName = headerTitle
//                    cell.delegate = self
//                    cell.jobCategoryModel = jobcategories
//                }
//                return cell
//            }
//        }
//
//        //add Employment Index
//        if headerTitle == MIHomeModuleEnums.reports.rawValue {
//            if let cell = tblView.dequeueReusableCell(withIdentifier: "MISwipeCollectionTableViewCell") as? MISwipeCollectionTableViewCell {
//
//                if let employmentIndexes = info.dicModel[headerTitle] as? [MIHomeEmploymentIndex] {
//                    cell.headerName = headerTitle
//                    cell.delegate = self
//                    cell.employmentIndexModel = employmentIndexes
//                }
//
//                return cell
//            }
//        }
//
//        //add video cell
//        if headerTitle == MIHomeModuleEnums.videos.rawValue {
//            if let cell = tblView.dequeueReusableCell(withIdentifier: "MISwipeCollectionTableViewCell") as? MISwipeCollectionTableViewCell {
//
//                 if let videos = info.dicModel[headerTitle] as? [MIHomeVideos] {
//                    cell.headerName = headerTitle
//                    cell.delegate = self
//                    cell.videoModel = videos
//                }
//                return cell
//            }
//        }

        
        
        if headerTitle == MIHomeModuleEnums.recomondedJob.rawValue {
            
            if let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MISwippingTableViewCell.self), for: indexPath) as? MISwippingTableViewCell{
                
                cell.isNoMoreAdd=false
                cell.isReload=false
                
                if headerTitle == MIHomeModuleEnums.recomondedJob.rawValue {
                    if let recomemdedJobs = info.dicModel[headerTitle] as? JoblistingBaseModel , recomemdedJobs.data?.count ?? 0 > 0 {
                        if self.recomendedJobBySearch == nil{
                            self.recomendedJobBySearch=recomemdedJobs
                        }
                    }
                    cell.swipeView.currentCardIndex=0
                    cell.jobListingModel = self.recomendedJobBySearch
                    
                }
                
                if self.recomendedJobBySearch == nil || self.recomendedJobBySearch?.meta?.paging?.cursors?.next == nil {
                    cell.isNoMoreAdd=true
                    cell.swipeView.reloadData()
                } else{
                    cell.isReload=true
                    cell.swipeView.reloadData()
                }
                
                cell.reloadNewCard={[unowned self] in
                    // self.recomendedJobBySearch?.data?.removeAll()
                    // self.tblView.reloadData()
                    self.getRecommendedJob(next: self.recomendedJobBySearch?.meta?.paging?.cursors?.next)
                    
                }
                
                cell.swipeCardSelection={ [unowned self] (index,bool) -> Void in
                    
                    if !bool{
                        self.abTestingRecommendedJobEvent("JOB_VIEW",jobID: cell.jobListingModel?.data?[index].jobId?.stringValue)
                        
                        if cell.jobListingModel?.data![index].jobTypes?.filter({$0.lowercased().contains("sjs")}).count ?? 0 > 0 || cell.jobListingModel?.data![index].isCJT == 1 {
                            self.callIsViewedApi(jobId: cell.jobListingModel!.data![index].jobId ?? 0)
                            let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
                            
                            vc.url = self.getSJSURL(model: cell.jobListingModel!.data![index])
                            
                            vc.ttl = "Detail"
                            let nav = MINavigationViewController(rootViewController:vc)
                            nav.modalPresentationStyle = .fullScreen
                            self.present(nav, animated: true, completion: nil)
                        }else{
                            self.callAPIForDashboardSeekerJourneyMapEvent(type: CONSTANT_JOB_SEEKER_TYPE.RECOMMENDED_JOBS, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK])
                            
                            CommonClass.googleEventTrcking("dashboard_screen", action: "recommended_jobs", label: "click")
                            
                            let vc = MIJobDetailsViewController()
                            vc.delegate=self
                            vc.jobId = String(cell.jobListingModel?.data![index].jobId ?? 0)
                            vc.referralUrl = .RECOMMENDED_JOBS
                            vc.abTestingVersion = cell.jobListingModel?.meta?.version ?? "V1"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        
                    }
                    //                        else if !cell.isReload{
                    //                            let vc = MIJobPreferenceViewController()
                    //                            vc.flowVia = .ViaPendingAction
                    //                            vc.jobpreferenceSuccessPendingAction={(isSuccess,jobPref) in
                    //                                self.callApi()
                    //                              }
                    //                            self.navigationController?.pushViewController(vc, animated: true)
                    //                        }
                }
                
                cell.applyCardSelection = {  (index) in
                    CommonClass.googleEventTrcking("dashboard_screen", action: "recommended_Jobs", label: "apply")
                    
                    self.callAPIForDashboardSeekerJourneyMapEvent(type: CONSTANT_JOB_SEEKER_TYPE.RECOMMENDED_JOBS, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.SWIPE,"jobId":cell.jobListingModel?.data?[index].jobId?.stringValue ?? ""])
                    self.abTestingRecommendedJobEvent("JOB_APPLY", jobID: cell.jobListingModel?.data?[index].jobId?.stringValue)
                    
                    self.applyAction(jobId: String(cell.jobListingModel?.data![index].jobId ?? 0), redirectURl: cell.jobListingModel?.data![index].redirectUrl, jobApplyTracking: (cell.jobListingModel?.data![index])! )
                }
                cell.skipCardSelection={(index) in
                    self.callAPIForDashboardSeekerJourneyMapEvent(type: CONSTANT_JOB_SEEKER_TYPE.RECOMMENDED_JOBS, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.SWIPE,"jobId":cell.jobListingModel?.data?[index].jobId?.stringValue ?? ""])
                    let filterJobs = cell.jobListingModel?.data![index]
                    self.skippedJob(jobId: filterJobs?.jobId ?? 0)
                    CommonClass.googleEventTrcking("dashboard_screen", action: "recommended_jobs", label: "skip")
                }
                cell.editJobPreference={[weak self] in
                    self?.callAPIForDashboardSeekerJourneyMapEvent(type: CONSTANT_JOB_SEEKER_TYPE.RECOMMENDED_JOBS, data:["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.EDIT_PREFERENCES])
                    let vc = MIJobPreferenceViewController()
                    vc.flowVia =  .ViaPendingAction
                    vc.jobpreferenceSuccessPendingAction={[weak self](isSuccess,jobPref) in
                        self?.callApi()
                    }
                    self?.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                return cell
            }
            
            //}
        } //if
        
        if let pendingCell = tblView.dequeueReusableCell(withIdentifier: pendingActionCellId) as? MIHomePendingActionCell, headerTitle == MIHomeModuleEnums.pendingAction.rawValue {
            //            cell.removeAllViewsFromScrollView()
            if let pendingItems = info.dicModel[headerTitle] as? [MIPendingItemModel] {
                pendingCell.addPendingView(pendingItemList: pendingItems)
            }
            
            return pendingCell
        }
        
            
        
        if let cell = tblView.dequeueReusableCell(withIdentifier: "MISwipeCollectionTableViewCell") as? MISwipeCollectionTableViewCell {
            
            //Add top companies cell
            if headerTitle == MIHomeModuleEnums.topCompanies.rawValue {
                if let itemsList = info.dicModel[headerTitle] as? [MIHomeJobTopCompanyModel] {
                    cell.headerName = headerTitle
                    cell.delegate = self
                    cell.jobTopCompanyModel = itemsList
                }
                
            }
            
            //add job category cell
            if headerTitle == MIHomeModuleEnums.jobCategory.rawValue {
                if let jobcategories = info.dicModel[headerTitle] as? [MIHomeJobCategory] {
                    cell.headerName = headerTitle
                    cell.delegate = self
                    cell.jobCategoryModel = jobcategories
                }
            }
            
            //add video cell
            if headerTitle == MIHomeModuleEnums.videos.rawValue {
                if let videos = info.dicModel[headerTitle] as? [MIHomeVideos] {
                    cell.headerName = headerTitle
                    cell.delegate = self
                    cell.videoModel = videos
                }
            }
            
            //add Employment Index
            if headerTitle == MIHomeModuleEnums.reports.rawValue {
                if let employmentIndexes = info.dicModel[headerTitle] as? [MIHomeEmploymentIndex] {
                    cell.headerName = headerTitle
                    cell.delegate = self
                    cell.employmentIndexModel = employmentIndexes
                }
            }
            
            cell.collectionListView.reloadData()
            return cell
            
        }
        
        if let cell = tblView.dequeueReusableCell(withIdentifier: scrollCellId) as? MIHomeScrollCell, MIHomeModuleEnums.allCases.filter({$0.rawValue==headerTitle}).count > 0 {
            
            if headerTitle == MIHomeModuleEnums.careerService.rawValue {
                //                if let careerServices = info.dicModel[headerTitle] as? [MIHomeCareerService]  {
                //                    cell.addCareerServiceView(careerServices: careerServices)
                //                }
            }
            else if headerTitle == MIHomeModuleEnums.employemnentIndex.rawValue {
                //                cell.addEmploymentIndex()
            }
            
            //            else if headerTitle == MIHomeModuleEnums.reports.rawValue {
            //                if let employmentIndexes = info.dicModel[headerTitle] as? [MIHomeEmploymentIndex] {
            //                    cell.delegate = self
            //                    cell.addEmploymentIndex(employmentIndexes: employmentIndexes)
            //                }
            //            }
            //
            //                //            else if headerTitle == MIHomeModuleEnums.monsterEducation.rawValue {
            //                //                cell.addEducationView()
            //                //            }
            //
            //            else if headerTitle == MIHomeModuleEnums.jobCategory.rawValue {
            //                if let jobcategories = info.dicModel[headerTitle] as? [MIHomeJobCategory] {
            //                    cell.delegate = self
            //                    cell.addJobCategoryView(jobCategories: jobcategories)
            //                }
            //            }
            //
            //            else if headerTitle == MIHomeModuleEnums.videos.rawValue {
            //                if let videos = info.dicModel[headerTitle] as? [MIHomeVideos] {
            //                    cell.delegate = self
            //                    cell.addExpertSpeak(videosInfo: videos)
            //                }
            //            }
            //
            //            //Add top companies cell
            //            else if headerTitle == MIHomeModuleEnums.topCompanies.rawValue {
            //
            //                if let itemsList = info.dicModel[headerTitle] as? [MIHomeJobTopCompanyModel] {
            //                    cell.delegate = self
            //                    cell.addTopCompanies(topCompanyInfo: itemsList)
            //                }
            //            }
            
            
            return cell
        }
        
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let info = self.modulesArray[section]
        let headerTitle = info.headerTitle//
        let header = MIHomeHeaderView.header
        
        if info.aliasName == MIHomeModuleEnums.jobCategory.rawValue || info.aliasName == MIHomeModuleEnums.pendingAction.rawValue || info.aliasName == MIHomeModuleEnums.topCompanies.rawValue {
            header.backgroundColor = UIColor(hex: "f4f6f8")
        }
        
        header.show(ttlNo: "", ttl: headerTitle, shouldShowViewAll: false)
        if let enumName = MIHomeModuleEnums(rawValue: info.aliasName) {
            var ttl = ""
            var shouldShowViewAll = false
            if enumName.showTitleNo {
                ttl = "0"
            }
            
            shouldShowViewAll         = enumName.showViewAll
            header.lblTitle.font      = enumName.font
            header.lblTitle.textColor = enumName.titleColor
            
            if enumName == MIHomeModuleEnums.recomondedJob {
                shouldShowViewAll = false
                if self.recomendedJobBySearch?.meta?.paging?.total ?? 0 > 0  {
                    shouldShowViewAll = true
                }
                ttl = ""
                header.show(ttlNo: ttl, ttl: headerTitle, shouldShowViewAll: shouldShowViewAll)
                header.viewAll = { status in
                    CommonClass.googleEventTrcking("dashboard_screen", action: "recommended_jobs", label: "view_all")
                    
                    let vc = MIViewAllJobsViewController()
                    vc.controllerType = .recomended
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            if enumName == MIHomeModuleEnums.videos {
                header.show(ttlNo: ttl, ttl: headerTitle, shouldShowViewAll: true)
                header.viewAll = { status in
                    CommonClass.googleEventTrcking("dashboard_screen", action: "expert_speaks", label: "view_all")
                    
                    self.videoViewAllClicked()
                    
                }
            }
            
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let info = self.modulesArray[section]
        let sectionName = info.headerTitle
        //        if let pendingItems = info.dicModel[headerTitle] as? [MIPendingItemModel] {
        //
        //        }
        if !sectionName.isEmpty {
            return 55
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let info = self.modulesArray[indexPath.section]
        let sectionName = info.aliasName
        
        if MIHomeModuleEnums.allCases.filter({$0.rawValue==sectionName}).count > 0 {
            
            switch sectionName{
            case MIHomeModuleEnums.topCompanies.rawValue:
                return 100
            case MIHomeModuleEnums.jobCategory.rawValue:
                return 160.0
            case MIHomeModuleEnums.videos.rawValue:
                return 190.0
            case MIHomeModuleEnums.reports.rawValue:
                return 195.0
            default:
                 return UITableView.automaticDimension
            }
           // return UITableView.automaticDimension
        }
        

        return 0
    }
    

    

    
}

extension MIHomeViewController: MIHomeScrollCellDelgate,MIHomeJobCellDelegate,MIHomeBeSafeHeaderViewDelegate,MFMailComposeViewControllerDelegate, ListCollectionCellDelgate {
    
    
    func videoViewAllClicked() {
        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
        vc.url = "https://\(WebURl.domain ?? "monsterindia.com")/career-advice/career-advice-videos.html"
        vc.ttl = "Expert Speaks"
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
    }
    
    func employmentIndexClicked(url: String, controllerTitle: String) {
        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
        vc.url = url + "?app=true"
        vc.ttl = controllerTitle
        if controllerTitle == "Employment Index" {
            CommonClass.googleEventTrcking("dashboard_screen", action: "monster_employment_index", label: "learn_more")
        }else if controllerTitle == "Salary Index"{
            CommonClass.googleEventTrcking("dashboard_screen", action: "monster_salary_index", label: "learn_more")
        }
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
    }
    
    func showJobsFromUrl(ttl: String, type: HomeJobCategoryType) {
        
       CommonClass.predefinedViewItemList(ttl) //firebase predefined View_Item_List
        
        let vc = MISRPJobListingViewController()
        vc.jobTypes = type.jobType
        
        if type.jobType == .nearBy{
            if MIAppLocationManager.locationManagerSharedInstance.status == .authorizedAlways || MIAppLocationManager.locationManagerSharedInstance.status == .authorizedWhenInUse {
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                self.showAlert(title: "", message: "You have to enable location services from Settings.")
            }
        }else{
            self.callAPIForDashboardSeekerJourneyMapEvent(type: CONSTANT_JOB_SEEKER_TYPE.JOBS_BY_CATEGORY, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK,"cardName":type.jobSeekerJourneyCardName])
            var firebaseLabelName = ""
            if type.jobType == .contract {
                firebaseLabelName = "Contract-Jobs"
                self.abTestingHomeEvent("CONTRACT_JOBS")
                
            }else if type.jobType == .walkIn {
                firebaseLabelName = "Walk-In-Jobs"
                self.abTestingHomeEvent("WALKIN_JOBS")
                
            }else if type.jobType == .fresher {
                firebaseLabelName = "Fresher-Jobs"
                self.abTestingHomeEvent("FRESHER_JOBS")
                
            }else if type.jobType == .itJobs {
                firebaseLabelName = "IT-Jobs"
                self.abTestingHomeEvent("IT_JOBS")
                
            }else if type.jobType == .bpo {
                firebaseLabelName = "Call-Centre"
                self.abTestingHomeEvent("BPO_JOBS")
                
            }else if type.jobType == .manufacture {
                firebaseLabelName = "Manufacturing"
                self.abTestingHomeEvent("ENGINEERING_JOBS")
                
            }else if type.jobType == .finance {
                firebaseLabelName = "Finance"
                self.abTestingHomeEvent("FINANCE_JOBS")
                
            }else if type.jobType == .sales {
                firebaseLabelName = "Sales"
                self.abTestingHomeEvent("SALES_JOBS")
                
            }
            CommonClass.googleEventTrcking("dashboard_screen", action: "jobs_by_category", label: firebaseLabelName)
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func abTestingHomeEvent(_ action: String) {
        
        let param = [
            "apiId" : "V1",
            "pageType" : "HOMEPAGE",
            "action" : action,
            "sessionId" : sessionId,
            "source" : "homepage",
            "data": [:]
            ] as [String : Any]
        
        MIApiManager.seekerABTestingAPI(param) { (result, error) in
        }
    }
    
    func abTestingRecommendedJobEvent(_ action: String, jobID: String?) {
        let pageNumber = (self.recomendedJobBySearch?.data?.count ?? 1) / (self.recomendedJobBySearch?.meta?.paging?.limit ?? 1)
        var data = [
            "resultCount":self.recomendedJobBySearch?.meta?.paging?.total as Any,
             "query" : [
                "pageSize" : self.recomendedJobBySearch?.meta?.paging?.limit as Any,
                "pageNo" : pageNumber+1
            ]
        ]
        if action == "JOB_APPLY" {
            data["apiRequestTime"] = self.requestStartTime
            data["apiResponseTime"] = Date().timeIntervalSince1970
        }
        if let id = jobID {
            data["jobId"] = id
        }

        let param = [
            "apiId" : self.recomendedJobBySearch?.meta?.version ?? "V1",
            "pageType" : "RECOMMENDED_JOBS",
            "action" : action,
            "searchId" : self.recomendedJobBySearch?.meta?.resultId as Any,
            "sessionId" : sessionId,
            "source" : "homepage",
            "data" : data
            ] as [String : Any]
        
        MIApiManager.seekerABTestingAPI(param) { (result, error) in
        }
    }
    
    
    func careerServiceClicked(url: String) {
        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
        vc.url = url
        vc.ttl = "Career Service"
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
    }
    
    func showVideoFromUrl(url: String) {
        let vc = YTPlayerVC.instantiate(fromAppStoryboard: .Main)
        vc.videoID = url.youtubeID
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
    }
    
    func showTopCompanyDetails(compId: String) {
        
            MIActivityLoader.showLoader()
            MIApiManager.hitCompanyDetailsAPI(compId) { (success, response, error, code) in
                
                DispatchQueue.main.async {
                    MIActivityLoader.hideLoader()
                    if let response = response as? JSONDICT {
                      let compDetail = Company.init(dictionary: response as NSDictionary)
                        
                        if error == nil && (code >= 200) && (code <= 299) {
                            let comData = MIRecruiterDetailsViewController()
                            comData.compOrRecId = compId
                            comData.recuterOrCompanyType = .company
                            
                             let jobData=JoblistingData()
                            jobData.company = compDetail
                            
                            comData.jobModel = jobData
                            comData.jobModel?.isCompanyFollow = compDetail?.isCompanyFollow
                           self.navigationController?.pushViewController(comData, animated: true)
                        } else {
                            if let errorMessage = response["errorMessage"] as? String {
                               self.toastView(messsage: errorMessage)
                            }
                        }
                    } else {
                        if (!MIReachability.isConnectedToNetwork()){
                            self.toastView(messsage: ExtraResponse.noInternet)
                        }
                    }
                }
            }
        }
        

    
    // MARK:- MIHomeJobCellDelegate
    func savedJobClicked() {
        self.tabBarController?.selectedIndex=1
        if let trackJobVc=self.tabBarController?.selectedViewController as? MINavigationViewController{
            if let rootVc=trackJobVc.viewControllers.first as? MITrackJobsHomeViewController{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    rootVc.moveToViewController(at: 1, animated: false)
                }
                
            }
        }
    }
    
    func appliedJobClicked() {
        self.tabBarController?.selectedIndex=1
        if let trackJobVc=self.tabBarController?.selectedViewController as? MINavigationViewController{
            if let rootVc=trackJobVc.viewControllers.first as? MITrackJobsHomeViewController{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                    rootVc.moveToViewController(at: 0, animated: false)
                }
                //rootVc.moveToViewController(at: 0, animated: true)
            }
        }
    }
    
    func jobAlertClicked() {
        //self.navigationController?.pushViewController(MIAlertsHomeViewController(), animated: true)
    }
    
    // MARK :- MIHomeBeSafeHeaderViewDelegate
    func reportAnAbuseClicked() {
        let feedbackVC = MIFeedbackViewController()
        self.navigationController?.pushViewController(feedbackVC, animated: true)
    }
    
    func mailIDClicked() {
        self.sendEmail()
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([self.spamMail])
            mail.setMessageBody("", isHTML: true)
            
            present(mail, animated: true)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func showSendMailErrorAlert() {
        self.showAlert(title: "", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.",isErrorOccured:true)

        //AKAlertController.alert("Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension MIHomeViewController: MISearchBarDelegate{
    
    @available(iOS 10.0, *)
    func voiceButtonAction(_ btn: UIButton) {
        self.callAPIForDashboardSeekerJourneyMapEvent(type: CONSTANT_JOB_SEEKER_TYPE.VOICE_SEARCH, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK])

        let vc = MISpeechRecognitionVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        vc.completionHandler = { data in
            guard data.experience.count + data.locations.count + data.salary.count + data.skills.count > 0 else  {
                return
            }
            
            
            let prevView=MISRPJobListingViewController()
            
            prevView.selectedSkills = data.skills.joined(separator: ",")
            prevView.selectedLocation =  data.locations.joined(separator: ",")
            
            let exp = data.experience
                .map({ ($0.contains("year") || $0.contains("yrs")) ? $0.parseInt ?? 0 : 0})
                .sorted(by: { $0 < $1 })
            if !exp.isEmpty {
                let lowerRange = (exp.first ?? 0).stringValue
                let upperrange = (exp.last ?? 0).stringValue
                prevView.param["experienceRanges"] = [lowerRange + "~" + upperrange]
            }
            let mappedData = data.salary
            .map({ ($0.contains("lakh") || $0.contains("lac")) ? ($0.parseInt ?? 0) * 100000 : 0 })
            let sal = mappedData.sorted(by: { $0 < $1 })
            if !sal.isEmpty {
                let lowerRange = (sal.first ?? 0).stringValue
                let upperrange = (sal.last ?? 0).stringValue

                prevView.param["salaryRanges"] = [lowerRange + "~" + upperrange]
            }
            
            self.navigationController?.pushViewController(prevView, animated: false)
        }
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if isPushed == false {
            isPushed = true
            self.callAPIForDashboardSeekerJourneyMapEvent(type: CONSTANT_JOB_SEEKER_TYPE.DASHBOARD_SEARCH_BUTTON, data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK_SUBMIT])
            let vc = MISearchViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return false
    }
    
}

extension MIHomeViewController:NotificationHomeIconDelegate{
    func notificationIconTapped() {
        let vc = MINotificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MIHomeViewController{
    func applyAction(jobId: String,redirectURl: String?, jobApplyTracking: JoblistingData) {
        self.eventTrackingValue = .RECOMMENDED_JOBS
        self.requestStartTime = Date().timeIntervalSince1970
        self.applyActionGlobal(jobId: jobId, redirectURl: redirectURl, jobApplyModel: jobApplyTracking) {
                self.abTestingRecommendedJobEvent("JOB_APPLY", jobID: jobId)
        }
    }
}

extension MIHomeViewController{
    func getRecommendedJob(next:String?){
        // self.startActivityIndicator()
        //param[SRPListingDictKey.next.rawValue]=next
        let _ = MIAPIClient.sharedClient.load(path:APIPath.suggestedJobs,method: .get, params:[SRPListingDictKey.next.rawValue:next ?? "10","limit":30]) { [weak self] (dataResponse, error,code) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                
            if error != nil{
              //  DispatchQueue.main.sync {
                    // self.stopActivityIndicator()
                    self.tblView.reloadData()
               // }
                return
            }else{
                if let jsonData=dataResponse as? [String:Any]{
                    //  print(jsonData)
                    let jobData=JoblistingBaseModel(dictionary: jsonData as NSDictionary)
                    if jobData?.data?.count ?? 0 > 0{
                        // for item in jobData?.data ?? []{
                        //     self.recomendedJobBySearch?.data?.append(item)
                        //  }
                        self.recomendedJobBySearch=jobData
                    }
                    // self.recomendedJobBySearch?.meta = jobData?.meta
                  //  DispatchQueue.main.async {
                        //  self.stopActivityIndicator()
                        self.tblView.reloadData()
                  //  }
                }
            }
            }
        }
    }
    func skippedJob(jobId:Int){
        let _ = MIAPIClient.sharedClient.load(path: APIPath.skippedJob, method: .post, params: ["jobId":jobId]) { (response, error, code) in
            if error != nil{
                if code==401{
                    DispatchQueue.main.async {
                        // self.logoutToLogin()
                    }
                }
            }
        }
    }
    
}

extension MIHomeViewController:JobsAppliedOrSaveDelegate{
    func jobApplied(model: JoblistingData?) {
        let filterData=self.recomendedJobBySearch?.data?.filter{$0.jobId == model?.jobId}
        if filterData?.count ?? 0 > 0{
            filterData![0].isApplied=true
        }
        self.recomendedJobBySearch?.data=self.recomendedJobBySearch?.data?.filter({$0.isApplied != true})
        self.tblView.reloadData()
    }
    func jobSaveUnsave(model: JoblistingData?, isSaved: Bool) {
        
    }
    func companyFollowUnFollow(compId: Int, isFollow: Bool) {
        
    }
}


extension MIHomeViewController{
    
    func deepURlCreateAlertAction(vc:MICreateJobAlertViewController){
        
        self.tabBarController?.selectedIndex = 4
        let navigation = self.tabBarController?.viewControllers?[4] as? MINavigationViewController
        
        if let id = navigateJobId {
            if id.isEmpty {
                let jobAlertVc=MIManageJobAlertVC()
                navigation?.pushViewController(jobAlertVc, animated: true)
            } else {
                MIAPIClient.sharedClient.load(path: APIPath.getJobAlert + "/" + id, method: .get, params: [:]) { [weak self](response, error, errorCode) in
                    guard let `self` = self else{return}
                    if error == nil{
                        if let jsonData=response as? [String:Any]{
                            
                            let jobAlertModel=JobAlertModelDataWithMaster(dictionary: jsonData as NSDictionary)
                            DispatchQueue.main.async {
                                if jobAlertModel != nil {
                                    vc.jobAlertType = .edit
                                    vc.modelData = JobAlertModel(model:jobAlertModel!)
                                }
                                navigation?.pushViewController(vc, animated: true)
                            }
                        }
                    }
                }
            }
        } else {
            navigation?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK:- Covid Flag, gleac report,
extension  MIHomeViewController {
    
        func callGetCovidFlag() {
            
            MIApiManager.hitCovidFlagAPI(.get, covidFlag: covid19Flag) { (success, response, error, code) in
                
                DispatchQueue.main.async {
                    if let responseData = response as? JSONDICT {
                        covid19Flag = responseData["covidLayoff"] as? Bool ?? false
                        
                        self.addCovidData()
                        self.btnCovidStatus()
                        self.tblView.reloadData()
                    } else {
                        if (!MIReachability.isConnectedToNetwork()){
                            self.toastView(messsage: ExtraResponse.noInternet)
                        }
                    }
                }
            }
            
        }

    
    func btnCovidStatus() {
        self.btnCovid.isHidden = false
        covid19Flag ? self.btnCovid.setImage(#imageLiteral(resourceName: "fabButtonGreen"), for: .normal) : self.btnCovid.setImage(#imageLiteral(resourceName: "fabButtonRed"), for: .normal)
     }
    
    func btnViewGleacReport(_ url : String) {
        let dic = ["viewReport" : true ]
        self.gleacReportMapEvents(dic, pagetype: CONSTANT_JOB_SEEKER_TYPE.HOME_PAGE, destination: CONSTANT_SCREEN_NAME.HOME)
        
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
          vc.url = url
          vc.ttl = "Benchmark Report"
          vc.openWebVC = .fromHomeGleacReport

          let nav = MINavigationViewController(rootViewController:vc)
          nav.modalPresentationStyle = .fullScreen

          self.present(nav, animated: true, completion: nil)
    }
    
    
    func gleacReportMapEvents(_ dic: [String: Any], pagetype: String, destination: String) {
        MIApiManager.hitGleacSkillMapEventsAPI(pagetype, accessedUrl: destination, data: dic) { (success, response, error, code) in
        }
    }
    
    
    func getGleacSkillReport() {
        
        MIApiManager.hitGleacSkillsResultAPI { (success, response, error, code) in
            
            DispatchQueue.main.async {
                if let responseData = response as? JSONDICT {
                    if let result = responseData["result"] as? JSONDICT{
                        if let url = result["url"] as? String {
                            self.btnViewGleacReport(url)
                        }
                    } else if let errors = responseData["errors"] as? [String] {
                        let err = errors.joined(separator: ", ")
                        self.toastView(messsage: err)
                    }
                }
            }
            
        }
    }
            
    
}


//
//  MIUpSkillViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 08/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import AVKit

class MIUpSkillViewController: MIBaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak private var tblView: UITableView!
    private let scrollCellId  = "homeScrollCell"
    private let articleCellId = "articleCell"
    private let jobCellId     = "jobCell"
    private let kTitleKey            = "title"
    private let kTableRowHasData     = "TableContainData"
    private var modulesArray         = [MIHomeModel]()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(MIProfileViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = Color.colorDarkBlack
        
        return refreshControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if JobSeekerSingleton.sharedInstance.dataArray?.last != self.screenName {
            JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        }
        self.navigationItem.title=ControllerTitleConstant.upSkill
        if self.modulesArray.isEmpty {
            self.callApi()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
        self.stopActivityIndicator()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.callApi()
        refreshControl.endRefreshing()
    }
    
    //MARK:- Life Cycle
    @objc func notifcationViewAction(_ sender:UIBarButtonItem){
        let vc = MINotificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func initUI() {
        
        let chars = ["%","{","}","cms.hook.","ygggH"," "]
        var newStr = "%{cms.hook.HOOK_HEADER}%"
        newStr.removeChars(chars: chars)
        self.tblView.register(UINib(nibName: "MIHomeScrollCell", bundle: nil), forCellReuseIdentifier: scrollCellId)
        self.tblView.register(UINib(nibName: "MIUpSkillArticleCell", bundle: nil), forCellReuseIdentifier: articleCellId)
        self.tblView.addSubview(self.refreshControl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(locationChanged), name: .CountryChanged, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .CountryChanged, object: nil)
    }
    
    @objc func locationChanged() {
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
        MIApiManager.callUpSkillService(){ [weak self] (isSuccess, response, error, code) in
            DispatchQueue.main.async {
                guard let `self` = self else { return }
                self.stopActivityIndicator()
                if isSuccess,
                    let res = response as? [String:Any],
                    let meta = res["meta"] as? [String:Any],
                    let theme = meta["theme"] as? [String:Any] {
                    
                    self.modulesArray.removeAll()
                    userDefaults.set(theme, forKey: "upskillTheme")
                    self.parseData(theme: theme)
                    
                } else {
                    if self.modulesArray.count == 0 {
                        if let theme = userDefaults.object(forKey: "upskillTheme") as? [String:Any] {
                            self.parseData(theme: theme)
                        }
                    }
                }
            }
        }
    }
    
    func parseData(theme:[String:Any]) {
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
                                    let info = MIHomeModel.init(with: dic)
                                    tempArray.append(info)
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
            self.tblView.reloadData()
        }
    }
    
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.modulesArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let info = self.modulesArray[section]
        let headerTitle = info.aliasName
        if headerTitle == MIHomeModuleEnums.article.rawValue {
            if let articles = info.dicModel[headerTitle] as? [Any] {
                return articles.count > 5 ? 5 : articles.count
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let info = self.modulesArray[indexPath.section]
        let headerTitle = info.aliasName
        
        if let cell = tblView.dequeueReusableCell(withIdentifier: scrollCellId) as? MIHomeScrollCell, MIHomeModuleEnums.allCases.filter({$0.rawValue==headerTitle}).count > 0 {
            cell.removeAllViewsFromScrollView()
           
            if headerTitle == MIHomeModuleEnums.careerService.rawValue {
                if let careerServices = info.dicModel[headerTitle] as? [MIHomeCareerService]  {
                    cell.addCareerServiceView(careerServices: careerServices)
                    cell.delegate = self
                }
            }
            else if headerTitle == MIHomeModuleEnums.monsterEducation.rawValue {
                if let educations = info.dicModel[headerTitle] as? [MIMonsterEducation] {
                    cell.addEducationView(educationList: educations)
                }
                
            }
            else if headerTitle == MIHomeModuleEnums.jobCategory.rawValue {
                if let jobcategories = info.dicModel[headerTitle] as? [MIHomeJobCategory] {
                    cell.delegate = self
                    cell.addJobCategoryView(jobCategories: jobcategories)
                }
            }
            else if headerTitle == MIHomeModuleEnums.videos.rawValue {
                if let videos = info.dicModel[headerTitle] as? [MIHomeVideos] {
                    cell.delegate = self
                    cell.addExpertSpeak(videosInfo: videos)
                }
            }
            else if headerTitle == MIHomeModuleEnums.article.rawValue {
                if let articleCell = tblView.dequeueReusableCell(withIdentifier: articleCellId) as? MIUpSkillArticleCell {
                    if let articles = info.dicModel[headerTitle] as? [MIHomeArticle] {
                        articleCell.delegate = self
                        articleCell.show(info: articles[indexPath.row], indexId: indexPath.row)
                        return articleCell
                    }
                }
            }
            return cell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let info = self.modulesArray[section]
        let headerTitle = info.headerTitle
        let header = MIHomeHeaderView.header
       
        if info.aliasName == MIHomeModuleEnums.monsterEducation.rawValue  {
            header.show(ttlNo: "", ttl: headerTitle, shouldShowViewAll: true)
            header.viewAll = {status in
                self.openViewAllSection(url: "https://\(WebURl.domain ?? "www.monsterindia.com")/courses-certifications/",withTile: headerTitle)
                
                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.MONSTER_EDUCATION, data:  ["eventValue" :CONSTANT_JOB_SEEKER_EVENT_VALUE.VIEWALL], source: "", destination: CONSTANT_SCREEN_NAME.UPSKILL_SCREEN) { (success, response, error, code) in
                }
            }
            
        }else if  info.aliasName == MIHomeModuleEnums.careerService.rawValue{
            header.show(ttlNo: "", ttl: headerTitle, shouldShowViewAll: true)
            header.viewAll = {status in
                CommonClass.googleEventTrcking("upskill_screen", action: "career_services", label: "view_all")

                MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.CAREER_SERVICES, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.VIEWALL], source: "", destination: CONSTANT_SCREEN_NAME.UPSKILL_SCREEN) { (success, response, error, code) in
                }
                
                self.openViewAllSection(url: "https://\(WebURl.domain ?? "www.monsterindia.com")/career-services/", withTile: headerTitle)
                
            }
            
        }else{
            header.show(ttlNo: "", ttl: headerTitle, shouldShowViewAll: false)

        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let info = self.modulesArray[section]
        let sectionName = info.headerTitle
        if !sectionName.isEmpty && info.isDataAvailable {
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
            return UITableView.automaticDimension
        }
        return 0
    }
    
    func openViewAllSection(url: String,withTile:String) {
        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
        vc.url = url + "?app=true"
        vc.ttl = withTile
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
    }
    
}

extension MIUpSkillViewController: MIHomeScrollCellDelgate,MIHomeJobCellDelegate,MIUpSkillArticleCellDelgate {
    
    func employmentIndexClicked(url: String, controllerTitle: String) {
        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
        vc.url = url
        vc.ttl = controllerTitle
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
    }
    
    func showJobsFromUrl(ttl: String, type: HomeJobCategoryType) {
        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
        vc.url = ttl
        vc.ttl = "Jobs"
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
    }
    
    func careerServiceClicked(url: String) {
        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
        vc.url = url + "?app=true"
        vc.ttl = "Career Service"
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
    }
    
    func showVideoFromUrl(url: String) {
        let vc = YTPlayerVC.instantiate(fromAppStoryboard: .Main)
        vc.videoID = url.youtubeID
        //        self.navigationController?.pushViewController(vc, animated: true)
        //        let vc = MIWebViewViewController()
        //        vc.url = url
        //        vc.youtubeVideo=true
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
    }
    
    func showTopCompanyDetails(compId: String) {
        
    }

    
    // MARK:- MIUpSkillArticleCellDelgate
    func showArticleFromSummary(summary: String, url: String) {
        let vc=Storyboard.main.instantiateViewController(withIdentifier: "MIWebViewController") as! MIWebViewController
        // let vc = MIWebViewController()
        if url.isEmpty {
            vc.summary = summary
        } else {
            vc.url     = url
        }
        vc.ttl = "Articles"
        let nav = MINavigationViewController(rootViewController:vc)
        nav.modalPresentationStyle = .fullScreen

        self.present(nav, animated: true, completion: nil)
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
}

extension MIUpSkillViewController:UISearchBarDelegate{
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        let vc = MISearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        return false
    }
}
extension MIUpSkillViewController:NotificationHomeIconDelegate{
    func notificationIconTapped() {
        let vc = MINotificationViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


//
//  MIMoreTabHomeViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIMoreTabHomeViewController: MIBaseViewController {
    
    //MARK:Variable and Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // var items = [MoreOptionViewModelItem]()
    var modelData=[MoreOptionModel]()
    
    //MARK:Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title="More Options"
        
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        self.checkForUpdate()
    }
    
    func setUpUI(){
        
        modelData=[
            MoreOptionModel(image:#imageLiteral(resourceName: "manage-ico"), title: MoreOptionViewModelItemType.manageJobAlert.value),
            MoreOptionModel(image: #imageLiteral(resourceName: "setting-ico"), title: MoreOptionViewModelItemType.settings.value),
            MoreOptionModel(image:#imageLiteral(resourceName: "feedback-ico"), title: MoreOptionViewModelItemType.feedback.value),
            MoreOptionModel(image:#imageLiteral(resourceName: "share"), title: MoreOptionViewModelItemType.shareApp.value),
            // MoreOptionModel(image:#imageLiteral(resourceName: "rate-ico"), title: MoreOptionViewModelItemType.rateApp.value),
            // MoreOptionModel(image:#imageLiteral(resourceName: "faq-ico"), title: MoreOptionViewModelItemType.faq.value)
        ]
        
        tableView.register(UINib(nibName:String(describing: MIMoreOptionsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIMoreOptionsTableViewCell.self))
        //items=[RecruiterActions(),CareerServices(),MonsterEducation(),Articles(),ShareApp(),Settings(),Feedback(),ContactUs(),PrivacyPolicy(),TermsCondition()]
        //   tableView.register(UINib(nibName:String(describing: MIMoreOptionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIMoreOptionTableViewCell.self))
        //   tableView.register(UINib(nibName: String(describing: MIOptionViewHeader.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: MIOptionViewHeader.self))
        tableView.delegate=self
        tableView.dataSource=self
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.bounces=true
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView=UIView(frame: .zero)
    }
    
    func checkForUpdate() {
        DispatchQueue.global(qos: .background).async {
            do {
                let update = try self.isUpdateAvailable()
                self.modelData = self.modelData.filter({ $0.title != MoreOptionViewModelItemType.updateApp.value })

                if update {
                    self.modelData.append(MoreOptionModel(image:#imageLiteral(resourceName: "downloadApp"), title: MoreOptionViewModelItemType.updateApp.value))
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func navigateToNextController(controller:UIViewController){
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}

//MARK:TableView Delegate and Datasouce implementation
extension MIMoreTabHomeViewController:UITableViewDataSource,UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelData.count
        //        let item = items[section]
        //        guard item.isCollapsible else {
        //            return item.rowCount
        //        }
        //
        //        if item.isCollapsed {
        //            return 0
        //        } else {
        //            return item.rowCount
        //        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIMoreOptionsTableViewCell.self), for: indexPath)as?MIMoreOptionsTableViewCell else {
            return UITableViewCell()
        }
        cell.modelData=self.modelData[indexPath.row]
        cell.tintColor = AppTheme.appGreyColor
        
        if self.modelData[indexPath.row].title == MoreOptionViewModelItemType.settings.value{
            cell.accessoryType = .disclosureIndicator
        }
        //        let item = items[indexPath.section]
        //        switch item.type {
        //        case .careerServices:
        //            if let career=item as? CareerServices{
        //                cell.titleLabel.text=career.subtitle[indexPath.row].rawValue
        //                cell.subTitlelabel.text=nil
        //            }
        //        case .settings:
        //            if let setting=item as? Settings{
        //                let subTitleType=setting.subtitle[indexPath.row]
        //                cell.titleLabel.text=subTitleType.rawValue
        //                cell.subTitlelabel.text=nil
        //                if subTitleType == .changecountry{
        //                    cell.subTitlelabel.text="India"
        //                }
        //            }
        //        default:
        //            break
        //        }
        return cell
    }
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: MIOptionViewHeader.self)) as? MIOptionViewHeader {
    //            let item = items[section]
    //            headerView.item = item
    //            headerView.section = section
    //            headerView.delegate = self
    //            return headerView
    //        }
    //        return UIView()
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.modelData[indexPath.row].title {
            
        case MoreOptionViewModelItemType.manageJobAlert.value:
            
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.MANAGE_JOB_ALERT, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: "", destination: CONSTANT_SCREEN_NAME.MORE_SCREEN) { (success, response, error, code) in
            }
            
            let jobAlertVc=MIManageJobAlertVC()
            self.navigateToNextController(controller: jobAlertVc)
            
            
        case MoreOptionViewModelItemType.settings.value:
            
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SETTINGS, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: "", destination: CONSTANT_SCREEN_NAME.MORE_SCREEN) { (success, response, error, code) in
            }
            
            let settingVc=MISettingMainViewController()
            self.navigateToNextController(controller: settingVc)
            
            CommonClass.googleEventTrcking("more_screen", action: "settings", label: "")
            
        case MoreOptionViewModelItemType.feedback.value:
            
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.FEEDBACK, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: "", destination: CONSTANT_SCREEN_NAME.MORE_SCREEN) { (success, response, error, code) in
            }
            
            let vc=MIFeedbackViewController()
            self.navigateToNextController(controller: vc)
            
        case MoreOptionViewModelItemType.shareApp.value:
            
            MIApiManager.hitSeekerJourneyMapEvents(CONSTANT_JOB_SEEKER_TYPE.SHARE_APP, data: ["eventValue" : CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], source: "", destination: CONSTANT_SCREEN_NAME.MORE_SCREEN) { (success, response, error, code) in
            }
            if let cell = self.tableView.cellForRow(at: indexPath) as? MIMoreOptionsTableViewCell {
                self.shareApp(cell: cell)
                
            }
            
        case MoreOptionViewModelItemType.updateApp.value:
            if let rateUrl = URL(string: ShareAppURL.appStoreUrl) {
                UIApplication.shared.open(rateUrl)
            }
            CommonClass.googleEventTrcking("more_screen", action: "update_app", label: "")

            
        case MoreOptionViewModelItemType.rateApp.value:
            if let rateUrl = URL(string: ShareAppURL.rateAppUrl) {
                UIApplication.shared.open(rateUrl)
            }
            
        case MoreOptionViewModelItemType.faq.value:
            
            let vc = MIWebViewViewController()
            vc.url = WebURl.faqUrl
            vc.ttl = "FAQ"
            let nav = MINavigationViewController(rootViewController:vc)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
            
        default:
            break
        }
        
        //        let item = items[indexPath.section]
        //        if let setting=item as? Settings{
        //            let subTitleType=setting.subtitle[indexPath.row]
        //            if subTitleType != .signout{
        //                let settingHomeVc=MISettingHomeViewController()
        //                settingHomeVc.selectedSettingType = subTitleType
        //                self.navigateToNextController(controller: settingHomeVc)
        //            }
        //
        //        }
        //
        //        if let careerServices = item as? CareerServices {
        //             let subTitle = careerServices.subtitle[indexPath.row]
        //
        //            switch (subTitle) {
        //
        //            case .xpressresume :
        //                    self.navigateToNextController(controller: MIXpressResumeViewController())
        //                    break
        //            case .rightResume :
        //
        //                    break
        //            case .careerBooster :
        //                self.navigateToNextController(controller: MICarrerAdviceTipsViewController())
        //                    break
        //            case .resumeHighlighter :
        //
        //                    break
        //            default :
        //
        //                    break
        //
        //            }
        //
        //
        //        }
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let settingVc=MISettingMainViewController()
        self.navigateToNextController(controller: settingVc)
    }
    //    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    //        return 60
    //
    //    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func shareApp(cell:MIMoreOptionsTableViewCell) {
        
        let shareUrl = URL(string: ShareAppURL.appStoreUrl)!
        
        let shareAll = [shareUrl] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad ) {
            if let popOver = activityViewController.popoverPresentationController {
                popOver.sourceView =  cell.contentView
                popOver.sourceRect = cell.contentView.frame
                
            }
        }else{
            activityViewController.popoverPresentationController?.sourceView = self.view
        }
        
        self.present(activityViewController, animated: true, completion: nil)
        
        //GA get medium
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            let activityType = activityType?.rawValue
            let type = activityType?.components(separatedBy: ".").last?.lowercased()
            
            if completed {
                self.tabbarController?.showRatingView(from: .FromAppShare)
            }
            
            CommonClass.googleEventTrcking("more_screen", action: "share_app", label: type ?? "")
        }
        
    }
    
    func isUpdateAvailable() throws -> Bool {
        guard let info = Bundle.main.infoDictionary,
            //let currentVersion = info["CFBundleShortVersionString"] as? String,
            let identifier = info["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/in/lookup?bundleId=\(identifier)") else {
                throw VersionError.invalidBundleInfo
        }
        let data = try Data(contentsOf: url)
        print(url)
        guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any] else {
            throw VersionError.invalidResponse
        }
        if let result = (json["results"] as? [Any])?.first as? [String: Any], let version = result["version"] as? String {
            
            print("version: \(version)")
            print("currentVersion: \(CurrentAppVersion)")
            return (version > CurrentAppVersion)
        }
        throw VersionError.invalidResponse
    }
    
}



//MARK:Section Header View Touch Delegate Method
extension MIMoreTabHomeViewController: HeaderViewDelegate {
    func toggleSection(header: MIOptionViewHeader, section: Int) {
        //        var item = items[section]
        //        if item.isCollapsible {
        //
        //            // Toggle collapse
        //            let collapsed = !item.isCollapsed
        //            item.isCollapsed = collapsed
        //            header.setCollapsed(collapsed: collapsed)
        //
        //            // Adjust the number of the rows inside the section
        //            tableView.beginUpdates()
        //            tableView.reloadSections([section], with: .automatic)
        //            tableView.endUpdates()
        //
        //        }else{
        //            switch item.type{
        //            case .recruiterActions:
        //                self.navigateToNextController(controller: MIRecuiterActionViewController())
        //
        //            case .feedback:
        //                self.navigateToNextController(controller: MIFeedbackViewController())
        //            case .monsterEducation:
        //                self.navigateToNextController(controller: MIEduTechnologyDetailViewController())
        //            default:
        //                break
        //            }
        //        }
    }
    
}


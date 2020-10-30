//
//  MISearchViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 06/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIAutoSuggestInfo: Equatable {
    static func == (lhs: MIAutoSuggestInfo, rhs: MIAutoSuggestInfo) -> Bool {
        lhs.name.lowercased() == rhs.name.lowercased()
    }
    
    var id   = ""
    var name = ""
    var suggestedType = ""
    
    init(with dict: [String: Any]) {
        self.id            = dict.stringFor(key: "id")
        self.name          = dict.stringFor(key: "name")
        self.suggestedType = dict.stringFor(key: "suggestType")
    }
    
    init(id: String, name: String, type: SkillCategory) {
        self.id     = id
        self.name   = name.withoutWhiteSpace()
        self.suggestedType = type.rawValue
    }
}

class MISearchViewController: MIBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectedViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak private var tblView:UITableView!
    lazy   var searchBar:MISearchBar = MISearchBar(frame:CGRect(x: 0, y: 0, width:Double(self.view.frame.size.width-60), height: 30))
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var btnCurrentLocation: UIButton!
    @IBOutlet weak var btnChangeLocation: UIButton!
    private var recentSearchView = MIRecentSearchView.header
    
    private var cellId            = "recentSearchCell"
    private var recentSearchArray = [MISearchInfo]()
    private var fileterArray      = [MIAutoSuggestInfo]()
    private var suggestionList    = [MIAutoSuggestInfo]()
    var selectedInfoArray = [String]()
    private var searchCellId      = "searchCell"
    private var suggestionCellId  = "suggestionCell"
    private var isSearching       = false
    private var isProductSelected = false
    private var isFirstTimeSearchSelected = false
    var locationList      = [String]()
    
    @IBOutlet weak var searchBtn: UIButton!
    
    lazy private var advanceSearchBtn: UIBarButtonItem = {
        let image = UIImage(named: "advance_search_icon", in: bundle(), compatibleWith: nil)
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(advanceSearch));
        button.tintColor = navigationController?.navigationBar.tintColor
        //        let title = NSLocalizedString("mbdoccapture.done_button", tableName: nil, bundle: bundle(), value: "Done", comment: "")
        //        let button = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(DoneLocation))
        //        button.tintColor = navigationController?.navigationBar.tintColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.navigationItem.rightBarButtonItem = advanceSearchBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
        self.navigationItem.title = ""
        searchBar.becomeFirstResponder()
        self.locationSelected(locArray: self.locationList)
        self.searchJobSeekerEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.LANDING], type: CONSTANT_JOB_SEEKER_TYPE.SEARCH)

        
    }

    func setUI() {
        self.callAPIForGetRecentSearchOptions()
        searchBtn.showPrimaryBtn()
        //self.navigationController?.navigationBar.isHidden = true
        self.btnCurrentLocation.setTitle("Add Location", for: .normal)
        self.btnCurrentLocation.frame.size.width = self.btnCurrentLocation.frame.size.width + 20
        self.btnChangeLocation.setTitle("", for: .normal)
        locationView.addShadow(opacity: 0.3)
        self.navigationItem.titleView=searchBar
       // self.navigationItem.leftBarButtonItem=UIBarButtonItem(image: #imageLiteral(resourceName: "back_bl"), style: .plain, target:self, action: #selector(MISearchViewController.backbarButtonAction(_:)))

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        searchBar.miDelegate=self
        searchBar.placeholder = "Search by keywords, skills etc."
        searchBar.showsCancelButton = true
        if #available(iOS 10.0, *) {
            searchBar.showVoiceSearch = true
        } else {
            searchBar.showVoiceSearch = false
        }
        self.btnChangeLocation.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
        self.btnCurrentLocation.setTitleColor(AppTheme.defaltBlueColor, for: .normal)

        recentSearchArray.removeAll()
        
        self.tblView.register(UINib(nibName: "MIRecentSearchCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.tblView.register(UINib(nibName: "MISearchCell", bundle: nil), forCellReuseIdentifier: searchCellId)
        self.tblView.register(UINib(nibName: "MISearchSuggestedCell", bundle: nil), forCellReuseIdentifier: suggestionCellId)
        
        self.showSelection(list: self.selectedInfoArray)
        self.recentSearchView.clearAll_Btn?.addTarget(self, action: #selector(btnRecentSearchClearAll(_:)), for: .touchUpInside)
        self.tblView.tableFooterView = UIView()
        self.tblView.reloadData()
    }
    
    @objc private func advanceSearch() {
       if let vcs = self.navigationController?.viewControllers {
        for (index,vc) in vcs.enumerated(){
            if vc is MIAdvanceSearchViewController{
                self.navigationController?.viewControllers.remove(at: index)
                break
            }
        }
        }
        self.searchJobSeekerEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], type: CONSTANT_JOB_SEEKER_TYPE.ADVANCED_SEARCH)
        let vc = MIAdvanceSearchViewController()
        vc.searchModel.skill = selectedInfoArray
        var loc = [MICategorySelectionInfo]()
        for locName in locationList {
            loc.append(MICategorySelectionInfo(dictionary: ["name":locName]) ?? MICategorySelectionInfo())
        }
        vc.searchModel.location = loc
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func btnRecentSearchClearAll(_ sender: UIButton) {
        self.searchJobSeekerEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLEAR_ALL], type: CONSTANT_JOB_SEEKER_TYPE.RECENT_SEARCHES)
        CommonClass.googleEventTrcking("search_screen", action: "recent_searches", label: "clear_all") //GA
        self.startActivityIndicator()
        MIApiManager.callAPIForDeleteRecentSearchAll { (isSucess, response, error, code) in
            DispatchQueue.main.async {
                if isSucess {
                    print("Deletecd Successfully")
                    //                    self.callAPIForGetRecentSearchOptions()
                    self.recentSearchArray.removeAll()
                    self.tblView.reloadData()
                    self.stopActivityIndicator()
                }
            }
        }
    }
    
    func showRightBarButtonItem(isShow:Bool){
        if isShow {
            let searchBtn = UIBarButtonItem(image:UIImage(named: "search-purple"), style: .plain, target:self, action: #selector(MISearchViewController.searchJobsAction(_:)))
            self.navigationItem.rightBarButtonItems = [searchBtn,advanceSearchBtn]
        } else {
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = advanceSearchBtn
        }
    }
    
    @IBAction func searchClicked(_ sender: UIButton) {
        if locationList.count > 0 || suggestionList.count > 0 || self.searchBar.text?.count ?? 0 > 1 || self.selectedInfoArray.count > 0 {
            self.showSearchResultViewController()
            
            CommonClass.googleEventTrcking("search_screen", action: "search_cta", label: "")
        } else {
            self.showAlert(title: "", message: "Please enter a keyword such as java, sales or name of the city.")
        }
        
        if self.searchBar.text?.count ?? 0 > 0 || locationList.count > 0 || self.selectedInfoArray.count > 0 {
            self.searchJobSeekerEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], type: CONSTANT_JOB_SEEKER_TYPE.SEARCH_BUTTON)

        }else{
            self.searchJobSeekerEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK,"validationErrorMessages":[["field":"search","message":"Please enter a keyword such as java, sales or name of the city."]]], type: CONSTANT_JOB_SEEKER_TYPE.SEARCH_BUTTON)

        }

    }
    
    @IBAction func currentLocationClicked(_ sender: UIButton) {
        CommonClass.googleEventTrcking("search_screen", action: "add_location", label: "current_location") //GA
        self.searchJobSeekerEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], type: CONSTANT_JOB_SEEKER_TYPE.ADD_LOCATION)
        let vc = MISearchLocationViewController()
        vc.delegate = self
        let btnTxt  = self.btnCurrentLocation.titleLabel?.text
        let locList = btnTxt?.components(separatedBy: ",")
        if btnTxt?.lowercased() != "Add Location".lowercased() {
            vc.selectedInfoArray = locList ?? [String]()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func changeLocationClicked(_ sender: UIButton) {
        CommonClass.googleEventTrcking("search_screen", action: "add_location", label: "changes") //GA
        
        let vc = MISearchLocationViewController()
        vc.delegate = self
        let btnTxt  = self.btnCurrentLocation.titleLabel?.text
        let locList = btnTxt?.components(separatedBy: ",")
        if btnTxt?.lowercased() != "Add Location".lowercased() {
            vc.selectedInfoArray = locList ?? [String]()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)

        var newNavigationController=[UIViewController]()
        var prevView:UIViewController?
      
        if let vcs=self.navigationController?.viewControllers{
            for vc in vcs{
                if let _ = vc as? MISRPJobListingViewController{
                    prevView=vc
                }else{
                    newNavigationController.append(vc)
                }
            }
        }
        if prevView == nil{
            self.navigationController?.popViewController(animated: true)
        } else{
            newNavigationController.append(prevView!)
            self.navigationController?.viewControllers = newNavigationController
        }
    }
    @objc func searchJobsAction( _ sender:UIBarButtonItem) {
        self.showSearchResultViewController()

    }
    
    @objc func backbarButtonAction(_ sender:UIBarButtonItem){
        searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
//        self.view.endEditing(true)

//        var newNavigationController=[UIViewController]()
//        var prevView:UIViewController?
//        var adVance:UIViewController?
//        if let vcs=self.navigationController?.viewControllers{
//            for vc in vcs{
//                if let prevVc=vc as? MISRPJobListingViewController{
//                    prevView=prevVc
//                    continue
//                }
//                if let adv=vc as? MIAdvanceSearchViewController{
//                    adVance=adv
//                    continue
//                }
//
//            newNavigationController.append(vc)
//
//            }
//        }
//        if adVance != nil{
//           newNavigationController.append(adVance!)
//        }
//        if (prevView != nil){
//            newNavigationController.append(prevView!)
//            self.navigationController?.viewControllers=newNavigationController
//        }else{
//        self.navigationController?.popViewController(animated: true)
//        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
//        let keyboardFrame: NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
//        let keyboardRectangle = keyboardFrame.cgRectValue
//        let keyboardHeight    = keyboardRectangle.height
//        self.tblViewBottomConstraint.constant = -(keyboardHeight + 5 + 70)
    }
    
    func getSearchArray() -> [String] {
        var strArray = [String]()
        let array = self.searchBar.text?.components(separatedBy: ",")
        strArray = self.removeDuplicates(arr: array ?? [" test"])
        strArray.removeLast()
        return strArray
    }
    
    func removeDuplicates(arr:[String]) -> [String] {
        var strArray = [String]()
        for str:String in arr {
            let txtWithoutSpace = str.withoutWhiteSpace()
            if !strArray.contains(txtWithoutSpace) {
                strArray.append(txtWithoutSpace)
            }
        }
        return strArray
    }

   
    //MARK:- UITableViewDataSource,UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isProductSelected {
            return 1
        } else if isSearching {
            return self.fileterArray.count
        } else {
            return self.recentSearchArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isProductSelected, let cell = tblView.dequeueReusableCell(withIdentifier: suggestionCellId) as? MISearchSuggestedCell {
            cell.addSuggestionList(list: suggestionList, selectedList: self.selectedInfoArray)
            cell.delegate = self
            return cell
        } else if isSearching, let cell = tblView.dequeueReusableCell(withIdentifier: searchCellId) as? MISearchCell {
            cell.show(info: fileterArray[indexPath.row])
            
            
            if (self.selectedInfoArray.filter({$0.lowercased() == fileterArray[indexPath.row].name.lowercased()}).count > 0) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            return cell
        }
        if let cell = tblView.dequeueReusableCell(withIdentifier: cellId) as? MIRecentSearchCell {
            cell.show(info: recentSearchArray[indexPath.row], cellTag: indexPath.row)
            cell.delegate = self
            return cell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSearching || isProductSelected {
            return UIView()
        }
        if recentSearchArray.count > 0 {
//            recentSearchView.clearAll_Btn?.isHidden = true
            recentSearchView.clearAll_Btn?.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
            recentSearchView.recentsearch_Btn?.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
            return recentSearchView
        }else{
            return UIView()

        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSearching || isProductSelected {
            return 0
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            let searchingSelectedInfo = fileterArray[indexPath.row]
            self.updateSelectedList(selectedTtl: searchingSelectedInfo.name)
            searchBar.text = ""
            
        }else if isProductSelected {
            
        } else if self.recentSearchArray.count > 0 {
            
            self.searchJobSeekerEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], type: CONSTANT_JOB_SEEKER_TYPE.RECENT_SEARCHES)
            self.updateSelectedList(selectedTtl: self.recentSearchArray[indexPath.row].title)
            CommonClass.googleEventTrcking("search_screen", action: "recent_searches", label: "\(indexPath.row)") //GA
        }
    }
    
}


extension MISearchViewController: MISearchBarDelegate {
    
    func updateSelectedList(selectedTtl:String) {
        var isAppending = false
        
        //self.selectedInfoArray.contains(selectedTtl)
        if (self.selectedInfoArray.filter({$0.lowercased() == selectedTtl.lowercased()}).count > 0) {
            self.delete(element: selectedTtl)
        } else {
            isAppending = true
            selectedInfoArray.append(selectedTtl)
        }
        self.showSelection(list: selectedInfoArray,isAppending: isAppending)
        if isAppending {
            self.callSuggestedKeywordApi(suggestTxt: selectedTtl)
            isProductSelected = true
        }
        if self.recentSearchArray.count>0 && !isSearching{
            if self.recentSearchArray.filter({$0.title == selectedTtl}).count > 0{
                self.showSearchResultViewController()
            }
        }
        self.tblView.reloadData()
    }
    
    @available(iOS 10.0, *)
    func voiceButtonAction(_ btn: UIButton) {
        self.searchJobSeekerEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], type: CONSTANT_JOB_SEEKER_TYPE.VOICE_SEARCH)
        let vc = MISpeechRecognitionVC()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
        vc.completionHandler = { data in
            guard data.experience.count + data.locations.count + data.salary.count + data.skills.count > 0 else  {
                return
            }
        
            CommonClass.predefinedViewSearchResult(data.skills.joined(separator: ",")) //FireBase PreDefined for search
            let prevView=MISRPJobListingViewController()
            
            prevView.selectedSkills = data.skills.joined(separator: ",")
            prevView.selectedLocation =  data.locations.joined(separator: ",")

            let exp = data.experience
                .map({ ($0.contains("year") || $0.contains("yrs")) ? $0.parseInt ?? 0 : 0})
                .sorted(by: { $0 < $1 })
            if !exp.isEmpty {
                let lowerLimit = (exp.first ?? 0).stringValue
                let upperLimit = (exp.last ?? 0).stringValue
                prevView.param["experienceRanges"] = [lowerLimit + "~" + upperLimit]
            }
            
            
            let sal = data.salary
                .map({ ($0.contains("lakh") || $0.contains("lac")) ? ($0.parseInt ?? 0) * 100000 : 0 })
                .sorted(by: { $0 < $1 })
            if !sal.isEmpty {
                let lowerLimit = (sal.first ?? 0).stringValue
                let upperLimit = (sal.last ?? 0).stringValue

                prevView.param["salaryRanges"] = [lowerLimit + "~" + upperLimit]
            }
            
            self.navigationController?.pushViewController(prevView, animated: false)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        if text != "\n"{
            fileterArray.removeAll()
            let searchString = NSString(string: searchBar.text ?? "").replacingCharacters(in: range, with: text )
            isSearching = false
            isProductSelected = false
            if searchString.count >= 2 {
                isSearching = true
                self.callAutoSuggestApi(suggestKeyword: searchString.addValueOFSpace())
            }
        }
        self.tblView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) { 
            self.searchBar.showVoiceSearch = self.searchBar.text!.isEmpty
        }
        
        return true
    }
    
    //MARK: - API Calling Helper Methods
    func callAPIForGetRecentSearchOptions() {
        
        MIApiManager.callAPIForGETRecentKeywords(methodType: .get, path: APIPath.recentSearchGETAPIEndpoint) { (success, response, error, code) in
            DispatchQueue.main.async { 
            if success && (code >= 200) && (code <= 299) {
                if let responseData = response as? [[String:Any]]{
                    
                    for dict in responseData {
                        if let events = dict["events"] as? [[String:Any]] , let eventData = events.first {
                            //if let action = eventData["action"] as? String {
                             //   if (action == "job-listing") {
                                    let recentModel = MISearchInfo(dict: eventData)
                                    if !recentModel.title.withoutWhiteSpace().isEmpty {
                                        self.recentSearchArray.append(recentModel)
                                    }
                             //   }
                               
                            //}
                            
                           }
                        }
                    
                        self.tblView.reloadData()
                }
                
            } else {
                self.handleAPIError(errorParams: response, error: error)
            }
                
            }
        }
    }
    
    func getExcludeKeywords() -> String {
        var excludeString = ""
        if selectedInfoArray.count > 0 {
            for i in 0 ..< selectedInfoArray.count {
                excludeString = excludeString + "&excludeKeywords=\(selectedInfoArray[i])"
            }
        }
        return excludeString
    }
    
    func callAutoSuggestApi(suggestKeyword:String)
    {
        MIApiManager.callAutoSuggest(searchTxt: suggestKeyword, excludeString: self.getExcludeKeywords()) { [weak wSelf = self] (isSuccess, response, error, code) in
            DispatchQueue.main.async {
                if isSuccess, let res = response as? [String:Any], let data = res["data"] as? [[String:Any]] {
                    for dic in data {
                        let objSkill = MIAutoSuggestInfo.init(with: dic)
                        wSelf?.fileterArray.append(objSkill)
                    }
                }
                
                if let arr = wSelf?.fileterArray,arr.count > 0 {
                    wSelf?.fileterArray = arr.removeSearchAutoSuggestedDuplicates() 
                }
                
                wSelf?.tblView.reloadData()
            }
        }
    }
    
    func callSuggestedKeywordApi(suggestTxt:String) {
        MIApiManager.callSuggestedKeyword(key: suggestTxt, excludeString: self.getExcludeKeywords()){ [weak wSelf = self] (isSuccess, response, error, code) in
            DispatchQueue.main.async {
                wSelf?.isProductSelected = true
                if isSuccess, let res = response as? [String:Any],let data = res["data"] as? [[String:Any]] {
                    var arr = [MIAutoSuggestInfo]()
                    
                    for dic in data {
                        let objSkill = MIAutoSuggestInfo.init(with: dic)
                        arr.append(objSkill)
                    }
                    
                    if arr.count > 0 {
                        wSelf?.suggestionList.removeAll()
                        wSelf?.suggestionList = arr
                    }
                }
                wSelf?.tblView.reloadData()
            }
        }
    }
    
    func callAPIForSearchSeekerJourneyMapEvent(type:String,referralScreen:String,data:[String:Any]) {
        MIApiManager.hitSeekerJourneyMapEvents(type, data: data, source: referralScreen, destination: CONSTANT_SCREEN_NAME.SEARCH) { (success, response, error, code) in
            
        }
    }
    
    func showSearchResultViewController(){
        CommonClass.googleEventTrcking("dashboard_screen", action: "search", label: "")

        if  selectedInfoArray.count == 0 && self.searchBar.text?.count == 0 && locationList.count == 0{
            self.showAlert(title: "", message: "Please select atleast one filter to get better result for your job.")
            
        }else {
       
        if let vcs = self.navigationController?.viewControllers{
            for (index,vc) in vcs.enumerated(){
                if let _ = vc as? MISRPJobListingViewController{
                    self.navigationController?.viewControllers.remove(at: index)
                    //break
                }
                if let _ = vc as? MIAdvanceSearchViewController{
                    self.navigationController?.viewControllers.remove(at: index)
                    //break
                }
                
            }
        }
            
        if self.searchBar.text?.withoutWhiteSpace().count ?? 0 > 0 {
            
          //  self.selectedInfoArray.filter({$0.lowercased() == self.searchBar.text?.lowercased()}).count > 0
            //self.selectedInfoArray.contains(self.searchBar.text ?? "")
            if !(self.selectedInfoArray.filter({$0.lowercased() == self.searchBar.text?.lowercased()}).count > 0) {
                    selectedInfoArray.append(self.searchBar.text ?? "")
                    self.showSelection(list: selectedInfoArray,isAppending: true)

                }
                self.searchBar.text = ""
            }
        CommonClass.predefinedViewSearchResult(selectedInfoArray.joined(separator: ",")) //FireBase PreDefined for search
            
        let prevView=MISRPJobListingViewController()
        if selectedInfoArray.count != 0{
            prevView.selectedSkills = selectedInfoArray.joined(separator: ",")
        }else{
            prevView.selectedSkills=self.searchBar.text ?? ""
        }
        prevView.selectedLocation = locationList.joined(separator: ",")
        //newNavigationController.append(prevView)
        self.navigationController?.pushViewController(prevView, animated: false)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchJobSeekerEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], type: CONSTANT_JOB_SEEKER_TYPE.SEARCH_BUTTON)
        self.showSearchResultViewController()
    }

    func searchJobSeekerEvent(data:[String:Any],type:String) {
        guard let nc = self.navigationController else { return }
        if nc.containsViewController(ofKind: MIHomeViewController.self) {
            self.callAPIForSearchSeekerJourneyMapEvent(type: type, referralScreen: CONSTANT_SCREEN_NAME.HOME, data: data)
        }else{
            self.callAPIForSearchSeekerJourneyMapEvent(type: type, referralScreen: CONSTANT_SCREEN_NAME.WELCOME, data: data)
        }
    }
}

extension MISearchViewController: MIMasterDataSelectionViewDelegate,MISearchSuggestedCellDelegate,MISearchLocationDelegate {
    
    // MARK:- MISearchLocationDelegate
    func locationSelected(locArray: [String]) {
        
        locationList.removeAll()
        if locArray.count > 0 {
            locationList.append(contentsOf: locArray)
            self.btnCurrentLocation.setTitle(locArray.joined(separator: ","), for: .normal)
            self.btnChangeLocation.setTitle("Change", for: .normal)
            self.showRightBarButtonItem(isShow: true)
        }else{
            locationList.removeAll()
            self.btnCurrentLocation.setTitle("Add Location", for: .normal)
            self.btnChangeLocation.setTitle("", for: .normal)

        }
    }
    
    func preferLocationSelected() {
        locationList.removeAll()
        if let tabBar = self.tabBarController as? MIHomeTabbarViewController {
            self.locationList =  tabBar.jobPreferenceInfo.preferredLocationList.map({$0.name})
            let preferlist = self.locationList.joined(separator: ",")
            self.btnCurrentLocation.setTitle(preferlist, for: .normal)
            self.btnChangeLocation.setTitle("Change", for: .normal)
            self.showRightBarButtonItem(isShow: true)
        }
    }
    
    // MARK:- MISearchSuggestedCellDelegate
    func searchSuggestionCellClicked(ttl: String) {
        self.searchJobSeekerEvent(data: ["eventValue":CONSTANT_JOB_SEEKER_EVENT_VALUE.CLICK], type: CONSTANT_JOB_SEEKER_TYPE.SUGGESTIONS_CLICK)
        self.updateSelectedList(selectedTtl: ttl)
    }

    // MARK:- MIMasterDataSelectionViewDelegate
    func removeListItem(item: String) {
        if !item.isEmpty {
            self.delete(element: item)
            self.showSelection(list: selectedInfoArray)
            self.tblView.reloadData()
            
            CommonClass.googleEventTrcking("search_screen", action: "search_suggestion", label: "cross")
        }
    }
    
    func removeAll()
    {
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func delete(element: String) {
        self.selectedInfoArray = selectedInfoArray.filter() { $0.lowercased() != element.lowercased() }
    }
    
    func showSelection(list:[String], isAppending:Bool = false) {
        var xOrigin = 10
        if !isAppending {
            self.removeAll()
        }
        if list.count == 0 {
            self.selectedViewHeightConstraint.constant = 0
        } else {
            self.selectedViewHeightConstraint.constant = 44
        }
        if list.count > 0 {
            self.showRightBarButtonItem(isShow: true)
        } else {
            self.showRightBarButtonItem(isShow: false)
//            self.navigationItem.rightBarButtonItem = advanceSearchBtn
        }
        for index in 0..<list.count {
            let sugView = MIMasterDataSelectionView.selectedView
            sugView.show(ttl: list[index])
            sugView.frame.size.width = sugView.titleLbl.frame.size.width + 50
            sugView.frame = CGRect(x: CGFloat(xOrigin), y: 7, width: sugView.frame.size.width, height: sugView.frame.size.height-10)
            sugView.delegate = self
            xOrigin = xOrigin + Int(sugView.frame.size.width + 10)

           // xOrigin = Int(sugView.frame.maxX + 10)
            self.scrollView.addSubview(sugView)
            self.scrollView.contentSize = CGSize(width: xOrigin + 10, height: 0)
        }
        
        let scrollWidth = kScreenSize.width
        let totalWidth = self.scrollView.contentSize.width - scrollWidth
        let xIndex = (totalWidth/(scrollWidth))
        if xIndex > 0 {
            self.scrollView.setContentOffset(CGPoint(x: CGFloat(xIndex)*CGFloat(scrollWidth), y: 0), animated: isAppending)
        }
    }
}

extension MISearchViewController:MIRecentSearchCellDelegate {
    func recentSearchDelete(data: String, cellTag: Int) {
        self.startActivityIndicator()
        MIApiManager.callAPIForDeleteRecentKeywords(keywords: data, completion: { (isSucess, response, error, code) in
            DispatchQueue.main.async {
                if isSucess {
                   // #warning("index out of bound crash on fabric")
                    let updateArray = self.recentSearchArray.filter({$0.title.lowercased() != data.lowercased()})
                    self.recentSearchArray =  updateArray
                    self.tblView.reloadData()
                    self.stopActivityIndicator()
                }
            }
        })
    }
    
}



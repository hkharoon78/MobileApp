//
//  MIAdvanceSearchJobViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 25/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol MIAdvanceSearchJobViewControllerDelegate:class {
    func skillSelected(skills:[String])
}
class MIAdvanceSearchJobViewController: MIBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var tblView:UITableView!
    weak var delegate:MIAdvanceSearchJobViewControllerDelegate?
//    lazy var searchBar:MISearchBar = MISearchBar(frame:CGRect(x: 0, y: 0, width:Double(self.view.frame.size.width-60), height: 30))

    @IBOutlet weak var textField: UITextField!
    
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
    private var locationList      = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        self.navigationItem.title = "Select Skill"
//        searchBar.becomeFirstResponder()
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    func setUI() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        recentSearchArray.removeAll()
        self.tblView.register(UINib(nibName: "MIRecentSearchCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.tblView.register(UINib(nibName: "MISearchCell", bundle: nil), forCellReuseIdentifier: searchCellId)
        self.tblView.register(UINib(nibName: "MISearchSuggestedCell", bundle: nil), forCellReuseIdentifier: suggestionCellId)
        
        self.showSelection(list: self.selectedInfoArray)
        self.tblView.tableFooterView = UIView()
        self.tblView.reloadData()
    }
    
   
    @objc func searchJobsAction( _ sender:UIBarButtonItem) {
//        self.showSearchResultViewController()
    }
    
    @objc func backbarButtonAction(_ sender:UIBarButtonItem){
//        searchBar.resignFirstResponder()
        //        self.view.endEditing(true)
        
        var newNavigationController=[UIViewController]()
        var prevView:UIViewController?
        if let vcs=self.navigationController?.viewControllers{
            for vc in vcs{
                if let prevVc=vc as? MISRPJobListingViewController{
                    prevView=prevVc
                }else{
                    newNavigationController.append(vc)
                }
            }
        }
        if (prevView != nil){
            newNavigationController.append(prevView!)
            self.navigationController?.viewControllers=newNavigationController
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func selectionDone() {
        self.stopActivityIndicator()
        self.delegate?.skillSelected(skills: selectedInfoArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneClicked() {
        self.selectionDone()
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
            cell.accessoryType = .checkmark

            if selectedInfoArray.contains(fileterArray[indexPath.row].name) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
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
        } else {
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
        if isSearching && fileterArray.count > indexPath.row{
            let searchingSelectedInfo = fileterArray[indexPath.row]
            self.updateSelectedList(selectedTtl: searchingSelectedInfo.name)
            //  searchBar.text = ""
            
        }else if isProductSelected {
            
        } else if self.recentSearchArray.count > 0 {
            
            self.updateSelectedList(selectedTtl: self.recentSearchArray[indexPath.row].title)
        }
    }
    
}


extension MIAdvanceSearchJobViewController: MISearchBarDelegate,UITextFieldDelegate {
    
    func updateSelectedList(selectedTtl:String) {
        var isAppending = false
        if self.selectedInfoArray.contains(selectedTtl) {
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
//        if self.recentSearchArray.count>0{
//            if self.recentSearchArray.filter({$0.title == selectedTtl}).count > 0{
//                self.showSearchResultViewController()
//            }
//        }
        self.tblView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        fileterArray.removeAll()

        let searchString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        isSearching = false
        isProductSelected = false
        if searchString.count >= 2 {
            isSearching = true
            self.callAutoSuggestApi(suggestKeyword: searchString.addValueOFSpace())
        }else {
            //For future case handle

        }
        self.tblView.reloadData()

        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.selectionDone()
        return true
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
//    func showSearchResultViewController(){
//        if  selectedInfoArray.count == 0 && self.searchBar.text?.count == 0 && locationList.count == 0{
//            self.showAlert(title: "", message: "Please select atleast one filter to get better result for your job.")
//
//        }else{
//            // var newNavigationController=[UIViewController]()
//            //var prevView:UIViewController?
//            //        if let vcs=self.navigationController?.viewControllers{
//            //            for vc in vcs{
//            //                if let _ = vc as? MISRPJobListingViewController{
//            //                    continue
//            //                }else{
//            //                    newNavigationController.append(vc)
//            //                }
//            //            }
//            //        }
//            if let vcs=self.navigationController?.viewControllers{
//                for (index,vc) in vcs.enumerated(){
//                    if let _ = vc as? MISRPJobListingViewController{
//                        self.navigationController?.viewControllers.remove(at: index)
//                        //break
//                    }
//
//                }
//            }
//
//            let prevView=MISRPJobListingViewController()
//            if selectedInfoArray.count != 0{
//                prevView.selectedSkills = selectedInfoArray.joined(separator: ",")
//            }else{
//                prevView.selectedSkills=self.searchBar.text ?? ""
//            }
//            prevView.selectedLocation = locationList.joined(separator: ",")
//            //newNavigationController.append(prevView)
//            self.navigationController?.pushViewController(prevView, animated: false)
//        }
//    }
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        self.showSearchResultViewController()
//    }
    

    
}

extension MIAdvanceSearchJobViewController: MIMasterDataSelectionViewDelegate,MISearchSuggestedCellDelegate {
    
    // MARK:- MISearchSuggestedCellDelegate
    func searchSuggestionCellClicked(ttl: String) {
        self.updateSelectedList(selectedTtl: ttl)
    }
    
    // MARK:- MIMasterDataSelectionViewDelegate
    func removeListItem(item: String) {
        if !item.isEmpty {
            self.delete(element: item)
            self.showSelection(list: selectedInfoArray)
            self.tblView.reloadData()
        }
    }
    
    func removeAll()
    {
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func delete(element: String) {
        self.selectedInfoArray = selectedInfoArray.filter() { $0 != element }
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
        for index in 0..<list.count {
            let sugView = MIMasterDataSelectionView.selectedView
            sugView.show(ttl: list[index])
            sugView.frame.size.width = sugView.titleLbl.frame.size.width + 50
            sugView.frame = CGRect(x: CGFloat(xOrigin), y: 7, width: sugView.frame.size.width, height: sugView.frame.size.height-10)
            sugView.delegate = self
            xOrigin = Int(sugView.frame.maxX + 10)
            self.scrollView.addSubview(sugView)
            
            self.scrollView.contentSize = CGSize(width: xOrigin + 10, height: 0)
        }
        
        let scrollWidth = kScreenSize.width
        let totalWidth = self.scrollView.contentSize.width - scrollWidth
        let xIndex = (totalWidth/(scrollWidth))
        if xIndex > 0 {
            let xValue : CGFloat = CGFloat(xIndex)*CGFloat(scrollWidth)
            self.scrollView.setContentOffset(CGPoint(x: xValue, y: 0), animated: isAppending)
        }
    }
}

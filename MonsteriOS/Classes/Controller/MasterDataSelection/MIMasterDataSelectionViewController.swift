//
//  MIMasterDataSelectionViewController.swift
//  MonsteriOS
//
//  Created by Monster on 01/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
//import RealmSwift

protocol MIMasterDataSelectionViewControllerDelegate:class {
    func masterDataSelected(selectedCategoryInfo:[MICategorySelectionInfo],selectedListInfo:[String],enumName:String)
}

class MIMasterDataSelectionViewController: MIBaseViewController,MIMasterDataSelectionViewDelegate {
    
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var selectedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak private var tblView:UITableView!
    @IBOutlet weak var addBtnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var addBtn: UIButton!

    private var cellId    = "defaultCell"
    var selectedTitle     = ""
    var infoArray         = [MICategorySelectionInfo]()
    var filterDataArray   = [MICategorySelectionInfo]()
    var selectDataArray   = [MICategorySelectionInfo]()
    var excludedData      = [MICategorySelectionInfo]()

    var selectedInfoArray = [String]()
    var limitSelectionCount = 2
    var limitCount        = 0
    var isoCountryCode    : String?

    var masterType        = MasterDataType.ROLE
    var limitAlert        = MIMasterDataLimitAlert.view
    var limitAlertShowing = false
    var otherContains     = [MICategorySelectionInfo]()
    var parentId          = ""
    weak var delegate:MIMasterDataSelectionViewControllerDelegate?
    var selectionHandler: (([MICategorySelectionInfo])->Void)?
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    var shouldShowAdd = true
    class var newInstance: MIMasterDataSelectionViewController {
        get {
            return MIMasterDataSelectionViewController()
        }
    }
    
    override func viewDidLoad() {
    //    self.navigationItem.title = masterType.masterTitle.capitalized
        if shouldShowAdd {
            shouldShowAdd  = masterType.shouldShowAdd
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.stopActivityIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        if masterType == MasterDataType.ITSkill {
            self.navigationItem.title = masterType.masterTitle
        } else {
            self.navigationItem.title = masterType.masterTitle.capitalized
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.selectDataArray.count == 0 && self.selectedInfoArray.count == 0 && self.limitSelectionCount == 1 && masterType.isOptional {
            if let info = MICategorySelectionInfo(dictionary: [:]) {
                
                self.selectedInfoArray.append(info.name)
                self.selectDataArray.append(info)
                self.delegate?.masterDataSelected(selectedCategoryInfo: self.selectDataArray, selectedListInfo: self.selectedInfoArray, enumName: masterType.rawValue)
            }
        }
    }
    
    override func initUI() {
        
        self.addBtnWidthConstraint.constant = 0
        self.selectedInfoArray = self.selectedInfoArray.filter() { $0 != "" }
        let xOrigin =  (kScreenSize.width - limitAlert.frame.size.width)/2
        limitAlert.frame = CGRect(x: xOrigin, y: kScreenSize.height + 100, width: limitAlert.frame.size.width, height: limitAlert.frame.size.height)
        limitAlert.showlimit(limit: self.limitSelectionCount)
        self.view.addSubview(limitAlert)
        self.addBtn.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
        if let modf = GlobalVariables.masterDataTypeArray.filter ({ $0.key == masterType.rawValue }).first {
            self.limitCount = Int(modf.data_count) ?? 0
        }
        
        self.tblView.register(UINib(nibName: "MIDefaultSelectionCell", bundle: nil), forCellReuseIdentifier: cellId)
        self.tblView.tableFooterView = UIView()
        self.populateDataSource()
        self.navigationController?.navigationBar.isHidden = false
        self.showSelection(list: self.selectedInfoArray)
        if limitSelectionCount > 1 {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        }
        
        if !parentId.isEmpty {
            
        }
        
    }
    
    // MARK:- Action
    @IBAction func addClicked(_ sender: UIButton) {
        if limitSelectionCount == 1 {
            selectedInfoArray.removeAll()
            selectDataArray.removeAll()
        }
        selectedInfoArray.append(self.searchTxtField.text ?? "")
        let info = MICategorySelectionInfo(dictionary: [:])
        info?.uuid = "" //otherContains.first?.uuid ?? "bd567eeb-9cf1-4a04-83f2-1512d8428f2a"
        info?.name = self.searchTxtField.text ?? ""
        selectDataArray.append(info!)
        self.delegate?.masterDataSelected(selectedCategoryInfo: selectDataArray, selectedListInfo: selectedInfoArray, enumName: masterType.rawValue)
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneClicked() {
        
        //find category model array
//        var selectedCategoryInfo = [MICategorySelectionInfo]()
//        for info in infoArray {
//            if selectedInfoArray.contains(info.name) {
//                selectedCategoryInfo.append(info)
//            }
//        }
        self.stopActivityIndicator()
        self.delegate?.masterDataSelected(selectedCategoryInfo: selectDataArray, selectedListInfo: selectedInfoArray, enumName: masterType.rawValue)
        self.selectionHandler?(selectDataArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:- Private Methdods
    func removeAll()
    {
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
    }
    
    func deleteObj(obj: MICategorySelectionInfo) {
        selectDataArray = selectDataArray.filter() { $0.name != obj.name }

    }
    
    func delete(element: String) {
        selectedInfoArray = selectedInfoArray.filter() { $0 != element }
    }
    
    func showSelection(list:[String], isAppending:Bool = false) {
        var xOrigin = 10
        if !isAppending {
            self.removeAll()
        }
        
        if list.count == 0 {
            self.selectedViewHeightConstraint.constant = 0
        } else {
            self.selectedViewHeightConstraint.constant = 60
        }
        
        for index in 0..<list.count {
            let sugView = MIMasterDataSelectionView.selectedView
            sugView.show(ttl: list[index])
            sugView.circular(0, borderColor:nil)
            sugView.frame.size.width = sugView.titleLbl.frame.size.width + 50
            sugView.frame = CGRect(x: CGFloat(xOrigin), y: 12.0, width: sugView.frame.size.width, height: sugView.frame.size.height)
            sugView.delegate = self
            sugView.backgroundColor = AppTheme.defaltBlueColor
            xOrigin = Int(sugView.frame.maxX + 10)
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
    
    func populateDataSource()  {
        if masterType.isFromDB, let decodedData  = userDefaults.object(forKey: self.masterType.rawValue) as? Data, let arr = NSKeyedUnarchiver.unarchiveObject(with: decodedData) as? [MICategorySelectionInfo] {
                self.infoArray.removeAll()
                self.infoArray.append(contentsOf: arr)
                self.filterDataArray.append(contentsOf: arr)
                self.tblView.reloadData()
                self.callApiInBackground()
        } else {
            self.callApi()
        }
    }
    
    func archiveCategory(category:[MICategorySelectionInfo]) -> NSData {
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: category as NSArray)
        return archivedObject as NSData
    }
    
    func callApiInBackground() {
        MIApiManager.callMasterService(funType:masterType.rawValue, parentId: parentId, limit: "\(self.limitCount)", countryISO: isoCountryCode) { [weak wSelf = self] (isSuccess, response, error, code) in
              DispatchQueue.global(qos: .background).async {
                if isSuccess, let res = response as? [String:Any],let data = res["data"] as? [[String:Any]] {
                    let modelArray = MICategorySelectionInfo.modelsFromDictionaryArray(array: data)
                    if (wSelf?.masterType.isFromDB)! {
                        if (modelArray.count) > 0 {
                            let archiveObject = self.archiveCategory(category: modelArray)
                            let funName = wSelf?.masterType.rawValue
                            userDefaults.set(archiveObject, forKey:funName!)
                            userDefaults.synchronize()
                        }
                    }
                }
            }
        }
    }
    // MARK:- Api Calling
    func callApi() {
        let limit = 200
//        if(self.limitCount <= 1100 && self.limitCount > 0) {
//            limit = self.limitCount
//        }
        
        self.startActivityIndicator()
        
       // kAppDelegate.window?.bringSubviewToFront(kActivityView)
        MIApiManager.callMasterService(funType:masterType.rawValue, parentId: parentId, limit: "\(limit)", countryISO: isoCountryCode) { [weak wSelf = self] (isSuccess, response, error, code) in
            DispatchQueue.main.async {
                self.stopActivityIndicator()
                wSelf?.infoArray.removeAll()
                wSelf?.filterDataArray.removeAll()
                if code == 999 {
                   self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
                    
                    self.nojobPopup.addFromTop(onView: self.view, topHeight: 180, onCompletion: nil)
                    return
                }
                else if error != nil{
                    self.showAlert(title: "", message: error?.localizedDescription)
                    return
                }
                if isSuccess, let res = response as? [String:Any],let data = res["data"] as? [[String:Any]] {
                    wSelf?.infoArray = MICategorySelectionInfo.modelsFromDictionaryArray(array: data)
                    wSelf?.filterDataArray = MICategorySelectionInfo.modelsFromDictionaryArray(array: data)
                    
                    
                }
                
                if (wSelf?.masterType.isFromDB)! {
                    if (wSelf?.infoArray.count)! > 0 {
                        let archiveObject = self.archiveCategory(category: wSelf?.infoArray ?? [MICategorySelectionInfo]())
                        let funName = wSelf?.masterType.rawValue
                        userDefaults.set(archiveObject, forKey:funName!)
                        userDefaults.synchronize()
                    }
                }
                
                wSelf?.filterDataArray = wSelf?.filterDataArray.filter({$0.name != ""}) ?? [MICategorySelectionInfo]()
                wSelf?.infoArray = wSelf?.infoArray.filter({$0.name != ""}) ?? [MICategorySelectionInfo]()
                
                wSelf?.filterDataArray =  wSelf?.filterDataArray.removeMasterDataDuplicates() ?? [MICategorySelectionInfo]()
                wSelf?.infoArray = wSelf?.infoArray.removeMasterDataDuplicates() ?? [MICategorySelectionInfo]()
                

                let site = AppDelegate.instance.site
                let sourceCountryISO = site?.defaultCountryDetails.isoCode ?? ""
                if sourceCountryISO.lowercased() != "in" && wSelf?.masterType == .HIGHEST_QUALIFICATION {
                    wSelf?.filterDataArray = wSelf?.filterDataArray.filter({$0.uuid != kClass12Id }) ?? [MICategorySelectionInfo]()
                    wSelf?.infoArray = wSelf?.infoArray.filter({$0.uuid != kClass12Id }) ?? [MICategorySelectionInfo]()
                    wSelf?.filterDataArray = wSelf?.filterDataArray.filter({$0.uuid != kCLASS10 }) ?? [MICategorySelectionInfo]()
                    wSelf?.infoArray = wSelf?.infoArray.filter({$0.uuid != kCLASS10 }) ?? [MICategorySelectionInfo]()
                }
                let arr = wSelf?.filterDataArray.filter({(mod:MICategorySelectionInfo) -> Bool in
                    return  !self.excludedData.contains(where: {(mod.uuid == $0.uuid)})
                })
                if self.excludedData.count > 0 {
                    wSelf?.filterDataArray = arr ?? [MICategorySelectionInfo]()
                    wSelf?.infoArray = arr ?? [MICategorySelectionInfo]()
                }
                if wSelf?.masterType == .VISA_TYPE {
                    wSelf?.infoArray.insert(MICategorySelectionInfo.getDefaultVisaTypeForDontHaveAuthorization(), at: 0)
                    wSelf?.filterDataArray.insert(MICategorySelectionInfo.getDefaultVisaTypeForDontHaveAuthorization(), at: 0)
                }
            //    self.stopActivityIndicator()
                wSelf?.tblView.reloadData()
            }
        }
    }
    
    func callApiSearching(searchingTxt:String) {
        MIApiManager.callMasterServiceSearching(searchString: searchingTxt, funcType: masterType.rawValue, parentId: parentId, limit: "100", countryISO: isoCountryCode) { [weak wSelf = self] (isSuccess, response, error, code) in
            DispatchQueue.main.async {
                wSelf?.nojobPopup.removeMe()
                wSelf?.filterDataArray.removeAll()
                if isSuccess, let res = response as? [String:Any],let data = res["data"] as? [[String:Any]] {
                    wSelf?.filterDataArray = MICategorySelectionInfo.modelsFromDictionaryArray(array: data)
                }
                wSelf?.filterDataArray = wSelf?.filterDataArray.removeMasterDataDuplicates() ?? [MICategorySelectionInfo]()
                
                wSelf?.filterDataArray = wSelf?.filterDataArray.filter({$0.name != ""}) ?? [MICategorySelectionInfo]()
                let site = AppDelegate.instance.site
                let sourceCountryISO = site?.defaultCountryDetails.isoCode ?? ""
                if sourceCountryISO.lowercased() != "in" && wSelf?.masterType == .HIGHEST_QUALIFICATION {
                    wSelf?.filterDataArray = wSelf?.filterDataArray.filter({$0.uuid != kClass12Id }) ?? [MICategorySelectionInfo]()
                    wSelf?.filterDataArray = wSelf?.filterDataArray.filter({$0.uuid != kCLASS10 }) ?? [MICategorySelectionInfo]()
                }
                let arr = wSelf?.filterDataArray.filter({(mod:MICategorySelectionInfo) -> Bool in
                    return  !self.excludedData.contains(where: {(mod.uuid == $0.uuid)})
                })
                if self.excludedData.count  > 0 {
                    wSelf?.filterDataArray = arr ?? [MICategorySelectionInfo]()
                }
                self.otherContains = wSelf?.filterDataArray.filter({$0.name.lowercased() == searchingTxt.lowercased()}) ?? [MICategorySelectionInfo]()
                if wSelf?.masterType == .LOCATION {
                    if wSelf?.filterDataArray.count == 0 {
                        self.callApiSearching(searchingTxt: "other")
                    }
                }
                
                if self.shouldShowAdd,self.otherContains.count == 0 {
                    wSelf?.addBtnWidthConstraint.constant = 80
                } else {
                    wSelf?.addBtnWidthConstraint.constant = 0
                }
                wSelf?.tblView.reloadData()
            }
        }
    }
    
    //MARK:- MIMasterDataSelectionViewDelegate
    func removeListItem(item: String) {
        if !item.isEmpty {
            self.delete(element: item)
            let dataList = selectDataArray.filter { $0.name == item }
            if let obj = dataList.first {
                self.deleteObj(obj: obj)
            }
            self.showSelection(list: selectedInfoArray)
            self.tblView.reloadData()
        }
    }
    
    func showAlert() {
        limitAlertShowing = true
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.2) {
            self.limitAlert.frame.origin.y = kScreenSize.height - 200
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
            UIView.animate(withDuration: 0.2) {
                self.limitAlert.alpha = 0.0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                self.limitAlert.frame.origin.y = kScreenSize.height + 100
                self.limitAlert.alpha          = 1
                self.limitAlertShowing         = false
            })
        })
    }
}

extension MIMasterDataSelectionViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? MIDefaultSelectionCell {
        
            let info = filterDataArray[indexPath.row]
            cell.show(info: info)
            cell.tintColor = AppTheme.defaltBlueColor
            if selectedInfoArray.contains(info.name) {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if limitSelectionCount == 1 {
            selectedInfoArray.removeAll()
            selectDataArray.removeAll()
        }
        
        var isAppending = false
        let modelInfo = filterDataArray[indexPath.row]
        if selectedInfoArray.contains(modelInfo.name) {
            self.delete(element: modelInfo.name)
            self.deleteObj(obj: modelInfo)
        } else if selectedInfoArray.count < limitSelectionCount {
            isAppending = true
            selectedInfoArray.append(modelInfo.name)
            selectDataArray.append(modelInfo)
        } else if !limitAlertShowing {
            self.showAlert()
        }
        
        self.tblView.reloadRows(at: [indexPath], with: .automatic)
        self.showSelection(list: selectedInfoArray,isAppending: isAppending)
        
        if limitSelectionCount == 1 {
            self.delegate?.masterDataSelected(selectedCategoryInfo: selectDataArray, selectedListInfo: selectedInfoArray, enumName: masterType.rawValue)
            self.selectionHandler?(selectDataArray)
            self.navigationController?.popViewController(animated: true)
        }else{
            self.searchTxtField.text = ""
            filterDataArray = infoArray
            self.addBtnWidthConstraint.constant = 0
            self.tblView.reloadData()

        }

    }
}


extension MIMasterDataSelectionViewController:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var searchTxt = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
//        let trimmedString = searchTxt.trimmingCharacters(in: .whitespaces)
        if searchTxt.count > 40 && masterType == .ITSkill {
            return false
        }
        searchTxt.removedSpaceFromStarting()
        
        if masterType.isFromDB {
            filterDataArray = searchTxt.isEmpty ? infoArray : infoArray.filter({(mod: MICategorySelectionInfo) -> Bool in
                // If dataItem matches the searchText, return true to include it
                return mod.name.range(of: searchTxt, options: .caseInsensitive) != nil
            })

            if self.shouldShowAdd && filterDataArray.isEmpty {
                self.addBtnWidthConstraint.constant = 80
            } else {
                self.addBtnWidthConstraint.constant = 0
            }
        } else if searchTxt.count >= 2 {
            
            self.callApiSearching(searchingTxt: searchTxt)
        } else {
            filterDataArray = infoArray
            self.addBtnWidthConstraint.constant = 0
        }
        
        self.tblView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



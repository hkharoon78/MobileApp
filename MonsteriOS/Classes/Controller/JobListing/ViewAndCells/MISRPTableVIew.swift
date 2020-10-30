//
//  MISRPTableVIew.swift
//  MonsteriOS
//
//  Created by ishteyaque on 09/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import Foundation
import SwipeCellKit

protocol SRPTableViewDelegate:class {
    func longPressSelected(indexPath:IndexPath)
    func tableViewDidSelection(indexPath:IndexPath)
    func callScrollEndAPI(param:[String:Any])
    func applyAction(jobId:String,redirectURl:String?,searchId:String,isAfterLoginAutoApply:Bool?, jobApplyTracking: JoblistingData?)
    
    func jobsRightForYou()
    func saveJob(jobId:String)

}
class MISRPTableVIew: UIView {
    var jsonData:JoblistingBaseModel?
    var savedData:JoblistingBaseModel?
    weak var delegate:SRPTableViewDelegate?
    var isPaginationRunning = false

    let spinner = UIActivityIndicatorView(style: .gray)
    var isSelectionEnable=false {
        didSet{
            //if let visibleIndex=self.tableView.indexPathsForVisibleRows{
                self.tableView.reloadData()
               // self.tableView.reloadRows(at: visibleIndex, with: .none)
            //}
        }
    }
    var walkInFilter=["walkInDateRanges":[FilterModel(title: WalinFilterTitle.today.rawValue),FilterModel(title: WalinFilterTitle.tomorrow.rawValue),FilterModel(title: WalinFilterTitle.thisWeek.rawValue),FilterModel(title: WalinFilterTitle.nextWeek.rawValue),FilterModel(title: WalinFilterTitle.thisMonth.rawValue),FilterModel(title: WalinFilterTitle.selecDate.rawValue)]]

    @IBOutlet weak var tableView: UITableView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configure()
    }
    
    
    func configure(){
        tableView.register(UINib(nibName:String(describing: MIJobListingTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIJobListingTableCell.self))
        tableView.register(UINib(nibName:String(describing: MIFeedbackTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIFeedbackTableCell.self))
        tableView.register(UINib(nibName:String(describing: MISRPFilterOptionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MISRPFilterOptionCell.self))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        // let longPress=UILongPressGestureRecognizer(target: self, action: #selector(MISRPTableVIew.longPressGestureAction(_:)))
        //self.tableView.addGestureRecognizer(longPress)
        spinner.tintColor = AppTheme.defaltTheme
        spinner.hidesWhenStopped=true
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        self.tableView.tableFooterView = spinner
       // self.delegate=nil
    }
    
    @objc func longPressGestureAction(_ sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                self.longpress(indexPath: indexPath)
            }
        }
        
    }
    func longpress(indexPath: IndexPath){
        if let isSelected=self.jsonData?.data![indexPath.section].isSelected{
            //self.isSelectionEnable=true
            self.jsonData?.data![indexPath.section].isSelected = !isSelected
            if self.jsonData?.data?.filter({$0.isSelected}).count ?? 0 > 0{
                if !self.isSelectionEnable{
                    self.isSelectionEnable=true
                    // self.tableView.reloadData()
                }
            }else{
                self.isSelectionEnable=false
                // self.tableView.reloadData()
            }
            //DispatchQueue.main.async {
            //self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
            self.tableView.reloadRows(at: [indexPath], with: .none)
            // }
            
        }
        delegate?.longPressSelected(indexPath: indexPath)
    }
    
    func getQuery() -> String? {
        guard let parentVc = self.parentViewController as? MISRPJobListingViewController else { return nil }
        
        switch parentVc.jobTypes {
        case .nearBy?:
            return ControllerTitleConstant.jobsNearMe
        case .walkIn?:
            return HomeJobCategoryType.walkin.rawValue
        case .contract?:
            return HomeJobCategoryType.contractJobs.rawValue
        case .fresher?:
            return HomeJobCategoryType.fresherJobs.rawValue
        case .company?, .recruiter?:
            return parentVc.selectedSkills
        default:
            return !parentVc.selectedSkills.isEmpty ? parentVc.selectedSkills : parentVc.selectedLocation
        }
    }
}

extension MISRPTableVIew:UITableViewDelegate,UITableViewDataSource, SwipeTableViewCellDelegate{
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.jsonData?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentDate = Date().getStringWithFormat(format: "dd/MM/yyyy")
        let lastDate = AppUserDefaults.value(forKey: .JobFeedbackLastDate, fallBackValue: "").stringValue
        if lastDate != currentDate {
            AppUserDefaults.removeValue(forKey: .JobFeedbackQueries)
        }
        
        var query = ""
        if let queryStr = getQuery() {
            query = queryStr
        }
        
        let queries = AppUserDefaults.value(forKey: .JobFeedbackQueries, fallBackValue: []).arrayObject as? [String] ?? []
                
        let resultID = self.jsonData?.meta?.resultId

        if (section+1) % 8 == 0 && !queries.contains(query) && resultID != nil && CommonClass.isLoggedin() {
            // For displaying feedback card
            return 2
        }
        else if ((section+1) % 6 == 0 ) && ((section+1) <= 18) && MIFirebaseRemoteConfigInfo.sharedRemoteConfig.srpFilterEnable {
            var data = [String]()
                           
           if (section+1) / 6 == 1 {
               let filterOption = self.jsonData?.filters?.filterValue["Experience Ranges"]
               data = filterOption?.map({$0.rawTitle})  ?? [String]()
                if data.count > 0 {
                    return 2
                }else{
                    return 1
                }
           }else if (section+1) / 6 == 3 {
               let filterOption = self.jsonData?.filters?.filterValue["Job Cities"]
               data = filterOption?.map({$0.rawTitle}) ?? [String]()
            if data.count > 0 {
                   return 2
               }else{
                   return 1
               }
           }else if (section+1) / 6 == 2 {
               let filterOption = self.jsonData?.filters?.filterValue["Job Types"]
               data = filterOption?.map({$0.rawTitle}) ?? [String]()
            if data.count > 0 {
                   return 2
               }else{
                   return 1
               }
           }
            return 1

        }
        else {
            return 1
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "f4f6f8")
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIJobListingTableCell.self), for: indexPath) as! MIJobListingTableCell
            
            let modelData=self.jsonData?.data![indexPath.section]
            cell.modelData = JoblistingCellModel(model: modelData!, isSaved: self.savedData?.data?.filter({$0.jobId==modelData!.jobId}).count ?? 0 > 0 ? true : false, isSearchLogo:modelData!.isSearchLogo ?? 0)

            cell.saveUnSaveAction={[weak self](save) in
                 guard let `self`=self else {return}

                if let modelData=self.jsonData?.data![indexPath.section]{
                    modelData.isSaved=save
                    if let jobid = modelData.jobId {
                        self.delegate?.saveJob(jobId: "\(jobid)")
                        if save {
                            CommonClass.googleEventTrcking("search_screen", action: "save_job", label: "\((indexPath.section, "_", jobid ))") //GA
                        }
                    }
                    
                    if let parentVc = self.parentViewController as? MISRPJobListingViewController {
                        parentVc.seekerSRPEvent("SAVE_JOB", jobID: self.jsonData?.data?[indexPath.section].jobId?.stringValue)
                    }
                }
               // self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            cell.delegate = self
            return cell
            
        } else if indexPath.row == 1  {
            if ((indexPath.section+1) % 6 == 0 ) && (indexPath.section+1) <= 18 {
                let filterCell = tableView.dequeueReusableCell(withClass: MISRPFilterOptionCell.self, for: indexPath)
                var data = [String]()
                var filterName = ""

                if (indexPath.section+1) / 6 == 1 {
                    let filterOption = self.jsonData?.filters?.filterValue["Experience Ranges"]
                   data = filterOption?.map({$0.rawTitle}) ?? [String]()
                    filterName = "Experience"
                    filterCell.filterType = .experienceRange
                }else if (indexPath.section+1) / 6 == 3 {
                    let filterOption = self.jsonData?.filters?.filterValue["Job Cities"]
                    filterName = "City"
                    filterCell.filterType = .locations
                    data = filterOption?.map({$0.rawTitle}) ?? [String]()
                }else if (indexPath.section+1) / 6 == 2 {
                    let filterOption = self.jsonData?.filters?.filterValue["Job Types"]
                    data = filterOption?.map({$0.rawTitle}) ?? [String]()
                    filterName = "Job Type"
                    filterCell.filterType = .jobTypes
                }
                if data.count > 5 {
                   var filterNewData = data.prefix(5)
                   filterNewData.append("More Options >")
                   data = Array(filterNewData)
                }
                filterCell.collectionView_FilterItems?.reloadData()
                filterCell.showAttributedFilterTitle(title: "Filter by ", attString: filterName,withItesm: data)
                filterCell.filterOptionSelected = { value,isMoreSel,filterType in
                    if let parentVc = self.parentViewController as? MISRPJobListingViewController {
                        if isMoreSel {
                            parentVc.filterAction(filterType: filterType)
                        }else{
                            
                            parentVc.applyFilter(filters: self.getAppliedAndSelectedFilter(value: value, filterType: filterType), walkInfilter: self.walkInFilter)
                        }
                    }
                }
                return filterCell
            }else{
                let cell = tableView.dequeueReusableCell(withClass: MIFeedbackTableCell.self, for: indexPath)
                
                cell.likeButton.addTarget(self, action: #selector(likeAction), for: .touchUpInside)
                cell.dislikeButton.addTarget(self, action: #selector(disLikeAction), for: .touchUpInside)

                return cell

            }
        }
        
        return UITableViewCell()
    }
    
    @objc func likeAction() {
        self.submitFeedback(1)
        self.delegate?.jobsRightForYou()
    }
    
    @objc func disLikeAction() {
        self.submitFeedback(0)
    }
    
    func submitFeedback(_ value: Int) {
        guard let resultID = self.jsonData?.meta?.resultId else { return }
        var pageName="Job_Listing"
        if self.parentViewController?.navigationItem.title?.count ?? 0 > 0{
            pageName=self.parentViewController?.navigationItem.title ?? ""
        }
        let param = [
            "resultId" : resultID,
            "feedback" : value.stringValue,
            "pageName" : pageName,
            "appVersion" : UIApplication.appVersion()
        ]
        
        let currentDate = Date().getStringWithFormat(format: "dd/MM/yyyy")
        
        MIApiManager.jobFeedbackAPI(param) { (result, error) in
            
            if let query = self.getQuery(), !query.isEmpty {
                var queries = AppUserDefaults.value(forKey: .JobFeedbackQueries, fallBackValue: []).arrayObject ?? []
                queries.append(query)
                AppUserDefaults.save(value: queries, forKey: .JobFeedbackQueries)
            }
            AppUserDefaults.save(value: currentDate, forKey: .JobFeedbackLastDate)
            
            (self.delegate as? UIViewController)?.toastView(messsage: "Thank you for your valuable feedback",isErrorOccured:false)

            self.tableView.reloadData()
        }

    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
         let jobId = self.jsonData?.data![indexPath.section].jobId
        CommonClass.googleEventTrcking("search_screen", action: "swipe_right", label: "\((indexPath.section, "_", jobId ))") //GA
        
        if self.isSelectionEnable {
            return nil
        }
        
        
        guard orientation == .left else { return nil }
        var title=SRPListingStoryBoardConstant.Apply
        if self.jsonData?.data![indexPath.section].jobTypes?.filter({$0.lowercased().contains(JobTypes.walkIn.value.lowercased())}).count ?? 0 > 0{
            title=SRPListingStoryBoardConstant.imIntersted
        }
        if let modelData=self.jsonData?.data![indexPath.section]{
            if modelData.isApplied != nil{
                if modelData.isApplied!{
                    title=SRPListingStoryBoardConstant.Applied
                }
            }
        }
        let applyAction = SwipeAction(style: .default, title:title) {[weak self] action, indexPath in
             guard let `self`=self else {return}
           
            // handle action by updating model with deletion
            if let jobId=self.jsonData?.data![indexPath.section].jobId{
                if let modelData=self.jsonData?.data![indexPath.section]{
                    if modelData.isApplied != nil{
                        if modelData.isApplied!{
                            CommonClass.googleEventTrcking("search_screen", action: "apply", label: "\((indexPath.section, "_", jobId ))") //GA
                            return
                        }
                    }
                }
                
                let data = self.jsonData?.data?[indexPath.section]
                self.delegate?.applyAction(jobId: String(jobId), redirectURl: self.jsonData?.data![indexPath.section].redirectUrl,searchId:self.jsonData?.data![indexPath.section].resultId ?? "", isAfterLoginAutoApply: true, jobApplyTracking: data)
            }
        }
        applyAction.backgroundColor = AppTheme.greenColor
        return [applyAction]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // if indexPath.section==(self.jsonData?.data!.count)! - 1{
        // self.callPagination()
        // }
        //        let lastSectionIndex = tableView.numberOfSections - 1
        //        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        //        if indexPath.section ==  lastSectionIndex && indexPath.row == lastRowIndex {
        //            // print("this is the last cell")
        //
        //
        //        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.jsonData?.data![indexPath.section].isSelected=true
        //self.longpress(indexPath: indexPath)
        self.jsonData!.data![indexPath.section].isViewed=true
        
        if let cell = self.tableView.cellForRow(at: indexPath) as? MIJobListingTableCell {
            cell.enable(on: false)
        }
       // self.tableView.reloadRows(at: [indexPath], with: .none)

     //   print(indexPath)

        delegate?.tableViewDidSelection(indexPath: indexPath)
        
      //  print(indexPath)
    }
    
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //
    //        // UITableView only moves in one direction, y axis
    //
    //    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 2.0 {
            if !isPaginationRunning{
                isPaginationRunning = true
                self.callPagination()

            }
            //self.loadMore()
        }
    }
    func callPagination(){
        if let paging=self.jsonData?.meta?.paging{
            if let cursor=paging.cursors{
                if let newNext=cursor.next{
                    if let next=Int(newNext){
                        if next < paging.total!{
                            spinner.startAnimating()
                            self.tableView.tableFooterView?.isHidden = false
                            delegate?.callScrollEndAPI(param:[SRPListingDictKey.next.rawValue:cursor.next ?? "10"] )
                        }
                    }
                }
            }
        }
    }
    func getAppliedAndSelectedFilter(value:String,filterType:FilterType) -> [String : Any]{
        var param=[String:Any]()

        if let data = self.jsonData?.selectedFilters?.filterValue {

            for (key,item) in data {
                let seleted=item.filter({$0.isSelected})
                
                if seleted.count > 0 {
                    var selectedArray = [String]()
                    
                    if filterType == .experienceRange ||  filterType == .salaryRange {
                                           selectedArray =    seleted.map({$0.title.components(separatedBy:"(").first!.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression).replacingOccurrences(of: " - ", with: "~")})
                                       }else{
                                           selectedArray =    seleted.map({$0.title.components(separatedBy:"(").first!.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)})

                                       }
                        let doubleArray = selectedArray.map({Int($0)}).compactMap({$0})
                                       
                        param[key.replacingOccurrences(of: " ", with: "").smallFirstLetter()]=doubleArray.count > 0 ? doubleArray[0] : selectedArray
                    
                       
                    
                }
//                else{
//                    var key = ""
//                    if filterType == .experienceRange {
//                        key = SRPListingDictKey.experienceRanges.rawValue
//                    }else if filterType == .jobTypes {
//                        key = SRPListingDictKey.jobTypes.rawValue
//                    }else if filterType == .locations {
//                        key = SRPListingDictKey.jobCities.rawValue
//                    }
//
//                     return [key:[value]]
//                }
            }
            
        }
        
        if filterType == .experienceRange {
            CommonClass.googleEventTrcking("search_screen", action: "open_filter_experience", label: "open_filter_selection")
            if var data = param[SRPListingDictKey.experienceRanges.rawValue] as? [String] {
                if data.count > 0 {
                    data.append(value)
                    param[SRPListingDictKey.experienceRanges.rawValue] = data
                }else{
                    param[SRPListingDictKey.experienceRanges.rawValue] = [value]

                }
            }else {
                param[SRPListingDictKey.experienceRanges.rawValue] = [value]
            }
        }else if filterType == .jobTypes {
            CommonClass.googleEventTrcking("search_screen", action: "open_filter_job_type", label: "open_filter_selection")

              if var data = param[SRPListingDictKey.jobTypes.rawValue] as? [String] {
                 if data.count > 0 {
                     data.append(value)
                     param[SRPListingDictKey.jobTypes.rawValue] = data
                 }else{
                     param[SRPListingDictKey.jobTypes.rawValue] = [value]

                 }
             }else {
                 param[SRPListingDictKey.jobTypes.rawValue] = [value]
             }
        }else if filterType == .locations {
            CommonClass.googleEventTrcking("search_screen", action: "open_filter_city", label: "open_filter_selection")

              if var data = param[SRPListingDictKey.jobCities.rawValue] as? [String] {
                  if data.count > 0 {
                      data.append(value)
                      param[SRPListingDictKey.jobCities.rawValue] = data
                  }else{
                      param[SRPListingDictKey.jobCities.rawValue] = [value]
                  }
              }else {
                  param[SRPListingDictKey.jobCities.rawValue] = [value]
              }
        }
        return param
    }
}

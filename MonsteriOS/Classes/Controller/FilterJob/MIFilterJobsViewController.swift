//
//  MIFilterJobsViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 21/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

struct SRPListingStoryBoardConstant{
    static let results=" Results"
    static let Apply="Apply"
    static let Applied="Applied"
    static let Years=" Years"
    static let Posted="Posted "
    static let applied="Applied "
    static let monthago=" month ago"
    static let monthsago=" months ago"
    static let today=" today"
    static let dayAgo=" day ago"
    static let daysAgo=" days ago"
    static let imIntersted="I am Interested"
    static let saved="Saved "
    
}
struct FilterStoryBoardConstant{
    static let apply="Apply Filters"
    static let Filter=" Filter"
    static let applyAll="Apply All"
    static let sort=" Sort"
    
}
enum WalinFilterTitle:String,CaseIterable{
    case today="Today"
    case tomorrow="Tomorrow"
    case thisWeek="This Week"
    case nextWeek="Next Week"
    case thisMonth="This Month"
    case selecDate="Select Date   📆"
}
protocol FilterAppyDelegate {
    func applyFilter(filters:[String:Any],walkInfilter:[String:[FilterModel]])
}
extension FilterAppyDelegate{
    func applyFilter(filters:[String:Any]){}
}
class MIFilterJobsViewController: MIBaseViewController {
    //MARK:Outlets And Variables
    @IBOutlet weak var filterTableView: UITableView!
    @IBOutlet weak var resultTableView: UITableView!
    @IBOutlet weak var applyFilterButton: UIButton!
   // var filterData=FilterType.allCases
    var filterJsonData:Filters?
    var selectedFilterData:Filters?
    var filterLabel=[String:String]()
    var filterArrayLabel=[String]()
    var queryItem=""
   // var selectedFilter:FilterType = .skills
    var selectedFilterValue=""
    var filterTitleArray=[String]()
    var data=[String:[FilterModel]]()
    var delegate:FilterAppyDelegate!
    var jobType:JobTypes! = .all
    var walkInFilter=["walkInDateRanges":[FilterModel(title: WalinFilterTitle.today.rawValue),FilterModel(title: WalinFilterTitle.tomorrow.rawValue),FilterModel(title: WalinFilterTitle.thisWeek.rawValue),FilterModel(title: WalinFilterTitle.nextWeek.rawValue),FilterModel(title: WalinFilterTitle.thisMonth.rawValue),FilterModel(title: WalinFilterTitle.selecDate.rawValue)]]
    enum ChoiceType{
        case single
        case multiple
    }
    var choiceType:ChoiceType = .multiple
 
    //MARK:Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpUI()
        if let selectedFilter=selectedFilterData?.filterValue{
            for (key,item) in selectedFilter{
                if item.count > 0 && key != self.jobType.keyValue{
                    data[key]=item
                    if let label=filterLabel[key.replacingOccurrences(of: " ", with: "").smallFirstLetter()]{
                    filterTitleArray.append(key)
                    filterArrayLabel.append(label)
                    }
                }
                
            }
        }
        if self.jobType == .walkIn{
        for (key,item) in walkInFilter{
                    data[key]=item
                    filterArrayLabel.append("Walkin")
                    filterTitleArray.append(key)
                    }
            }

        if let filterData=filterJsonData?.filterValue{
            for (key,item) in filterData{
                if item.count > 0{
                    data[key]=item
                    if let label=filterLabel[key.replacingOccurrences(of: " ", with: "").smallFirstLetter()]{
                        filterTitleArray.append(key)
                        filterArrayLabel.append(label)
                    }
                    //filterTitleArray.append(key)
                }
            }
        }
        
        if filterTitleArray.count>0 && self.selectedFilterValue.count == 0{
            self.selectedFilterValue=filterTitleArray[0]
        }else{
            self.filterTableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if  let index = self.filterTitleArray.firstIndex(of: self.selectedFilterValue) {
                               self.filterTableView.scrollToRow(at: IndexPath(item: index, section: 0), at: .bottom, animated: true)

                    }
            }
           
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CommonClass.googleAnalyticsScreen(self) //GA for Screen
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

        self.title = ControllerTitleConstant.filter
    }
    
    func setUpUI(){
        self.applyFilterButton.showPrimaryBtn()
        self.applyFilterButton.setTitle(FilterStoryBoardConstant.apply, for: .normal)
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: NavigationBarButtonTitle.clearAll, style: .done, target: self, action: #selector(MIFilterJobsViewController.clearAllAction(_:)))
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(MIFilterJobsViewController.dismissButtonAction(_:)))
       
        filterTableView.register(UINib(nibName:String(describing: MIFilterJobTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIFilterJobTableViewCell.self))
        filterTableView.delegate=self
        filterTableView.dataSource=self
        filterTableView.estimatedRowHeight = 55
        filterTableView.rowHeight = UITableView.automaticDimension
        self.filterTableView.keyboardDismissMode = .onDrag
        filterTableView.separatorStyle = .none
        filterTableView.tableFooterView=UIView(frame: .zero)
        filterTableView.backgroundColor=AppTheme.viewBackgroundColor//UIColor.init(hex: "f4f6f8")
        
        resultTableView.register(UINib(nibName:String(describing: MICheckBoxTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MICheckBoxTableViewCell.self))
        resultTableView.register(UINib(nibName: String(describing: MIRadioTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIRadioTableViewCell.self))
        resultTableView.delegate=self
        resultTableView.dataSource=self
        resultTableView.estimatedRowHeight = resultTableView.rowHeight
        resultTableView.rowHeight = UITableView.automaticDimension
        self.resultTableView.keyboardDismissMode = .onDrag
        resultTableView.separatorStyle = .none
        resultTableView.backgroundColor = .white
        resultTableView.tableFooterView=UIView(frame: .zero)
    }
    //MARK:Clear All Navigation Button Action
    @objc func clearAllAction(_ sender:UIBarButtonItem){
        for (_,item) in self.data{
            for newItem in item{
                newItem.isSelected=false
                CommonClass.googleEventTrcking("search_filter", action: "clear_all", label: "") //GA
            }
        }
        if self.jobType == .walkIn{
            for (_,item) in walkInFilter{
                for newItem in item{
                    newItem.isSelected=false
                    if WalinFilterTitle.allCases.filter({$0.rawValue==newItem.title}).count == 0{
                        newItem.title = WalinFilterTitle.selecDate.rawValue
                    }
                }
            }
        }
        self.resultTableView.reloadData()
        self.filterTableView.reloadData()
    }

    //MARK:Close View Navigation Button Action
    @objc func dismissButtonAction(_ sender:UIBarButtonItem){
         CommonClass.googleEventTrcking("search_filter", action: "cross", label: "") //GA
        self.dismiss(animated: true, completion:nil)
    }
    
    //MARK:Apply Filter Button Action
    @IBAction func applyFilterButtonAction(_ sender: UIButton) {
        
        var param=[String:Any]()
        var filterSelected = [String]()
        for (key,item) in self.data{
            let seleted=item.filter({$0.isSelected})
           
            if seleted.count > 0 {
                if let filterName = Seeker_Job_Event_Filter(rawValue: key)?.jobskeer_data_filter {
                    filterSelected.append(filterName)
                }
                if key=="walkInDateRanges"{
                    var walkDate=[String]()
                    for item in seleted{
                        walkDate.append(getWalkInRages(title: item.title))
                    }
                    param[key]=walkDate
                }else{
                    var selectedArray = [String]()
                        
                    
                    if key == Seeker_Job_Event_Filter.experienceRanges.rawValue ||  key == Seeker_Job_Event_Filter.salaryRanges.rawValue {
                        selectedArray =    seleted.map({$0.title.components(separatedBy:"(").first!.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression).replacingOccurrences(of: " - ", with: "~")})
                    }else{
                        selectedArray =    seleted.map({$0.title.components(separatedBy:"(").first!.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)})

                    }
                    
                    let doubleArray = selectedArray.map({Int($0)}).compactMap({$0})
                    
                    param[key.replacingOccurrences(of: " ", with: "").smallFirstLetter()]=doubleArray.count > 0 ? doubleArray[0] : selectedArray//seleted.map({$0.title.components(separatedBy:"(").first!.replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)})
                }
            }
        }
//        if param.count==0 && queryItem.isEmpty && self.jobType == .all{
//            self.showAlert(title: "", message: "Please select at least one location")
//            return
//        }else if param.count==1 && queryItem.isEmpty,param[SRPListingDictKey.locations.rawValue] == nil && self.jobType == .all{
//            self.showAlert(title: "", message: "Please select at least one location")
//            return
//        }
       // else{
        if let _dele=self.delegate{
            self.callAPIForFilterJobSeekerEvent(data: ["eventValue":"click","filters":filterSelected], type: CONSTANT_JOB_SEEKER_TYPE.FILTER_APPLY)
            _dele.applyFilter(filters: param,walkInfilter:self.walkInFilter)
            CommonClass.googleEventTrcking("search_filter", action: "apply_filters", label: "")
        }
        self.dismiss(animated: true, completion: nil)
      //  }
    }
    
    func getWalkInRages(title:String)->String{
       let dateFormatter=DateFormatter()
        dateFormatter.dateFormat = PersonalTitleConstant.dateFormatePattern
        if title==WalinFilterTitle.today.rawValue{
            return dateFormatter.string(from: Date()) + "~" + dateFormatter.string(from: Date())
        }
        if title==WalinFilterTitle.tomorrow.rawValue{
            return dateFormatter.string(from: Date()) + "~" + dateFormatter.string(from: Date.tomorrow)
        }
        if title==WalinFilterTitle.thisWeek.rawValue{
            return dateFormatter.string(from: Date()) + "~" + dateFormatter.string(from: Date().endOfWeek ?? Date())
        }
        if title==WalinFilterTitle.thisMonth.rawValue{
            return dateFormatter.string(from: Date()) + "~" + dateFormatter.string(from: Date().endOfMonth())
        }
        if title==WalinFilterTitle.nextWeek.rawValue{
            return dateFormatter.string(from: Date().startOfNextWeek ?? Date()) + "~" + dateFormatter.string(from: Date().endOfNextWeek ?? Date())
        }
        return "\(title)~\(title)"
    }
   

    func callAPIForFilterJobSeekerEvent(data:[String:Any],type:String) {
        
        
        MIApiManager.hitSeekerJourneyMapEvents(type, data: data, source: CONSTANT_SCREEN_NAME.SRP, destination: CONSTANT_SCREEN_NAME.FILTER) { (success, response, error, code) in
            
        }
    }

}

//MARK: UITableView Delegate And Data Source Method
extension MIFilterJobsViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView==self.filterTableView{
            return self.filterTitleArray.count
        }
        return data[self.selectedFilterValue]?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView==self.filterTableView{
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIFilterJobTableViewCell.self), for: indexPath)as?MIFilterJobTableViewCell else {
                return UITableViewCell()
            }
            cell.modelData=FilterJobModelData(title: self.filterArrayLabel[indexPath.row], filterCount: data[self.filterTitleArray[indexPath.row]] ?? [])
            //cell.filterTitleLabel.text=self.filterData[indexPath.row].rawValue
           cell.addAndRemoveBorder=true
            if selectedFilterValue==self.filterTitleArray[indexPath.row]{
                cell.addAndRemoveBorder=false
            }
            return cell
        }else{
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIRadioTableViewCell.self), for: indexPath)as?MIRadioTableViewCell else {
                return UITableViewCell()
            }
            if let dataArray=data[self.selectedFilterValue]{
                cell.selectImage = #imageLiteral(resourceName: "checkbox_clicked")
                cell.unselectedImage = #imageLiteral(resourceName: "checkbox_default")
                self.choiceType = .multiple
                if self.selectedFilterValue == "Job Freshness"{
                    cell.selectImage=#imageLiteral(resourceName: "off-1")
                    cell.unselectedImage=#imageLiteral(resourceName: "off-2")
                    self.choiceType = .single
                }
                cell.modelData=dataArray[indexPath.row]
            }
            return cell
        }
       
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var actionGA = self.selectedFilterValue
        var lblGA = ""
        
        if tableView==self.filterTableView{
            self.selectedFilterValue=self.filterTitleArray[indexPath.row]
            actionGA = self.selectedFilterValue
        }else{
            if let dataArray=data[selectedFilterValue]{
            if choiceType == .single {
                if dataArray[indexPath.row].isSelected{
                    dataArray[indexPath.row].isSelected = false
                }else{
                    for i in 0..<dataArray.count {
                        dataArray[i].isSelected = false
                    }
                    dataArray[indexPath.row].isSelected = true
                    
                    lblGA = dataArray[indexPath.row].title
                }
            }
            else{
                // if selection type multible then select item pressed
                let item = dataArray[indexPath.row]
                if selectedFilterValue=="walkInDateRanges" && indexPath.row == dataArray.count-1{
                    if item.isSelected{
                        item.title = WalinFilterTitle.selecDate.rawValue
                        item.isSelected = false
                    }else{
                    MIDatePicker.selectDate(title: "", hideCancel: false, datePickerMode: .date, selectedDate: Date(), minDate: Date(), maxDate: nil) { (dateSelected) in
                       
                        let dateFormatter=DateFormatter()
                        dateFormatter.dateFormat = PersonalTitleConstant.dateFormatePattern
                        item.title=dateFormatter.string(from: dateSelected)
                        item.isSelected=true
                        self.filterTableView.reloadData()
                        self.resultTableView.reloadData()
                        
                        }
                        return
                    }
                } else{
                    item.isSelected = !item.isSelected
                }

                lblGA = item.title
                
              }
            }
        }
        
        CommonClass.googleEventTrcking("search_filter", action: actionGA, label: lblGA)
        self.resultTableView.reloadData()
        self.filterTableView.reloadData()
    }
    
  
}

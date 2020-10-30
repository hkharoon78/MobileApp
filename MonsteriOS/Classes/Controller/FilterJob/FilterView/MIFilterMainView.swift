//
//  MIFilterMainView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 14/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import DropDown
enum SortJobs:String,CaseIterable{
    case relevance="Relevance"
    case freshness="Freshness"
    case walkInDate="WalkIn-Date"
    var value:Int{
        switch self {
        case .relevance:
            return 1
        case .freshness:
            return 2
        case .walkInDate:
            return 3
        }
    }
}
protocol FilterButtonActionDelegate:class{
    func filterAction(filterType:FilterType)
    func sortAction(sortValue:Int)
    func editMapAction()
}
extension FilterButtonActionDelegate{
    func filterAction(filterType:FilterType){}
    func sortAction(){}
    func editMapAction(){}
}
class MIFilterMainView: UIView {

    enum SetFilterTitle{
        case filter
        case apply
        case applyAll
    }
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    //var selectedDropDownRow=0
    var jobTypes:JobTypes! = .all{
        didSet{
            if jobTypes == .nearBy{
                sortButton.isHidden=true
            }else{
                editButton.isHidden=true
            }
            if jobTypes == .walkIn{
                self.dropDown.dataSource=[SortJobs.relevance.rawValue,SortJobs.walkInDate.rawValue]
            }else{
               self.dropDown.dataSource=[SortJobs.relevance.rawValue ,SortJobs.freshness.rawValue]
            }
             self.dropDown.selectRow(0)
        }
    }
    weak var delegate:FilterButtonActionDelegate?
    var setFilterTitle:SetFilterTitle = .filter{
        didSet{
            self.sortButton.isHidden=true
            filterButton.setTitleColor(AppTheme.appGreyColor, for: .normal)
            self.filterButton.tintColor = AppTheme.appGreyColor
           self.resultLabel.isHidden=true
            switch setFilterTitle {
            case .filter:
                if self.jobTypes != .nearBy{
                self.sortButton.isHidden=false
                }
               // filterButton.setImage(#imageLiteral(resourceName: "filter-ico"), for: .normal)
                filterButton.setTitle(FilterStoryBoardConstant.Filter, for: .normal)
                filterButton.setTitleColor(AppTheme.appGreyColor, for: .normal)
                filterButton.setTitleColor(AppTheme.defaltBlueColor, for: .selected)
                filterButton.setImage(#imageLiteral(resourceName: "filter-ico"), for: .normal)
                filterButton.setImage(UIImage(named: "filter-ico_blue"), for: .selected)

               //  self.filterButton.titleLabel?.textColor = UIColor.init(hex: "637381")
                self.filterButton.tintColor = UIColor.init(hex: "637381")
               self.resultLabel.isHidden=false
            case .apply:
                filterButton.setImage(nil, for: .normal)
                filterButton.setImage(nil, for: .selected)
                filterButton.setTitle(SRPListingStoryBoardConstant.Apply, for: .selected)
                filterButton.setTitle(SRPListingStoryBoardConstant.Apply, for: .normal)
            case .applyAll:
                filterButton.setImage(nil, for: .normal)
                filterButton.setImage(nil, for: .selected)
                filterButton.setTitle(FilterStoryBoardConstant.applyAll, for: .normal)
                filterButton.setTitle(FilterStoryBoardConstant.applyAll, for: .selected)

            }
        }
    }
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
    
    let dropDown=DropDown()
    func configure(){
       // resultLabel.text="200 Results"
        filterButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: 12)
        sortButton.titleLabel?.font = UIFont.customFont(type: .Regular, size: 12)
        sortButton.setTitle(FilterStoryBoardConstant.sort, for: .normal)
        sortButton.setImage(#imageLiteral(resourceName: "sortico"), for: .normal)
        self.dropDown.anchorView=sortButton
        self.dropDown.width=400
        self.dropDown.bottomOffset = CGPoint(x: -80, y:(self.dropDown.anchorView?.plainView.bounds.height)!)
        self.dropDown.topOffset = CGPoint(x:-80, y:-(self.dropDown.anchorView?.plainView.bounds.height)!)
        self.setUpDropDown()
        
    }
    func setUpDropDown(){
        dropDown.direction = .any
        dropDown.dismissMode = .automatic
        dropDown.cellHeight = 40
        dropDown.selectionBackgroundColor = AppTheme.defaltBlueColor
        dropDown.selectedTextColor = .white
        dropDown.separatorColor = .lightGray
        dropDown.textFont=UIFont.customFont(type: .Regular, size: 14)
        dropDown.backgroundColor = .white
        dropDown.textColor=AppTheme.textColor
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            guard let `self`=self else{return}
            if let _dele=self.delegate{
                let filtered=SortJobs.allCases.filter({$0.rawValue==item})
                if filtered.count > 0{
                   // self.selectedDropDownRow=index
                _dele.sortAction(sortValue: filtered[0].value)
                }
            }
        }
        dropDown.cellConfiguration = {(_, item) in
            return "\(item)"
        }
    }
   
    @IBAction func filterButtonAction(_ sender: UIButton) {
        if let _dele=self.delegate{
            _dele.filterAction(filterType: .none)
        }
    }
    
    @IBAction func sortButtonAction(_ sender: UIButton) {
       
       self.dropDown.show()
    }
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        if let _dele=self.delegate{
            _dele.editMapAction()
        }
    }
    
}


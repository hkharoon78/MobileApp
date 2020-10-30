//
//  MISelectSalaryMinMaxViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 18/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MISelectSalaryMinMaxViewController: UIViewController {

    @IBOutlet private weak var tblView:UITableView!
    @IBOutlet private weak var headingSeen_View:UIView!
    @IBOutlet private weak var minOption_Btn:UIButton! {
        didSet {
            minOption_Btn.titleLabel?.font = UIFont.customFont(type: .Regular, size: 14)
        }
    }
    @IBOutlet private weak var maxOption_Btn:UIButton! {
        didSet {
            maxOption_Btn.titleLabel?.font = UIFont.customFont(type: .Regular, size: 14)
        }
    }
    @IBOutlet private weak var done_btn:UIButton!
    @IBOutlet private weak var highlighter_LeadingConstrnt:NSLayoutConstraint!
    
    var optionDataSource = [MISalaryModel]()
    var optionSelectionInfo = MISalaryModel.optionSelectionData
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpView()
        self.populateData()
        
    }

    // MARK: - Private Helper Methods
    private func populateData() {
        
        //Dummy Data for UI Only
        optionDataSource.append(MISalaryModel(title: "1", subTitle: "0"))
        optionDataSource.append(MISalaryModel(title: "2", subTitle: "5000"))
        optionDataSource.append(MISalaryModel(title: "3", subTitle: "10000"))
        optionDataSource.append(MISalaryModel(title: "4", subTitle: "15000"))
        optionDataSource.append(MISalaryModel(title: "5", subTitle: "20000"))
        optionDataSource.append(MISalaryModel(title: "6", subTitle: "25000"))
        optionDataSource.append(MISalaryModel(title: "7", subTitle: "30000"))
        optionDataSource.append(MISalaryModel(title: "8", subTitle: "35000"))
        optionDataSource.append(MISalaryModel(title: "9", subTitle: "40000"))
        optionDataSource.append(MISalaryModel(title: "10", subTitle: "45000"))
       
    }
    
    private func setUpView() {
        
        tblView.register(UINib.init(nibName:"MIOptionSelectionCell", bundle: nil), forCellReuseIdentifier:String(describing: MIOptionSelectionCell.self))
        self.title = ControllerTitleConstant.selectSalary
        self.done_btn.showPrimaryBtn()
    }
    
    // MARK: - IBAction Methods
    @IBAction func minMaxOptionSelectionAction(_ sender:UIButton) {
        
        self.minOption_Btn.isSelected = false
        self.maxOption_Btn.isSelected = false
        if sender.tag == 10 {
            
            self.minOption_Btn.isSelected = true
            self.highlighter_LeadingConstrnt.constant = 16
        }else {
            
            self.maxOption_Btn.isSelected = true
            self.highlighter_LeadingConstrnt.constant = 124
        }
        self.tblView.reloadData()
    }
}

extension MISelectSalaryMinMaxViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MIOptionSelectionCell", for: indexPath) as? MIOptionSelectionCell {
            cell.delegate = self
            cell.displayContent(obj: optionDataSource[indexPath.row], selctionData: optionSelectionInfo, contentIndex: indexPath,forMinData: self.minOption_Btn.isSelected)
            return cell
        }
        return UITableViewCell.init(style: .default, reuseIdentifier: "cell")
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let headingView = MISelectionTitleHeaderView.headerSectionView as! MISelectionTitleHeaderView
        headingView.setHeadingTitleSubTitle(title: "Lacs", subTitle: "Thousands")
        return headingView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MISelectSalaryMinMaxViewController:OptionSelectionDelegate {
   
    func optionSelectedIndex(indexValue: IndexPath, forTitle: Bool) {
        if self.minOption_Btn.isSelected{
            if forTitle {
                optionSelectionInfo["minOptionSelection"]?["titleSelectedIndex"] = indexValue.row
            }else {
                optionSelectionInfo["minOptionSelection"]?["subTitleSelectedIndex"] = indexValue.row
            }
        }else {
            if forTitle {
                optionSelectionInfo["maxOptionSelection"]?["titleSelectedIndex"] = indexValue.row
            }else {
                optionSelectionInfo["maxOptionSelection"]?["subTitleSelectedIndex"] = indexValue.row
            }
        }
        self.tblView.reloadData()
    }

}

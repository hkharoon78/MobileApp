//
//  MIManageSubscriptionView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIManageSubscriptionView: UIView {
  
    //MARK:Outlets And Variables
    var index = 2
    var viewController: UIViewController?
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:Initializer
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
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.register(UINib(nibName: String(describing: MIManageSubsTopTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIManageSubsTopTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: MIManageSubsTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIManageSubsTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: MIManageSubsReadMoreTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIManageSubsReadMoreTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: MIManageSubsFooterTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIManageSubsFooterTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: MITableSectionHeaderView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: MITableSectionHeaderView.self))
        
        self.tableView.keyboardDismissMode = .onDrag
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
       self.tableView.bounces=true
     let footerView=UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 70))
        footerView.backgroundColor=AppTheme.viewBackgroundColor//UIColor.init(hex: "f4f6f8")
        tableView.tableFooterView=footerView
    }


}

//MARK:UITableView Delegate and Data Source Method
extension MIManageSubscriptionView:UITableViewDelegate,UITableViewDataSource{
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return ManageSubscSection.allCases.count + index
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            
            guard let cell=tableView.dequeueReusableCell(withIdentifier:String(describing: MIManageSubsTopTableViewCell.self), for: indexPath)as?MIManageSubsTopTableViewCell else{ return UITableViewCell() }
            
            return cell

        case ManageSubscSection.allCases.count+1:
            guard let cell=tableView.dequeueReusableCell(withIdentifier:String(describing: MIManageSubsFooterTableViewCell.self), for: indexPath)as?MIManageSubsFooterTableViewCell else{ return UITableViewCell() }
            
            cell.btnMore.addTarget(self, action: #selector(btnMorePressed(_:)), for: .touchUpInside)
            
            return cell
            
        case ManageSubscSection.allCases.count+2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIManageSubsReadMoreTableViewCell") as! MIManageSubsReadMoreTableViewCell
            
            cell.lblDeactivationMsg.text! = ManageSubsCellConstant.readMore
            cell.btnDeactivate.addTarget(self, action: #selector(btnDeleteDeactivatePressed(_:)), for: .touchUpInside)
            cell.btnDelete.addTarget(self, action: #selector(btnDeleteDeactivatePressed(_:)), for: .touchUpInside)
            cell.btnLess.addTarget(self, action: #selector(btnLessPressed(_:)), for: .touchUpInside)
            cell.btnProceed.addTarget(self, action: #selector(btnProceedPressed(_:)), for: .touchUpInside)
            
            return cell

        default:
            guard let cell=tableView.dequeueReusableCell(withIdentifier:String(describing: MIManageSubsTableViewCell.self), for: indexPath)as?MIManageSubsTableViewCell else{
                return UITableViewCell()
            }
            return cell


        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0
        case ManageSubscSection.allCases.count+1:
            return 20.0
        case ManageSubscSection.allCases.count+2:
            return 0
        default:
            return 50.0
        }
        

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView=tableView.dequeueReusableHeaderFooterView(withIdentifier:String(describing: MITableSectionHeaderView.self))as?MITableSectionHeaderView else {
            return UIView()
        }
        headerView.sectionTitlelabel.font=UIFont.customFont(type: .Regular, size: 16)
        headerView.sectionTitlelabel.textColor=UIColor.init(hex: "7f8e94")
        
        if section != 0 {
            if section < ManageSubscSection.allCases.count+1{
                headerView.sectionTitlelabel.text=ManageSubscSection.allCases[section-1].rawValue
            } else {
                headerView.sectionTitlelabel.text=nil
            }
        }
        headerView.topView1.backgroundColor=AppTheme.viewBackgroundColor//UIColor.init(hex: "f4f6f8")
        headerView.viewAllButton.isHidden=true
        return headerView
    }
    
    @objc func btnMorePressed(_ sender: UIButton) {
        if index == 2 {
            index = index+1
            self.tableView.reloadData()
            sender.isHidden = true
        }

        
    }
    
    @objc func btnDeleteDeactivatePressed(_ sender: UIButton) {
        
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: ManageSubscSection.allCases.count+2)) as! MIManageSubsReadMoreTableViewCell
        
            cell.btnDelete.isSelected = false
            cell.btnDeactivate.isSelected = false

            sender.isSelected = true
        
    }
    
    @objc func btnLessPressed(_ sender: UIButton) {
        if index != 2 {
            index -= 1
            
            self.tableView.reloadData()

            let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: ManageSubscSection.allCases.count+1)) as! MIManageSubsFooterTableViewCell
            cell.btnMore.isHidden = false

        }
        
    }
    
    @objc func btnProceedPressed(_ sender: UIButton){
        let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: ManageSubscSection.allCases.count+2)) as! MIManageSubsReadMoreTableViewCell
    
        if cell.btnDeactivate.isSelected {
            let controller = MIDeactivateAccountViewController()
            viewController?.navigationController?.pushViewController(controller, animated: true)

        } else if cell.btnDelete.isSelected{
            let controller = MIDeleteAccountViewController()
            viewController?.navigationController?.pushViewController(controller, animated: true)

        } else {
        }
        
    }
    
}


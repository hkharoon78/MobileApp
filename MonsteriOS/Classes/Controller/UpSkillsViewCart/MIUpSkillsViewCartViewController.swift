//
//  MIUpSkillsViewCartViewController.swift
//  MonsteriOS
//
//  Created by Anushka on 31/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIUpSkillsViewCartViewController: UIViewController {
    
    @IBOutlet weak var tableViewUpSkillViewCart: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableViewUpSkillViewCart.delegate = self
        self.tableViewUpSkillViewCart.dataSource = self
                
        self.tableViewUpSkillViewCart.register(UINib(nibName: "MISelectedViewCartTableViewCell", bundle: nil), forCellReuseIdentifier: "MISelectedViewCartTableViewCell")
        self.tableViewUpSkillViewCart.register(UINib(nibName: "MIEnterCoupanCodeTableViewCell", bundle: nil), forCellReuseIdentifier: "MIEnterCoupanCodeTableViewCell")
        self.tableViewUpSkillViewCart.register(UINib(nibName: "MIUpSkillPriceTableViewCell", bundle: nil), forCellReuseIdentifier: "MIUpSkillPriceTableViewCell")
        self.tableViewUpSkillViewCart.register(UINib(nibName: "MIUpSkillViewcartBuyNowTableViewCell", bundle: nil), forCellReuseIdentifier: "MIUpSkillViewcartBuyNowTableViewCell")
        
        self.title = ControllerTitleConstant.upSkillViewCart
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NavigationBarButtonTitle.addMore, style: .done, target: self, action: #selector(btnAddMorePressed(_:)))
        
    }
    
    @objc func btnAddMorePressed(_ sender: UIButton){
    }
    
}

//MARK:- table view delegate and data source
extension MIUpSkillsViewCartViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MISelectedViewCartTableViewCell") as! MISelectedViewCartTableViewCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIEnterCoupanCodeTableViewCell") as! MIEnterCoupanCodeTableViewCell
            cell.txtfCouponCode.delegate = self
            cell.btnApply.addTarget(self, action: #selector(btnApplyPressed(_:)), for: .touchUpInside)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIUpSkillPriceTableViewCell") as! MIUpSkillPriceTableViewCell
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MIUpSkillViewcartBuyNowTableViewCell") as! MIUpSkillViewcartBuyNowTableViewCell
            return cell
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @objc func btnApplyPressed(_ sender: UIButton) {
        
    }
    
    
}

//
//  MIWorkExpListVC.swift
//  MonsteriOS
//
//  Created by Rakesh on 12/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIWorkExpListVC: UIViewController {
    @IBOutlet weak var tblView_Year: UITableView!
    @IBOutlet weak var tblView_Month: UITableView!
   // @IBOutlet weak var yearsLabel: UILabel!
   // @IBOutlet weak var monthsLabel: UILabel!
    var experienceInYear : String?
    var experienceInMonth : String?
    var workExperienceSelected : ((_ yearOfExp:String?,_ monthOfExp:String?)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialSetup()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Update Work Experience"
        self.navigationItem.hidesBackButton = false
        self.navigationController?.isNavigationBarHidden = false
        
    }
    func initialSetup() {
        
        self.tblView_Year.delegate = self
        self.tblView_Year.dataSource = self
        self.tblView_Month.delegate = self
        self.tblView_Month.dataSource = self
        self.tblView_Month.register(UINib(nibName: "MIDefaultSelectionCell", bundle: nil), forCellReuseIdentifier: "defaultCell")
        self.tblView_Year.register(UINib(nibName: "MIDefaultSelectionCell", bundle: nil), forCellReuseIdentifier: "defaultCell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NavigationBarButtonTitle.done, style: .plain, target: self, action: #selector(MIWorkExpListVC.doneBtnClicked(_:)))
    }
    @objc func doneBtnClicked(_ sender:UIBarButtonItem){
        if let callBack = self.workExperienceSelected {
            callBack(experienceInYear,experienceInMonth)
        }
        self.navigationController?.popViewController(animated: true)
    }


}
extension MIWorkExpListVC : UITableViewDelegate,UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell") as? MIDefaultSelectionCell {
            cell.tintColor = AppTheme.defaltBlueColor
            cell.accessoryType = .none
            if tableView == tblView_Year {
                if let selectedYear = self.experienceInYear {
                    if selectedYear == "\(indexPath.row)" {
                        cell.accessoryType = .checkmark
                    }
                }
                cell.showTitle(title: (indexPath.row == 0) ? "Fresher" : "\(indexPath.row-1) \((indexPath.row-1 > 1 ? "Years" : "Year"))")

            } else {
                if let selectedMonth = self.experienceInMonth {
                    if selectedMonth == "\(indexPath.row)" {
                        cell.accessoryType = .checkmark
                    }
                }
                cell.showTitle(title: "\(indexPath.row) \((indexPath.row > 1 ? "Months" : "Month"))")

            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tblView_Year {
            return 52
        }else{
            return 12
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tblView_Year {
            experienceInYear = "\(indexPath.row)"
            if experienceInYear == "0" {
                experienceInMonth = nil
                self.tblView_Month.reloadData()

            }
            self.tblView_Year.reloadData()
        }else{
            experienceInMonth = "\(indexPath.row)"
            if experienceInYear == "0" && experienceInMonth != "0" {
                experienceInYear = nil
                self.tblView_Year.reloadData()

            }
            self.tblView_Month.reloadData()
        }
       
    }
}

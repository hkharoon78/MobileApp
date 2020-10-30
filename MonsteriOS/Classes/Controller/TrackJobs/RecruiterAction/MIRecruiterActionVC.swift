//
//  MIRecruiterActionVC.swift
//  MonsteriOS
//
//  Created by Anushka on 15/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIRecruiterActionVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var tableViewRecruiterAction: UITableView!
    
    
    //MARK:- view did life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initaSetup()
    }
    
    func initaSetup() {
        self.tableViewRecruiterAction.delegate = self
        self.tableViewRecruiterAction.dataSource = self
        
        self.tableViewRecruiterAction.register(UINib(nibName: "MIRecruiterActionCell", bundle: nil), forCellReuseIdentifier: "MIRecruiterActionCell")

    }

}

//MARk:- Table view delegate and data source
extension MIRecruiterActionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "MIRecruiterActionCell") as! MIRecruiterActionCell
        
        cell.accessoryType = .disclosureIndicator
        cell.tintColor = AppTheme.appGreyColor

        let nameArr = ["Profile Viewed", "Considered", "Contacted"]
        
        cell.lblActionName.text = nameArr[indexPath.row]
        cell.lblActionCount.text = "295 Recruiters considered your profile"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.accessoryType = .disclosureIndicator
    }
    
}




//
//  MIPersonalDetailViewController.swift
//  MonsteriOS
//
//  Created by Piyush on 18/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

enum MIProfileGenericType:Int{
    case GenericEntry = 0
    case GenericRadio = 1
}

class MIProfileGenericInfo:NSObject {
    var placeHolder = ""
    var data        = ""
    var type        = MIProfileGenericType.GenericEntry
    init(with placeHolderTxt:String,  moduleType:MIProfileGenericType = MIProfileGenericType.GenericEntry) {
        self.placeHolder = placeHolderTxt
        self.type        = moduleType
    }
}

class MIPersonalDetailViewController: MIBaseViewController {

    @IBOutlet weak var tblView:UITableView!
    private var genericEntryCellId = "genericCell"
    private var personalDetailArray = [MIProfileGenericInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.tblView.tableFooterView = UIView()
        self.populateDataSource()
    }
    
    func populateDataSource() {
        var genericModel = MIProfileGenericInfo.init(with: "Home")
        self.personalDetailArray.append(genericModel)
        
        genericModel = MIProfileGenericInfo.init(with: "Permanent Address")
        self.personalDetailArray.append(genericModel)
        
        genericModel = MIProfileGenericInfo.init(with: "Pin Code")
        self.personalDetailArray.append(genericModel)
        
        genericModel = MIProfileGenericInfo.init(with: "Maritial Status")
        self.personalDetailArray.append(genericModel)
        
        genericModel = MIProfileGenericInfo.init(with: "Date of Birth")
        self.personalDetailArray.append(genericModel)
        
        genericModel = MIProfileGenericInfo.init(with: "Passport Number")
        self.personalDetailArray.append(genericModel)
        
        genericModel = MIProfileGenericInfo.init(with: "Category")
        self.personalDetailArray.append(genericModel)
        
        genericModel = MIProfileGenericInfo.init(with: "Work Permit for USA")
        self.personalDetailArray.append(genericModel)
        
        genericModel = MIProfileGenericInfo.init(with: "Work Permit for Other Country")
        self.personalDetailArray.append(genericModel)
        
        genericModel = MIProfileGenericInfo.init(with: "Nationality")
        self.personalDetailArray.append(genericModel)
        
    }
    
    func setUI()  {
        self.tblView.register(UINib(nibName: "MIProfileGenericEntryCell", bundle: nil), forCellReuseIdentifier: genericEntryCellId)
    }
}

extension MIPersonalDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.personalDetailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tblView.dequeueReusableCell(withIdentifier: genericEntryCellId) as? MIProfileGenericEntryCell{
            cell.show(info: self.personalDetailArray[indexPath.row])
            return cell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "default")
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

//
//  MIPopOverController.swift
//  DemoPopover
//
//  Created by Piyush on 07/02/19.
//  Copyright © 2019 Piyush. All rights reserved.
//

import UIKit

public enum MIProfileActionEnum:String {
    case edit   = "Edit"
    case delete = "Delete"
}

protocol MIPopOverControllerDelegate: class {
    func popOverClicked(actionType: MIProfileActionEnum, info:Any, profileType:MIProfileEnums)
}

class MIPopOverController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    private var list = ["Edit","Delete"]
    weak var delegate:MIPopOverControllerDelegate?
    var info = [Any]()
    var profileType = MIProfileEnums.ITSkill
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    
    func setUI() {
        self.tableView.register(UINib(nibName: "popOverCell", bundle: nil), forCellReuseIdentifier: "popOverCell")
        self.tableView.tableFooterView = UIView()
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "popOverCell") as? popOverCell {
            cell.show(ttl: list[indexPath.row])
            cell.titleLbl.textColor = Color.blueThemeColor
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
            var actionEnum = MIProfileActionEnum.edit
            if indexPath.row == 1 {
                actionEnum = MIProfileActionEnum.delete
            }
            if let editInfo = self.info.first {
                self.delegate?.popOverClicked(actionType: actionEnum, info: editInfo, profileType: self.profileType)
            }
        }
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

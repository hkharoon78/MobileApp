//
//  MILanguageKnownVC.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 24/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MILanguageKnownVC: UIViewController {

    let tableView=UITableView()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Language Known"
        
        // Do any additional setup after loading the view.
        self.tableView.register(nib: MIFloatingTextFieldTableCell.loadNib(), withCellClass: MIFloatingTextFieldTableCell.self)
        self.tableView.register(nib: MI3CheckBoxTableCell.loadNib(), withCellClass: MI3CheckBoxTableCell.self)
        self.tableView.register(nib: MICheckboxTableCell.loadNib(), withCellClass: MICheckboxTableCell.self)
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.tableFooterView?.backgroundColor=UIColor.colorWith(r: 244, g: 246, b: 248, a: 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
}

extension MILanguageKnownVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withClass: MIFloatingTextFieldTableCell.self, for: indexPath)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withClass: MI3CheckBoxTableCell.self, for: indexPath)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withClass: MICheckboxTableCell.self, for: indexPath)
            cell.checkboxButtn.isHidden = true
            return cell

        }
    }
}

//
//  MIJobAlertHomeViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 14/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class MIJobAlertHomeViewController: UIViewController,IndicatorInfoProvider {

    let tableView = UITableView()
    var delegate:JobDetailsNavigationDelegate!
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    let sectionTitle=["Designer","Product Manager","iOS Developer"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName:String(describing: MITrackJobTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MITrackJobTableViewCell.self))
        tableView.register(UINib(nibName: String(describing: MITableSectionHeaderView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: MITableSectionHeaderView.self))
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.tableFooterView?.backgroundColor=UIColor.colorWith(r: 244, g: 246, b: 248, a: 1)
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: ControllerTitleConstant.jobAlert)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MIJobAlertHomeViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MITrackJobTableViewCell.self), for: indexPath)as?MITrackJobTableViewCell else {
            return UITableViewCell()
        }
        cell.trackJobType = .jobAlert
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView=tableView.dequeueReusableHeaderFooterView(withIdentifier:String(describing: MITableSectionHeaderView.self))as?MITableSectionHeaderView else {
            return UIView()
        }
        headerView.sectionTitlelabel.text=self.sectionTitle[section]
        headerView.topView1.backgroundColor=UIColor.init(hex: "f4f6f8")
        return headerView
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _dele=self.delegate{
            _dele.navigateToJobDetails()
        }
    }
}

//
//  MIRecuiterActionViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 03/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIRecuiterActionViewController: MIBaseViewController {

    let tableView=UITableView()
    
    override func loadView() {
        super.loadView()
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints=false
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: self.view.topAnchor),tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)])
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
         self.tableView.register(UINib(nibName: String(describing: MIHomeJobCell.self), bundle: nil), forCellReuseIdentifier: "jobCell")
        self.tableView.register(UINib(nibName: String(describing: MIRecuiterActionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIRecuiterActionTableViewCell.self))
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.bounces=true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title=MoreOptionViewModelItemType.recruiterActions.value
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

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
extension MIRecuiterActionViewController:UITableViewDelegate,UITableViewDataSource{
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return 6
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row==0{
            guard let cell=tableView.dequeueReusableCell(withIdentifier:"jobCell", for: indexPath)as?MIHomeJobCell else {
                return UITableViewCell()
            }
            cell.show(info: MIJobStatusInfo(with: "10", ttlAppliedJobCount: "30", ttlJobAlertCont: "01", ttlSavedJob: "Views", ttlAppliedJob: "Downloads", ttlJobAlert: "CONTACTED"))
            cell.delegate=self
            return cell
            }else{
                guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIRecuiterActionTableViewCell.self), for: indexPath)as?MIRecuiterActionTableViewCell else{
                    return UITableViewCell()
                }
                cell.recuiterData=RecuiterActionViewModel(recuiterName: "Gaurav Thapa", companyName: "Monster India", locationName: "Noida", date: "Today")
                return cell
            }
        }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
}

extension MIRecuiterActionViewController:MIHomeJobCellDelegate{
    func savedJobClicked(){
        
    }
    func appliedJobClicked(){
        
    }
    func jobAlertClicked(){
        
    }
    
}

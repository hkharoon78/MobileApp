//
//  MICarrerAdviceTipsViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 24/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MICarrerAdviceTipsViewController: UIViewController {

    @IBOutlet weak var tablView : UITableView!
    
    var carrerAdviceData = [MICarrerTipsModel]()
    var tipsDataSource = [MICarrerTipsModel]()

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpView()
    }
    //MARK : - Helper Methids
    func setUpView() {
        
        self.title = "Career Advice & Tips"
        self.tablView.estimatedRowHeight = 124
        self.tablView.rowHeight = UITableView.automaticDimension
        
        self.tablView.register(UINib.init(nibName: "MICarrerAdviceCell", bundle: nil), forCellReuseIdentifier: String(describing: MICarrerAdviceCell.self))
        
        //Dummy Data for Advice List
        carrerAdviceData.append(MICarrerTipsModel.init(title: "Happy Monster Holidays!", descriptionContent: "If you have not caught up with it already, here is more on our new Content Marketing Campaign – Happy Monster Holidays – aimed at. If you have not caught up with it already, here is more on our new Content Marketing Campaign – Happy Monster Holidays – aimed at", isSelected: false))
        
        carrerAdviceData.append(MICarrerTipsModel.init(title: "Beware of fraud calls in the name of Monster India.", descriptionContent: "If you have not caught up with it already, here is more on our new Content Marketing Campaign – Happy Monster Holidays – aimed at. If you have not caught up with it already, here is more on our new Content Marketing Campaign – Happy Monster Holidays – aimed at", isSelected: false))

        carrerAdviceData.append(MICarrerTipsModel.init(title: "How can IT professionals future-proof...", descriptionContent: "If you have not caught up with it already, here is more on our new Content Marketing Campaign – Happy Monster Holidays – aimed at. If you have not caught up with it already, here is more on our new Content Marketing Campaign – Happy Monster Holidays – aimed at", isSelected: false))
        
        //Dummy Data for tips list
        tipsDataSource.append(MICarrerTipsModel.init(title: "Trending", isSelected: true))
        tipsDataSource.append(MICarrerTipsModel.init(title: "Career Management", isSelected: false))
        tipsDataSource.append(MICarrerTipsModel.init(title: "Interview Tips", isSelected: false))
        tipsDataSource.append(MICarrerTipsModel.init(title: "Interview Questions", isSelected: false))

    }
}

extension MICarrerAdviceTipsViewController : UITableViewDelegate,UITableViewDataSource,ReadMoreAdviceDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.carrerAdviceData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MICarrerAdviceCell", for: indexPath) as? MICarrerAdviceCell {
            cell.showContent(obj: carrerAdviceData[indexPath.row])
            cell.delegate = self
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return carrerAdviceData[indexPath.row].flag ? UITableView.automaticDimension : 220
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = MICarrerTipsHeaderView.headerView
        headerView.tipsData = self.tipsDataSource
        return headerView
    }
  
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    //MARK: - ReadMoreAdviceDelegate Methods
    func readMoreContent(model: MICarrerTipsModel) {
        
//        if let index =  self.carrerAdviceData.index(of:model) {
//            self.tablView.reloadData()
//            //self.tablView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
//        }
    }
}

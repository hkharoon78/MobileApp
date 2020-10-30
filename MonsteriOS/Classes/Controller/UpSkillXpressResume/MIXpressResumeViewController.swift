//
//  MIXpressResumeViewController.swift
//  MonsteriOS
//
//  Created by Rakesh on 20/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

struct MIXpressResumeInfo {
    var regionName : String!
    var descriptionContent : String!
    var amount : String!
}
class MIXpressResumeViewController: UIViewController {

    @IBOutlet weak var tblView : UITableView!
    
    var xpressResumeDataSource  = [MIXpressResumeInfo]()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpView()
        self.populateData()
    }

    //MARK: - Private Helper Methods
    private func setUpView() {
        
        self.title = ControllerTitleConstant.xpressResume
        
        let rightBarItem = UIBarButtonItem(image: UIImage(named: "star-fill"), style: .done, target: self, action:#selector(MIXpressResumeViewController.questionMarkBtnAction(_:)))
        self.navigationItem.rightBarButtonItem = rightBarItem
      
        self.tblView.backgroundColor = AppTheme.viewBackgroundColor
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedSectionFooterHeight = 100
        self.tblView.sectionFooterHeight = UITableView.automaticDimension
        self.tblView.register(UINib.init(nibName: "MIXpressResumeCell", bundle: nil), forCellReuseIdentifier: String(describing: MIXpressResumeCell.self))

    }
    //Dummay Data
    private func populateData() {
        
        xpressResumeDataSource.append(MIXpressResumeInfo(regionName: "National", descriptionContent:"Share your resume with the 1200 Placement Consultant", amount: "Rs 999.00"))
        xpressResumeDataSource.append(MIXpressResumeInfo(regionName: "Gulf", descriptionContent:"Share your resume with the 200 Placement Consultant", amount: "Rs 1499.00"))
        xpressResumeDataSource.append(MIXpressResumeInfo(regionName: "National + Gulf", descriptionContent:"Share your resume with the 1400 Placement Consultant", amount: "Rs 1999.00"))
        xpressResumeDataSource.append(MIXpressResumeInfo(regionName: "Consultants in", descriptionContent:"Share your resume with Consultant in", amount: "Rs 599.00"))
    }
    
    //MARK: - IBAction Methods
    @objc func questionMarkBtnAction(_ sender:UIBarButtonItem) {
    }
}

extension MIXpressResumeViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
  
        return xpressResumeDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MIXpressResumeCell", for: indexPath) as? MIXpressResumeCell {
            cell.showData(info: xpressResumeDataSource[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerView = MIXpressResumerFooterView.footerView
        footerView.setTitleBodyContent(title: "Disclaimer", bodyContent: "Please note that Monster only shares your resume with the recruitment consultants. We do not have any tie up with the placement consultants nor do we provide any assurance of job offers.")
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

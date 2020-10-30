//
//  MIRecruiterMessageVC.swift
//  MonsteriOS
//
//  Created by Anushka on 25/06/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MIRecruiterMessageVC: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    var jsonResponse: RecruiterActionMsgBase?
    var topViewModel: RecuiterActionCellViewModel?
  
    //MARK:- View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initialSetup()
    }
    
    func initialSetup() {
        
        self.title = "Recruiter Message"
        
        self.recruiterActionMsgAPI()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(UINib(nibName: String(describing: MIRecruiterMsgDetailsCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIRecruiterMsgDetailsCell.self))
        
        self.tableView.register(UINib(nibName: String(describing: MIRecruiterMsgDescriptionCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIRecruiterMsgDescriptionCell.self))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title =  "Recruiter Message"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.title = ""
    }


}


extension MIRecruiterMessageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jsonResponse != nil ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
            case 0:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIRecruiterMsgDetailsCell.self)) as? MIRecruiterMsgDetailsCell else { return UITableViewCell() }
        
                cell.modelData = topViewModel
                
                return cell
           
            default :
                guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIRecruiterMsgDescriptionCell.self)) as? MIRecruiterMsgDescriptionCell else { return UITableViewCell() }
              
                cell.modelData = self.jsonResponse
                
                return cell
        }
    }
    
}


extension MIRecruiterMessageVC {
    
    func recruiterActionMsgAPI() {
        
        if let path = Bundle.main.path(forResource: "RecruiterActionMsg", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? NSDictionary{
                    
                    self.jsonResponse = RecruiterActionMsgBase(dictionary: jsonResult)
                    
                    self.tableView.reloadData()
                }
            } catch {
                // handle error
            }
        }
        
    }
}

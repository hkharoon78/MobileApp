//
//  MIGleacSkillIndexCell.swift
//  MonsteriOS
//
//  Created by Anushka on 19/06/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit

class MIGleacSkillIndexCell: UITableViewCell {
    
    @IBOutlet weak var btnViewReport: UIButton!
    var viewReportCallBack: (()->Void)?
    
    var reportURL = ""
    var viewController: UIViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
        // self.getGleacSkillReport()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnReportPressed(_ sender: UIButton){
        self.viewReportCallBack?()
       
//        if !self.reportURL.isEmpty {
//             self.viewReportCallBack?(self.reportURL)
//        } else {
//            self.getGleacSkillReport()
//        }
    }
    
}

//extension MIGleacSkillIndexCell {
//
//    func getGleacSkillReport() {
//
//        MIApiManager.hitGleacSkillsResultAPI { (success, response, error, code) in
//            DispatchQueue.main.async {
//
//                if let responseData = response as? JSONDICT {
//                    if let result = responseData["result"] as? JSONDICT{
//                        if let url = result["url"] as? String {
//                            self.reportURL = url
//                        }
//                    } else if let errors = responseData["errors"] as? String {
//                        self.viewController?.toastView(messsage: errors)
//                    }
//                }
//            }
//        }
//
//    }
//
//
//}

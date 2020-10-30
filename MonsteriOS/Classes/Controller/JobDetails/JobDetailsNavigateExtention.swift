//
//  JobDetailsNavigateExtention.swift
//  MonsteriOS
//
//  Created by ishteyaque on 19/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
import UIKit

extension MIJobDetailsViewController{
    func checkNavigateAPI(){
        switch navigateAction {
        case .apply:
            self.refereshJobDetailAfterLogin(jobApplyNav: navigateAction,jobApplyId: navigateJobId ?? "")
         //   self.applyAction(jobId: self.jobId)
        case .save:
            self.saveUnSaveApiCall(path: APIPath.saveJob, sender: self.savedButton)
        case .followRecruiter:
            followCompanyOrRecruiter(path: APIPath.followRecruiter + (self.jsonData?.recruiter?.recruiterUuid ?? ""), type: .recruiter)
            
        case .followCompany:
            followCompanyOrRecruiter(path: APIPath.followCompany + String(self.jsonData?.companyId ?? 0), type: .company)
        default:
            break
        }
        navigateAction = .none
        navigateJobId = nil
        navigateStartValue=nil

    }
    
    func followCompanyOrRecruiter(path:String,type:CompanyOrRec){
        let _ = MIAPIClient.sharedClient.load(path: path, method: .post, params: [:]) { [weak self] (responseData, error,code) in
            //guard let wkSelf=self else {return}
             DispatchQueue.main.async {
            if error != nil {
               // DispatchQueue.main.async {
                    self?.showAlert(title: "", message: error?.errorDescription)
               // }
                return
            }else{
                if let jsonData=responseData as? [String:Any]{
                   // DispatchQueue.main.async {
                        self?.showAlert(title: "", message:jsonData["successMessage"]as?String,isErrorOccured:false)
                        if type == .company{
                            self?.listView.modelData?.isCompanyFollow = true
                        }else{
                            self?.listView.modelData?.isRecruiterFollow = true
                        }
                        self?.listView.tableView.reloadData()
                        
                   // }
                }
                
            }
            }
        }
    }
    
}

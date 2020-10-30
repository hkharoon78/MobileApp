//
//  CompOrRecNavigateExtension.swift
//  MonsteriOS
//
//  Created by ishteyaque on 15/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
import UIKit

extension MIRecruiterDetailsViewController{
    
    func checkNavigateAPI(){
        switch navigateAction {
        case .apply:
            self.eventTrackingValue=self.recuterOrCompanyType.eventTrack 
            //self.applyActionGlobal(jobId: navigateJobId ?? "", redirectURl: nil)
            self.refereshDataAfterLoginFlowForApply(jobId: navigateJobId ?? "", navigationFor: navigateAction, start: navigateStartValue ?? "")
            navigateJobId = nil
            
        case .save:
            self.saveJobNavigate(path: APIPath.saveJob)
        case .followRecruiter:
            followAndUnfollowCmpanyOrRecuiter(path: APIPath.followRecruiter + (self.jobModel?.recruiter?.recruiterUuid ?? "0"), method: .post, type: .recruiter)
            
        case .followCompany:
            followAndUnfollowCmpanyOrRecuiter(path: APIPath.followCompany + String(self.jobModel?.companyId ?? 0), method: .post, type: .company)
        default:
            break
        }
        navigateAction = .none
        navigateJobId = nil
        navigateStartValue=nil

    }
func saveJobNavigate(path:String){
    let _ = MIAPIClient.sharedClient.load(path:path, method: path==APIPath.saveJob ? .post : .delete, params: ["jobId":navigateJobId ?? ""]) { (responseData, error,code) in
        
        if error != nil{
            return
        }else{
            DispatchQueue.main.async {
                isSavedOrUnsaved=true
                if path==APIPath.saveJob{
                  //  self.showAlert(title: "", message:"Saved Successfully",isErrorOccured:false)
                    let savedData=self.companyJobJson?.data?.filter({$0.jobId==Int(navigateJobId ?? "0")})
                    savedData?.first?.isSaved=true
                    navigateJobId = nil
                    self.tableView.reloadData()
                }
            }
        }
    }
}
}

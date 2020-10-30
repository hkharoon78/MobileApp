//
//  JobListingNavigationExtension.swift
//  MonsteriOS
//
//  Created by ishteyaque on 19/02/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import Foundation
import UIKit

extension MISRPJobListingViewController{
    
    func checkNavigateAPI(){
        switch navigateAction {
        case .apply:
            var searchId=""
            if let jobData=self.listView.jsonData?.data?.filter({$0.jobId == Int(navigateJobId ?? "0")!}){
                if jobData.count > 0{
                    searchId=jobData[0].resultId
                }
            }
            self.joblistAPICallForNonLoginApplyFlow(jobToApply: navigateJobId ?? "", flowType: navigateAction, painationStart: navigateStartValue ?? "", searchId: searchId)
            
          //  self.applyAction(jobId: navigateJobId ?? "", redirectURl: nil, searchId:searchId)
            navigateJobId = nil
            navigateStartValue = nil
        case .save:
            self.saveJobNavigate(path: APIPath.saveJob)
        case .createAlert:
            self.callJobAlertApi()
//            let vc=MICreateJobAlertViewController()
//            let modelData=JobAlertModel()
//            modelData.keywords=self.selectedSkills
//            modelData.desiredLocation=self.selectedLocation
//            var categArray=[MICategorySelectionInfo]()
//            for item in self.selectedSkills.components(separatedBy: ","){
//                let categ=MICategorySelectionInfo()
//                categ.name=item
//                categArray.append(categ)
//            }
//            modelData.masterData[MasterDataTitle.keywords.rawValue]=categArray
//            categArray.removeAll()
//            for item in self.selectedLocation.components(separatedBy: ","){
//                let categ=MICategorySelectionInfo()
//                categ.name=item
//                categArray.append(categ)
//            }
//            modelData.masterData[MasterDataTitle.desiredLocation.rawValue]=categArray
//
//           // modelData.masterData[MasterDataTitle.keywords.rawValue]=
//            vc.modelData=modelData
//            vc.jobAlertType = .fromSRP
//            vc.alertCreatedSuccess={(true) in
//                self.createJobAlertView.isHidden=true
//            }
//            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
        navigateAction = .none
        navigateStartValue=nil

    }
    
    func saveJobNavigate(path:String){
        
        let _ = MIAPIClient.sharedClient.load(path:path, method: path==APIPath.saveJob ? .post : .delete, params: ["jobId":navigateJobId ?? ""]) { (responseData, error,code) in
            if error != nil{
                return
            }else{
                DispatchQueue.main.async {
                    let pageName="Job Listing"
                    isSavedOrUnsaved=true
                    if path==APIPath.saveJob{
                        let savedData=self.listView.jsonData?.data?.filter({$0.jobId==Int(navigateJobId ?? "0")})
                        savedData?.first?.isSaved=true
                        navigateJobId = nil
                        self.listView.tableView.reloadData()
                    }
                }
            }
        }
    }

}

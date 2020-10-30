//
//  MIHorizontalScrollTableCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 28/12/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIHorizontalScrollTableCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var swipeCardSelection:((Int,Bool)->Void)?
    var applyCardSelection:((Int?,String?,_ isAppliedFired:Bool)->Void)?
    var jobListingModel: JoblistingBaseModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    var isNoMoreAdd=false{
        didSet{
            if isNoMoreAdd{
                cardCount=1
            }else{
                cardCount=0
            }
        }
    }
    var cardCount=0
    var isApplyViewShow=false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.register(UINib(nibName:String(describing: MIRecommendJobCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MIRecommendJobCollectionViewCell.self))
        
        self.selectionStyle = .none
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


extension MIHorizontalScrollTableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (jobListingModel?.data?.count ?? 0) + cardCount
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width-40, height: collectionView.frame.size.height-20)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withClass: MIRecommendJobCollectionViewCell.self, for: indexPath)
        if self.jobListingModel?.data == nil || indexPath.item == self.jobListingModel?.data?.count{
            cell.isNoMore=true
        }else{
            cell.isNoMore=false
            cell.showData(JoblistingCellModel(model: jobListingModel!.data![indexPath.item]))
                if isApplyViewShow {
                    cell.contentItem.applySkipView.isHidden = false
                    cell.contentItem.applySkipVIewHeight.constant = 40
                        cell.contentItem.applySkipAction = {(skipOrApply) in
                            
                            if skipOrApply{
                                if self.jobListingModel?.data?[indexPath.item].isApplied ?? false {
                                    //Job Already applied
                                }else{
                                                            self.applyCardSelection?(self.jobListingModel?.data?[indexPath.item].jobId,self.jobListingModel?.data?[indexPath.item].redirectUrl, true)
                                                            
                                                          //self.applyCardSelection?(indexPath.item)
                                    //                        if AppDelegate.instance.authInfo.accessToken.count > 0 {
                                    //                            self.jobListingModel?.data?.remove(at: indexPath.item)
                                    //                        }
                                                            let lbl = ("\(indexPath.item)") + "_" + String(self.jobListingModel?.data?[indexPath.item].jobId ?? 0)
                                                            CommonClass.googleEventTrcking("job_detail_screen", action: "similar_jobs_apply", label: lbl ) //GA

                                }
                            }else{
                               
                                let lbl = ("\(indexPath.item)") + "_" + String(self.jobListingModel?.data?[indexPath.item].jobId ?? 0)
                                CommonClass.googleEventTrcking("job_detail_screen", action: "similar_jobs_skip", label: lbl ) //GA
                               
                               //Job Skipped
                                                                                            self.applyCardSelection?(self.jobListingModel?.data?[indexPath.item].jobId,self.jobListingModel?.data?[indexPath.item].redirectUrl, false)
                                if CommonClass.isLoggedin() {
                                    self.jobListingModel?.data?.remove(at: indexPath.item)
                                }
                              
                            }
                           
                            if self.jobListingModel?.data?.count == 0{
                                if let parentVc=self.parentViewController as? MIJobDetailsViewController{
                                    if let index=parentVc.listView.sectionTitle.firstIndex(of:JobDetailsSectionTitle.similarJobs.rawValue){
                                        parentVc.listView.sectionTitle.remove(at:index)
                                        parentVc.listView.tableView.reloadData()
                                    }
                                   // parentVc.similarJobsData=self.jobListingModel
                                }
                                if let parentVc=self.parentViewController as? MIJobAppliedSuccesViewController{
                                    if parentVc.setionTitle.count > 1{
                                        parentVc.setionTitle.remove(at:1)
                                        parentVc.tableView.reloadData()
                                    }
                                    // parentVc.similarJobsData=self.jobListingModel
                                }
                            }
                            self.collectionView.reloadData()
                        }
                }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let lbl = ("\(indexPath.item)") + "_" + String(self.jobListingModel?.data?[indexPath.item].jobId ?? 0)
      
        CommonClass.googleEventTrcking("similar_jobs_screen", action: "job_card", label: lbl ) //GA
        if let cell = collectionView.cellForItem(at: indexPath) as? MIRecommendJobCollectionViewCell {
            swipeCardSelection?(indexPath.item,cell.isNoMore)
        }
        
    }
}

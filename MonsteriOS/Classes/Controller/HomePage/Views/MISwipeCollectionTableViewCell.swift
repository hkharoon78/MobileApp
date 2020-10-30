//
//  MISwipeCollectionTableViewCell.swift
//  MonsteriOS
//
//  Created by Anushka on 14/09/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit

protocol ListCollectionCellDelgate:class {
    func showTopCompanyDetails(compId: String)
    func showJobsFromUrl(ttl:String, type:HomeJobCategoryType)
    func employmentIndexClicked(url:String, controllerTitle:String)
    func showVideoFromUrl(url:String)
}

class MISwipeCollectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionListView: UICollectionView!
    @IBOutlet weak var heightCollectionView: NSLayoutConstraint!
    
    weak var delegate: ListCollectionCellDelgate?
    var headerName = ""
    var jobTopCompanyModel =  [MIHomeJobTopCompanyModel]()
    var jobCategoryModel = [MIHomeJobCategory]()
    var videoModel = [MIHomeVideos]()
    var employmentIndexModel = [MIHomeEmploymentIndex]()
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.contentView.leftAnchor.constraint(equalTo: leftAnchor),
            self.contentView.rightAnchor.constraint(equalTo: rightAnchor),
            self.contentView.topAnchor.constraint(equalTo: topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        self.registerCell()
        
        self.collectionListView.delegate = self
        self.collectionListView.dataSource = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionListView.collectionViewLayout = layout
        
    }
    
    func registerCell() {
        self.collectionListView.register(UINib(nibName:String(describing: MIListingHomeCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MIListingHomeCollectionViewCell.self))
        
        self.collectionListView.register(UINib(nibName:String(describing: MIJobCategoryCollectionCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MIJobCategoryCollectionCell.self))
        
        self.collectionListView.register(UINib(nibName:String(describing: MIHomeEmploymentIndexCollectionCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MIHomeEmploymentIndexCollectionCell.self))
        
        self.collectionListView.register(UINib(nibName:String(describing: MIHomeVideoCollectionCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MIHomeVideoCollectionCell.self))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}


extension MISwipeCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch headerName {
        case MIHomeModuleEnums.topCompanies.rawValue:
            return self.jobTopCompanyModel.count
            
        case MIHomeModuleEnums.jobCategory.rawValue:
            return self.jobCategoryModel.count
            
        case MIHomeModuleEnums.reports.rawValue:
            return self.employmentIndexModel.count
            
        case MIHomeModuleEnums.videos.rawValue:
            return self.videoModel.count
            
        default:
            return 0
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        self.collectionListView.backgroundColor = UIColor(hex: "f4f6f8")
        
        if headerName == MIHomeModuleEnums.topCompanies.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MIListingHomeCollectionViewCell", for: indexPath) as? MIListingHomeCollectionViewCell {
                
                cell.showTopCompanies(compInfo: self.jobTopCompanyModel[indexPath.row])
                
                return cell
            }
            
        }
        
        if headerName == MIHomeModuleEnums.jobCategory.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MIJobCategoryCollectionCell", for: indexPath) as? MIJobCategoryCollectionCell {
                
                cell.showJobCategory(info: self.jobCategoryModel[indexPath.row])
                
                return cell
            }
            
        }
        
        if headerName == MIHomeModuleEnums.reports.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MIHomeEmploymentIndexCollectionCell", for: indexPath) as? MIHomeEmploymentIndexCollectionCell {
                
                cell.show(info: self.employmentIndexModel[indexPath.row])
                
                cell.learnMoreCallBack = {
                    let row = self.employmentIndexModel[indexPath.row]
                    self.delegate?.employmentIndexClicked(url: row.url, controllerTitle: row.controllerTitle)
                }
                
                return cell
            }
            
        }
        
        if headerName == MIHomeModuleEnums.videos.rawValue {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MIHomeVideoCollectionCell", for: indexPath) as? MIHomeVideoCollectionCell {
                
                self.collectionListView.backgroundColor = UIColor.white
                
                cell.showVideo(info: self.videoModel[indexPath.row])
                cell.videoCallBack = {
                    let row = self.videoModel[indexPath.row]
                    self.delegate?.showVideoFromUrl(url: row.video_url)
                }
                
                return cell
            }
            
        }
        
        return UICollectionViewCell()
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch headerName {
        case MIHomeModuleEnums.topCompanies.rawValue:
            let row = self.jobTopCompanyModel[indexPath.row]
            self.delegate?.showTopCompanyDetails(compId: String(row.companyId ?? 0))
            
        case MIHomeModuleEnums.jobCategory.rawValue:
            let row = self.jobCategoryModel[indexPath.row]
            self.delegate?.showJobsFromUrl(ttl: row.name, type: row.jobType)
            
        default:
            break
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10) //UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.size.height
        let width = collectionView.frame.size.height * 1.35
        
        switch headerName {
        case MIHomeModuleEnums.topCompanies.rawValue:
            return CGSize(width: width, height: height)
        case MIHomeModuleEnums.jobCategory.rawValue:
            return CGSize(width: (height * 0.8) + 0 , height: height)
        case MIHomeModuleEnums.videos.rawValue:
            return CGSize(width: width - 10, height: height)
        case MIHomeModuleEnums.reports.rawValue:
            return CGSize(width: width + 20, height: height)
        default:
            return UICollectionViewFlowLayout.automaticSize
        }
        
    }
    
    
}




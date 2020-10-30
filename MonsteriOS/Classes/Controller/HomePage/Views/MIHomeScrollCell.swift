//
//  MIHomeScrollCell.swift
//  MonsteriOS
//
//  Created by Piyush on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

protocol MIHomeScrollCellDelgate:class {
    func showVideoFromUrl(url:String)
    func careerServiceClicked(url:String)
    func employmentIndexClicked(url:String, controllerTitle:String)
    func showJobsFromUrl(ttl:String,type:HomeJobCategoryType)
    func showTopCompanyDetails(compId: String)
}

class MIHomeScrollCell: UITableViewCell,UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollHeightConstraint: NSLayoutConstraint?
    
    weak var delegate:MIHomeScrollCellDelgate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    func removeAllViewsFromScrollView() {
        for vv in self.scrollView.subviews {
            vv.removeFromSuperview()
        }
        self.layoutIfNeeded()
        self.setNeedsLayout()
    }
    
    func addCareerServiceView(careerServices:[MIHomeCareerService])
    {
        self.removeAllViewsFromScrollView()
        for index in 0..<careerServices.count {
            let careerInfo = careerServices[index]
            let careerView = MIHomeCareerServiceView.view
            let viewWidth = careerView.frame.size.width
            careerView.frame = CGRect(x: viewWidth*CGFloat(index), y: 0, width: viewWidth, height: careerView.frame.size.height)
            
            careerView.show(info: careerInfo)
            careerView.delegate = self
            scrollView.addSubview(careerView)
            scrollView.contentSize = CGSize(width: careerView.frame.maxX, height: 0)
            self.scrollHeightConstraint?.constant = careerView.frame.size.height
        }
    }
    
    func addJobCategoryView(jobCategories:[MIHomeJobCategory]) {
        var originX = 0
        self.removeAllViewsFromScrollView()
        self.backgroundColor = UIColor(hex: "f4f6f8")
        
        for index in 0..<jobCategories.count {
            let jobInfo = jobCategories[index]
            let categoryView = MIHomeJobCategoryView.view
            categoryView.delegate = self
            categoryView.show(info: jobInfo)
            categoryView.frame.origin.x = CGFloat(originX)
            originX = originX + Int(categoryView.frame.size.width) - 10
            self.scrollView.addSubview(categoryView)
            self.scrollView.contentSize = CGSize(width: categoryView.frame.maxX, height: 0)
            self.scrollHeightConstraint?.constant  = categoryView.frame.size.height
        }
        
    }
    
    
    func addEmploymentIndex(employmentIndexes:[MIHomeEmploymentIndex])
    {
        self.removeAllViewsFromScrollView()
        self.backgroundColor = UIColor(hex: "f4f6f8")
        for index in 0..<employmentIndexes.count {
            let employmentIndex = employmentIndexes[index]
            let employmentView = MIHomeEmploymentIndexView.view
            
            let viewWidth = employmentView.frame.size.width
            employmentView.frame = CGRect(x: 0*CGFloat(index) + CGFloat(viewWidth)*CGFloat(index), y: 1, width: viewWidth, height: employmentView.frame.size.height)
            employmentView.show(info: employmentIndex)
            employmentView.delegate = self
            scrollView.addSubview(employmentView)
            scrollView.contentSize = CGSize(width: employmentView.frame.maxX, height: 0)
            self.scrollHeightConstraint?.constant = employmentView.frame.size.height + 2
        }
        
    }
    
    func addEducationView(educationList:[MIMonsterEducation]) {
        self.removeAllViewsFromScrollView()
        
        for index in 0..<educationList.count {
            let educationView = MIHomeMonsterEducationView.view
            let viewWidth = kScreenSize.width - 50
            educationView.showData(model: educationList[index])
            educationView.frame = CGRect(x: 0*CGFloat(index) + CGFloat(viewWidth)*CGFloat(index), y: 1, width: viewWidth, height: educationView.frame.size.height)
            scrollView.addSubview(educationView)
            scrollView.contentSize = CGSize(width: educationView.frame.maxX, height: 0)
            self.scrollHeightConstraint?.constant = educationView.frame.size.height + 2
        }
    }
    
    func addExpertSpeak(videosInfo:[MIHomeVideos]) {
        self.removeAllViewsFromScrollView()
        for index in 0..<videosInfo.count {
            let expertView = MIHomeVideoView.view
            expertView.delegate = self
            expertView.btnVideoIcon.tag = index
            expertView.showVideo(info: videosInfo[index])
            let viewWidth = kScreenSize.width - 140
            expertView.frame = CGRect(x:  CGFloat(viewWidth)*CGFloat(index), y: 1, width: viewWidth, height: expertView.frame.size.height)
            scrollView.addSubview(expertView)
            scrollView.contentSize = CGSize(width: expertView.frame.maxX, height: 0)
            self.scrollHeightConstraint?.constant = expertView.frame.size.height + 2
        }
        self.backgroundColor = UIColor.white
    }
    
    func addArticleView(articleInfo:[MIHomeArticle]) {
        self.removeAllViewsFromScrollView()
        
        for index in 0..<articleInfo.count {
            let articleView = MIHomeArticleView.view
            let viewWidth = kScreenSize.width - 140
            articleView.show(info: articleInfo[index])
            articleView.frame = CGRect(x: CGFloat(viewWidth)*CGFloat(index), y: 1, width: viewWidth, height: articleView.frame.size.height )
            
            scrollView.addSubview(articleView)
            scrollView.contentSize = CGSize(width: articleView.frame.maxX, height: 0)
            self.scrollHeightConstraint?.constant = articleView.frame.size.height + 2
            
        }
    }
    
    func addTopCompanies(topCompanyInfo: [MIHomeJobTopCompanyModel]) {
        var originX = 0
        self.removeAllViewsFromScrollView()
        self.backgroundColor = UIColor(hex: "f4f6f8")

        for index in 0..<topCompanyInfo.count {
            let companyInfo = topCompanyInfo[index]
            let topCompanyView = MIHomeJobTopCompaniesView.view

            topCompanyView.delegate =  self
            topCompanyView.showTopCompanies(compInfo: companyInfo)

            topCompanyView.frame.origin.x = CGFloat(originX)
            originX = originX + Int(topCompanyView.frame.size.width) - 10

            self.scrollView.addSubview(topCompanyView)
            self.scrollView.contentSize = CGSize(width: topCompanyView.frame.maxX, height: 0)
            self.scrollHeightConstraint?.constant  = topCompanyView.frame.size.height
        }
    }
    
}

extension MIHomeScrollCell: MIHomeVideoDelegate,MIHomeJobCategoryViewDelegate,MIHomeCareerServiceViewDelegate,MIHomeEmploymentIndexViewDelegate, MIHomeTopCompaniesViewDelegate {
    
    
    // MIHomeEmploymentIndexViewDelegate
    func employmentIndexUrlClicked(url: String, controllerTitle: String) {
        self.delegate?.employmentIndexClicked(url: url, controllerTitle: controllerTitle)
    }
    
    func jobCategoryClicked(ttl: String, jobType: HomeJobCategoryType) {
        if !ttl.isEmpty {
            self.delegate?.showJobsFromUrl(ttl: ttl, type: jobType)
        }
    }
    
    func careerServiceClicked(url: String) {
        self.delegate?.careerServiceClicked(url: url)
    }
    
    func videoClicked(url: String) {
        self.delegate?.showVideoFromUrl(url: url)
    }
    
    func topCompanyClicked(compId: String) {
        self.delegate?.showTopCompanyDetails(compId: compId)
    }
}

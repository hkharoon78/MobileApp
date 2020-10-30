//
//  MICreateJobAlertTableView.swift
//  MonsteriOS
//
//  Created by ishteyaque on 18/01/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

protocol CreateJobAlertListDelegate {
    func navigateToMaster(title:String?)
}
extension CreateJobAlertListDelegate{
    func navigateToMaster(title:String?){}
}

protocol CreateJobAlertDelegate{
    func jobAlertEditedAndCreated()
    func manageJobAlert()
}
extension CreateJobAlertDelegate{
    func jobAlertEditedAndCreated(){}
    func manageJobAlert(){}
}
enum MasterDataTitleEnum:String{
    case keywords=""
}

class MICreateJobAlertTableView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var jobAlertType:CreateJobAlertType = .create {
        didSet{
            switch self.jobAlertType {
            case .create,.fromSRP:
                headerView.titleLabel.text=StoryboardConstant.titleText
                //headerView.imageIcon.image=#imageLiteral(resourceName: "createAlert")
                headerView.imgWidthConstriant.constant = 0
                headerView.lblLeadingConstraint.constant = 0
                tableView.tableHeaderView=headerView
                tableView.tableHeaderView?.backgroundColor=AppTheme.viewBackgroundColor
            case .edit,.fromSRPReplace:
                tableView.tableHeaderView=UIView(frame: .zero)
                //break
            }
        }
    }
    var modelData:JobAlertModel?
    var delegate:CreateJobAlertListDelegate?
    
    lazy var headerView:MICreateHeaderView={
        let passwordView=MICreateHeaderView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 80))
        passwordView.backgroundColor=AppTheme.viewBackgroundColor
        return passwordView
    }()
    
    var errorData : (index:Int,errorMessage:String) = (-1,"") {
        didSet {
            if (errorData.index > -1) {
                self.tableView.reloadData()
                self.tableView.scrollToRow(at: IndexPath(row: errorData.index, section: 0), at: .top, animated: false)
            }
        }
    }
    
    var textFieldPlaceHolderArray=[String]()
    var textFieldTitleHolderArray=[String]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
        configure()
    }
    
    
    func configure(){
        self.textFieldTitleHolderArray=[StoryboardConstant.keywords,StoryboardConstant.experience,StoryboardConstant.desiredLocation,StoryboardConstant.industry,StoryboardConstant.funcionalArea,StoryboardConstant.role,StoryboardConstant.alertName,StoryboardConstant.emailId,StoryboardConstant.frequency]
        self.textFieldPlaceHolderArray=[StoryboardConstant.keywordsPlaceHolder,StoryboardConstant.experiencePlaceHolder,StoryboardConstant.desiredLocationPlaceHolder,StoryboardConstant.industryPlaceHolder,StoryboardConstant.funcionalAreaPlaceHolder,StoryboardConstant.rolePlaceHolder,StoryboardConstant.alertNamePlaceHolder,StoryboardConstant.emailId,StoryboardConstant.frequency]
        
        let site = AppDelegate.instance.site
        
        if site?.defaultCountryDetails.isoCode == "IN"{
            self.textFieldTitleHolderArray.removeLast()
            self.textFieldPlaceHolderArray.removeLast()
        }
        
        tableView.register(UINib(nibName:String(describing: MICreateAlertTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MICreateAlertTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIFrequencyTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIFrequencyTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MITextFieldTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MITextFieldTableViewCell.self))
        // MIFrequencyTableViewCell
        
        tableView.register(UINib(nibName:String(describing: MITextViewTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MITextViewTableViewCell.self))
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.showsVerticalScrollIndicator=false
        tableView.showsHorizontalScrollIndicator=false
        tableView.backgroundColor = AppTheme.viewBackgroundColor
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView.keyboardDismissMode = .onDrag
        // tableView.separatorStyle = .singleLine
        tableView.tableFooterView=UIView(frame: .zero)
        tableView.tableFooterView?.backgroundColor = AppTheme.viewBackgroundColor
        tableView.bounces=true
        
    }
    
}

extension MICreateJobAlertTableView:UITableViewDelegate,UITableViewDataSource{
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textFieldTitleHolderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title=textFieldTitleHolderArray[indexPath.row]
      
        if title == StoryboardConstant.frequency{
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIFrequencyTableViewCell.self), for: indexPath) as? MIFrequencyTableViewCell else{return UITableViewCell()}
            cell.viewModel=FrequencyModel(title: self.modelData?.frequency, id: self.modelData?.frequencyId)
            return cell
        }
            
        else if title == StoryboardConstant.emailId || title==StoryboardConstant.alertName{
            let cell=tableView.dequeueReusableCell(withClass: MITextFieldTableViewCell.self, for: indexPath)
            
            if self.errorData.index == indexPath.row {
                cell.showError(with: self.errorData.errorMessage,animated: false)
            } else {
                cell.showError(with: "",animated: false)
            }
            cell.primaryTextField.isUserInteractionEnabled = true
            cell.primaryTextField.text = title==StoryboardConstant.alertName ? self.modelData?.alertName : self.modelData?.email

            if title == StoryboardConstant.emailId {
                if let email = self.modelData?.email, email.count > 0 {
                    cell.primaryTextField.isUserInteractionEnabled = false
                }
            }
            cell.primaryTextField.setRightViewForTextField()

            cell.titleLabel.text = title
            cell.secondryTextField.isHidden=true
            cell.primaryTextField.placeholder=self.textFieldPlaceHolderArray[indexPath.row]
            cell.primaryTextField.tag=indexPath.row
            cell.primaryTextField.delegate=self
            return cell
        } else{
            let cell=tableView.dequeueReusableCell(withClass: MITextViewTableViewCell.self, for: indexPath)
            if self.errorData.index == indexPath.row {
                cell.showError(with: self.errorData.errorMessage,animated: false)
            } else {
                cell.showError(with: "",animated: false)
            }
            cell.titleLabel.text = title
            cell.textView.placeholder = textFieldPlaceHolderArray[indexPath.row] as NSString
            cell.textView.isUserInteractionEnabled = false
            cell.textView.text = nil
           
            switch title{
            case MasterDataTitle.keywords.rawValue:
                cell.textView.text=self.modelData?.keywords
            case MasterDataTitle.funcionalArea.rawValue:
                cell.textView.text=self.modelData?.functionalArea
                cell.helpButton.isHidden=false
                cell.showPopUpCallBack={
                    //cell.helpButton.setImage(#imageLiteral(resourceName: "help"), for: .normal)
                    cell.showInfoPopup(infoMsg: "Select department you work in. For example, Finance, HR, Sales")
                }
            case MasterDataTitle.industry.rawValue:
                cell.textView.text=self.modelData?.industry
                cell.helpButton.isHidden=false
                
                cell.showPopUpCallBack={
                    //cell.helpButton.setImage(#imageLiteral(resourceName: "help"), for: .normal)
                    cell.showInfoPopup(infoMsg: "Select industry you work in. For example, IT, Telecom, BPO")
                }
                
                
            case MasterDataTitle.desiredLocation.rawValue:
                cell.textView.text=self.modelData?.desiredLocation
            case MasterDataTitle.experience.rawValue:
                if let expe = self.modelData?.experience{
                    if let expeInt=Int(expe){
                        if expeInt == 0 || expeInt == 1{
                            cell.textView.text=expe+" Year"
                        }else{
                            cell.textView.text=expe+" Years"
                        }
                    }else{
                        cell.textView.text = ""
                    }
                }
            case MasterDataTitle.role.rawValue:
                cell.textView.text=self.modelData?.role
                cell.helpButton.isHidden=false
                cell.showPopUpCallBack={
                    //cell.helpButton.setImage(#imageLiteral(resourceName: "help"), for: .normal)
                    cell.showInfoPopup(infoMsg: "Select your role work in. For example, Finance, HR, Sales")
                }
            case MasterDataTitle.frequency.rawValue:
                cell.textView.text=self.modelData?.frequency
            default:
                break
            }
            
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title=self.textFieldTitleHolderArray[indexPath.row]
        if title != StoryboardConstant.alertName && title != StoryboardConstant.emailId && title != StoryboardConstant.frequency{
            self.delegate?.navigateToMaster(title: title)
        }
    }
}

extension MICreateJobAlertTableView:UITextFieldDelegate,UITextViewDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let parentVc=self.parentViewController as? MICreateJobAlertViewController{
            UIView.animate(withDuration: 0.3) {
                parentVc.setMainViewFrame(originY: 0)
            }
        }
        let title=self.textFieldTitleHolderArray[textField.tag]
        if title == StoryboardConstant.alertName{
            self.modelData?.alertName = textField.text
        }else{
            self.modelData?.email=textField.text
        }
        self.errorData = (-1,"")
        
        //self.tableView.reloadData()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.errorData = (-1,"")
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let parent=self.parentViewController as? MICreateJobAlertViewController{
            parent.setMainViewFrame(originY: 0)
            let movingHeight = textField.movingHeightIn(view : parent.view)
            if movingHeight > 0 {
                UIView.animate(withDuration: 0.3) {
                    parent.setMainViewFrame(originY: -movingHeight)
                }
            }
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        //self.errorData = (-1,"")
        self.delegate?.navigateToMaster(title: self.textFieldTitleHolderArray[textView.tag])
        return false
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

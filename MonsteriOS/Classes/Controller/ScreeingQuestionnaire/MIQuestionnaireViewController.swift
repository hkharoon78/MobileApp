//
//  MIQuestionnaireViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 22/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIQuestionnaireViewController: MIBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var submitView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    
    var questionModels=[Questions]()
    var textFieldDic=[String:String]()
    var submitActionSuccess:(([[String:String]])->Void)?
    
    //MARK: View life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title=ControllerTitleConstant.qestionnaire
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)
    }

    func setUpUI(){
        
        tableView.register(UINib(nibName:String(describing: MIQuestionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIQuestionTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIQuestionnaireTopTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIQuestionnaireTopTableViewCell.self))
        tableView.register(UINib(nibName:String(describing: MIQuestRadioTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIQuestRadioTableViewCell.self))
       // MITitleValueCell
        tableView.register(UINib(nibName:String(describing: MIQuestionWithTextTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MIQuestionWithTextTableViewCell.self))
        
        tableView.delegate=self
        tableView.dataSource=self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .singleLine
        tableView.keyboardDismissMode = .onDrag
        tableView.tableFooterView=submitView
        submitButton.showPrimaryBtn()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back_bl"), style: .plain, target:self, action: #selector(MIWalkinVenueViewController.backButtonAction(_:)))
    }
    
    @objc func backButtonAction(_ sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        var param=[[String:String]]()
        
//        let textBox =  questionModels.filter({$0.type=="textbox"})
//        if textBox.count > 0 && (textBox[0].answer?.count == 0 || textBox[0].answer == nil){
//            self.showAlert(title: "", message: "Provide details for \(textBox[0].question ?? "Ques")")
//            return
//        }
        
        for item in questionModels{
            if item.answer == nil || item.answer?.count == 0{
                self.showAlert(title: "", message: "Please provide an answer to all the questions.")
                return
            }
        }
        for item in questionModels {
            if item.type == "textbox"{
                param.append(["questionNumber":item.questionNumber ?? "q\(item.indexpath)","answer" : item.answer ?? ""])
            }else if item.type == "radio"{
                param.append(["questionNumber":item.questionNumber ?? "q\(item.indexpath)","answer" : item.answer ?? ""])
            }
            else if let cell = self.tableView.cellForRow(at: IndexPath(row: item.indexpath + 1, section: 0))as?MIQuestionTableViewCell{
                param.append(["questionNumber":item.questionNumber ?? "q\(item.indexpath+1)", "answer":cell.choiceView.data.filter({$0.isSelected == true}).first?.title ?? item.answer ?? "yes"])
            }
        }
        
        if let action = self.submitActionSuccess{
            action(param)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:Table view delegate and data soure implementation

extension MIQuestionnaireViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionModels.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        //Showing Top cell with Title and section
        if indexPath.row == 0{
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIQuestionnaireTopTableViewCell.self), for: indexPath)as?MIQuestionnaireTopTableViewCell else {
                return UITableViewCell()
            }
            cell.screeningTitle.text="Screeing Questionnaire"
            cell.screeningDesc.text="Job required questionnaire submission before application."
            cell.screeningDesc.numberOfLines=0
            return cell
        }
        //Showing Cell with Text Field
        let questModel=self.questionModels[indexPath.row - 1]
        questModel.indexpath=indexPath.row
      
        if questModel.type == "textbox"{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MIQuestionWithTextTableViewCell.self), for: indexPath) as? MIQuestionWithTextTableViewCell else {
                return UITableViewCell()
            }
            cell.floatLebelTextView.delegate = self
            cell.floatLebelTextView.placeholder  =  "Enter details" as NSString
            cell.floatLebelTextView.text = questModel.answer ?? ""
            cell.floatLebelTextView.tag=indexPath.row
            cell.quesTitle="Ques \(indexPath.row): "
            cell.questDesc=questModel.question ?? ""
            
            return cell
        }
        
        if questModel.type == "radio"{
            guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIQuestRadioTableViewCell.self), for: indexPath)as?MIQuestRadioTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel=questModel
            return cell
        }
        //Shwoing Cell with Radio Button and Checkbox
        guard let cell=tableView.dequeueReusableCell(withIdentifier: String(describing: MIQuestionTableViewCell.self), for: indexPath)as?MIQuestionTableViewCell else {
            return UITableViewCell()
        }
        cell.quesTitle=questModel.questionNumber ?? "Ques\(indexPath.row): "
        cell.questDesc=questModel.question ?? ""
        cell.choiceView.selectionType = .multiple
        cell.choiceView.selectedImage=#imageLiteral(resourceName: "checkbox_clicked")
        cell.choiceView.unselectedImage=#imageLiteral(resourceName: "checkbox_default")
        cell.choiceView.data=[FilterModel(title:questModel.answer ?? "",isSelected:true,isUserSelectEnable:true),FilterModel(title:"No")]
       cell.choiceViewHeight.constant=cell.choiceView.height + 20
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
}

//MARK:TextField Delegate Method implementation
extension MIQuestionnaireViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        UIView.setAnimationsEnabled(false)
        self.tableView.beginUpdates()
        
        let fixedWidth: CGFloat = textView.frame.size.width
        if let cell = self.tableView.cellForRow(at: IndexPath(row: textView.tag, section: 0)) as?  MIQuestionWithTextTableViewCell {
            let newSize: CGSize = textView.sizeThatFits(CGSize(width:fixedWidth,height:.greatestFiniteMagnitude))
            cell.textViewHeight.constant = newSize.height
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
            
            
        }
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            self.setMainViewFrame(originY: 0)
            let movingHeight = textView.movingHeightIn(view : self.view) + 40
            //  + ((kScreenSize.height <= 667) ? 40 : 130)
            if movingHeight > 0 {
                UIView.animate(withDuration: 0.3) {
                    self.setMainViewFrame(originY: -movingHeight)
                }
            }
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
       self.questionModels[textView.tag - 1].answer = textView.text.withoutWhiteSpace()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                self.setMainViewFrame(originY: 0)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
  
}


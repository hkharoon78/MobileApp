//
//  MIWalkinVenueViewController.swift
//  MonsteriOS
//
//  Created by ishteyaque on 22/04/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit
import DropDown

class MIWalkinVenueViewController: MIBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            self.titleLabel.font=UIFont.customFont(type: .Medium, size: 16)
            self.titleLabel.textColor=AppTheme.textColor
        }
    }
    @IBOutlet weak var venueTextField: RightViewTextField!{
        didSet{
            self.venueTextField.font=UIFont.customFont(type: .Regular, size: 14)
            self.venueTextField.textColor=AppTheme.textColor
        }
    }
    @IBOutlet weak var dateTextField: RightViewTextField!{
        didSet{
            self.dateTextField.font=UIFont.customFont(type: .Regular, size: 14)
            self.dateTextField.textColor=AppTheme.textColor
        }
    }
    @IBOutlet weak var timeTextField: RightViewTextField!{
        didSet{
            self.timeTextField.font=UIFont.customFont(type: .Regular, size: 14)
            self.timeTextField.textColor=AppTheme.textColor
        }
    }
    let venueDropDown=DropDown()
    let dateDropDown=DropDown()
    let timeDropDown=DropDown()
    var walkInVenueArray=[WalkInSchedule]()
    var dateFilterValueArray=[WalkInSchedule]()
    var submitActionSuccess:(([String:Any])->Void)?
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel1: UILabel!
    @IBOutlet weak var errorLabel2: UILabel!
    @IBOutlet weak var errorLabel3: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.titleLabel.text="Choose Venue, Interview Date & Times Slot."
        self.venueTextField.placeholder="Venue"
        self.dateTextField.placeholder="Date"
        self.timeTextField.placeholder="Time"
        
        self.configureDropDown()
        self.configureDropDown(dropDown: dateDropDown)
        self.configureDropDown(dropDown: timeDropDown)
        
        venueDropDown.direction = .any
        venueDropDown.dismissMode = .automatic
        venueDropDown.selectionBackgroundColor = .white
        venueDropDown.separatorColor = .lightGray
        venueDropDown.textFont=UIFont.customFont(type: .Regular, size: 14)
        venueDropDown.backgroundColor = .white
        venueDropDown.textColor=AppTheme.textColor
        
        venueTextField.delegate=self
        timeTextField.delegate=self
        dateTextField.delegate=self
        
        let tapGest=UITapGestureRecognizer(target: self, action: #selector(MIWalkinVenueViewController.venueDropDownDhow(_:)))
        tapGest.numberOfTapsRequired=1
        venueTextField.addGestureRecognizer(tapGest)
        let dateGest=UITapGestureRecognizer(target: self, action: #selector(MIWalkinVenueViewController.dateDropDownDhow(_:)))
        dateGest.numberOfTapsRequired=1
        dateTextField.addGestureRecognizer(dateGest)
        let timeGest=UITapGestureRecognizer(target: self, action: #selector(MIWalkinVenueViewController.timeDropDownDhow(_:)))
        timeGest.numberOfTapsRequired=1
        timeTextField.addGestureRecognizer(timeGest)
        
        self.submitButton.setTitle("Submit", for: .normal)
        self.submitButton.showPrimaryBtn()
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(image: #imageLiteral(resourceName: "back_bl"), style: .plain, target:self, action: #selector(MIWalkinVenueViewController.backButtonAction(_:)))
        
        venueTextField.setRightViewForTextField("bottom_direction_arrow")
        dateTextField.setRightViewForTextField("bottom_direction_arrow")
        timeTextField.setRightViewForTextField("bottom_direction_arrow")
        
        venueTextField.roundCorner(1, borderColor: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), rad: 5)
        dateTextField.roundCorner(1, borderColor: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), rad: 5)
        timeTextField.roundCorner(1, borderColor: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1), rad: 5)
    }
    
    @objc func backButtonAction(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title="Venue Details"
        JobSeekerSingleton.sharedInstance.addScreenNameBasedOnController(vc: self)

    }
    
    @objc func venueDropDownDhow(_ sender:UITapGestureRecognizer){
        self.selectTF(venueTextField)
        
        let uniqueVenue=self.walkInVenueArray.filter({$0.apply ?? 0 < $0.maxApply ?? 0}).unique(map: {$0.venue})
        self.venueDropDown.dataSource=uniqueVenue.map({$0.venueAddress ?? ""})
        self.venueDropDown.show()
    }
    
    @objc func dateDropDownDhow(_ sender:UITapGestureRecognizer){
        self.selectTF(dateTextField)
        
        self.dateFilterValueArray = self.dateFilterValueArray.sorted(by:{ $0.scheduleDateSort?.compare($1.scheduleDateSort ?? Date()) == ComparisonResult.orderedAscending })
        self.dateDropDown.dataSource = self.dateFilterValueArray.map({$0.scheduleDate ?? ""})
        self.dateDropDown.show()
    }
    
    @objc func timeDropDownDhow(_ sender:UITapGestureRecognizer){
        self.selectTF(timeTextField)
        
        self.timeDropDown.show()
    }
    
    func getDateArray(startTime:String,endTime:String)->[String]{
        var intervalsContainer = [String]()
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat="h:mm a"
        dateFormatter.locale=Locale(identifier: "en_US_POSIX")
        guard let startDate = dateFormatter.date(from: startTime) else {return intervalsContainer}
        guard let endDate = dateFormatter.date(from: endTime) else {return intervalsContainer}
        var intervalDate = startDate;
        var dateComponentshourMin = DateComponents()
        dateComponentshourMin.hour = 1
        let calendar = Calendar.current
        intervalsContainer.append(dateFormatter.string(from: startDate))
        while(endDate.compare(intervalDate) == ComparisonResult.orderedDescending) {
            guard let finalDate=calendar.date(byAdding: dateComponentshourMin, to: intervalDate) else {continue}
            intervalsContainer.append(dateFormatter.string(from: finalDate))
            intervalDate=finalDate
            
        }
        return intervalsContainer
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.venueDropDown.anchorView=venueTextField
        self.venueDropDown.bottomOffset = CGPoint(x: 0, y:((self.venueDropDown.anchorView?.plainView.bounds.height)!))
        self.venueDropDown.topOffset = CGPoint(x: 0, y:-((self.venueDropDown.anchorView?.plainView.bounds.height)!))
        
        self.dateDropDown.anchorView=dateTextField
        self.dateDropDown.bottomOffset = CGPoint(x: 0, y:((self.dateDropDown.anchorView?.plainView.bounds.height)!))
        self.dateDropDown.topOffset = CGPoint(x: 0, y:-((self.dateDropDown.anchorView?.plainView.bounds.height)!))
        
        self.timeDropDown.anchorView=timeTextField
        self.timeDropDown.bottomOffset = CGPoint(x: 0, y:((self.timeDropDown.anchorView?.plainView.bounds.height)!))
        self.timeDropDown.topOffset = CGPoint(x: 0, y:-((self.timeDropDown.anchorView?.plainView.bounds.height)!))
    }
    
    func configureDropDown(){
        venueDropDown.selectionAction = {  (index: Int, item: String) in
            self.deselectTF(self.venueTextField)
            self.venueTextField.text=item
            self.dateFilterValueArray = self.walkInVenueArray.filter({ $0.venueAddress == item && $0.apply ?? 0 < $0.maxApply ?? 0 && $0.scheduleDateSort ?? Date() >= self.getDateWithOutTime()}).unique(map: { $0.scheduleDate })
            self.dateTextField.text=nil
            self.timeTextField.text=nil
        }
        dateDropDown.selectionAction = {  (index: Int, item: String) in
            self.deselectTF(self.dateTextField)
            self.dateTextField.text=item
            let timeSlot=self.walkInVenueArray.filter({$0.scheduleDate == item  && $0.venueAddress == self.venueTextField.text ?? ""})
//            let filterApplyMax = timeSlot.filter({$0.apply ?? 0 < $0.maxApply ?? 0})
//            let fromtime = filterApplyMax.map({($0.fromTime ?? "8:00 AM") + " - " + ($0.toTime ?? "8:00 PM")})
            self.timeDropDown.dataSource = timeSlot.filter({$0.apply ?? 0 < $0.maxApply ?? 0}).map({($0.fromTime ?? "8:00 AM") + " - " + ($0.toTime ?? "8:00 PM")})
            self.timeTextField.text=nil
        }
        timeDropDown.selectionAction = {  (index: Int, item: String) in
            self.deselectTF(self.timeTextField)
            self.timeTextField.text=item
        }
        venueDropDown.cellConfiguration = {(_, item) in
            return "\(item)"
        }
        timeDropDown.cellConfiguration = {(_, item) in
            return "\(item)"
        }
        dateDropDown.cellConfiguration = {(_, item) in
            return "\(item)"
        }
    }
    func getDateWithOutTime()->Date{
        let dateFormatter=DateFormatter()
        dateFormatter.dateFormat = PersonalTitleConstant.dateFormatePattern
        let dateString=dateFormatter.string(from: Date())
        return dateFormatter.date(from: dateString) ?? Date()
    }
    
    @IBAction func submitButtonAction(_ sender: Any) {
        
        if self.venueTextField.text?.count==0 {
            self.showError(with: "Please select Venue", on: venueTextField)
            
        } else if self.dateTextField.text?.count==0 {
            self.showError(with: "Please select Date", on: dateTextField)
            
        } else if self.timeTextField.text?.count==0 {
            self.showError(with: "Please select Time", on: timeTextField)
            
        } else {
            if let action=self.submitActionSuccess{
                var data = [String:Any]()
                data["venueAddress"] = self.venueTextField.text ?? ""
                data["timeSlot"] = self.timeTextField.text ?? ""
                data["walkinDate"] = self.dateTextField?.text ?? ""
                data["venue"] = self.walkInVenueArray.filter({$0.venueAddress==self.venueTextField.text}).first?.venue ?? ""
                
             /*   ["venueAddress":self.venueTextField.text ?? "",
                 "timeSlot":self.timeTextField.text ?? "",
                 "walkinDate":self.dateTextField?.text ?? "",
                 "venue":self.walkInVenueArray.filter({$0.venueAddress==self.venueTextField.text}).first?.venue ?? ""]*/
                
                action(data)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}


extension MIWalkinVenueViewController {
    
    func showError(with message: String, on textField: UITextField) {
        textField.layer.borderColor = Color.errorColor.cgColor
        
        switch textField {
        case venueTextField:
            errorLabel1.textColor = Color.errorColor
            errorLabel1.text = message
            
        case dateTextField:
            errorLabel2.textColor = Color.errorColor
            errorLabel2.text = message
            
        case timeTextField:
            errorLabel3.textColor = Color.errorColor
            errorLabel3.text = message
            
        default: break
        }
        
        if message.count == 0 {
            self.deselectTF(textField)
        }
    }
    
    func selectTF(_ textField: UITextField) {
        textField.layer.borderColor = AppTheme.defaltBlueColor.cgColor
        
        errorLabel1.text = ""
        errorLabel2.text = ""
        errorLabel3.text = ""
    }
    
    func deselectTF(_ textField: UITextField) {
        textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        errorLabel1.text = ""
        errorLabel2.text = ""
        errorLabel3.text = ""
    }
    
}




extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
            
            
        }
        
        return arrayOrdered
    }
}

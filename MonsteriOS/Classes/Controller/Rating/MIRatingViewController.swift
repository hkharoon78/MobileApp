//
//  MIRatingViewController.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 01/06/20.
//  Copyright © 2020 Monster. All rights reserved.
//

import UIKit
import TagListView
import BottomPopup

enum RatingFlow {
    case FromJobApply
    case FromJobShare
    case FromAppShare
}

var ratingFlowFrom: RatingFlow = .FromJobApply

class MIRatingViewController: BottomPopupViewController {

    @IBOutlet var ratingButton: [UIButton]!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var improveLabel: UILabel!
    @IBOutlet weak var tagView: TagListView!
    @IBOutlet weak var placeholderLabel: RSKPlaceholderTextView!
    @IBOutlet weak var submitButton: AKLoadingButton!
       
    
    fileprivate var getEventCategory: String {
        let isRated = ratingButton.filter({ $0.isSelected }).count > 0
        return isRated ? "App_Rating_Feedback" : "App_Rating_Popup"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tagView.textFont = UIFont.systemFont(ofSize: 14)
        tagView.addTags(CommonClass.ratingFeedbacks)
        tagView.delegate = self
        
        tagView.isHidden        = true
        improveLabel.isHidden   = true
        submitButton.isHidden   = true
        placeholderLabel.isHidden = true
        
        placeholderLabel.delegate = self
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        self.registerObservers()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        NotificationCenter.default.removeObserver(self)
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupHeight(to: self.getHeight())
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func getPopupHeight() -> CGFloat {
        return 500
    }
   
    override func getPopupCornerRadius() -> CGFloat {
        return 15
    }
       
    override func shouldPopupDismissInteractivelty() -> Bool {
        return false
    }

    override func getPopupPresentDuration() -> Double {
        return 0.2
    }
    
    private func getHeight() -> CGFloat {
        var actualHeight = UIScreen.width * 1.12
//            headerImg.height //Image
//        actualHeight += 30  //Space
//        actualHeight += 110 //Rate View
//       // actualHeight += stackView.height //Rate Stars
//        actualHeight += 65

        let isRated = ratingButton.filter({ $0.isSelected }).count > 0
        var hiddenItems = tagView.intrinsicContentSize.height //tags
        hiddenItems += 80 // text view
        hiddenItems += 20 // Improve Label
        hiddenItems += 30 // Stack Spacing
        //hiddenItems += 20 // Additional

        if isRated {
            actualHeight = actualHeight+hiddenItems
        }
        return actualHeight
    }
    
    @IBAction func ratingButtonAction(_ sender: UIButton) {
        CommonClass.googleEventTrcking(self.getEventCategory, action: "Star_Rating", label: sender.tag.stringValue)

        for btn in ratingButton {
            if btn.tag <= sender.tag {
                btn.isSelected = true
            } else {
                btn.isSelected = false
            }
        }
        
        if sender.tag >= CommonClass.starRatingValue {
            self.dismiss(animated: false) {
                MIApiManager.hitReportBug("Rating",
                                          name: AppDelegate.instance.userInfo.fullName,
                                          email: AppDelegate.instance.userInfo.primaryEmail,
                                          mobileNumber: AppDelegate.instance.userInfo.mobileNumber,
                                          details: self.placeholderLabel.text,
                                          rating: sender.tag)
                { (success, response, error, code) in
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                    let vc = MIAppStoreRatingVC.instantiate(fromAppStoryboard: .Rating)
                    vc.rating = sender.tag
                    self.tabbarController?.present(vc, animated: true, completion: nil)
                }
                
                self.saveRatingState(sender.tag)
            }
        } else {
            tagView.isHidden        = false
            improveLabel.isHidden   = false
            submitButton.isHidden   = false
            placeholderLabel.isHidden = false
            
            self.setupHeight(to:  self.getHeight())
        }
        
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        self.saveRatingState(5)

        let rating = ratingButton.filter({ $0.isSelected }).last?.tag ?? 0
        CommonClass.googleEventTrcking(self.getEventCategory, action: "Close", label: rating.stringValue)
      
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitButtonAction(_ sender: AKLoadingButton) {
        let selected = self.tagView.selectedTags().map({ $0.currentTitle ?? "" })
       
        var labels = selected
        labels.append(self.placeholderLabel.text)
        CommonClass.googleEventTrcking(self.getEventCategory, action: "Submit", label: labels.joined(separator: ", "))

        MIApiManager.hitReportBug("Rating",
                                  name: AppDelegate.instance.userInfo.fullName,
                                  email: AppDelegate.instance.userInfo.primaryEmail,
                                  mobileNumber: AppDelegate.instance.userInfo.mobileNumber,
                                  details: self.placeholderLabel.text,
                                  rating: sender.tag,
                                  tags: selected)
        { (success, response, error, code) in
        }
        
        self.dismiss(animated: false) {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
                self.presentThankYou()
            }
        }
    }
    
    private func presentThankYou() {
        let rating = ratingButton.filter({ $0.isSelected }).last?.tag ?? 0
        self.saveRatingState(rating)
        
        let vc = MIThankYouRatingVC.instantiate(fromAppStoryboard: .Rating)
        self.tabbarController?.present(vc, animated: true, completion: nil)
    }

    
    private func saveRatingState(_ rating: Int) {

        switch ratingFlowFrom {
        case .FromJobApply:
            AppUserDefaults.save(value: Date(), forKey: .JobApplyOnDate)
            AppUserDefaults.save(value: rating, forKey: .JobApplyRating)

        case .FromJobShare:
            AppUserDefaults.save(value: Date(), forKey: .JobSharedOnDate)
            AppUserDefaults.save(value: rating, forKey: .JobShareRating)

        case .FromAppShare:
            AppUserDefaults.save(value: Date(), forKey: .AppSharedOnDate)
            AppUserDefaults.save(value: rating, forKey: .AppShareRating)

        }
    }
}


extension MIRatingViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        tagView.isSelected = !tagView.isSelected
        CommonClass.googleEventTrcking(self.getEventCategory, action: "Improve_Actions", label: title)
    }
}
//
//extension MIRatingViewController {
//
//    func registerObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//
//    @objc func keyboardWillAppear(notification: Notification){
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardRectangle = keyboardFrame.cgRectValue
//            let keyboardHeight = keyboardRectangle.height
//
//            guard self.view.transform == .identity else { return }
//            let popupBottomHeight = self.view.height //- self.popupView.maxY
//            self.view.transform = CGAffineTransform(translationX: 0, y: popupBottomHeight-keyboardHeight-20)
//        }
//    }
//
//    @objc func keyboardWillHide(notification: Notification){
//        self.view.transform = .identity
//    }
//}

extension MIRatingViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        let points = textView.convert(CGPoint.zero, to: self.view)
        let middle = self.view.bounds.size.height/2 - 20
        if (points.y >= middle) {

            var frame = self.view.frame
            frame.origin.y = middle - points.y
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = frame
            })
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        var returnframe = self.view.frame
        returnframe.origin.y = UIScreen.height-self.view.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = returnframe
        })
    }

}

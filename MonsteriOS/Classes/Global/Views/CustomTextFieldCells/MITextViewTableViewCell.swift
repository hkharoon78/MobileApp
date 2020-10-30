//
//  MITextViewTableViewCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 13/09/19.
//  Copyright © 2019 Monster. All rights reserved.
//

import UIKit

class MITextViewTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tvContainerView: UIView!
    @IBOutlet weak var textViewHC: NSLayoutConstraint!
    @IBOutlet weak var textView: RSKPlaceholderTextView! {
        didSet {
            self.showTextCount(showCounterLabel)
        }
    }
    @IBOutlet weak var tvContainerViewHtConstraint: NSLayoutConstraint!

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var accessoryImageView: UIImageView!
    var maxCharaterCount = 250
    var showCounterLabel: Bool = false {
        didSet {
            self.showTextCount(showCounterLabel)
        }
    }
    
    var showPopUpCallBack : (()->Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        
        self.helpButton.isHidden = true
        
        NotificationCenter.default.addObserver(forName: UITextView.textDidBeginEditingNotification, object: self.textView, queue: .main) { [weak self] (notification) in
            self?.selectTV(notification.object as? UITextView)
        }
        NotificationCenter.default.addObserver(forName: UITextView.textDidEndEditingNotification, object: self.textView, queue: .main) { [weak self] (notification) in
            self?.deSelectTV(notification.object as? UITextView)
        }
        NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: self.textView, queue: .main) { [weak self] (notification) in
            guard let `self` = self else { return }
            self.showTextCount(self.showCounterLabel)
        }
        
        self.titleLabel.textColor = AppTheme.appGreyColor
        self.errorLabel.font = UIFont.customFont(type: .Regular, size: 12)
        textView.isScrollEnabled = false
       // textView.sizeToFit()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        
    }
    
    @IBAction func helpButtonAction(_ btn: UIButton) {
        self.helpButton.setImage(#imageLiteral(resourceName: "help"), for: .normal)
        self.showPopUpCallBack?()
    }
    
    private func showTextCount(_ show: Bool) {
        if show {
            self.textCountLabel.text = (self.textView.text?.count.stringValue ?? "") + "/\(maxCharaterCount)"
        } else {
            self.textCountLabel.text = ""
        }
    }
    
    func showInfoPopup(infoMsg:String) {
        
        let controller = MIInfoPopOverController()
        controller.delegate = self
        controller.message = infoMsg
        controller.preferredContentSize = CGSize(width: self.bounds.size.width, height: 100)
        
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        //presentationController.delegate = self
        
        presentationController.sourceView = self.helpButton
        presentationController.sourceRect = self.contentView.bounds
        presentationController.permittedArrowDirections = [.down, .up]
        
        self.superview?.parentViewController?.present(controller, animated: true)
    }
    
    func showError(with message: String, animated: Bool = true) {

        tvContainerView.layer.borderColor = Color.errorColor.cgColor
        errorLabel.textColor = Color.errorColor
        
        if animated { (self.superview as? UITableView)?.beginUpdates() }
        errorLabel.text = message
        if animated { (self.superview as? UITableView)?.endUpdates()  }
        if message.count == 0 {
            self.deSelectTV(textView)
        }
    }
    
    func selectTV(_ textView: UITextView?) {
        tvContainerView?.layer.borderColor = AppTheme.defaltBlueColor.cgColor

        (self.superview as? UITableView)?.beginUpdates()
        errorLabel.text = ""
        (self.superview as? UITableView)?.endUpdates()
    }
    
    func deSelectTV(_ textView: UITextView?) {
        tvContainerView?.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
    }
}


@objc extension MITextViewTableViewCell {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.selectTV(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.deSelectTV(textView)
    }

}

extension MITextViewTableViewCell: DismissPopOverControllerDelegate {
    
    func dismissInfoPopOverController() {
        self.helpButton.setImage(#imageLiteral(resourceName: "helpgray"), for: .normal)
    }
}



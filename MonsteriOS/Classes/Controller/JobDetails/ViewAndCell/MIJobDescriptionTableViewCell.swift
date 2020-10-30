//
//  MIJobDescriptionTableViewCell.swift
//  MonsteriOS
//
//  Created by ishteyaque on 16/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIJobDescriptionTableViewCell: UITableViewCell {

    //MARK:Outlets And Variables
    @IBOutlet weak var descriptionLabel: UILabel!
    var moretitleData=""
    var descriptionTitle:String!{
        didSet{
            self.descriptionLabel.attributedText=self.descriptionTitle.htmlAttributed(using: UIFont.customFont(type: .Regular, size: 11), color: AppTheme.textColor)
            if self.descriptionLabel.calculateMaxLines() > 6{
                moreButton.isHidden=false
                moreButtonHeight.constant=30
                if isReadMore{
                    self.descriptionLabel.numberOfLines = 6
                    moreButton.setTitle("MORE", for: .normal)
                }else{
                    self.descriptionLabel.numberOfLines = 0
                    moreButton.setTitle("LESS", for: .normal)
                }
            }else{
                moreButton.isHidden=true
                moreButtonHeight.constant=0
                moreButtonTop.constant=0
            }

        }
    }
    var isReadMore:Bool!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var moreButtonHeight: NSLayoutConstraint!
    
    @IBOutlet weak var moreButtonTop: NSLayoutConstraint!
    var moreAction:(()->Void)?
    //MARK:View More Button Action
    @IBAction func moreButtonAction(_ sender: UIButton) {
        if let action=moreAction{
            action()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isReadMore=true
        self.descriptionLabel.numberOfLines = 0
        moreButton.isHidden=true
        moreButtonHeight.constant=0
        moreButtonTop.constant=0
        moreButton.setTitleColor(AppTheme.defaltBlueColor, for: .normal)
    }
    
}
extension String {
    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()
        
        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }
        
        return results.map { String($0) }
    }
}


extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
extension String {

    func htmlAttributed(using font: UIFont, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(font.pointSize)pt !important;" +
                "color: #\(color.hexString!) !important;" +
                "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

extension UIColor {
    var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
}

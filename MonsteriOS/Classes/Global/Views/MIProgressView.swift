//
//  MIProgressView.swift
//  MonsteriOS
//
//  Created by Monster on 31/10/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit

class MIProgressView: UIView {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet var segementTitle_Lbl: [UILabel]!

    class var header:MIProgressView {
        get {
            return UINib(nibName: "MIProgressView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MIProgressView
        }
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
    }
    func progressViewStatus(num:Int, completed:Int,current:Int) {
        //topView.backgroundColor = .red
        for subView in topView.subviews {
            subView.removeFromSuperview()
        }
        self.backgroundColor = UIColor.init(hex: "e6ecf0")
        _=self.segementTitle_Lbl.map({$0.isHidden = true})
        let aspectRatioCircleView = Int(self.topView.frame.size.height)
        let lineSize = Int((kScreenSize.size.width-90)/CGFloat(num-1)) - aspectRatioCircleView/2
        
        let midFrame = Int(self.topView.frame.size.height/2) - 1
        for index in 0..<num {
            let circleView = UIView(frame: CGRect(x: index * lineSize , y: 0, width: aspectRatioCircleView, height: aspectRatioCircleView))
            
//            if index != 0 {
//                circleView.frame.origin.x = CGFloat(index * lineSize - aspectRatioCircleView)
//            }
            
            let lineView = UIView(frame: CGRect(x:  (Int(circleView.frame.maxX))+20 , y: midFrame, width: lineSize-50, height: 2))
            
            if num == 2 {
                self.segementTitle_Lbl[0].text = " Education"
            }else{
                self.segementTitle_Lbl[0].text = "Work Experience"
                self.segementTitle_Lbl[1].text = "  Education"
                self.segementTitle_Lbl[1].isHidden = false

            }
            self.segementTitle_Lbl[0].isHidden = false
            self.segementTitle_Lbl[2].text = " Job Preferences"
            self.segementTitle_Lbl[2].isHidden = false

            if index<completed {
                self.segementTitle_Lbl[index].font = UIFont.customFont(type: .Medium, size: 8)
                self.segementTitle_Lbl[index].textColor = UIColor.black
                self.segementTitle_Lbl[index].text = ""
                lineView.backgroundColor = Color.blueThemeColor
                circleView.circular(3, borderColor: Color.blueThemeColor)
                circleView.backgroundColor = Color.blueThemeColor
                let imgView = UIImageView(frame: CGRect(x: 3, y: 3, width: circleView.frame.size.width - 6, height: circleView.frame.size.height - 6))
                imgView.image = UIImage(named: "right_tick_white")
                imgView.contentMode = .scaleAspectFit
              //  circleView.addSubview(imgView)
                
            } else if index == current {
                self.segementTitle_Lbl[index].font = UIFont.customFont(type: .Medium, size: 8)
                self.segementTitle_Lbl[index].textColor = UIColor.black
                lineView.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
                circleView.circular(3, borderColor: Color.blueThemeColor)
                circleView.backgroundColor = .white
                let imgView = UIImageView(frame: CGRect(x: 3, y: 3, width: circleView.frame.size.width - 6, height: circleView.frame.size.height - 6))
                imgView.image = UIImage(named: "right_tick_white")
                imgView.contentMode = .scaleAspectFit

            } else {
                if num == 2 {
                    self.segementTitle_Lbl[2].font = UIFont.customFont(type: .Regular, size: 8)
                    self.segementTitle_Lbl[2].textColor = UIColor.lightGray
                }
                self.segementTitle_Lbl[index].font = UIFont.customFont(type: .Regular, size: 8)
                self.segementTitle_Lbl[index].textColor = UIColor.lightGray
                lineView.backgroundColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
                circleView.circular(3, borderColor: Color.colorLightGrey)
                circleView.backgroundColor = .white
               // lineView.backgroundColor   = Color.blueThemeColor
               // circleView.circular(0, borderColor: nil)
//                if index == completed {
//                    circleView.backgroundColor = UIColor.white
//                    circleView.circular(3, borderColor: Color.colorLightDefault)
//                }
            }
            
            if index != (num-1) {
                topView.addSubview(lineView)
                topView.addSubview(circleView)
            } else {
                topView.addSubview(circleView)
            }
            
        }
    }
}

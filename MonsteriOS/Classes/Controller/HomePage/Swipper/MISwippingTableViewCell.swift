//
//  MISwippingTableViewCell.swift
//  MonsteriOS
//
//  Created by Anupam Katiyar on 27/11/18.
//  Copyright © 2018 Monster. All rights reserved.
//

import UIKit
import Koloda

class MISwippingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var swipeView: KolodaView!
    
    var jobListingModel: JoblistingBaseModel? {
        didSet {
           // swipeView.currentCardIndex=0
            swipeView.reloadData()
            
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
    var isReload=false{
        didSet{
            if  isReload && cardCount == 0{
                cardCount=1
            }
        }
    }
    var cardCount=0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        swipeView.dataSource = self
        swipeView.delegate = self
        
        
        self.selectionStyle = .none
    }
    var swipeCardSelection: ((Int,Bool)->Void)?
    var applyCardSelection:((Int)->Void)?
     var skipCardSelection:((Int)->Void)?
    var reloadNewCard:(()->Void)?
    var editJobPreference:(()->Void)?
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        swipeCardSelection = nil
        applyCardSelection = nil
        skipCardSelection = nil
        reloadNewCard = nil
        jobListingModel=nil
        editJobPreference=nil
        
        
    }
    
    
}


extension MISwippingTableViewCell: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        // Call back After finished card
//        if isNoMoreAdd==false{
//            if let action=self.reloadNewCard {
//                action()
//            }
//        }
    }
    func kolodaPanFinished(_ koloda: KolodaView, card: DraggableCardView) {
        if self.jobListingModel?.data?.count ?? 0 > 0{
            if let swipeCard=koloda.viewForCard(at: koloda.currentCardIndex) as? MISwipableCardView{
                swipeCard.skipIcon.isHidden=true
                swipeCard.applyIcon.isHidden=true
            }
        }
    }
    func koloda(_ koloda: KolodaView, shouldSwipeCardAt index: Int, in direction: SwipeResultDirection) -> Bool {
        if cardCount == 1{
            if self.jobListingModel?.data == nil || index == self.jobListingModel?.data?.count{
                return false
            }
        }
        return true
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //Selection Action
        
        if self.jobListingModel?.data == nil || index == self.jobListingModel?.data?.count{
            self.swipeCardSelection?(index,true)
        }else{
            self.swipeCardSelection?(index,false)
        }
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if self.jobListingModel?.data?.count  == index+1{
            if isNoMoreAdd==false{
                if let action=self.reloadNewCard {
                    action()
                    //return
                }
            }
        }
        if direction == .right{
            
            if self.jobListingModel?.data?.count ?? 0 > index {
                self.applyCardSelection?(index)
            }
        }else if direction == .left{
            if let action=self.skipCardSelection{
                action(index)
            }
        }
      
       // printDebug(direction)
    }
    func koloda(_ koloda: KolodaView, draggedCardWithPercentage finishPercentage: CGFloat, in direction: SwipeResultDirection) {
        if self.jobListingModel?.data?.count ?? 0 > 0{
            if let swipeCard=koloda.viewForCard(at: koloda.currentCardIndex) as? MISwipableCardView{
                swipeCard.skipIcon.isHidden=true
                swipeCard.applyIcon.isHidden=true
                switch direction{
                case .topLeft:
                    print("finish Percentage \(finishPercentage)")
                    break
                    
                case .left:
                    if finishPercentage > 20.0{
                        swipeCard.applyIcon.isHidden=false
                    }else{
                        swipeCard.applyIcon.isHidden=true
                    }
                case .right:
                    if finishPercentage > 20.0{
                        swipeCard.skipIcon.isHidden=false
                    }else{
                        swipeCard.skipIcon.isHidden=true
                    }
                default :
                    break
                }
                
            }
        }
        print(direction)
        print(finishPercentage)
    }
    
    
}

//extension MISwippingTableViewCell {
//
//    func koloda(_ koloda: KolodaView, shouldDragCardAt index: Int) -> Bool {
//        return false
//    }
//
//}

// MARK: KolodaViewDataSource

extension MISwippingTableViewCell: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return (jobListingModel?.data?.count ?? 0) + cardCount
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        if self.jobListingModel?.data == nil || index == self.jobListingModel?.data?.count{
            let view=NoMoreJobsSwiperView(frame: koloda.frame)
            //view.frame=koloda.frame
            view.reloadViewFlag=isReload
            view.editPrefAction={[weak self] in
                if let action=self?.editJobPreference{
                    action()
                }
            }
//            if isReload{
//            view.noMoreTitle.text="Please Wait...."
//            view.subTitleLabel.text="Getting New Jobs....."
//            view.setPrefButton.isHidden=true
//            view.iconView.isHidden=true
//            }
            return view
        }
        let view = Bundle.main.loadNibNamed("MISwipableCardView", owner: self, options: nil)![0] as! MISwipableCardView
        view.showData(JoblistingCellModel(model: jobListingModel!.data![index]))
        return view
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return false
    }
}

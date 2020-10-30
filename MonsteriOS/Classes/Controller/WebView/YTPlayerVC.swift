//
//  YTPlayerVC.swift
//  Gadfly
//
//  Created by Anupam Katiyar on 04/03/18.
//  Copyright © 2018 Anupam Katiyar. All rights reserved.
//

import UIKit
import YouTubePlayer
// https://github.com/gilesvangruisen/Swift-YouTube-Player

var lastTime: Float?
var lastVideoID: String = ""

class YTPlayerVC: UIViewController, YouTubePlayerDelegate {

    @IBOutlet weak var playerView: YouTubePlayerView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var videoID: String?
    var playListID = ""
    private var nojobPopup  = MINoJobFoundPopupView.popup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Video"
        indicatorView.startAnimating()
        playerView.delegate = self
        
        playerView.playerVars = [
            "playsinline": "1",
            "controls": "1",
            "showinfo": "0"
            ] as [String: AnyObject]
        if let id = videoID {
            playerView.loadVideoID(id)
        } else {
            playerView.loadPlaylistID(playListID)
        }
        
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(image: #imageLiteral(resourceName: "back_bl"), style: .done, target: self, action:#selector(backButtonAction(_:)))
        
        if (!MIReachability.isConnectedToNetwork()){
            self.nojobPopup.show(ttl: ErrorAndValidationMsg.opps.rawValue, desc:ErrorAndValidationMsg.somethingWrong.rawValue,imgNm: "plugbase")
            self.nojobPopup.addFromTop(onView: self.view, topHeight: 180, onCompletion: nil)
        }
    }
    
    @objc func backButtonAction(_ sender:UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        indicatorView.stopAnimating()
        
        playerView.play()
        
        if videoID == lastVideoID {
            playerView.seekTo(lastTime ?? 0, seekAhead: true)
        }
    }
}


extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
}

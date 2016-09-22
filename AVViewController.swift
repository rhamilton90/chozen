//
//  AVViewController.swift
//  Chozen
//
//  Created by HamiltonMac on 9/16/16.
//  Copyright © 2016 HamiltonMac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class AVViewController: UIViewController {
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the video from the app bundle.
        let videoURL: NSURL = Bundle.main.url(forResource: "coffeeShop", withExtension: "mp4")! as NSURL
        
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        playerLayer.frame = view.bounds
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        
        //loop video
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(AVViewController.loopVideo),
                                                         name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                         object: nil)
    }
    
    func loopVideo() {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    
}

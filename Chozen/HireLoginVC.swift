//
//  HireLoginVC.swift
//  AppX
//
//  Created by HamiltonMac on 7/1/16.
//  Copyright © 2016 HamiltonMac. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class HireLoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var back_btn: UIButton!
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var submitTapped: CustomButton!
    
     var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        // Load the video from the app bundle.
        let videoURL: NSURL = Bundle.main.url(forResource: "coffeeShop2", withExtension: "mp4")! as NSURL
        
        player = AVPlayer(url: videoURL as URL)
        player?.actionAtItemEnd = .none
        player?.isMuted = false
        
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
                                               selector: #selector(HireLoginVC.loopVideo),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: nil)
        
    }
    
 
        func loopVideo() {
            player?.seek(to: kCMTimeZero)
            player?.play()
        }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTF {
            
            self.passwordTF.becomeFirstResponder()
            
        } else if textField == passwordTF {
            
            passwordTF.resignFirstResponder()
        }
        //self.view.endEditing(true)
        return false
    }
    
    
    @IBAction func onSumbitTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func onTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

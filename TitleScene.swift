//
//  TitleScene.swift
//  Take Cover
//
//  Created by Alexander Warren on 4/9/16.
//  Copyright © 2016 Alexander Warren. All rights reserved.
//

import SpriteKit
import AVFoundation

struct Cloud {
    static var playerString = "default"
    static var currency = 1000
    static var lockedForPlayers = [
        true,
        true,
        true,
        true,
        true,
        true,
        true
    ]
    static var lockedForThemes = [
        true,
        true,
        true
    ]
    static var sound = false
    static var playOrig:CGPoint = CGPoint(x: 0, y: 0)
    static var shopOrig:CGPoint = CGPoint(x: 0, y: 0)
    static var settOrig:CGPoint = CGPoint(x: 0, y: 0)
    static var buttonSize:CGSize = CGSize(width: 0, height: 0)
    static var disco = false
    static var onPlayerView = true
    static var onThemeView = false

}

class TitleScene: SKScene {
    
    var playButton = UIButton()//frame: CGRectMake(500, 350, 100, 100))
    var shopButton = UIButton()//frame: CGRectMake(200, 350, 100, 100))
    let settingsButton = UIButton()
    var titleMusicPlayer = AVAudioPlayer()
    var titleMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("TitleMusicv3", ofType: "mp3")!)
    var transitioning = false
    let viewCont = GameViewController()
    let currencyLabel = UILabel(frame: CGRectMake(400, 400, 200, 20))
    
    override func didMoveToView(view: SKView) {
        
        let background = SKSpriteNode()
        background.color = UIColor.whiteColor()
        background.size = self.frame.size
        background.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        background.zPosition = 0
        self.addChild(background)
        //print(self.frame.maxX, self.frame.minY)
        currencyLabel.text = String(Cloud.currency)
        currencyLabel.center = CGPointMake(self.view!.frame.maxX - 100, self.view!.frame.minY + 10)
        currencyLabel.font = currencyLabel.font.fontWithSize(20)
        self.view!.addSubview(currencyLabel)
        //print(currencyLabel)
        
        do {
            // Preperation
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch _ {
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch _ {
        }
        
        do {
            titleMusicPlayer = try AVAudioPlayer(contentsOfURL: titleMusic)
        } catch _{
        }
        
        if Cloud.sound {
            titleMusicPlayer.prepareToPlay()
            titleMusicPlayer.play()
            titleMusicPlayer.numberOfLoops = -1
        }
        
        playButton.setImage(UIImage(named: "playButton"), forState: .Normal)
        //playButton.center.x = view.center.x//playButton.center = CGPoint(x: background.frame.midX, y: background.frame.midY) //CGPoint(x: self.view!.frame.midX, y: 210)//x: 500, y: 350)
        //playButton.center.y = 210
        playButton.addTarget(self, action: #selector(TitleScene.play), forControlEvents: .TouchUpInside)
        playButton.frame.size.width = 100
        playButton.frame.size.height = 100
        
        playButton.center.x = self.view!.center.x //- 50//playButton.frame.size.width / 2
        playButton.center.y = 210
        view.addSubview(playButton)
        Cloud.buttonSize = playButton.frame.size

        //print(view.frame.midX)
        shopButton.setImage(UIImage(named: "ShopButton"), forState: .Normal)
        shopButton.frame.size.width = 100
        shopButton.frame.size.height = 100
        //shopButton.center = CGPoint(x: self.view!.center.x - 200, y: 210)//x: 500, y: 350)
        shopButton.center.x = self.view!.frame.midX - 200
        shopButton.center.y = 210
        shopButton.addTarget(self, action: #selector(TitleScene.shop), forControlEvents: .TouchUpInside)
        view.addSubview(shopButton)
        
        settingsButton.setImage(UIImage(named: "ShopButton"), forState: .Normal)
        //settingsButton.center = CGPoint(x: self.view!.frame.midX + 200, y: 210)
        settingsButton.frame.size = CGSize(width: 100, height: 100)
        settingsButton.center.x = self.view!.frame.midX + 200//.frame.center.x + 200
        settingsButton.center.y = 210
        settingsButton.addTarget(self, action: #selector(TitleScene.settings), forControlEvents: .TouchUpInside)
        self.view!.addSubview(settingsButton)
        
        //Cloud.playOrig = playButton.frame.origin
        Cloud.playOrig = playButton.center
        //Cloud.settOrig = settingsButton.frame.origin
        Cloud.settOrig = settingsButton.center
        //Cloud.shopOrig = shopButton.frame.origin
        Cloud.shopOrig = shopButton.center
    }
    
    func settings(){
        let skView = self.view! as SKView
        let scene = SettingsScene(fileNamed: "SettingsScene")
        scene!.scaleMode = .AspectFill
        removeAllFromSuperview()
        skView.presentScene(scene)

    }
    
    func play(){
        let skView = self.view! as SKView
        let scene = GameScene(fileNamed:"GameScene")
        scene!.scaleMode = .AspectFill
            currencyLabel.removeFromSuperview()
        UIView.animateWithDuration(1.0, animations: {
            self.transitioning = true
            self.playButton.alpha = 0.0
            self.shopButton.alpha = 0.0
            self.settingsButton.alpha = 0.0
            skView.presentScene(scene)
            //self.fadeVolumeAndPause()
            }, completion: { finshed in
                self.playButton.removeFromSuperview()
                self.shopButton.removeFromSuperview()
        })
        //UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
        //   self.playButton.alpha = 0.0
        //})
        //UIView.animateWithDuration(1.0, animations: {
        //   self.playButton.alpha = 0.0
        // }, completion: nil)
    }
    
    func shop(){
        let skView = self.view! as SKView
        let scene = ShopScene(fileNamed:"ShopScene")
        scene!.scaleMode = .AspectFill
        removeAllFromSuperview()
        skView.presentScene(scene)
    }
    
    func removeAllFromSuperview() {
        currencyLabel.removeFromSuperview()
        playButton.removeFromSuperview()
        shopButton.removeFromSuperview()
        settingsButton.removeFromSuperview()
    }
    
    func fadeOut(duration duration: NSTimeInterval = 1.0) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0.0
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //print(touches.first!.locationInView(self.view))
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
    
    func fadeVolumeAndPause(){
        if titleMusicPlayer.volume > 0.1 {
            titleMusicPlayer.volume = self.titleMusicPlayer.volume - 0.1
            
            let dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
            dispatch_after(dispatchTime, dispatch_get_main_queue(), {
                self.fadeVolumeAndPause()
            })
            
        } else {
            titleMusicPlayer.pause()
            titleMusicPlayer.volume = 1.0
        }
    }
    
}

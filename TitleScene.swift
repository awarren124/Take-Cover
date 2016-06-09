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
        false,
        true,
        true,
        true,
        true,
        true,
        true
    ]
    static var lockedForThemes = [
        false,
        true,
        true
    ]
    static var sound = false
    static var playOrig:CGPoint = CGPoint(x: 0, y: 0)
    static var shopOrig:CGPoint = CGPoint(x: 0, y: 0)
    static var settOrig:CGPoint = CGPoint(x: 0, y: 0)
    static var buttonSize:CGSize = CGSize(width: 0, height: 0)
    static var onPlayerView = true
    static var onThemeView = false
    static var themeString = "classic"
    static var backFromSettings = false
    static var backFromShop = false
    static var model = String()
    static var highScore = 0
}

class TitleScene: SKScene {
    
    var playButton = UIButton()
    var shopButton = UIButton()
    let settingsButton = UIButton()
    var titleMusicPlayer = AVAudioPlayer()
    var titleMusic = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("TitleMusicv3", ofType: "mp3")!)
    var transitioning = false
    let viewCont = GameViewController()
    let currencyLabel = UILabel(frame: CGRectMake(400, 400, 200, 20))
    var cornerImages = [UIImageView]()
    let cornerImageStrings = ["ul", "ur", "ll", "lr"]
    let backgroundImageView = UIImageView(image: UIImage(named: "Title Screen Graident"))
    
    override func didMoveToView(view: SKView) {
        backgroundImageView.frame = self.view!.frame
        if Cloud.backFromSettings || Cloud.backFromShop {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.view!.insertSubview(self.backgroundImageView, atIndex: 0)
            })
        }else{
            self.view!.addSubview(self.backgroundImageView)
        }
        let screenHeight = self.view!.frame.height
        switch screenHeight {
        case 375.0:
            //realRadius = CGFloat(M_PI_4) * 100
            Cloud.model = "iPhone 6"
            break
        case 320.0:
            Cloud.model = "iPhone 5"
            //realRadius = 90
            break
        case 414.0:
            Cloud.model = "iPhone 6+"
            //realRadius = 70
            break
        default:
            //realRadius = 50
            break
        }
        //if Cloud.backFromSettings || Cloud.backFromShop {
          //  currencyLabel.removeFromSuperview()
            //print("removing in Cloud.backFromSettings || Cloud.backFromShop")
        //}
//        background.color = UIColor.whiteColor()
//        background.texture = SKTexture(imageNamed: "Title Screen Graident")
//        background.size = self.frame.size
//        background.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
//        background.zPosition = 0
//        backgroundImage.frame = CGRectMake(self.view!.frame.midX, 100, 100, 100) //self.view!.frame
//        background.image = UIImage(named: "Title Screen Gradient")
//        self.view!.addSubview(backgroundImage)
        
        for imageName in cornerImageStrings {
            cornerImages.append(UIImageView(image: UIImage(named: imageName)))
        }
        
        for imageView in cornerImages {
            let thisIt = cornerImages.indexOf(imageView)
            switch cornerImageStrings[thisIt!] {
            case "ul":
                if Cloud.backFromSettings {
                    imageView.frame = CGRectMake(0 - self.view!.frame.maxX, 0, 100, 100)
                }else if Cloud.backFromShop {
                    imageView.frame = CGRectMake(0 + self.view!.frame.maxX, 0, 100, 100)
                }else{
                    imageView.frame = CGRectMake(0, 0, 100, 100)
                }
            case "ur":
                imageView.frame.size = CGSizeMake(100, 100)
                if Cloud.backFromSettings {
                    imageView.frame.origin = CGPointMake(((self.view?.frame.maxX)! - imageView.frame.size.width) - self.view!.frame.maxX, 0)
                }else if Cloud.backFromShop {
                    imageView.frame.origin = CGPointMake(((self.view?.frame.maxX)! - imageView.frame.size.width) + self.view!.frame.maxX, 0)
                }else{
                    imageView.frame.origin = CGPointMake((self.view?.frame.maxX)! - imageView.frame.size.width, 0)
                }
            case "ll":
                //MARK: FIX THIS
                imageView.frame.size = CGSizeMake(100, 100)
                if Cloud.backFromSettings {
                    imageView.frame.origin = CGPointMake(0 - self.view!.frame.maxX, self.view!.frame.maxY - imageView.frame.size.height)
                }else if Cloud.backFromShop{
                    imageView.frame.origin = CGPointMake(0 + self.view!.frame.maxX, self.view!.frame.maxY - imageView.frame.size.height)
                }
                else{
                    imageView.frame.origin = CGPointMake(0, self.view!.frame.maxY - imageView.frame.size.height)
                }
            case "lr":
                imageView.frame.size = CGSizeMake(100, 100)
                if Cloud.backFromSettings {
                    imageView.frame.origin = CGPointMake(((self.view?.frame.maxX)! - imageView.frame.size.width) - self.view!.frame.maxX , self.view!.frame.maxY - imageView.frame.size.height)
                }else if Cloud.backFromShop {
                    imageView.frame.origin = CGPointMake(((self.view?.frame.maxX)! - imageView.frame.size.width) + self.view!.frame.maxX , self.view!.frame.maxY - imageView.frame.size.height)
                }else{
                    imageView.frame.origin = CGPointMake((self.view?.frame.maxX)! - imageView.frame.size.width, self.view!.frame.maxY - imageView.frame.size.height)
                }
            default:
                break
            }
            self.view?.addSubview(imageView)
        }
        
        //self.addChild(background)
        currencyLabel.text = String(Cloud.currency)
        currencyLabel.frame.size = CGSize(width: 60, height: 15)
        currencyLabel.center = CGPointMake(self.view!.center.x + 100, self.view!.frame.minY + 10)
        currencyLabel.textAlignment = NSTextAlignment.Right
        currencyLabel.font = currencyLabel.font.fontWithSize(20)
        self.view!.addSubview(currencyLabel)
        if Cloud.sound {
            
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
            
            titleMusicPlayer.prepareToPlay()
            titleMusicPlayer.play()
            titleMusicPlayer.numberOfLoops = -1
        }
        
        playButton.setImage(UIImage(named: "playButton"), forState: .Normal)
        playButton.addTarget(self, action: #selector(TitleScene.play), forControlEvents: .TouchUpInside)
        playButton.frame.size.width = 100
        playButton.frame.size.height = 100
        if Cloud.backFromSettings {
            playButton.center = CGPointMake(self.view!.center.x - self.view!.frame.maxX, (self.view?.center.y)!)
        }else if Cloud.backFromShop {
            playButton.center = CGPointMake(self.view!.center.x + self.view!.frame.maxX, (self.view?.center.y)!)
        }else{
            playButton.center = self.view!.center
        }
        view.addSubview(playButton)
        Cloud.buttonSize = playButton.frame.size
        
        shopButton.setImage(UIImage(named: "ShopButton"), forState: .Normal)
        shopButton.frame.size.width = 100
        shopButton.frame.size.height = 100
        if Cloud.backFromSettings {
            shopButton.center = CGPointMake(self.view!.frame.midX - 200 - self.view!.frame.maxX, self.view!.center.y)
        }else if Cloud.backFromShop {
            shopButton.center = CGPointMake(self.view!.frame.midX - 200 + self.view!.frame.maxX, self.view!.center.y)
        }else{
            shopButton.center.x = self.view!.frame.midX - 200
            shopButton.center.y = self.view!.center.y
        }
        
        shopButton.addTarget(self, action: #selector(TitleScene.shop), forControlEvents: .TouchUpInside)
        view.addSubview(shopButton)
        
        settingsButton.setImage(UIImage(named: "ShopButton"), forState: .Normal)
        settingsButton.frame.size = CGSize(width: 100, height: 100)
        if  Cloud.backFromSettings {
            settingsButton.center = CGPointMake(self.view!.frame.midX + 200 - self.view!.frame.maxX, self.view!.center.y)
            currencyLabel.center.x -= self.view!.frame.maxX
        }else if Cloud.backFromShop{
            settingsButton.center = CGPointMake(self.view!.frame.midX + 200 + self.view!.frame.maxX, self.view!.center.y)
        }else{
            settingsButton.center.x = self.view!.frame.midX + 200
            settingsButton.center.y = self.view!.center.y
        }
        settingsButton.addTarget(self, action: #selector(TitleScene.settings), forControlEvents: .TouchUpInside)
        self.view!.addSubview(settingsButton)
        
        Cloud.playOrig = playButton.center
        Cloud.settOrig = settingsButton.center
        Cloud.shopOrig = shopButton.center
        if Cloud.backFromSettings {
            UIView.animateWithDuration(1, animations: {
                self.playButton.center.x += self.view!.frame.maxX
                self.shopButton.center.x += self.view!.frame.maxX
                self.settingsButton.center.x += self.view!.frame.maxX
                for corner in self.cornerImages {
                    corner.frame.origin.x += self.view!.frame.maxX
                }
                self.currencyLabel.center.x += self.view!.frame.maxX
            })
            Cloud.backFromSettings = false
        }else if Cloud.backFromShop{
            UIView.animateWithDuration(1, animations: {
                self.playButton.center.x -= self.view!.frame.maxX
                self.shopButton.center.x -= self.view!.frame.maxX
                self.settingsButton.center.x -= self.view!.frame.maxX
                for corner in self.cornerImages {
                    corner.frame.origin.x -= self.view!.frame.maxX
                }
            })
            Cloud.backFromShop = false
        }
    }
    
    func settings(){
        let skView = self.view! as SKView
        let scene = SettingsScene(fileNamed: "SettingsScene")
        scene!.scaleMode = .AspectFill
        UIView.animateWithDuration(1, animations: {
            self.currencyLabel.center.x -= self.view!.frame.maxX
            self.playButton.center.x -= self.view!.frame.maxX
            self.shopButton.center.x -= self.view!.frame.maxX
            self.settingsButton.center.x -= self.view!.frame.maxX
            for image in self.cornerImages {
                image.frame.origin.x -= self.view!.frame.maxX
            }
            }, completion: { finished in
                self.backgroundImageView.removeFromSuperview()

        })
        //currencyLabel.removeFromSuperview()
        skView.presentScene(scene)
        
    }
    
    func play(){
        let skView = self.view! as SKView
        let scene = GameScene(fileNamed:"GameScene")
        scene!.scaleMode = .AspectFill
        currencyLabel.removeFromSuperview()
        print("removing in play()")
//        background.runAction(SKAction.fadeAlphaTo(0.0, duration: 10))
        
        UIView.animateWithDuration(1.0, animations: {
            self.transitioning = true
            self.playButton.alpha = 0.0
            self.shopButton.alpha = 0.0
            self.settingsButton.alpha = 0.0
            self.backgroundImageView.alpha = 0.0
            
            for image in self.cornerImages {
                image.alpha = 0.0
            }
            skView.presentScene(scene)
            }, completion: { finshed in
                self.playButton.removeFromSuperview()
                self.shopButton.removeFromSuperview()
                self.settingsButton.removeFromSuperview()
                for image in self.cornerImages {
                    image.removeFromSuperview()
                }
        })
    }
    
    func shop(){
        let skView = self.view! as SKView
        let scene = ShopScene(fileNamed:"ShopScene")
        scene!.scaleMode = .AspectFill
        //removeAllFromSuperview()
        UIView.animateWithDuration(1, animations: {
            self.playButton.center.x += self.view!.frame.maxX
            self.shopButton.center.x += self.view!.frame.maxX
            self.settingsButton.center.x += self.view!.frame.maxX
            for corner in self.cornerImages {
                corner.frame.origin.x += self.view!.frame.maxX
            }
//            self.currencyLabel.center.x += self.view!.frame.maxX
            self.currencyLabel.removeFromSuperview()
            }, completion: { finished in
                self.backgroundImageView.removeFromSuperview()
         })/*
        UIView.animateWithDuration(1, animations: {
            self.playButton.center.x += self.view!.frame.maxX
            self.shopButton.center.x += self.view!.frame.maxX
            self.settingsButton.center.x += self.view!.frame.maxX
            for corner in self.cornerImages {
                corner.frame.origin.x += self.view!.frame.maxX
            }
            }, completion: { finished in
                self.currencyLabel.removeFromSuperview()
            })*/
        skView.presentScene(scene)
    }
    
    func removeAllFromSuperview() {
        currencyLabel.removeFromSuperview()
        playButton.removeFromSuperview()
        shopButton.removeFromSuperview()
        settingsButton.removeFromSuperview()
        for image in cornerImages {
            image.removeFromSuperview()
        }
    }
    
    func fadeOut(duration duration: NSTimeInterval = 1.0) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0.0
        })
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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

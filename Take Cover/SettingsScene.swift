//
//  SettingsScene.swift
//  Take Cover
//
//  Created by Alexander Warren on 4/24/16.
//  Copyright © 2016 Alexander Warren. All rights reserved.
//

import SpriteKit
import MessageUI

class SettingsScene: SKScene, MFMailComposeViewControllerDelegate{
    
    let soundSwitch = UIButton()
    let realSoundSwitch = UISwitch()
    let discoSwitch = UIButton()
    let backButton = UIButton()
    let mailButton = UIButton()
    let settingsLabel = UILabel()
    let soundDesc = UILabel()
    let feedDesc = UILabel()
    let feedHelp = UIButton()
    let creditsButton = UIButton()
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let background = SKSpriteNode()
    var arrayOfButtons = [UIButton]()
    var arrayOfLabels = [UILabel]()
    let fadeOut = SKAction.fadeOutWithDuration(1.0)
    let doors = SKTransition.doorwayWithDuration(1.5)
    let actualFade = SKTransition.doorwayWithDuration(1.5)
    let backgroundImageView = UIImageView(image: UIImage(named: "Title Screen Graident"))

    override func didMoveToView(view: SKView) {
        
        backgroundImageView.frame = self.view!.frame
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.9 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.view!.insertSubview(self.backgroundImageView, atIndex: 0)
        })
        
        arrayOfButtons.append(soundSwitch)
        arrayOfButtons.append(backButton)
        arrayOfButtons.append(mailButton)
        arrayOfLabels.append(settingsLabel)
        arrayOfLabels.append(soundDesc)
        arrayOfLabels.append(feedDesc)
        arrayOfButtons.append(feedHelp)
        arrayOfButtons.append(creditsButton)
        realSoundSwitch.addTarget(self, action: #selector(SettingsScene.realSoundChange), forControlEvents: .ValueChanged)
        realSoundSwitch.on = Cloud.sound
        realSoundSwitch.frame.origin = CGPointMake(100 + self.view!.frame.maxX, self.view!.frame.minY + 80)
        self.view!.addSubview(realSoundSwitch)
        backButton.setImage(UIImage(named: "back-icon"), forState: .Normal)
        backButton.frame.size.width = 120
        backButton.frame.size.height = 85
        backButton.center = CGPoint(x: (view.frame.midX + 200) + self.view!.frame.maxX, y: 210)
        if Cloud.model == "iPhone 4s" || Cloud.model == "iPhone 5"{
            backButton.center = CGPoint(x: (view.frame.midX + 150) + self.view!.frame.maxX, y: 160)
        }
        backButton.addTarget(self, action: #selector(SettingsScene.backButtonPressed), forControlEvents: .TouchUpInside)
        self.view?.addSubview(backButton)
        mailButton.setImage(UIImage(named: "mail"), forState: .Normal)
        mailButton.frame.size = CGSize(width: 100, height: 100)
        
        mailButton.center = CGPointMake(realSoundSwitch.center.x, self.view!.frame.maxY - 100)
        
        mailButton.addTarget(self, action: #selector(SettingsScene.mailTime), forControlEvents: .TouchUpInside)
        self.view!.addSubview(mailButton)
        settingsLabel.text = "SETTINGS"
        settingsLabel.font = settingsLabel.font.fontWithSize(50)
        settingsLabel.frame.size = CGSizeMake(500, 100)
        settingsLabel.center = CGPointMake(self.view!.center.x + self.view!.frame.maxX, 30)
        settingsLabel.textAlignment = NSTextAlignment.Center
        self.view!.addSubview(settingsLabel)
        soundDesc.text = "Music"
        soundDesc.frame.size = CGSizeMake(120, 40)
        
        soundDesc.center = CGPointMake((realSoundSwitch.center.x + 120), realSoundSwitch.center.y)
        
        self.view!.addSubview(soundDesc)
        
        feedDesc.text = "Feedback"
        feedDesc.frame.size = CGSizeMake(120, 40)
        
        feedDesc.center = CGPointMake((mailButton.center.x + 120), mailButton.center.y)
        
        self.view!.addSubview(feedDesc)
        
        feedHelp.setImage(UIImage(named: "quues"), forState: .Normal)
        
        feedHelp.frame = CGRectMake((mailButton.frame.maxX + 10), mailButton.frame.maxY - 10, 30, 30)
        
        feedHelp.addTarget(self, action: #selector(SettingsScene.helpMe), forControlEvents: .TouchUpInside)
        self.view?.addSubview(feedHelp)
        creditsButton.setImage(UIImage(named: "creditsbutton"), forState: .Normal)
        creditsButton.frame.size = CGSize(width: 100, height: 100)
        creditsButton.frame.origin = CGPointMake((self.view!.frame.maxX - creditsButton.frame.width) + self.view!.frame.maxX, self.view!.frame.maxY - creditsButton.frame.height)
        creditsButton.addTarget(self, action: #selector(SettingsScene.credits), forControlEvents: .TouchUpInside)
        self.view!.addSubview(creditsButton)
        UIView.animateWithDuration(1, animations: {
            for thing in self.arrayOfButtons {
                thing.center.x -= self.view!.frame.maxX
            }
            for thing in self.arrayOfLabels {
                thing.center.x -= self.view!.frame.maxX
            }
            self.realSoundSwitch.center.x -= self.view!.frame.maxX
        })
    }
    
    func realSoundChange() {
        Cloud.sound = !Cloud.sound
    }
    
    func helpMe(){
        let theAlertVC = UIAlertController(title: "What is this button?", message: "This button is for feedback: \n bugs, feature requests, etc.", preferredStyle: .Alert)
        theAlertVC.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        let currentViewController:UIViewController=UIApplication.sharedApplication().keyWindow!.rootViewController!
        currentViewController.presentViewController(theAlertVC, animated: true, completion: nil)
    }
    
    func mailTime() {
        let m = setupMailTime()
        let currentViewController:UIViewController=UIApplication.sharedApplication().keyWindow!.rootViewController!
        if MFMailComposeViewController.canSendMail() {
            currentViewController.presentViewController(m, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Could Not Load", message: "Please Try Again Later", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            currentViewController.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func setupMailTime() -> MFMailComposeViewController {
        let m = MFMailComposeViewController()
        m.mailComposeDelegate = self
        m.setToRecipients(["doublebaat@gmail.com"])
        m.setSubject("FeedBack")
        return m
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        let currentViewController:UIViewController=UIApplication.sharedApplication().keyWindow!.rootViewController!
        currentViewController.dismissViewControllerAnimated(true, completion: nil)
        let newCurrentViewController:UIViewController=UIApplication.sharedApplication().keyWindow!.rootViewController!
        switch result.rawValue {
        case MFMailComposeResultSent.rawValue:
            let alertController = UIAlertController(title: "Message Sent", message:
                "Thanks For The Feedback!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            newCurrentViewController.presentViewController(alertController, animated: true, completion: nil)
        case MFMailComposeResultCancelled.rawValue:
            let alertController = UIAlertController(title: "Message Cancelled", message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            newCurrentViewController.presentViewController(alertController, animated: true, completion: nil)
        default:
            break
        }

    }
    
    func backButtonPressed(){
        UIView.animateWithDuration(1, animations: {
            for thing in self.arrayOfButtons {
                thing.center.x += self.view!.frame.maxX
            }
            for thing in self.arrayOfLabels {
                thing.center.x += self.view!.frame.maxX
            }
            self.realSoundSwitch.center.x += self.view!.frame.maxX
        })
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.backgroundImageView.removeFromSuperview()
        })
        Cloud.backFromSettings = true
        let skView = self.view! as SKView
        let scene = TitleScene(fileNamed:"TitleScene")
        scene!.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
    func credits() {
        let creditPanel = UIView(frame: CGRectMake(creditsButton.frame.origin.x - 240, self.view!.frame.maxY - 110, 230, 100))
        creditPanel.backgroundColor = UIColor.lightGrayColor()
        creditPanel.layer.cornerRadius = 10
        let creditLabel = UILabel(frame: CGRectMake(10,0,200,100))
        creditLabel.text = "Programming: Alexander Warren \n Art: Archie Caride \n Music: Marco Warren"
        creditLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        creditLabel.numberOfLines = 4
        creditPanel.addSubview(creditLabel)
        creditPanel.alpha = 0.0
        self.view!.addSubview(creditPanel)
        UIView.animateWithDuration(0.2, animations: {
            creditPanel.alpha = 1.0
        })
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            UIView.animateWithDuration(0.2, animations: {
                creditPanel.alpha = 0.0
                }, completion: { finished in
                    creditPanel.removeFromSuperview()
            })
        })
    }
}

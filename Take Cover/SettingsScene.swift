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
    let discoSwitch = UIButton()
    let backButton = UIButton()
    let mailButton = UIButton()
    let settingsLabel = UILabel()
    let soundDesc = UILabel()
    let feedDesc = UILabel()
    
    override func didMoveToView(view: SKView) {
        formatSwitchButton(soundSwitch, target: #selector(SettingsScene.soundSwitchTapped), frame: CGRectMake(100, self.view!.frame.minY + 80, 100, 50), value: Cloud.sound)
        //formatSwitchButton(discoSwitch, target: #selector(SettingsScene.discoSwitchPressed), frame: CGRectMake(self.view!.frame.midX - 20, soundSwitch.frame.origin.y + 30, 40, 20), value: Cloud.disco)
        backButton.setImage(UIImage(named: "back-icon"), forState: .Normal)
        backButton.center = CGPoint(x: view.frame.midX + 200, y: 210)//x: 500, y: 350)
        backButton.addTarget(self, action: #selector(SettingsScene.backButtonPressed), forControlEvents: .TouchUpInside)
        backButton.frame.size.width = 100
        backButton.frame.size.height = 100
        self.view?.addSubview(backButton)
        mailButton.setImage(UIImage(named: "mail"), forState: .Normal)
        mailButton.frame.size = CGSize(width: 100, height: 100)
        mailButton.center = CGPointMake(soundSwitch.center.x, self.view!.frame.maxY - 100)
        mailButton.addTarget(self, action: #selector(SettingsScene.mailTime), forControlEvents: .TouchUpInside)
        self.view!.addSubview(mailButton)
        settingsLabel.text = "SETTINGS"
        //settingsLabel.font = UIFont(name: "Verdana", size: 50)
        settingsLabel.font = settingsLabel.font.fontWithSize(50)
        settingsLabel.frame.size = CGSizeMake(500, 100)
        settingsLabel.center = CGPointMake(self.view!.center.x, 30)
//        settingsLabel.center = self.view!.center
        settingsLabel.textAlignment = NSTextAlignment.Center
        self.view!.addSubview(settingsLabel)
        soundDesc.text = "Sound"
        soundDesc.frame.size = CGSizeMake(120, 40)
        soundDesc.center = CGPointMake(soundSwitch.center.x + 120, soundSwitch.center.y)
        //soundDescView.backgroundColor = UIColor.clearColor()
        self.view!.addSubview(soundDesc)
        
        feedDesc.text = "Feedback"
        feedDesc.frame.size = CGSizeMake(120, 40)
        feedDesc.center = CGPointMake(mailButton.center.x + 120, mailButton.center.y)
        //soundDescView.backgroundColor = UIColor.clearColor()
        self.view!.addSubview(feedDesc)

    }
    
    func mailTime() {
        print("i")
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
            print("sent")
        case MFMailComposeResultCancelled.rawValue:
            let alertController = UIAlertController(title: "Message Cancelled", message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            newCurrentViewController.presentViewController(alertController, animated: true, completion: nil)
            print("cancelled")
        default:
            break
        }

    }
    
    func discoSwitchPressed(){
        //Cloud.disco = !Cloud.disco
        //setSwitchImage(discoSwitch, value: Cloud.disco)
    }
    
    func formatSwitchButton(theSwitch: UIButton, target: Selector, frame: CGRect, value: Bool){
        theSwitch.frame.size = frame.size
        theSwitch.frame.origin = frame.origin
        theSwitch.addTarget(self, action: target, forControlEvents: .TouchUpInside)
        setSwitchImage(theSwitch, value: value)
        self.view!.addSubview(theSwitch)
    }
    
    func backButtonPressed(){
        soundSwitch.removeFromSuperview()
        backButton.removeFromSuperview()
        settingsLabel.removeFromSuperview()
        mailButton.removeFromSuperview()
        soundDesc.removeFromSuperview()
        feedDesc.removeFromSuperview()
        
        let skView = self.view! as SKView
        let scene = TitleScene(fileNamed:"TitleScene")
        scene!.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
    func soundSwitchTapped() {
        Cloud.sound = !Cloud.sound
        setSwitchImage(soundSwitch, value: Cloud.sound)
    }
        
    func setSwitchImage(theSwitch: UIButton, value: Bool) {
        switch value {
        case true:
            theSwitch.setImage(UIImage(named: "switchOn"), forState: .Normal)
        case false:
            theSwitch.setImage(UIImage(named: "switchOff"), forState: .Normal)
        }
    }
}

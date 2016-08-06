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
    
    let soundSwitch = UISwitch()
    let discoSwitch = UIButton()
    let backButton = UIButton()
    let mailButton = UIButton()
    let settingsLabel = UILabel()
    let soundDesc = UILabel()
    let feedDesc = UILabel()
    let feedHelp = UIButton()
    let creditsButton = UIButton()
    let background = SKSpriteNode()
    var arrayOfButtons = [UIButton]()
    var arrayOfLabels = [UILabel]()
    let backgroundImageView = UIImageView(image: UIImage(named: "Title Screen Graident"))
    let showTutorialSwitch = UISwitch()
    let tutorialLabel = UILabel()
    
    override func didMoveToView(view: SKView) {
        //Background
        backgroundImageView.frame = self.view!.frame
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.9 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.view!.insertSubview(self.backgroundImageView, atIndex: 0)
        })

        //Sound switch
        setupSwitch(soundSwitch,
                    center: nil,
                    origin: CGPointMake(100 + self.view!.frame.maxX, self.view!.frame.minY + 80),
                    onValue: Cloud.sound,
                    selector: #selector(SettingsScene.realSoundChange))
        
        //Show tutorial switch
        setupSwitch(showTutorialSwitch,
                    center: nil,
                    origin: CGPointMake(100 + self.view!.frame.maxX, soundSwitch.frame.maxY + 30),
                    onValue: Cloud.showTutorial,
                    selector: #selector(SettingsScene.showTutorialValChange))
        
        //Tutorial label
        setupLabel(tutorialLabel,
                   center: CGPointMake(showTutorialSwitch.center.x + 120, showTutorialSwitch.center.y),
                   origin: nil,
                   size: nil,
                   text: "Show Tutorial",
                   specialFontSize: nil)
        
        //Back button
        setupButton(backButton,
                    center: CGPoint(x: (view.frame.midX + 200) + self.view!.frame.maxX, y: 210),
                    origin: nil,
                    size: CGSizeMake(120, 85),
                    image: (UIImage(named: "back-icon"))!,
                    selector: #selector(SettingsScene.backButtonPressed))
        if Cloud.model == "iPhone 4s" || Cloud.model == "iPhone 5"{
            backButton.center = CGPoint(x: (view.frame.midX + 150) + self.view!.frame.maxX, y: 160)
        }
        
        //Mail button
        setupButton(mailButton,
                    center: CGPointMake(soundSwitch.center.x, self.view!.frame.maxY - 100),
                    origin: nil,
                    size: CGSize(width: 100, height: 100),
                    image: (UIImage(named: "mail-revised"))!,
                    selector: #selector(SettingsScene.mailTime))
        
        //Settings label
        setupLabel(settingsLabel,
                   center: CGPointMake(self.view!.center.x + self.view!.frame.maxX, 30),
                   origin: nil,
                   size: nil,
                   text: "SETTINGS",
                   specialFontSize: 50)
        
        //Sound description
        setupLabel(soundDesc,
                   center: CGPointMake((soundSwitch.center.x + 120), soundSwitch.center.y),
                   origin: nil,
                   size: nil,
                   text: "Music",
                   specialFontSize: nil)
        
        //Feedback description
        setupLabel(feedDesc,
                   center: CGPointMake((mailButton.center.x + 120), mailButton.center.y),
                   origin: nil,
                   size: nil,
                   text: "FeedBack",
                   specialFontSize: nil)
        
        //Feedback help
        setupButton(feedHelp,
                    center: nil,
                    origin: CGPointMake(mailButton.frame.maxX + 10, mailButton.frame.maxY - 10),
                    size: CGSizeMake(30, 30),
                    image: (UIImage(named: "quues"))!,
                    selector: #selector(SettingsScene.helpMe))
        
        //Credits button
        setupButton(creditsButton,
                    center: nil,
                    origin: CGPointMake(2 * self.view!.frame.maxX - 100, self.view!.frame.maxY - 100),
                    size: CGSize(width: 100, height: 100),
                    image: (UIImage(named: "creditsbutton"))!,
                    selector: #selector(SettingsScene.credits))
        
        //Transition the elements
        UIView.animateWithDuration(1, animations: {
            for thing in self.arrayOfButtons {
                thing.center.x -= self.view!.frame.maxX
            }
            for thing in self.arrayOfLabels {
                thing.center.x -= self.view!.frame.maxX
            }
            self.soundSwitch.center.x -= self.view!.frame.maxX
            self.showTutorialSwitch.center.x -= self.view!.frame.maxX
        })
    }
    
    func showTutorialValChange() {
        Cloud.showTutorial = !Cloud.showTutorial
        NSUserDefaults.standardUserDefaults().setBool(Cloud.showTutorial, forKey: DefaultsKeys.showTutorialKey)
    }
    
    func realSoundChange() {
        Cloud.sound = !Cloud.sound
        NSUserDefaults.standardUserDefaults().setBool(Cloud.sound, forKey: DefaultsKeys.musicKey)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if Cloud.sound {
            appDelegate.play()
        }else{
            appDelegate.stop()
        }
    }
    
    //Shows UIAlertView
    func helpMe(){
        let theAlertVC = UIAlertController(title: "What is this button?", message: "This button is for feedback: \n bugs, feature requests, etc.", preferredStyle: .Alert)
        theAlertVC.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil))
        let currentViewController:UIViewController=UIApplication.sharedApplication().keyWindow!.rootViewController!
        currentViewController.presentViewController(theAlertVC, animated: true, completion: nil)
    }
    
    //Feedback
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
        case MFMailComposeResultSent.rawValue: //If it was sent
            let alertController = UIAlertController(title: "Message Sent", message:
                "Thanks For The Feedback!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            newCurrentViewController.presentViewController(alertController, animated: true, completion: nil)
        case MFMailComposeResultCancelled.rawValue: //If it was cancelled
            let alertController = UIAlertController(title: "Message Cancelled", message:
                "", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            newCurrentViewController.presentViewController(alertController, animated: true, completion: nil)
        default:
            break
        }

    }
    
    func backButtonPressed(){
        
        //Transition elements
        UIView.animateWithDuration(1, animations: {
            for thing in self.arrayOfButtons {
                thing.center.x += self.view!.frame.maxX
            }
            for thing in self.arrayOfLabels {
                thing.center.x += self.view!.frame.maxX
            }
            self.soundSwitch.center.x += self.view!.frame.maxX
            self.showTutorialSwitch.center.x += self.view!.frame.maxX
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
        
        //Credits panel
        let creditPanel = UIView(frame: CGRectMake(creditsButton.frame.origin.x - 240, self.view!.frame.maxY - 110, 230, 100))
        creditPanel.backgroundColor = UIColor.lightGrayColor()
        creditPanel.layer.cornerRadius = 10
        
        //Credit label (on credit panel)
        let creditLabel = UILabel(frame: CGRectMake(10,0,200,100))
        creditLabel.text = "Programming: Alexander Warren \n Art: Archie Caride \n Music: Marco Warren"
        creditLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        creditLabel.numberOfLines = 4
        creditPanel.addSubview(creditLabel)
        creditPanel.alpha = 0.0
        self.view!.addSubview(creditPanel)
        
        //Animate panel (fade in)
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
    
    func setupButton(button: UIButton, center: CGPoint?, origin: CGPoint?, size: CGSize, image: UIImage, selector: Selector){
        button.frame.size = size
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: selector, forControlEvents: .TouchUpInside)
        arrayOfButtons.append(button)
        if origin != nil {
            button.frame.origin = origin!
        }else if center != nil {
            button.center = center!
        }
        self.view!.addSubview(button)
    }
    
    func setupLabel(label: UILabel, center: CGPoint?, origin: CGPoint?, size: CGSize?, text: String, specialFontSize: CGFloat?){
        label.text = text
        label.font = UIFont(name: "VAGRound", size: 17)
        if specialFontSize != nil {
            label.font = UIFont(name: "VAGRound", size: specialFontSize!)
        }
        if size != nil {
            label.frame.size = size!
        }else{
            label.sizeToFit()
        }
        if origin != nil {
            label.frame.origin = origin!
        }else if center != nil {
            label.center = center!
        }
        arrayOfLabels.append(label)
        self.view!.addSubview(label)
    }
    
    func setupSwitch(uiSwitch: UISwitch, center: CGPoint?, origin: CGPoint?, onValue: Bool, selector: Selector) {
        if center != nil {
            uiSwitch.center = center!
        }else if origin != nil {
            uiSwitch.frame.origin = origin!
        }
        uiSwitch.on = onValue
        uiSwitch.addTarget(self, action: selector, forControlEvents: .ValueChanged)
        self.view!.addSubview(uiSwitch)
    }
    
}

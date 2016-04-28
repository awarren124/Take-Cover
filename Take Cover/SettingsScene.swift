//
//  SettingsScene.swift
//  Take Cover
//
//  Created by Alexander Warren on 4/24/16.
//  Copyright © 2016 Alexander Warren. All rights reserved.
//

import SpriteKit

class SettingsScene: SKScene {
    
    let soundSwitch = UIButton()
    let discoSwitch = UIButton()
    let backButton = UIButton()
    
    override func didMoveToView(view: SKView) {
        formatSwitchButton(soundSwitch, target: #selector(SettingsScene.soundSwitchTapped), frame: CGRectMake(self.view!.frame.midX - 20, self.view!.frame.minY + 30, 40, 20), value: Cloud.sound)
        formatSwitchButton(discoSwitch, target: #selector(SettingsScene.discoSwitchPressed), frame: CGRectMake(self.view!.frame.midX - 20, soundSwitch.frame.origin.y + 30, 40, 20), value: Cloud.disco)
        backButton.setImage(UIImage(named: "back-icon"), forState: .Normal)
        backButton.center = CGPoint(x: view.frame.midX + 200, y: 210)//x: 500, y: 350)
        backButton.addTarget(self, action: #selector(SettingsScene.backButtonPressed), forControlEvents: .TouchUpInside)
        backButton.frame.size.width = 100
        backButton.frame.size.height = 100
        self.view?.addSubview(backButton)

    }
    
    func discoSwitchPressed(){
        Cloud.disco = !Cloud.disco
        setSwitchImage(discoSwitch, value: Cloud.disco)
    }
    
    func formatSwitchButton(theSwitch: UIButton, target: Selector, frame: CGRect, value: Bool){
        theSwitch.frame.origin = frame.origin
        theSwitch.frame.size = frame.size
        theSwitch.addTarget(self, action: target, forControlEvents: .TouchUpInside)
        setSwitchImage(theSwitch, value: value)
        self.view!.addSubview(theSwitch)
    }
    
    func backButtonPressed(){
        soundSwitch.removeFromSuperview()
        backButton.removeFromSuperview()
        
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

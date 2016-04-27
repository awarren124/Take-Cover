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
    let backButton = UIButton()
    
    override func didMoveToView(view: SKView) {
        soundSwitch.frame = CGRectMake(self.view!.frame.midX - 20, self.view!.frame.minY + 30, 40, 20)
        //soundSwitch.setImage(UIImage(named: "switchOn"), forState: .Normal)
        //changeSoundSwitchImage()
        setSwitchImage(soundSwitch, value: Cloud.sound)
        soundSwitch.addTarget(self, action: #selector(SettingsScene.soundSwitchTapped), forControlEvents: .TouchUpInside)
        self.view!.addSubview(soundSwitch)
        backButton.setImage(UIImage(named: "back-icon"), forState: .Normal)
        backButton.center = CGPoint(x: view.frame.midX + 200, y: 210)//x: 500, y: 350)
        backButton.addTarget(self, action: #selector(SettingsScene.backButtonPressed), forControlEvents: .TouchUpInside)
        backButton.frame.size.width = 100
        backButton.frame.size.height = 100
        self.view?.addSubview(backButton)

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
        //changeSoundSwitchImage()
        setSwitchImage(soundSwitch, value: Cloud.sound)
    }
        
    func setSwitchImage(theSwitch: UIButton, value: Bool) {
        switch value {
        case true:
            theSwitch.setImage(UIImage(named: "switchOn"), forState: .Normal)
        default:
            theSwitch.setImage(UIImage(named: "switchOff"), forState: .Normal)
        }
    }
    
}

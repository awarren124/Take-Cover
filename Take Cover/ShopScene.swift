//
//  ShopScene.swift
//  Take Cover
//
//  Created by Alexander Warren on 4/9/16.
//  Copyright © 2016 Alexander Warren. All rights reserved.
//

import SpriteKit

class ShopScene: SKScene {
    
    let uiView = UIView()
    let scrollView = UIScrollView()
    var location = CGPoint()
    let playerImageStrings: [String] = [ //REMEMBER TO CHANGE AMOUNT OF ITEMS IN LOCK ARRAY
        "default",
        "circle",
        "triangle",
        "x-shape",
        "cake",
        "target",
        "bowling ball"
    ]
    var playerImageViews = [UIImageView?]()
    var themeImageViews = [UIImageView?]()
    var xPosForPlayers: CGFloat = 50
    var yPosForPlayers: CGFloat = 45 //70
    var xPosForThemes: CGFloat = 50 - 1000
    var yPosForThemes: CGFloat = 45 //70
    let backButton = UIButton()
    let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
    let backWhite = UIImageView(image: UIImage(named: "whiteback"))
    var lockArrayForPlayers = [UIImageView]()
    var lockArrayforThemes = [UIImageView]()
    var currencyLabelArray = [UILabel]()
    let currencylabelNumsForPlayers = [
        100,
        200,
        300,
        500,
        600,
        800,
        1000
    ]
    let currencyLabelNumsForThemes = [
        100,
        200,
        300
    ]
    let themeStrings = [ //REMEMBER (^)
        "classic",
        "dark",
        "disco"
    ]
    var currencyLabelArrayForThemes = [UILabel]()
    var playerSize: CGFloat = 0
    
    let currencyLabel = UILabel(frame: CGRectMake(400, 400, 200, 20))
    let items = ["Players", "Themes"]
    let controller = UISegmentedControl(items: ["Players", "Themes"])//items)
    let shopLabel = UILabel()
    var segmentedControlNum = 0
    let backgroundImageView = UIImageView(image: UIImage(named: "Title Screen Graident"))
    
    override func didMoveToView(view: SKView) {
        
        backgroundImageView.frame = self.view!.frame
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.9 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.view!.insertSubview(self.backgroundImageView, atIndex: 0)
        })
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        playerSize = screenSize.width / 6.67
        xPosForThemes = (playerSize / 2) - 1000
        xPosForPlayers = playerSize / 2
        if Cloud.model == "iPhone 4s" {
            xPosForThemes = (20) - 1000
            xPosForPlayers = 20
        }
    
        var yWidth: CGFloat = 4/10
        if Cloud.model == "iPhone 4s" {
            yWidth = 6/10
        }
        
        shopLabel.text = "SHOP"
        shopLabel.font = shopLabel.font.fontWithSize(50)
        shopLabel.frame.size = CGSizeMake(500, 100)
        shopLabel.center = CGPointMake(self.view!.center.x - self.view!.frame.maxX, 30)
        shopLabel.textAlignment = NSTextAlignment.Center
        self.view!.addSubview(shopLabel)
        
        controller.selectedSegmentIndex = 0
        controller.frame.size = CGSizeMake(200, 30)
        controller.center = CGPoint(x: self.view!.frame.midX - self.view!.frame.maxX, y: self.view!.frame.maxY - 27)
        controller.backgroundColor = UIColor.whiteColor()
        controller.tintColor = UIColor.blackColor()
        controller.addTarget(self, action: #selector(ShopScene.switchView(_:)), forControlEvents: .ValueChanged)
        controller.layer.cornerRadius = 5.0
        controller.layer.borderWidth = 2
        controller.layer.borderColor = UIColor.blackColor().CGColor
        self.view!.addSubview(controller)
        
        currencyLabel.text = String(Cloud.currency)
        currencyLabel.font = currencyLabel.font.fontWithSize(20)
        currencyLabel.frame.size = CGSize(width: 60, height: 15)
        currencyLabel.center = CGPointMake(self.view!.center.x + 100, self.view!.frame.minY + 10)
        
        currencyLabel.textAlignment = NSTextAlignment.Right
        self.view!.addSubview(currencyLabel)
        
        for _ in 1...themeStrings.count {
            lockArrayforThemes.append(UIImageView(image: UIImage(named: "lock")))
        }
        
        for _ in 1...playerImageStrings.count {
            lockArrayForPlayers.append(UIImageView(image: UIImage(named: "lock")))
        }
        let backImage = UIImage(named: "back-icon-rev")
        backButton.setImage(backImage, forState: .Normal)
        backButton.center = CGPoint(x: (view.frame.midX + 100) - self.view!.frame.maxX, y: 210)
        if Cloud.model == "iPhone 4s" {
            backButton.center.x += 18
        }
        backButton.addTarget(self, action: #selector(ShopScene.backButtonPressed), forControlEvents: .TouchUpInside)
        backButton.frame.size.width = 120
        backButton.frame.size.height = 85
        self.view?.addSubview(backButton)
        
        
        
        for num in currencylabelNumsForPlayers {
            currencyLabelArray.append(UILabel())
            currencyLabelArray[currencylabelNumsForPlayers.indexOf(num)!].text = String(num)
            if Cloud.lockedForPlayers[currencylabelNumsForPlayers.indexOf(num)!] {
                currencyLabelArray[currencylabelNumsForPlayers.indexOf(num)!].text = String(num)
            }else{
                currencyLabelArray[currencylabelNumsForPlayers.indexOf(num)!].text = ""
            }
            
            currencyLabelArray[currencylabelNumsForPlayers.indexOf(num)!].textAlignment = NSTextAlignment.Center
        }
        
        for num in currencyLabelNumsForThemes {
            currencyLabelArrayForThemes.append(UILabel())
            if Cloud.lockedForThemes[currencyLabelNumsForThemes.indexOf(num)!] {
                currencyLabelArrayForThemes[currencyLabelNumsForThemes.indexOf(num)!].text = String(num)
            }else{
                currencyLabelArrayForThemes[currencyLabelNumsForThemes.indexOf(num)!].text = ""
            }
            currencyLabelArrayForThemes[currencyLabelNumsForThemes.indexOf(num)!].textAlignment = NSTextAlignment.Center
        }
        
        for index in playerImageStrings {
            
            let thisIt = playerImageStrings.indexOf(index)!
            playerImageViews.append(UIImageView(image: UIImage(named: index)))
            playerImageViews[thisIt]!.frame = CGRectMake(CGFloat(xPosForPlayers)  - self.view!.frame.maxX , CGFloat(yPosForPlayers), screenSize.width / 6.67, screenSize.height / 3.75)
            playerImageViews[thisIt]!.contentMode = UIViewContentMode.ScaleAspectFit
            self.view!.addSubview(playerImageViews[thisIt]!)
            if Cloud.lockedForPlayers[thisIt] {
                playerImageViews[thisIt]!.alpha = 0.0
            }
            lockArrayForPlayers[thisIt].frame = playerImageViews[playerImageStrings.indexOf(index)!]!.frame
            lockArrayForPlayers[thisIt].contentMode = UIViewContentMode.ScaleAspectFit
            let lFrame = lockArrayForPlayers[thisIt].frame
            if Cloud.lockedForPlayers[thisIt]{
                self.view!.addSubview(lockArrayForPlayers[thisIt])
            }
            currencyLabelArray[thisIt].frame = CGRectMake(lFrame.minX, lFrame.maxY + 5, lFrame.width, 30)
            self.view?.addSubview(currencyLabelArray[thisIt])
            if CGFloat(xPosForPlayers) <= (self.view?.frame.maxX)! - (playerImageViews[0]!.frame.width + 100) {
                xPosForPlayers += 130
            }else{
                xPosForPlayers = playerSize / 2
                if Cloud.model == "iPhone 4s" {
                    xPosForPlayers = 20
                }
                yPosForPlayers += playerSize + (playerSize * yWidth) //play around with this
            }
        }
        for index in themeStrings {
            let thisIt = themeStrings.indexOf(index)
            themeImageViews.append(UIImageView(image: UIImage(named: index)))
            themeImageViews[thisIt!]?.frame = CGRectMake(CGFloat(xPosForThemes)  - self.view!.frame.maxX, CGFloat(yPosForThemes), screenSize.width / 6.67, screenSize.height / 3.75)
            themeImageViews[thisIt!]!.contentMode = UIViewContentMode.ScaleAspectFit
            self.view!.addSubview(themeImageViews[thisIt!]!)
            if Cloud.lockedForThemes[thisIt!] {
                themeImageViews[thisIt!]?.alpha = 0.0
            }
            lockArrayforThemes[thisIt!].frame = themeImageViews[thisIt!]!.frame
            lockArrayforThemes[thisIt!].contentMode = UIViewContentMode.ScaleAspectFit
            let lFrame = lockArrayforThemes[thisIt!].frame
            if Cloud.lockedForThemes[thisIt!] {
                self.view!.addSubview(lockArrayforThemes[thisIt!])
            }
            currencyLabelArrayForThemes[thisIt!].frame = CGRectMake(lFrame.minX, lFrame.maxY + 5, lFrame.width, 30)
            self.view!.addSubview(currencyLabelArrayForThemes[thisIt!])
            if CGFloat(xPosForThemes) <= (self.view?.frame.maxX)! - (themeImageViews[0]!.frame.width + 100) {
                xPosForThemes += 130
            }else{
                xPosForThemes = (playerSize / 2)  - 1000
                if Cloud.model == "iPhone 4s" {
                    xPosForPlayers = 20 - 1000
                }
                yPosForThemes += playerSize + (playerSize * yWidth)
            }
        }
        UIView.animateWithDuration(1, animations: {
            for index in self.playerImageStrings {
                let thisIt = self.playerImageStrings.indexOf(index)
                self.playerImageViews[thisIt!]!.center.x += self.view!.frame.maxX
                self.lockArrayForPlayers[thisIt!].center.x += self.view!.frame.maxX
                self.currencyLabelArray[thisIt!].center.x += self.view!.frame.maxX
            }
            for index in self.themeStrings {
                let thisIt = self.themeStrings.indexOf(index)
                self.themeImageViews[thisIt!]!.center.x += self.view!.frame.maxX
                self.lockArrayforThemes[thisIt!].center.x += self.view!.frame.maxX
                self.currencyLabelArrayForThemes[thisIt!].center.x += self.view!.frame.maxX
            }
            self.shopLabel.center.x += self.view!.frame.maxX
            self.controller.center.x += self.view!.frame.maxX
            self.backButton.center.x += self.view!.frame.maxX
            }, completion: { finished in
        })
    }
    func switchView(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animateWithDuration(0.5, animations: {
                for index in self.currencyLabelArray {
                    index.center.x -= 1000
                }
                for index in self.playerImageViews {
                    index!.center.x -= 1000
                }
                for index in self.lockArrayForPlayers {
                    index.center.x -= 1000
                }
                for index in self.currencyLabelArrayForThemes {
                    index.center.x -= 1000
                }
                for index in self.themeImageViews {
                    index!.center.x -= 1000
                }
                for index in self.lockArrayforThemes {
                    index.center.x -= 1000
                }
                self.backWhite.center.x -= 1000
            })
            segmentedControlNum = 0
        case 1:
            UIView.animateWithDuration(0.5, animations: {
                for index in self.currencyLabelArray {
                    index.center.x += 1000
                }
                for index in self.playerImageViews {
                    index!.center.x += 1000
                }
                for index in self.lockArrayForPlayers {
                    index.center.x += 1000
                }
                for index in self.currencyLabelArrayForThemes {
                    index.center.x += 1000
                }
                for index in self.themeImageViews {
                    index!.center.x += 1000
                }
                for index in self.lockArrayforThemes {
                    index.center.x += 1000
                }
                self.backWhite.center.x += 1000
            })
            segmentedControlNum = 1
        default:
            break
        }
    }
    
    func backButtonPressed(){
        UIView.animateWithDuration(1, animations: {
            if self.segmentedControlNum == 0 {
                for index in self.currencyLabelArray {
                    index.center.x -= self.view!.frame.maxX
                }
                for index in self.playerImageViews {
                    index!.center.x -= self.view!.frame.maxX
                }
                for index in self.lockArrayForPlayers {
                    index.center.x -= self.view!.frame.maxX
                }
            }else{
                for index in self.currencyLabelArray {
                    index.removeFromSuperview()
                }
                for index in self.playerImageViews {
                    index?.removeFromSuperview()
                }
                for index in self.lockArrayForPlayers {
                    index.removeFromSuperview()
                }
                
            }
            for index in self.currencyLabelArrayForThemes{
                index.center.x -= self.view!.frame.maxX
            }
            for index in self.themeImageViews {
                index!.center.x -= self.view!.frame.maxX
            }
            for index in self.lockArrayforThemes {
                index.center.x -= self.view!.frame.maxX
            }
            self.controller.center.x -= self.view!.frame.maxX
            self.backButton.center.x -= self.view!.frame.maxX
            self.label.center.x -= self.view!.frame.maxX
            self.shopLabel.center.x -= self.view!.frame.maxX
        })
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.backgroundImageView.removeFromSuperview()
        })
        backWhite.removeFromSuperview()
        currencyLabel.removeFromSuperview()
        Cloud.backFromShop = true
        let skView = self.view! as SKView
        let scene = TitleScene(fileNamed:"TitleScene")
        scene!.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
    func picTapped(index: Int){
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            location = touch.locationInView(self.view)
        }

        check(playerImageViews, arrayOfStrings: playerImageStrings, isLockedArray: &Cloud.lockedForPlayers, numArray: currencylabelNumsForPlayers, isPlayer: true, lockImgArray: lockArrayForPlayers, curlArray: currencyLabelArray)
        check(themeImageViews, arrayOfStrings: themeStrings, isLockedArray: &Cloud.lockedForThemes, numArray: currencyLabelNumsForThemes, isPlayer: false, lockImgArray: lockArrayforThemes, curlArray: currencyLabelArrayForThemes)
        
        NSUserDefaults.standardUserDefaults().setValue(Cloud.lockedForPlayers, forKey: DefaultsKeys.lockedForPlayersKey)
        NSUserDefaults.standardUserDefaults().setValue(Cloud.lockedForThemes, forKey: DefaultsKeys.lockedForThemesKey)
        NSUserDefaults.standardUserDefaults().setValue(Cloud.playerString, forKey: DefaultsKeys.playerStringKey)
        NSUserDefaults.standardUserDefaults().setValue(Cloud.themeString, forKey: DefaultsKeys.themeStringKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func check(arrayOfImages: Array<UIImageView?>, arrayOfStrings: Array<String>, inout isLockedArray: Array<Bool>, numArray: Array<Int>, isPlayer: Bool, lockImgArray: Array<UIImageView>, curlArray: Array<UILabel>) {
        for index in arrayOfImages {
            if CGRectContainsPoint(index!.frame, location){
                for imageName in arrayOfStrings {
                    if index?.image == UIImage(named: imageName){
                        if isLockedArray[arrayOfStrings.indexOf(imageName)!] {
                            if Cloud.currency >= numArray[arrayOfStrings.indexOf(imageName)!] {
                                if isPlayer {
                                    Cloud.playerString = imageName
                                    label.text = "\(imageName) selected"
                                }else{
                                    Cloud.themeString = imageName
                                }
                                self.transformImage(imageName, arrayOfImgViews: arrayOfImages, stringArray: arrayOfStrings, lockArray: lockImgArray)
                                Cloud.currency -= numArray[arrayOfStrings.indexOf(imageName)!]         //LLLLLLLABEL
                                NSUserDefaults.standardUserDefaults().setInteger(Cloud.currency, forKey: DefaultsKeys.currencyKey)
                                NSUserDefaults.standardUserDefaults().synchronize()
                                isLockedArray[arrayOfStrings.indexOf(imageName)!] = false
                                curlArray[arrayOfStrings.indexOf(imageName)!].text = ""
                                currencyLabel.text = String(Cloud.currency)
                            }
                        }else{
                            if isPlayer {
                                Cloud.playerString = imageName
                            }else{
                                Cloud.themeString = imageName
                            }
                            self.transformImage(imageName, arrayOfImgViews: arrayOfImages, stringArray: arrayOfStrings, lockArray: lockImgArray)
                        }
                    }
                }
            }
        }
    }
    
    func transformImage(imageName: String, arrayOfImgViews: Array<UIImageView?>, stringArray: Array<String>, lockArray: Array<UIImageView>) {
        for index in arrayOfImgViews {
            if index!.image == UIImage(named: imageName){
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                    let thisIt = stringArray.indexOf(imageName)!
                    self.backWhite.alpha = 0.0
                    lockArray[thisIt].alpha = 0.0
                    index!.alpha = 1.0
                    lockArray[thisIt].transform = CGAffineTransformMakeScale(2, 2)
                    }, completion: { finished in
                        self.backWhite.frame = CGRectMake(index!.frame.minX - 10, (index?.frame.minY)! - 10, index!.frame.width + 20, (index?.frame.height)! + 20) //index!.frame
                        self.backWhite.alpha = 0.0
                        self.view?.insertSubview(self.backWhite, atIndex: 1)
                        UIView.animateWithDuration(0.3, animations: {
                            self.backWhite.alpha = 1.0
                        })
                })
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
    
}

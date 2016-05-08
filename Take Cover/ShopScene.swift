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
        "Illuminati",
        "oldguy",
        "mets",
        "Pepe",
        "mtndew",
        "pizza"
    ]
    var playerImageViews = [UIImageView?]()
    var themeImageViews = [UIImageView?]()
    var xPosForPlayers = 50
    var yPosForPlayers = 70
    var xPosForThemes = 50 - 1000
    var yPosForThemes = 70
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
    
    let currencyLabel = UILabel(frame: CGRectMake(400, 400, 200, 20))
    let items = ["Players", "Themes"]
    //let controller = UISegmentedControl()
    let controller = UISegmentedControl(items: ["Players", "Themes"])//items)
    let shopLabel = UILabel()
    
    override func didMoveToView(view: SKView) {

        shopLabel.text = "SHOP"
        //shopLabel.font = UIFont(name: "Verdana", size: 50)
        shopLabel.font = shopLabel.font.fontWithSize(50)
        shopLabel.frame.size = CGSizeMake(500, 100)
        shopLabel.center = CGPointMake(self.view!.center.x, 30)
//        shopLabel.center = self.view!.center
        shopLabel.textAlignment = NSTextAlignment.Center
        self.view!.addSubview(shopLabel)
        
        controller.selectedSegmentIndex = 0
        //controller.frame = CGRectMake(self.view!.frame.midX, 20, 200, 30)
        controller.frame.size = CGSizeMake(200, 30)
        controller.center = CGPoint(x: self.view!.frame.midX, y: self.view!.frame.maxY - 27)
        controller.backgroundColor = UIColor.blackColor()
        controller.tintColor = UIColor.whiteColor()
        controller.addTarget(self, action: #selector(ShopScene.switchView(_:)), forControlEvents: .ValueChanged)
        controller.layer.cornerRadius = 5.0
        self.view!.addSubview(controller)
        
        currencyLabel.text = String(Cloud.currency)
        //currencyLabel.center = CGPointMake(self.view!.frame.maxX - 100, self.view!.frame.minY + 10)
        //currencyLabel.frame = CGRectMake(self.view!.frame.maxX, <#T##y: CGFloat##CGFloat#>, <#T##width: CGFloat##CGFloat#>, <#T##height: CGFloat##CGFloat#>)
        currencyLabel.font = currencyLabel.font.fontWithSize(20)
        currencyLabel.frame.size = CGSize(width: 60, height: 15)
        currencyLabel.center = CGPointMake(self.view!.frame.maxX - currencyLabel.frame.width, self.view!.frame.minY + 10)
        currencyLabel.textAlignment = NSTextAlignment.Right
        self.view!.addSubview(currencyLabel)
        
        for _ in 1...themeStrings.count {
            lockArrayforThemes.append(UIImageView(image: UIImage(named: "lock")))
        }
        
        for _ in 1...playerImageStrings.count {
            lockArrayForPlayers.append(UIImageView(image: UIImage(named: "lock")))
        }
        
        backButton.setImage(UIImage(named: "back-icon"), forState: .Normal)
        backButton.center = CGPoint(x: view.frame.midX + 200, y: 210)//x: 500, y: 350)
        backButton.addTarget(self, action: #selector(ShopScene.backButtonPressed), forControlEvents: .TouchUpInside)
        backButton.frame.size.width = 100
        backButton.frame.size.height = 100
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
            playerImageViews[thisIt]!.frame = CGRectMake(CGFloat(xPosForPlayers) , CGFloat(yPosForPlayers), 100, 100)
            self.view!.addSubview(playerImageViews[thisIt]!)
            if Cloud.lockedForPlayers[thisIt] {
                playerImageViews[thisIt]!.alpha = 0.0
            }
            //let lock = UIImageView(image: UIImage(named: "lock"))
            //lock.frame = playerImageViews[playerImageStrings.indexOf(index)!]!.frame
            //self.view!.addSubview(lock)
            lockArrayForPlayers[thisIt].frame = playerImageViews[playerImageStrings.indexOf(index)!]!.frame
            let lFrame = lockArrayForPlayers[thisIt].frame
            if Cloud.lockedForPlayers[thisIt]{
                self.view!.addSubview(lockArrayForPlayers[thisIt])
            }
            currencyLabelArray[thisIt].frame = CGRectMake(lFrame.minX, lFrame.maxY + 10, lFrame.width, 30)
            self.view?.addSubview(currencyLabelArray[thisIt])
            if CGFloat(xPosForPlayers) <= (self.view?.frame.maxX)! - (playerImageViews[0]!.frame.width + 100) {
                xPosForPlayers += 130
            }else{
                xPosForPlayers = 50
                yPosForPlayers += 130
            }
        }
        for index in themeStrings {
            let thisIt = themeStrings.indexOf(index)
            themeImageViews.append(UIImageView(image: UIImage(named: index)))
            themeImageViews[thisIt!]?.frame = CGRectMake(CGFloat(xPosForThemes), CGFloat(yPosForThemes), 100, 100)
            self.view!.addSubview(themeImageViews[thisIt!]!)
            if Cloud.lockedForThemes[thisIt!] {
                themeImageViews[thisIt!]?.alpha = 0.0
            }
            lockArrayforThemes[thisIt!].frame = themeImageViews[thisIt!]!.frame
            let lFrame = lockArrayforThemes[thisIt!].frame
            if Cloud.lockedForThemes[thisIt!] {
                self.view!.addSubview(lockArrayforThemes[thisIt!])
            }
            currencyLabelArrayForThemes[thisIt!].frame = CGRectMake(lFrame.minX, lFrame.maxY + 10, lFrame.width, 30)
            self.view!.addSubview(currencyLabelArrayForThemes[thisIt!])
            if CGFloat(xPosForThemes) <= (self.view?.frame.maxX)! - (themeImageViews[0]!.frame.width + 100) {
                xPosForThemes += 130
            }else{
                xPosForThemes = 50  - 1000
                yPosForThemes += 130
            }
        }
        
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
            print(themeImageViews[0]!.center)
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
            print(themeImageViews[0]!.center)
        default:
            print("no")
        }
    }
    
    func backButtonPressed(){
        for index in currencyLabelArray {
            index.removeFromSuperview()
        }
        for index in playerImageViews {
            index?.removeFromSuperview()
        }
        for index in lockArrayForPlayers {
            index.removeFromSuperview()
        }
        for index in currencyLabelArrayForThemes{
            index.removeFromSuperview()
        }
        for index in themeImageViews {
            index!.removeFromSuperview()
        }
        for index in lockArrayforThemes {
            index.removeFromSuperview()
        }
        controller.removeFromSuperview()
        backWhite.removeFromSuperview()
        backButton.removeFromSuperview()
        label.removeFromSuperview()
        currencyLabel.removeFromSuperview()
        shopLabel.removeFromSuperview()
        let skView = self.view! as SKView
        let scene = TitleScene(fileNamed:"TitleScene")
        scene!.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
    func picTapped(index: Int){
        print("yay")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            location = touch.locationInView(self.view)
        }
        /*
        for index in playerImageViews {
            if CGRectContainsPoint(index!.frame, location){
                for imageName in playerImageStrings {
                    if index?.image == UIImage(named: imageName){
                        if Cloud.lockedForPlayers[playerImageStrings.indexOf(imageName)!] {
                            if Cloud.currency >= self.currencylabelNumsForPlayers[playerImageStrings.indexOf(imageName)!] {
                                Cloud.playerString = imageName
                                label.text = "\(imageName) selected"
                                self.transformImage(imageName)
                                Cloud.currency -= self.currencylabelNumsForPlayers[playerImageStrings.indexOf(imageName)!]
                                Cloud.lockedForPlayers[playerImageStrings.indexOf(imageName)!] = false
                                currencyLabel.text = String(Cloud.currency)
                            }
                        }else{
                            Cloud.playerString = imageName
                            label.text = "\(imageName) selected"
                            self.transformImage(imageName)
                        }
                    }
                }
            }
        }
        for index in themeImageViews {
            if CGRectContainsPoint(index!.frame, location){
                for imageName in themeStrings {
                    if index?.image == UIImage(named: imageName){
                        if Cloud.lockedForThemes[themeStrings.indexOf(imageName)!] {
                            if Cloud.currency >= self.currencyLabelNumsForThemes[themeStrings.indexOf(imageName)!] {
                                //FIX --> Cloud.playerString = imageName
                                //FIX --> label.text = "\(imageName) selected"
                                self.transformImage(imageName)
                                Cloud.currency -= self.currencyLabelNumsForThemes[themeStrings.indexOf(imageName)!]
                                Cloud.lockedForThemes[themeStrings.indexOf(imageName)!] = false
                                currencyLabel.text = String(Cloud.currency)
                            }
                        }else{
                            //Cloud.playerString = imageName
                            //label.text = "\(imageName) selected"
                            self.transformImage(imageName)
                        }
                    }
                }
            }
        }
        */
        check(playerImageViews, arrayOfStrings: playerImageStrings, isLockedArray: &Cloud.lockedForPlayers, numArray: currencylabelNumsForPlayers, isPlayer: true, lockImgArray: lockArrayForPlayers, curlArray: currencyLabelArray)
        check(themeImageViews, arrayOfStrings: themeStrings, isLockedArray: &Cloud.lockedForThemes, numArray: currencyLabelNumsForThemes, isPlayer: false, lockImgArray: lockArrayforThemes, curlArray: currencyLabelArrayForThemes)
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
                                //self.transformImage(imageName)
                                Cloud.currency -= numArray[arrayOfStrings.indexOf(imageName)!]         //LLLLLLLABEL
                                isLockedArray[arrayOfStrings.indexOf(imageName)!] = false
                                curlArray[arrayOfStrings.indexOf(imageName)!].text = ""
                                currencyLabel.text = String(Cloud.currency)
                            }
                        }else{
                            if isPlayer {
                                Cloud.playerString = imageName
                            }
                            self.transformImage(imageName, arrayOfImgViews: arrayOfImages, stringArray: arrayOfStrings, lockArray: lockImgArray)
                        }
                    }
                }
            }
        }
    }
    
    func transformImage(imageName: String, arrayOfImgViews: Array<UIImageView?>, stringArray: Array<String>, lockArray: Array<UIImageView>) {
        /*
        for index in playerImageViews {
            if index!.image == UIImage(named: imageName){
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                    let thisIt = self.playerImageStrings.indexOf(imageName)!
                    self.backWhite.alpha = 0.0
                    self.lockArrayForPlayers[thisIt].alpha = 0.0
                    index!.alpha = 1.0
                    self.lockArrayForPlayers[thisIt].transform = CGAffineTransformMakeScale(2, 2)
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
        for index in themeImageViews {
            if index!.image == UIImage(named: imageName){
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                    let thisIt = self.themeStrings.indexOf(imageName)!
                    self.backWhite.alpha = 0.0
                    self.lockArrayforThemes[thisIt].alpha = 0.0
                    index!.alpha = 1.0
                    self.lockArrayforThemes[thisIt].transform = CGAffineTransformMakeScale(2, 2)
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
        */
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
    func temp(imageName: String, arrayOfImgViews: Array<UIImageView?>, stringArray: Array<String>, lockArray: Array<UIImageView>){
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

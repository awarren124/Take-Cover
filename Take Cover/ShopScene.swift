//
//  ShopScene.swift
//  Take Cover
//
//  Created by Alexander Warren on 4/9/16.
//  Copyright © 2016 Alexander Warren. All rights reserved.
//

import SpriteKit

class ShopScene: SKScene {
    
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
    var yPosForPlayers: CGFloat = 45
    var xPosForThemes: CGFloat = 50 - 1000
    var yPosForThemes: CGFloat = 45
    let backButton = UIButton()
    let backWhite = UIImageView(image: UIImage(named: "whiteback-revised"))
    var lockArrayForPlayers = [UIImageView]()
    var lockArrayforThemes = [UIImageView]()
    var currencyLabelArrayForPlayers = [UILabel]()
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
    
    let currencyLabel = UILabel()
    let controller = UISegmentedControl(items: ["Players", "Themes"])
    let shopLabel = UILabel()
    var segmentedControlNum = 0
    let backgroundImageView = UIImageView(image: UIImage(named: "Title Screen Graident"))
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var yWidth = CGFloat()
    let changeColorButton = UIButton()
    
    override func didMoveToView(view: SKView) {
        
        //Change color button
        setupButton(changeColorButton,
                    center: nil,
                    origin: CGPointMake(-100, self.view!.frame.maxY - 100),
                    size: CGSizeMake(100, 100),
                    image: UIImage(named: "BUTT")!,
                    selector: #selector(ShopScene.changeColorButtonPressed))
        changeColorButton.setImage(UIImage(named: "BUTTP"), forState: .Highlighted)
        
        //background
        backgroundImageView.frame = self.view!.frame
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.9 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
            self.view!.insertSubview(self.backgroundImageView, atIndex: 0)
        })
        
        //Set sizes and positions according to screen size
        playerSize = screenSize.width / 6.67
        xPosForThemes = (playerSize / 2) - 1000
        xPosForPlayers = playerSize / 2
        if Cloud.model == "iPhone 4s" {
            xPosForThemes = (20) - 1000
            xPosForPlayers = 20
        }
    
        yWidth = 4/10
        if Cloud.model == "iPhone 4s" {
            yWidth = 6/10
        }
        
        //Shop label
        setupLabel(shopLabel,
                   center: CGPointMake(self.view!.center.x - self.view!.frame.maxX, 30),
                   origin: nil,
                   size: CGSizeMake(500, 100),
                   text: "SHOP",
                   specialFont: shopLabel.font.fontWithSize(50))
        
        //Segmented control
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
        
        //Currency label
        setupLabel(currencyLabel,
                   center: CGPointMake(self.view!.center.x + 100, self.view!.frame.minY + 10),
                   origin: nil,
                   size: CGSizeMake(60, 15),
                   text: String(Cloud.currency),
                   specialFont: currencyLabel.font.fontWithSize(20))
        
        //Append lock image to arrays
        for _ in 1...themeStrings.count {
            lockArrayforThemes.append(img("lock"))
        }
        for _ in 1...playerImageStrings.count {
            lockArrayForPlayers.append(img("lock"))
        }
        
        //Back button
        setupButton(backButton,
                    center: CGPointMake((view.frame.midX + 100) - self.view!.frame.maxX, 210),
                    origin: nil,
                    size: CGSizeMake(120, 85),
                    image: UIImage(named: "back-icon-rev")!,
                    selector: #selector(ShopScene.backButtonPressed))
        if Cloud.model == "iPhone 4s" {
            backButton.center.x += 18
        }
        
        //Make labels have correct numbers
        assignNumsToLabels(currencylabelNumsForPlayers, currencyLabelArray: &currencyLabelArrayForPlayers, cloudLockedArray: Cloud.lockedForPlayers)
        assignNumsToLabels(currencyLabelNumsForThemes, currencyLabelArray: &currencyLabelArrayForThemes, cloudLockedArray: Cloud.lockedForThemes)
        
        //Setup the rest of the shop
        setupShop(playerImageStrings, imageViewArray: &playerImageViews, xPos: &xPosForPlayers, yPos: &yPosForPlayers, lockArray: lockArrayForPlayers, cloudLockedArray: Cloud.lockedForPlayers, currencyLabelArray: currencyLabelArrayForPlayers, offset: 0)
        setupShop(themeStrings, imageViewArray: &themeImageViews, xPos: &xPosForThemes, yPos: &yPosForThemes, lockArray: lockArrayforThemes, cloudLockedArray: Cloud.lockedForThemes, currencyLabelArray: currencyLabelArrayForThemes, offset: 1000)
        
        //Transition elements (move to the right)
        UIView.animateWithDuration(1, animations: {
            for index in self.playerImageStrings {
                let thisIt = self.playerImageStrings.indexOf(index)
                self.playerImageViews[thisIt!]!.center.x += self.view!.frame.maxX
                self.lockArrayForPlayers[thisIt!].center.x += self.view!.frame.maxX
                self.currencyLabelArrayForPlayers[thisIt!].center.x += self.view!.frame.maxX
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
            self.changeColorButton.center.x += self.view!.frame.maxX
            }, completion: { finished in
        })

    }
    
    func changeColorButtonPressed(){
        switch Cloud.color {
        case " orange":
            changePlayerColorTo(" blue")
        case " blue":
            changePlayerColorTo("")
        default:
            changePlayerColorTo(" orange")
        }
    }
    
    func changePlayerColorTo(color: String) {
        for image in playerImageViews {
            let thisIt: Int = playerImageViews.indexOf {
                $0! == image!
            }!
            image!.image = UIImage(named: "\(playerImageStrings[thisIt])\(color)")
        }
        Cloud.color = color
        NSUserDefaults.standardUserDefaults().setValue(color, forKey: DefaultsKeys.colorKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setupShop(stringArray: [String], inout imageViewArray: [UIImageView?], inout xPos: CGFloat, inout yPos: CGFloat, lockArray: [UIImageView], cloudLockedArray: [Bool], currencyLabelArray: [UILabel], offset: CGFloat) {
        for index in stringArray {                                  //Loops through array of image names
            let thisIt = stringArray.indexOf(index)
            imageViewArray.append(img("\(index)\(Cloud.color)"))    //Adds image to array withname of current image name + color
            imageViewArray[thisIt!]!.frame = CGRectMake(CGFloat(xPos)  - self.view!.frame.maxX, CGFloat(yPos), screenSize.width / 6.67, screenSize.height / 3.75)
            imageViewArray[thisIt!]!.contentMode = UIViewContentMode.ScaleAspectFit
            self.view!.addSubview(imageViewArray[thisIt!]!)         //Add image
            if cloudLockedArray[thisIt!] {
                imageViewArray[thisIt!]!.alpha = 0.0                //If current image is locked, make it transparent
            }
            
            //Add locks
            lockArray[thisIt!].frame = imageViewArray[thisIt!]!.frame
            lockArray[thisIt!].contentMode = UIViewContentMode.ScaleAspectFit
            let lFrame = lockArray[thisIt!].frame
            if cloudLockedArray[thisIt!] {
                self.view!.addSubview(lockArray[thisIt!])
            }
            currencyLabelArray[thisIt!].frame = CGRectMake(lFrame.minX, lFrame.maxY + 5, lFrame.width, 30)
            self.view!.addSubview(currencyLabelArray[thisIt!])
            
            //Compute position for next element
            if CGFloat(xPos) <= (self.view?.frame.maxX)! - (imageViewArray[0]!.frame.width + 100) {
                xPos += 130
            }else{
                xPos = (playerSize / 2)  - offset
                if Cloud.model == "iPhone 4s" {
                    xPos = 20 - offset
                }
                yPos += playerSize + (playerSize * yWidth)
            }
        }
    }
    
    func assignNumsToLabels(currencyLabelNumArray: [Int], inout currencyLabelArray: [UILabel], cloudLockedArray: [Bool]) {
        for num in currencyLabelNumArray {                      //Loops through label numbers
            let thisIt = currencyLabelNumArray.indexOf(num)!
            currencyLabelArray.append(UILabel())
            currencyLabelArray[thisIt].text = String(num)
            if cloudLockedArray[thisIt] {
                currencyLabelArray[thisIt].text = String(num)
            }else{
                currencyLabelArray[thisIt].text = ""
            }
            currencyLabelArray[thisIt].textAlignment = NSTextAlignment.Center
        }
    }
    
    func switchView(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            UIView.animateWithDuration(0.5, animations: {
                for index in self.currencyLabelArrayForPlayers {
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
                for index in self.currencyLabelArrayForPlayers {
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
                for index in self.currencyLabelArrayForPlayers {
                    index.center.x -= self.view!.frame.maxX
                }
                for index in self.playerImageViews {
                    index!.center.x -= self.view!.frame.maxX
                }
                for index in self.lockArrayForPlayers {
                    index.center.x -= self.view!.frame.maxX
                }
            }else{
                for index in self.currencyLabelArrayForPlayers {
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
            self.shopLabel.center.x -= self.view!.frame.maxX
            self.changeColorButton.center.x -= self.view!.frame.maxX
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            location = touch.locationInView(self.view)
        }

        //Check to see if they have enough coins and if so select player or theme
        check(playerImageViews, arrayOfStrings: playerImageStrings, isLockedArray: &Cloud.lockedForPlayers, numArray: currencylabelNumsForPlayers, isPlayer: true, lockImgArray: lockArrayForPlayers, curlArray: currencyLabelArrayForPlayers)
        check(themeImageViews, arrayOfStrings: themeStrings, isLockedArray: &Cloud.lockedForThemes, numArray: currencyLabelNumsForThemes, isPlayer: false, lockImgArray: lockArrayforThemes, curlArray: currencyLabelArrayForThemes)
        
        //Set NSUserDefaults
        NSUserDefaults.standardUserDefaults().setValue(Cloud.lockedForPlayers, forKey: DefaultsKeys.lockedForPlayersKey)
        NSUserDefaults.standardUserDefaults().setValue(Cloud.lockedForThemes, forKey: DefaultsKeys.lockedForThemesKey)
        NSUserDefaults.standardUserDefaults().setValue(Cloud.playerString, forKey: DefaultsKeys.playerStringKey)
        NSUserDefaults.standardUserDefaults().setValue(Cloud.themeString, forKey: DefaultsKeys.themeStringKey)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func check(arrayOfImages: Array<UIImageView?>, arrayOfStrings: Array<String>, inout isLockedArray: Array<Bool>, numArray: Array<Int>, isPlayer: Bool, lockImgArray: Array<UIImageView>, curlArray: Array<UILabel>) {
        for index in arrayOfImages {                                                            //Loops through array of images
            if CGRectContainsPoint(index!.frame, location){                                     //If the tap is on the current image
                for imageName in arrayOfStrings {                                               //Loops through image names
                    if imageNameMatches(index!, imageName: imageName, arrayOfImgViews: arrayOfImages) {//If the current image name matches the name of the selected image
                        if isLockedArray[arrayOfStrings.indexOf(imageName)!] {                  //If it is already locked
                            if Cloud.currency >= numArray[arrayOfStrings.indexOf(imageName)!] { //If there is enough currency
                                if isPlayer {
                                    Cloud.playerString = imageName
                                }else{
                                    Cloud.themeString = imageName
                                }
                                self.transformImage(imageName, arrayOfImgViews: arrayOfImages, stringArray: arrayOfStrings, lockArray: lockImgArray, unlocking: true)
                                Cloud.currency -= numArray[arrayOfStrings.indexOf(imageName)!]
                                NSUserDefaults.standardUserDefaults().setInteger(Cloud.currency, forKey: DefaultsKeys.currencyKey)
                                NSUserDefaults.standardUserDefaults().synchronize()
                                isLockedArray[arrayOfStrings.indexOf(imageName)!] = false
                                curlArray[arrayOfStrings.indexOf(imageName)!].text = ""
                                currencyLabel.text = String(Cloud.currency)
                            }
                        }else{                                                                  //If it is already unlocked
                            if isPlayer {
                                Cloud.playerString = imageName
                            }else{
                                Cloud.themeString = imageName
                            }
                            self.transformImage(imageName, arrayOfImgViews: arrayOfImages, stringArray: arrayOfStrings, lockArray: lockImgArray, unlocking: false)
                        }
                    }
                }
            }
        }
    }
    
    //Select player or theme
    func transformImage(imageName: String, arrayOfImgViews: Array<UIImageView?>, stringArray: Array<String>, lockArray: Array<UIImageView>, unlocking: Bool) {
        for index in arrayOfImgViews {                                                              //Loop through array of images
            if imageNameMatches(index!, imageName: imageName, arrayOfImgViews: arrayOfImgViews) {   //If the image matches the image name passed
                let thisIt = stringArray.indexOf(imageName)!
                self.backWhite.alpha = 0.0
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                    if unlocking {
                        lockArray[thisIt].alpha = 0.0
                        index!.alpha = 1.0
                        lockArray[thisIt].transform = CGAffineTransformMakeScale(2, 2)
                    }
                }, completion: { finished in
                    self.backWhite.frame = CGRectMake(index!.frame.minX - 10, (index?.frame.minY)! - 10, index!.frame.width + 20, (index?.frame.height)! + 20)
                    self.backWhite.alpha = 0.0
                    self.view!.insertSubview(self.backWhite, atIndex: 1)
                    UIView.animateWithDuration(0.3, animations: {
                        self.backWhite.alpha = 1.0
                    })
                })
                
            }
        }
    }
    
    //Check if the passed name matches the image + any color
    func imageNameMatches(image: UIImageView, imageName: String, arrayOfImgViews: Array<UIImageView?>) -> Bool {
        if image.image == UIImage(named: imageName) ||
            image.image == UIImage(named: "\(imageName) blue") ||
            image.image == UIImage(named: "\(imageName) orange"){
            return true
        }
        return false
    }
    
    //Returns a UIImageView with the passed title (used for syntax simplification)
    func img(title: String) -> UIImageView {
        return UIImageView(image: UIImage(named: title))
    }
    
    func setupButton(button: UIButton, center: CGPoint?, origin: CGPoint?, size: CGSize, image: UIImage, selector: Selector){
        button.frame.size = size
        button.setImage(image, forState: .Normal)
        button.addTarget(self, action: selector, forControlEvents: .TouchUpInside)
        if origin != nil {
            button.frame.origin = origin!
        }else if center != nil {
            button.center = center!
        }
        self.view!.addSubview(button)
    }
    
    func setupLabel(label: UILabel, center: CGPoint?, origin: CGPoint?, size: CGSize?, text: String, specialFont: UIFont?){
        label.text = text
        if specialFont != nil {
            label.font = specialFont!
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
        self.view!.addSubview(label)
    }

}

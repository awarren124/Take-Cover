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
    var xPos = 50
    var yPos = 50
    let backButton = UIButton()
    let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
    let backWhite = UIImageView(image: UIImage(named: "whiteback"))
    var lockArray = [UIImageView]()
    var currencyLabelArray = [UILabel]()
    let currencylabelNums = [
        100,
        200,
        300,
        500,
        600,
        800,
        1000
    ]
    let currencyLabel = UILabel(frame: CGRectMake(400, 400, 200, 20))

    
    override func didMoveToView(view: SKView) {
        currencyLabel.text = String(Cloud.currency)
        currencyLabel.center = CGPointMake(self.view!.frame.maxX - 100, self.view!.frame.minY + 10)
        currencyLabel.font = currencyLabel.font.fontWithSize(20)
        self.view!.addSubview(currencyLabel)

        for _ in 1...playerImageStrings.count {
            lockArray.append(UIImageView(image: UIImage(named: "lock")))
        }
        
        backButton.setImage(UIImage(named: "back-icon"), forState: .Normal)
        backButton.center = CGPoint(x: view.frame.midX + 200, y: 210)//x: 500, y: 350)
        backButton.addTarget(self, action: #selector(ShopScene.backButtonPressed), forControlEvents: .TouchUpInside)
        backButton.frame.size.width = 100
        backButton.frame.size.height = 100
        self.view?.addSubview(backButton)
        
        for num in currencylabelNums {
            currencyLabelArray.append(UILabel())
            currencyLabelArray[currencylabelNums.indexOf(num)!].text = String(num)
            currencyLabelArray[currencylabelNums.indexOf(num)!].textAlignment = NSTextAlignment.Center
        }
        
        for _ in 0...playerImageStrings.count {
            //playerImageViews.append(nil)
        }
        for index in playerImageStrings {
            let thisIt = playerImageStrings.indexOf(index)!
            playerImageViews.append(UIImageView(image: UIImage(named: index)))
            playerImageViews[thisIt]!.frame = CGRectMake(CGFloat(xPos) , CGFloat(yPos), 100, 100)
            self.view!.addSubview(playerImageViews[thisIt]!)
            if Cloud.locked[thisIt] {
                playerImageViews[thisIt]!.alpha = 0.0
            }
            //let lock = UIImageView(image: UIImage(named: "lock"))
            //lock.frame = playerImageViews[playerImageStrings.indexOf(index)!]!.frame
            //self.view!.addSubview(lock)
            lockArray[thisIt].frame = playerImageViews[playerImageStrings.indexOf(index)!]!.frame
            let lFrame = lockArray[thisIt].frame
            if Cloud.locked[thisIt]{
                self.view!.addSubview(lockArray[thisIt])
            }
            currencyLabelArray[thisIt].frame = CGRectMake(lFrame.minX, lFrame.maxY + 10, lFrame.width, 30)
            self.view?.addSubview(currencyLabelArray[thisIt])
            if CGFloat(xPos) <= (self.view?.frame.maxX)! - (playerImageViews[0]!.frame.width + 100) {
                xPos += 130
            }else{
                xPos = 50
                yPos += 130
            }
        }
        
        label.center = CGPointMake(160, 284)
        label.font = label.font.fontWithSize(20)
        label.textAlignment = NSTextAlignment.Center
        label.text = "SHOP"
        self.view!.addSubview(label)
    }
    
    func backButtonPressed(){
        for index in currencyLabelArray {
            index.removeFromSuperview()
        }
        for index in playerImageViews {
            index?.removeFromSuperview()
        }
        for index in lockArray {
            index.removeFromSuperview()
        }
        backWhite.removeFromSuperview()
        backButton.removeFromSuperview()
        label.removeFromSuperview()
        currencyLabel.removeFromSuperview()
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
        for index in playerImageViews {
            if CGRectContainsPoint(index!.frame, location){
                for imageName in playerImageStrings {
                    if index?.image == UIImage(named: imageName){
                        if Cloud.locked[playerImageStrings.indexOf(imageName)!] {
                            if Cloud.currency >= self.currencylabelNums[playerImageStrings.indexOf(imageName)!] {
                                Cloud.playerString = imageName
                                label.text = "\(imageName) selected"
                                self.transformImage(imageName)
                                Cloud.currency -= self.currencylabelNums[playerImageStrings.indexOf(imageName)!]
                                Cloud.locked[playerImageStrings.indexOf(imageName)!] = false
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
    }
    
    func transformImage(imageName: String) {
        for index in playerImageViews {
            if index!.image == UIImage(named: imageName){
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                    //self.lockArray[playerImageViews.indexOf(index)!].alpha = 0.0
                    let thisIt = self.playerImageStrings.indexOf(imageName)!
                    //if Cloud.currency >= self.currencylabelNums[thisIt] {
                    self.backWhite.alpha = 0.0
                    self.lockArray[thisIt].alpha = 0.0
                    index!.alpha = 1.0
                    self.lockArray[thisIt].transform = CGAffineTransformMakeScale(2, 2)
                    //index!.transform = CGAffineTransformMakeScale(1.5, 1.5)
                    //}
                    }, completion: { finished in
                        self.backWhite.frame = CGRectMake(index!.frame.minX - 10, (index?.frame.minY)! - 10, index!.frame.width + 20, (index?.frame.height)! + 20) //index!.frame
                        //self.view!.addSubview(self.backWhite)
                        self.backWhite.alpha = 0.0
                        self.view?.insertSubview(self.backWhite, atIndex: 1)
                        UIView.animateWithDuration(0.3, animations: {
                            self.backWhite.alpha = 1.0
                        })
                })
            }else{
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                    //index?.transform = CGAffineTransformIdentity
                    }, completion: { finished in
                })
                
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    override func update(currentTime: CFTimeInterval) {
    }
    
}

//
//  GameScene.swift
//  Take Cover
//
//  Created by Alexander Warren on 3/25/16.
//  Copyright © 2016 Alexander Warren. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene {
    
    let offset:CGFloat = 11
    var restartTapped = false
    var counter = 0
    var itIsPaused = false
    var pauseButton = UIButton(type: UIButtonType.Custom) as UIButton
    var inRect = 0
    var devSwitch = UISwitch(frame:CGRectMake(500, 60, 0, 0))
    var delaySlider = UISlider(frame:CGRectMake(20, 10, 150, 20))
    var minDelaySlider = UISlider(frame:CGRectMake(180, 10, 150, 20))
    var speedSlider = UISlider(frame:CGRectMake(350, 10, 150, 20))
    let labelalso = UILabel(frame: CGRectMake(400, 60, 200, 20))
    var minSpeedSlider = UISlider(frame:CGRectMake(510, 10, 150, 20))
    var restartButton = UIButton(frame: CGRectMake(300, 300, 100, 30))
    var switchDemo = UISwitch(frame:CGRectMake(200, 60, 0, 0))
    var scoreLabel = UILabel(frame: CGRectMake(20, 20, 30, 120))
    var one = 0
    var touching = false
    var location = CGPointMake(0, 0)
    let player = SKSpriteNode(imageNamed: Cloud.playerString)
    var done = false
    var dropSpeed = 15
    var dropFrames = 100 //the amount of frames that the shade will take
    var delayTime:Double = 1
    var delay = true
    var two = 0
    var circleSizeVariable = 2
    var three = 20
    var gameOver = false
    var rect = [SKShapeNode?]()
    var i = 0
    var moveHere:CGFloat = -1360
    var moveToY = SKAction()
    var shade = SKShapeNode()
    var duration:NSTimeInterval = 3
    var doneFalling = true
    var startVal:CGFloat = 600
    var makeCovers = true
    var delayChange = 0.1
    var durationChange = 0.4
    var minDelay = 0.5
    var minDur = 1.0
    var playerStepper = UIStepper(frame: CGRectMake(20, 60, 50, 50))
    var playerSpeed:CGFloat = 4
    let playerLabel = UILabel(frame: CGRectMake(130, 60, 100, 20))
    var die = true
    var devMode = false
    let label = UILabel(frame: CGRectMake(20, 40, 1000, 20))
    var radius:CGFloat = 100
    var eight = 0
    var score = 0
    var start = true
    var circle = [SKShapeNode?]()
    var first = true
    let playButton = TitleScene().playButton
    let shopButton = TitleScene().shopButton
    let restartButtonInPauseMenu = UIButton()
    let backButton = UIButton()
    let background = SKSpriteNode()
    let settingsButton = TitleScene().settingsButton
    var screenHeight:CGFloat = 0
    var realRadius:CGFloat = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        screenHeight = self.view!.frame.height
        print(screenHeight)
        switch screenHeight {
        case 375.0:
            realRadius = CGFloat(M_PI_4) * 100
            break
        case 320.0:
            realRadius = 90
            break
        case 414.0:
            realRadius = 70
            break
        default:
            realRadius = 50
            break
        }
        
        print(playButton.frame.size.width)
        
        let scene = GameScene(fileNamed: "GameScene")
        scene!.scaleMode = .AspectFill
        
        backButton.setImage(UIImage(named: "back-icon"), forState: .Normal)
        backButton.center = CGPoint(x: view.frame.midX - 200, y: 210)//x: 500, y: 350)
        backButton.addTarget(self, action: #selector(GameScene.backButtonPressed), forControlEvents: .TouchUpInside)
        backButton.frame.size.width = 100
        backButton.frame.size.height = 100
        
        restartButtonInPauseMenu.setImage(UIImage(named: "restart"), forState: .Normal)
        restartButtonInPauseMenu.center = CGPoint(x: view.frame.midX, y: 210)//x: 500, y: 350)
        restartButtonInPauseMenu.addTarget(self, action: #selector(GameScene.restartButtonTapped), forControlEvents: .TouchUpInside)
        restartButtonInPauseMenu.frame.size.width = 100
        restartButtonInPauseMenu.frame.size.height = 100
        //view.addSubview(restartButtonInPauseMenu)
        
        let moveToY = SKAction.moveToY(moveHere, duration: duration)
        self.moveToY = moveToY
        
        pauseButton.frame = CGRectMake(50, 50, 50, 50)
        pauseButton.setImage(UIImage(named: "pauseButton.png"), forState: .Normal)
        pauseButton.alpha = 0.0
        //pauseButton.center = CGPoint(x: view.frame.midX, y: 210)//x: 500, y: 350)
        pauseButton.addTarget(self, action: #selector(GameScene.pause), forControlEvents: UIControlEvents.TouchUpInside)
        delay(0.5){
            self.view?.addSubview(self.pauseButton)
            UIView.animateWithDuration(0.5, animations: {
                self.pauseButton.alpha = 1.0
            })
        }
        scoreLabel.text = "0"
        self.view?.addSubview(scoreLabel)
        
        devSwitch.on = devMode
        devSwitch.setOn(devMode, animated: false)
        devSwitch.addTarget(self, action: #selector(GameScene.valueChanged(_:)), forControlEvents: .ValueChanged)
        self.view!.addSubview(devSwitch)
        
        switchDemo.on = die
        switchDemo.setOn(die, animated: false);
        switchDemo.addTarget(self, action: #selector(GameScene.switchValueDidChange(_:)), forControlEvents: .ValueChanged)
        self.view!.addSubview(switchDemo);
        
        setupSlider(delaySlider, minVal: 0, maxVal: 2, val: Float(delayChange), color: UIColor.blueColor(), selector: #selector(GameScene.delaySliderValueDidChange(_:)))
        
        setupSlider(speedSlider, minVal: 0, maxVal: 2, val: Float(durationChange), color: UIColor.redColor(), selector: #selector(GameScene.speedSliderValueDidChange(_:)))
        
        setupSlider(minDelaySlider, minVal: 0, maxVal: 2, val: Float(minDelay), color: UIColor.blackColor(), selector: #selector(GameScene.minDelaySliderValueDidChange(_:)))
        
        setupSlider(minSpeedSlider, minVal: 0, maxVal: 2, val: Float(minDur), color: UIColor.yellowColor(), selector: #selector(GameScene.minSpeedSliderValueDidChange(_:)))
        
        restartButton.setTitle("Restart", forState: .Normal)
        restartButton.backgroundColor = UIColor.blueColor()
        restartButton.addTarget(self, action: #selector(GameScene.restart), forControlEvents: UIControlEvents.TouchUpInside)

        playerStepper.wraps = false
        playerStepper.autorepeat = true
        playerStepper.maximumValue = 20
        playerStepper.minimumValue = 1
        playerStepper.addTarget(self, action: #selector(GameScene.stepperValueChanged(_:)), forControlEvents: .ValueChanged)
        self.view!.addSubview(playerStepper)
        
        label.text = "\t \t delayinc \t  \t \t \t mindelay \t \t \t \t\t \t \t  speedinc \t \t \t \t \t \t \t \t  minspeed"
        label.textColor = UIColor.redColor()
        view.addSubview(label)
        
        playerLabel.textColor = UIColor.blackColor()
        view.addSubview(playerLabel)
        
        labelalso.text = "\(delayChange), \(minDelay), \(durationChange), \(minDur)"
        labelalso.textColor = UIColor.blackColor()
        view.addSubview(labelalso)
        
        //print("ran")
        for _ in 1...3 {
            rect.append(nil)
            circle.append(nil)
        }
        
        background.color = UIColor.whiteColor()
        background.size = self.frame.size
        background.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        background.zPosition = 0
        self.addChild(background)
        player.size = CGSize(width: 50, height: 50)
        player.position.x = self.frame.maxX / 2
        player.position.y = self.frame.minY + 200
        player.zPosition = 4
        self.addChild(player)
        
        //makeCovers(CGPoint(x: 50, y: 40), color: randColor())
    }
    
    func backButtonPressed(){
        reset()
        scoreLabel.removeFromSuperview()
        devSwitch.removeFromSuperview()
        pauseButton.removeFromSuperview()
        restartButtonInPauseMenu.removeFromSuperview()
        backButton.removeFromSuperview()
        
        let skView = self.view! as SKView
        let scene = TitleScene(fileNamed:"TitleScene")
        scene!.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
    func valueChanged(sender:UISwitch!) {
        devMode = sender.on
        //print("hereooo")
    }
    
    func switchValueDidChange(sender:UISwitch!) {
        if (sender.on == true){
            die = true
        }else{
            die = false
        }
    }
    
    func stepperValueChanged(sender:UIStepper!){
        //print("It Works, Value is \(Int(sender.value).description)")
        playerSpeed = CGFloat(sender.value)
    }
    
    func delaySliderValueDidChange(sender:UISlider!) {
        //print(delaySlider.value)
        delayChange = Double(delaySlider.value)
    }
    
    func speedSliderValueDidChange(sender:UISlider!){
        //print(speedSlider.value)
        durationChange = Double(speedSlider.value)
    }
    
    func minDelaySliderValueDidChange(sender:UISlider!){
        //print(minDelaySlider.value)
        minDelay = Double(minDelaySlider.value)
    }
    
    func minSpeedSliderValueDidChange(sender:UISlider!){
        //print(minSpeedSlider.value)
        minDur = Double(minSpeedSlider.value)
    }
    
    func restartButtonTapped(){
        restartTapped = true
        reset()
    }
    
    func pause(){
        itIsPaused = !itIsPaused
        
        let fade = SKShapeNode(rectOfSize: self.frame.size, cornerRadius: 0.0)
        fade.name = "fade"
        if itIsPaused {
            view!.addSubview(restartButtonInPauseMenu)
            view!.addSubview(backButton)
            restartButtonInPauseMenu.alpha = 0.0
            backButton.alpha = 0.0
            UIView.animateWithDuration(0.5, animations: {
                self.restartButtonInPauseMenu.alpha = 1.0
                self.backButton.alpha = 1.0
                
            })
            //pauseButton.alpha = 0.0
            shade.removeAllActions()
            //shade.alpha = 0.5
            fade.position = CGPoint(x: self.position.x + (self.size.width / 2), y: self.position.y + (self.size.height / 2))
            fade.fillColor = UIColor.whiteColor()
            self.addChild(fade)
            fade.alpha = 0.5
            fade.zPosition = 344
            //for node in circle {
            //    node!.alpha = 0.5
            //}
            //for node in rect {
            //    node!.alpha = 0.5
            //}
        }else{
            delay(0.5){
                self.restartButtonInPauseMenu.removeFromSuperview()
                self.backButton.removeFromSuperview()
            }
            deleteNodes("fade")
            UIView.animateWithDuration(0.5, animations: {
                self.restartButtonInPauseMenu.alpha = 0.0
                self.backButton.alpha = 0.0
                
            })
            shade.runAction(moveToY, completion: {
                //print(self.shade.position.y)
                //print("yeeeeeeeeeeeeyuoyeureyttttt boiiiiii")
                self.makeCovers = true
                self.delay(self.delayTime){
                    self.doneFalling = true
                }
                self.deleteNodes("shade")
                //self.deleteNodes("cover")
                //self.deleteNodes("coverShade")
                self.moveCovers()
            })
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        touching = true
        for touch in touches {
            location = touch.locationInNode(self)
            print(location)
            //print(shade.position.y)
        }
        
    }
    
    func setupSlider(slider: UISlider, minVal: Float, maxVal: Float, val: Float, color: UIColor, selector: Selector) {
        slider.minimumValue = minVal
        slider.maximumValue = maxVal
        slider.continuous = true
        slider.tintColor = color
        slider.value = val
        slider.addTarget(self, action: selector, forControlEvents: .ValueChanged)// #selector()
        self.view!.addSubview(slider)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = true
        for touch in touches {
            location = touch.locationInNode(self)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touching = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        //print(arc4random_uniform(7))
        delaySlider.hidden = !devMode
        minDelaySlider.hidden = !devMode
        speedSlider.hidden = !devMode
        minSpeedSlider.hidden = !devMode
        labelalso.hidden = !devMode
        switchDemo.hidden = !devMode
        playerStepper.hidden = !devMode
        playerLabel.hidden = !devMode
        label.hidden = !devMode
        counter += 1
        scoreLabel.text = String(score)
        
        playerLabel.text = "\(Int(playerSpeed))"
        labelalso.text = "\(round(10 * delayChange) / 10), \(round(10 * minDelay) / 10), \(round(10 * durationChange) / 10), \(round(10 * minDur) / 10)"
        
        if !gameOver {
            if doneFalling {
                if !itIsPaused {
                    fall()
                    
                    doneFalling = false
                    //print("here")
                    if delayTime >= minDelay {
                        delayTime -= delayChange
                    }
                    if duration > minDur {
                        //duration -= durationChange
                        duration /= 1.1
                    }
                }
            }
            if start {
                if makeCovers {
                    //for _ in 1...3 {
                    //makeCovers(CGPoint(x: (randPoint(self.frame.minX, max: self.frame.maxX))!, y: 350 ), color: UIColor.lightGrayColor()) //randColor())
                    //let point = convertPointToView(playButton.center)
                    //print(playButton.center)
                    //print(point)
                    
                    //let playPoint = convertPoint(CGPoint(x: playButton.frame.origin.x + offset, y: playButton.frame.origin.y), toNode: self)
                    //print(playPoint)
                    //let playPoint = convertPointFromView(playButton.frame.origin)
                    //print(playPoint)
                    //let shopPoint = self.convertPoint(CGPoint(x: shopButton.frame.origin.x + offset, y: shopButton.frame.origin.y), toNode: self)
                    //let shopPoint = convertPoint(Cloud.shopOrig, toScene: self)
                    let shopPoint = self.view!.convertPoint(Cloud.shopOrig, toScene: self)
                    //let settingsPoint = convertPoint(CGPoint(x: settingsButton.frame.origin.x + offset, y: settingsButton.frame.origin.y), toNode: self)
                    let settingsPoint = self.view!.convertPoint(Cloud.settOrig, toScene: self)
                
                    //var playPoint = playButton.convertPoint(playButton.frame.origin, toView: self.view!)
                    //playPoint = self.view!.convertPoint(playButton.frame.origin, fromView: playButton)
                    let playPoint = self.view!.convertPoint(Cloud.playOrig, toScene: self)
                    //makeCovers(CGPoint(x: shopButton.frame.minX + shopButton.frame.width + 4  , y: 350), color: UIColor.lightGrayColor())
                    //makeCovers(CGPoint(x: playButton.frame.minX + 10, y: 350), color: UIColor.lightGrayColor())
                    makeCovers(playPoint, color: UIColor.lightGrayColor())
                    //makeCovers(CGPoint(x: self.frame.origin.x + (self.frame.size.width / 2), y: 210), color: UIColor.lightGrayColor())
                    //makeCovers(CGPoint(x: (randPoint(self.frame.minX, max: self.frame.maxX))!, y: 350 ), color: UIColor.lightGrayColor())
                    makeCovers(shopPoint, color: UIColor.lightGrayColor())
                    makeCovers(settingsPoint, color: UIColor.lightGrayColor())
                    //CGPoint(x: playButton.frame.maxX , y: playButton.frame.maxY )
                    //}
                    makeCovers = false
                }
                start = false
            }
            
            if touching && !itIsPaused {
                moveSprite(player)
            }
            inRect = 0
            eight = 1
            if die {
                for node in rect {
                    //print("for8: \(eight)")
                    if ((node?.containsPoint(CGPoint(x: player.frame.minX, y: player.frame.maxY))) != false) || ((node?.containsPoint(CGPoint(x: player.frame.maxX, y: player.frame.maxY))) != false) {
                        inRect += 1
                    }
                    if ((node?.containsPoint(CGPoint(x: player.frame.minX, y: player.frame.maxY))) != false) && ((node?.containsPoint(CGPoint(x: player.frame.maxX, y: player.frame.maxY))) != false) {
                        break
                    }else{
                        //print("???")
                        if shade.containsPoint(CGPoint(x: player.frame.minX, y: player.frame.maxY)) != false || shade.containsPoint(CGPoint(x: player.frame.maxX, y: player.frame.maxY)) != false {
                            if !(inRect == 2) {
                                if eight % 3 == 0 {
                                    gameover()
                                    eight = 1
                                    break
                                }
                            }
                        }
                        eight += 1
                        //print("up")
                        //break
                        //print("no yeet")
                        //print("???")
                    }
                }
            }
        }
    }
    
    func deleteNodes(node: String) {
        self.enumerateChildNodesWithName(node) {
            node, stop in
            node.removeFromParent()
        }
    }
    
    func moveSprite(sprite: SKSpriteNode) {
        if sprite.position.x > location.x {
            sprite.position.x -= (player.position.x - location.x) / playerSpeed
        } else if player.position.x < location.x {
            sprite.position.x += (location.x - player.position.x) / playerSpeed
        }
    }
    
    func makeCovers(position: CGPoint, color: SKColor) {
        
        let cover = SKShapeNode(circleOfRadius: realRadius)      	//25)//78.5)//Cloud.buttonSize.width * 0.78539)//50)//(Cloud.buttWidth * (CGFloat(pi)/4)))/// 2)//78)//playButton.frame.size.width / 2)//78)// - CGFloat(two))
        //M_PI_4 * 100
        //let cover = SKShapeNode(ellipseOfSize: CGSize(width: Cloud.buttWidth * 4/3, height: Cloud.buttWidth * 4/3))
        let circleWidth = cover.frame.size.width
        //let circleHeight = circle.frame.size.height
        cover.position = position
        //cover.name = "defaultCircle"
        cover.strokeColor = SKColor.whiteColor()
        cover.glowWidth = 1
        cover.zPosition = 3
        cover.name = "cover"
        //circle.physicsBody?.usesPreciseCollisionDetection = true
        cover.fillColor = color
        cover.fillTexture = SKTexture(imageNamed: "CircleGradient")
        //circle.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        //cover.physicsBody = SKPhysicsBody(rectangleOfSize: self.frame.size)
        //cover.physicsBody?.usesPreciseCollisionDetection = true
        //cover.physicsBody?.affectedByGravity = false
        //cover.physicsBody?.dynamic = true //.physicsBody?.dynamic = true
        self.addChild(cover)
        //let rectangle = CGRectMake(position.x - (circleWidth / 2) + 1, position.y - self.frame.minY, circleWidth - 2, self.frame.minY - position.y)
        let rect = SKShapeNode(rect: CGRectMake(position.x - (circleWidth / 2) + 1, position.y - self.frame.minY, circleWidth - 2, self.frame.minY - position.y))//rectangle)
        //rect.physicsBody?.usesPreciseCollisionDetection = false
        //rect.physicsBody?.affectedByGravity = false
        //rect.igno
        rect.fillColor = UIColor.whiteColor()//color
        rect.zPosition = 2
        rect.name = "coverShade"
        rect.strokeColor = UIColor.clearColor()
        self.addChild(rect)
        //self.rect.append(rect)
        self.rect[i] = rect
        self.circle[i] = cover
        //print(position)
        //make it better
        if two < 50{
            two += circleSizeVariable
        }
        if i == 2 {
            i = 0
        }else{
            i += 1
        }
        
    }
    
    func moveCovers() {
        var z = 0
        deleteNodes("coverShade")
        for node in circle {
            //for _ in 1...3 {
            let x = rand(1020)
            let moveCover = SKAction.moveToX(CGFloat(x), duration: delayTime)
            //node?.runAction(moveCover)
            //print("x: ", x)
            //for node in circle {
            //node!.position = position
            node!.runAction(moveCover)
            //let circle = node!
            let rectangle = CGRectMake(CGFloat(x) - (node!.frame.size.width / 2) + 2, node!.position.y, node!.frame.size.width - 4, self.frame.minY - node!.position.y)
            let recta = SKShapeNode(rect: rectangle)
            recta.zPosition = 2//self.frame.minY - position.y
            recta.fillColor = UIColor.whiteColor()
            recta.name = "coverShade"
            self.addChild(recta)
            rect[z] = recta
            //let realRect = rect[z]
            //rect[z]!.runAction(SKAction.moveToX((CGFloat(x) - realRect!.frame.minX) /* - (realRect!.frame.size.width / 2) */ , duration: 1.0))//.position.x = (node?.position.x)!
            //realRect?.position.x = (CGFloat(x) - realRect!.frame.minX) - (realRect!.frame.size.width / 2)
            //if z == 0 && !first {//(node?.fillColor = UIColor.blackColor()) != nil {
            /*
             print("nodeX: \(node!.position.x)")
             print("rectX: \(realRect!.frame.minX)")
             print("x: \(x)")
             print(CGFloat(x) - realRect!.frame.minX)
             */
            //}
            //, completion:{
            //for other in self.rect {
            //print("in")
            //print(self.rect.count)
            //print("z:", z)
            //self.rect[z]!.position.x = (self.position.x - (self.radius))
            //}
            //z += 1
            //})
            //}
            z += 1
            //rect[z]?.runAction(moveCover)
        }
        first = false
    }
    
    func randPoint(min: CGFloat, max: CGFloat) -> Int? {
        //print("here")
        let result = Int(arc4random_uniform(UInt32(max)))
        if result < Int(min) {
            //print("fail")
            return nil
        } else {
            //("success")
            return result
        }
    }
    
    func randColor() -> SKColor {
        let color = arc4random_uniform(5)
        if color == 0 {
            return SKColor.blackColor()
        }else if color == 1 {
            return SKColor.redColor()
        }else if color == 2 {
            return SKColor.blueColor()
        }else if color == 3 {
            return SKColor.yellowColor()
        }else if color == 4 {
            return SKColor.greenColor()
        }else if color == 5 {
            return SKColor.whiteColor()
        }
        return SKColor.brownColor()
    }
    
    func rand(max: UInt32) -> Int {
        return Int(arc4random_uniform(max))
    }
    
    func drop() -> SKShapeNode {
        let shadeRect = CGRectMake(0, startVal, self.frame.width, self.frame.height)
        let shade = SKShapeNode(rect: shadeRect)
        shade.name = "shade"
        //shade.fillColor = randColor()//UIColor(red:0.34, green:0.21, blue:0.72, alpha:1.0)//SKColor.color //UIColor.purpleColor()//grayColor()
        shade.zPosition = 1
        shade.fillTexture = SKTexture(imageNamed: randShadeTex())
        shade.fillColor = UIColor.whiteColor()
        return shade
    }
    
    func fall() {
        if !start {
            score += 1
            print(score)
        }
        //print(score)
        let moveToY = SKAction.moveToY(moveHere, duration: duration)
        self.moveToY = moveToY
        
        self.shade = drop()
        //print("made")
        self.addChild(shade)
        shade.zPosition = 1
        //shade. = self.frame.size
        shade.runAction(moveToY, completion: {
            //print(self.shade.position.y)
            //print("yeeeeeeeeeeeeyuoyeureyttttt boiiiiii")
            self.makeCovers = true
            self.delay(self.delayTime){
                self.doneFalling = true
            }
            self.deleteNodes("shade")
            //self.deleteNodes("cover")
            //self.deleteNodes("coverShade")
            self.moveCovers()
        })
    }
    
    func gameover() {
        deleteNodes("cover")
        deleteNodes("coverShade")
        deleteNodes("shade")
        gameOver = true
        /*print("game over")
         UIView.animateWithDuration(0.5, animations: {
         self.scoreLabel.center = self.view!.center
         })*/
        UIView.animateWithDuration(0.5, delay: 0.2, options: .CurveEaseOut, animations: {
            self.scoreLabel.center = self.view!.center
            }, completion: { finished in
                //print("done!")
        })
        //scoreLabel.an
        view?.addSubview(restartButton)
        //while scoreLabel.center.x < 300 { //DOESNT WORK
        //  print("in")                   //FIX IT
        //delay(1.0){
        //  print("inin")
        //self.moveScore()
        //}
        // }
    }
    
    func moveScore() {
        self.scoreLabel.center.x += 3
    }
    
    func restart() {
        reset()
    }
    
    func reset() {
        if restartTapped{
            delay(0.5){
                self.restartButtonInPauseMenu.removeFromSuperview()
                self.backButton.removeFromSuperview()
            }
            UIView.animateWithDuration(0.5, animations: {
                self.restartButtonInPauseMenu.alpha = 0.0
                self.backButton.alpha = 0.0
                
            })
            restartTapped = false
        }
        deleteNodes("cover")
        deleteNodes("coverShade")
        deleteNodes("shade")
        itIsPaused = false
        deleteNodes("fade")
        gameOver = false
        doneFalling = true
        makeCovers = true
        restartButton.removeFromSuperview()
        delayChange = 0.7
        durationChange = 0.3
        minDelay = 0.5
        minDur = 1.0
        duration = 3
        delayTime = 1
        radius = 100
        start = true
        score = 0
        UIView.animateWithDuration(0.5, delay: 0.2, options: .CurveEaseOut, animations: {
            self.scoreLabel.center = CGPoint(x: 20, y: 20)
            }, completion: { finished in
                //print("done!")
        })
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func randShadeTex() -> String{
        let randNum = arc4random_uniform(4)
        switch(randNum){
        case 0 :
            return "BlueShade"
        case 1 :
            return "OrangeShade"
        case 2 :
            return "PinkShade"
        default :
            return "RedShade"
        }
    }
    
}

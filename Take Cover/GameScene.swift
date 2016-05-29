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
    let backButtonInGameOver = UIButton()
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
    var switchDemo = UISwitch(frame:CGRectMake(200, 60, 0, 0))
    var scoreLabel = UILabel(frame: CGRectMake(20, 20, 30, 120))
    var one = 0
    var touching = false
    var location = CGPointMake(0, 0)
    let player = SKSpriteNode(imageNamed: Cloud.playerString)
    var done = false
    var dropSpeed = 15
    var dropFrames = 100 //the amount of frames that the shade will take
    var delayTime = 1.0
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
    var pauseView = UIView()
    var scaleFactor:CGFloat = 0.9
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        
        
        //restartButton.frame = CGRectMake(self.view!.frame.midX, self.view!.frame.maxY - 150, 100, 30)
        
        switch Cloud.themeString {
        case "dark":
            background.color = UIColor.lightGrayColor()
        case "disco":
            background.color = randColor()
        default:
            background.color = UIColor.whiteColor()
        }
        
        screenHeight = self.view!.frame.height
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
        
        //background.color = UIColor.whiteColor()
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
        pauseView.removeFromSuperview()
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
            fade.zPosition = 5
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
            //            print(location)
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
                    let shopPoint = self.view!.convertPoint(Cloud.shopOrig, toScene: self)
                    //let settingsPoint = convertPoint(CGPoint(x: settingsButton.frame.origin.x + offset, y: settingsButton.frame.origin.y), toNode: self)
                    let settingsPoint = self.view!.convertPoint(Cloud.settOrig, toScene: self)
                    
                    //var playPoint = playButton.convertPoint(playButton.frame.origin, toView: self.view!)
                    //playPoint = self.view!.convertPoint(playButton.frame.origin, fromView: playButton)
                    let playPoint = self.view!.convertPoint(Cloud.playOrig, toScene: self)
                    //makeCovers(CGPoint(x: shopButton.frame.minX + shopButton.frame.width + 4  , y: 350), color: UIColor.lightGrayColor())
                    var color = UIColor()
                    switch Cloud.themeString {
                    case "dark":
                        color = UIColor.blackColor()
                    case "disco":
                        color = randColorThatsNotBackgroundColor()
                    default:
                        color = UIColor.lightGrayColor()
                    }
                    /*
                     makeCovers(playPoint, color: color)
                     makeCovers(shopPoint, color: color)
                     makeCovers(settingsPoint, color: color)
                     print("PLAY \(playPoint)")
                     print("SHOP \(shopPoint)")
                     print("SET \(settingsPoint)")
                     */
                    switch Cloud.model {
                    case "iPhone 6":
                        makeCovers(CGPointMake(512.0, 384.000061035156), color: color)
                        makeCovers(CGPointMake(819.04638671875, 384.000061035156), color: color)
                        makeCovers(CGPointMake(204.953491210938, 384.000061035156), color: color)
                    case "iPhone 5":
                        makeCovers(CGPointMake(512.0, 384.0), color: color)
                        makeCovers(CGPointMake(151.437, 384.0), color: color)
                        makeCovers(CGPointMake(872.563, 384.0), color: color)
                    case "iPhone 6+":
                        makeCovers(CGPointMake(512.0, 384.0), color: color)
                        makeCovers(CGPointMake(233.739135742188, 384.0), color: color)
                        makeCovers(CGPointMake(790.260864257812, 384.0), color: color)
                    default:
                        break
                    }
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
    
    func makeCovers(pointPosition: CGPoint, color: SKColor) {
        print(pointPosition)
        var position = pointPosition
        position.x = abs(pointPosition.x)
        position.y = abs(pointPosition.y)
        let cover = SKShapeNode(circleOfRadius: realRadius)      	//25)//78.5)//Cloud.buttonSize.width * 0.78539)//50)//(Cloud.buttWidth * (CGFloat(pi)/4)))/// 2)//78)//playButton.frame.size.width / 2)//78)// - CGFloat(two))
        //M_PI_4 * 100
        //let cover = SKShapeNode(ellipseOfSize: CGSize(width: Cloud.buttWidth * 4/3, height: Cloud.buttWidth * 4/3))
        let circleWidth = cover.frame.size.width
        //let circleHeight = circle.frame.size.height
        cover.position = position
        //cover.name = "defaultCircle"
        cover.strokeColor = SKColor.lightGrayColor()
        cover.glowWidth = 1
        cover.zPosition = 3
        cover.name = "cover"
        //circle.physicsBody?.usesPreciseCollisionDetection = true
        
        switch Cloud.themeString {
        case "classic":
            cover.fillColor = UIColor.whiteColor()
            cover.fillTexture = SKTexture(imageNamed: "CircleGradient")
        default:
            cover.fillColor = color
        }
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
        if Cloud.themeString == "disco" {
            background.color = randColor()
            for node in circle {
                node!.fillColor = randColorThatsNotBackgroundColor()
            }
        }
        var z = 0
        deleteNodes("coverShade")
        for node in circle {
            let x = rand(1020)
            let moveCover = SKAction.moveToX(CGFloat(x), duration: delayTime)
            node!.runAction(moveCover)
            let holderSizeNode = SKShapeNode(circleOfRadius: realRadius)
            let scaleAction = SKAction.scaleTo(scaleFactor, duration: delayTime)
            if scaleFactor >= 0.5 && score % 3 == 0 {
                node?.runAction(scaleAction)
            }
            let rectangle = CGRectMake(CGFloat(x) - ((holderSizeNode.frame.width * scaleFactor) / 2), node!.position.y, ((holderSizeNode.frame.width) * scaleFactor), self.frame.minY - node!.position.y)
            let recta = SKShapeNode(rect: rectangle)
            recta.zPosition = 2
            recta.fillColor = background.color
            recta.name = "coverShade"
            recta.lineWidth = 0.0
            self.addChild(recta)
            rect[z] = recta
            z += 1
        }
        if scaleFactor >= 0.5 && score % 3 == 2 {
            scaleFactor -= 0.1
            print("Shrinking...")
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
    
    func randColorThatsNotBackgroundColor() -> SKColor {
        let color = arc4random_uniform(5)
        if color == 0 {
            if SKColor.blackColor() == background.color {
                return SKColor.redColor()
            }else{
                return SKColor.blackColor()
            }
        }else if color == 1 {
            if SKColor.blueColor() == background.color {
                return SKColor.blueColor()
            }else{
                return SKColor.redColor()
            }
        }else if color == 2 {
            if SKColor.blackColor() == background.color {
                return SKColor.yellowColor()
            }else{
                return SKColor.blueColor()
            }
            //return SKColor.blueColor()
        }else if color == 3 {
            if SKColor.yellowColor() == background.color {
                return SKColor.greenColor()
            }else{
                return SKColor.yellowColor()
            }
        }else if color == 4 {
            if SKColor.greenColor() == background.color {
                return SKColor.blackColor()
            }else{
                return SKColor.greenColor()
            }
        }
        //}else if color == 5 {
        //    return SKColor.whiteColor()
        //}
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
        shade.lineWidth = 0
        return shade
    }
    
    func fall() {
        if !start {
            score += 1
            Cloud.currency += 5
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
        delayTime = 1
        pauseView = makeRestartPanel()
        pauseView.alpha = 0.0
        view!.addSubview(pauseView)
        backButtonInGameOver.setImage(UIImage(named: "realback"), forState: .Normal)
        backButtonInGameOver.frame = pauseButton.frame
        backButtonInGameOver.alpha = 0.0
        backButtonInGameOver.addTarget(self, action: #selector(GameScene.backButtonPressed), forControlEvents: .TouchUpInside)
        self.view!.addSubview(backButtonInGameOver)
        UIView.animateWithDuration(0.5, animations: {
            self.pauseView.alpha = 1.0
            self.pauseButton.alpha = 0.0
            self.backButtonInGameOver.alpha = 1.0
        })
    }
    
    func makeRestartPanel() -> UIView {
        let panel = UIView()
        panel.frame.size = CGSizeMake(150, 150)
        panel.center = self.view!.center
        let panelSize = panel.frame.size
        panel.layer.borderWidth = 15
        panel.layer.borderColor = UIColor.blackColor().CGColor
        panel.layer.cornerRadius = 10
        panel.backgroundColor = UIColor(red:0.53, green:0.87, blue:0.95, alpha:1.0)
        panel.alpha = 0.7
        let panelMax = self.view!.convertPoint(CGPoint(x: panel.frame.maxX, y: panel.frame.maxY), toView: panel)
        let scoreLabelText = UILabel(frame: CGRectMake(0, /*panel.frame.maxY / 4*/panelMax.y / 4, panelSize.width, 40))
        scoreLabelText.center.y = panelMax.y / 4
        scoreLabelText.text = "Score: \(score)"
        scoreLabelText.textAlignment = NSTextAlignment.Center
        panel.addSubview(scoreLabelText)
        let restartButton = UIButton()//frame: CGRectMake(300, 300, 100, 30))
        restartButton.frame = CGRectMake(0, panelMax.y / 2/*scoreLabelText.frame.maxY*/, panelSize.width - 10, 25)
        restartButton.center.y = panelMax.y / 2
        restartButton.setTitle("Restart", forState: .Normal)
        restartButton.backgroundColor = UIColor.blackColor()
        restartButton.addTarget(self, action: #selector(GameScene.restart), forControlEvents: UIControlEvents.TouchUpInside)
        panel.addSubview(restartButton)
        let currencyLabel = UILabel(frame: CGRectMake(0, panelMax.y * (3/4), panelSize.width, 25))
        currencyLabel.center.y = panelMax.y * (3/4)
        currencyLabel.text = "Coins: \(Cloud.currency)"
        currencyLabel.textAlignment = NSTextAlignment.Center
        panel.addSubview(currencyLabel)
        return panel
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
        }else{
            UIView.animateWithDuration(0.5, animations: {
                self.pauseButton.alpha = 1.0
            })
        }
        UIView.animateWithDuration(0.5, animations: {
            self.pauseView.alpha = 0.0
            self.backButtonInGameOver.alpha = 0.0
            }, completion: { finished in
                self.pauseView.removeFromSuperview()
                self.backButtonInGameOver.removeFromSuperview()
        })
        deleteNodes("cover")
        deleteNodes("coverShade")
        deleteNodes("shade")
        itIsPaused = false
        deleteNodes("fade")
        gameOver = false
        doneFalling = true
        makeCovers = true
        delayChange = 0.7
        durationChange = 0.3
        minDelay = 0.5
        minDur = 1.0
        duration = 3
        delayTime = 1
        radius = 100
        start = true
        score = 0
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

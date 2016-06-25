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
        
        switch Cloud.themeString {
        case "dark":
            background.color = UIColor.lightGrayColor()
        case "disco":
            background.color = randColor()
        default:
            background.color = UIColor.whiteColor()
        }
        
        screenHeight = self.view!.frame.height
        switch Cloud.model {
        case "iPhone 6":
            realRadius = CGFloat(M_PI_4) * 100
            break
        case "iPhone 5":
            realRadius = 90
            break
        case "iPhone 6+":
            realRadius = 70
            break
        case "iPhone 4s":
            realRadius = 85
            break
        default:
            break
        }
        
        
        let scene = GameScene(fileNamed: "GameScene")
        scene!.scaleMode = .AspectFill
        
        backButton.setImage(UIImage(named: "back-icon"), forState: .Normal)
        backButton.center = CGPoint(x: view.frame.midX - 200, y: 210)
        backButton.addTarget(self, action: #selector(GameScene.backButtonPressed), forControlEvents: .TouchUpInside)
        backButton.frame.size.width = 120
        backButton.frame.size.height = 85
        
        restartButtonInPauseMenu.setImage(UIImage(named: "restart"), forState: .Normal)
        restartButtonInPauseMenu.center = CGPoint(x: view.frame.midX, y: 210)
        restartButtonInPauseMenu.addTarget(self, action: #selector(GameScene.restartButtonTapped), forControlEvents: .TouchUpInside)
        restartButtonInPauseMenu.frame.size.width = 100
        restartButtonInPauseMenu.frame.size.height = 100
        
        let moveToY = SKAction.moveToY(moveHere, duration: duration)
        self.moveToY = moveToY
        
        pauseButton.frame = CGRectMake(50, 50, 50, 50)
        pauseButton.setImage(UIImage(named: "pausebutton"), forState: .Normal)
        pauseButton.alpha = 0.0
        pauseButton.addTarget(self, action: #selector(GameScene.pause), forControlEvents: UIControlEvents.TouchUpInside)
        delay(0.5){
            self.view?.addSubview(self.pauseButton)
            UIView.animateWithDuration(0.5, animations: {
                self.pauseButton.alpha = 1.0
            })
        }
        scoreLabel.text = "0"
        self.view?.addSubview(scoreLabel)
        
        for _ in 1...3 {
            rect.append(nil)
            circle.append(nil)
        }
        
        background.size = self.frame.size
        background.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        background.zPosition = 0
        self.addChild(background)
        player.size = CGSize(width: 50, height: 50)
        player.position.x = self.frame.maxX / 2
        player.position.y = self.frame.minY + 200
        player.zPosition = 4
        self.addChild(player)
        
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
            shade.removeAllActions()
            fade.position = CGPoint(x: self.position.x + (self.size.width / 2), y: self.position.y + (self.size.height / 2))
            fade.fillColor = UIColor.whiteColor()
            self.addChild(fade)
            fade.alpha = 0.5
            fade.zPosition = 5
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
                self.makeCovers = true
                self.delay(self.delayTime){
                    self.doneFalling = true
                }
                self.deleteNodes("shade")
                self.moveCovers()
            })
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        touching = true
        for touch in touches {
            location = touch.locationInNode(self)
        }
        
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
        counter += 1
        scoreLabel.text = String(score)
        
        if !gameOver {
            if doneFalling {
                if !itIsPaused {
                    fall()
                    
                    doneFalling = false
                    if delayTime >= minDelay {
                        delayTime -= delayChange
                    }
                    if duration > minDur {
                        duration /= 1.1
                    }
                }
            }
            if start {
                if makeCovers {
                    var color = UIColor()
                    switch Cloud.themeString {
                    case "dark":
                        color = UIColor.blackColor()
                    case "disco":
                        color = randColorThatsNotBackgroundColor()
                    default:
                        color = UIColor.lightGrayColor()
                    }
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
                    case "iPhone 4s":
                        makeCovers(CGPointMake(138.667, 384.0), color: color)
                        makeCovers(CGPointMake(512.0, 384.0), color: color)
                        makeCovers(CGPointMake(885.333, 384.0), color: color)
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
                    if ((node?.containsPoint(CGPoint(x: player.frame.minX, y: player.frame.maxY))) != false) || ((node?.containsPoint(CGPoint(x: player.frame.maxX, y: player.frame.maxY))) != false) {
                        inRect += 1
                    }
                    if ((node?.containsPoint(CGPoint(x: player.frame.minX, y: player.frame.maxY))) != false) && ((node?.containsPoint(CGPoint(x: player.frame.maxX, y: player.frame.maxY))) != false) {
                        break
                    }else{
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
        var position = pointPosition
        position.x = abs(pointPosition.x)
        position.y = abs(pointPosition.y)
        let cover = SKShapeNode(circleOfRadius: realRadius)
        let circleWidth = cover.frame.size.width
        cover.position = position
        cover.strokeColor = SKColor.lightGrayColor()
        cover.glowWidth = 1
        cover.zPosition = 3
        cover.name = "cover"
        
        switch Cloud.themeString {
        case "classic":
            cover.fillColor = UIColor.whiteColor()
            cover.fillTexture = SKTexture(imageNamed: "CircleGradient")
        default:
            cover.fillColor = color
        }
        self.addChild(cover)
        let rect = SKShapeNode(rect: CGRectMake(position.x - (circleWidth / 2) + 1, position.y - self.frame.minY, circleWidth - 2, self.frame.minY - position.y))
        rect.fillColor = background.color
        rect.zPosition = 2
        rect.name = "coverShade"
        rect.strokeColor = UIColor.clearColor()
        self.addChild(rect)
        self.rect[i] = rect
        self.circle[i] = cover
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
        if scaleFactor >= 0.6 && score % 3 == 0 {
            scaleFactor -= 0.1
        }
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
        first = false
    }
    
    func randPoint(min: CGFloat, max: CGFloat) -> Int? {
        let result = Int(arc4random_uniform(UInt32(max)))
        if result < Int(min) {
            return nil
        } else {
            return result
        }
    }
    
    func randColor() -> SKColor {
        let color = arc4random_uniform(5)
        if color == 0 {
            return SKColor.blueColor()
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
        return SKColor.brownColor()
    }
    
    func rand(max: UInt32) -> Int {
        return Int(arc4random_uniform(max))
    }
    
    func drop() -> SKShapeNode {
        let shadeRect = CGRectMake(0, startVal, self.frame.width, self.frame.height)
        let shade = SKShapeNode(rect: shadeRect)
        shade.name = "shade"
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
            NSUserDefaults.standardUserDefaults().setInteger(Cloud.currency, forKey: DefaultsKeys.currencyKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        let moveToY = SKAction.moveToY(moveHere, duration: duration)
        self.moveToY = moveToY
        
        self.shade = drop()
        self.addChild(shade)
        shade.zPosition = 1
        shade.runAction(moveToY, completion: {
            self.makeCovers = true
            self.delay(self.delayTime){
                self.doneFalling = true
            }
            self.deleteNodes("shade")
            self.moveCovers()
        })
    }
    
    func gameover() {
        deleteNodes("cover")
        deleteNodes("coverShade")
        deleteNodes("shade")
        if score > Cloud.highScore {
            Cloud.highScore = score
            NSUserDefaults.standardUserDefaults().setInteger(Cloud.highScore, forKey: DefaultsKeys.highScoreKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        gameOver = true
        delayTime = 1
        pauseView = makeRestartPanel()
        pauseView.alpha = 0.0
        view!.addSubview(pauseView)
        backButtonInGameOver.setImage(UIImage(named: "back-icon"), forState: .Normal)
        backButtonInGameOver.frame.size = CGSizeMake(120, 85)
        backButtonInGameOver.frame.origin = pauseButton.frame.origin
        if Cloud.model == "iPhone 4s" {
            backButtonInGameOver.center.x -= 15
        }
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
        let scoreLabelText = UILabel(frame: CGRectMake(0, panelMax.y / 4, panelSize.width, 40))
        scoreLabelText.center.y = 37.5 //panelMax.y / 4
        scoreLabelText.text = "Score: \(score)"
        scoreLabelText.textAlignment = NSTextAlignment.Center
        panel.addSubview(scoreLabelText)
        let restartButton = UIButton()
        restartButton.frame = CGRectMake(0, panelMax.y / 2, panelSize.width - 10, 25)
        restartButton.center.y = 75.0 //panelMax.y / 2
        restartButton.setTitle("Restart", forState: .Normal)
        restartButton.backgroundColor = UIColor.blackColor()
        restartButton.addTarget(self, action: #selector(GameScene.restart), forControlEvents: UIControlEvents.TouchUpInside)
        panel.addSubview(restartButton)
        let currencyLabel = UILabel(frame: CGRectMake(0, panelSize.height * (2.85/5), panelSize.width, 25))
        currencyLabel.text = "Coins: \(Cloud.currency)"
        currencyLabel.textAlignment = NSTextAlignment.Center
        panel.addSubview(currencyLabel)
        let highScoreLabel = UILabel(frame: CGRectMake(0, currencyLabel.frame.maxY, panelSize.width, 25))
        highScoreLabel.text = "HighScore: \(Cloud.highScore)"
        highScoreLabel.textAlignment = NSTextAlignment.Center
        panel.addSubview(highScoreLabel)        
        return panel
    }
    
    func moveScore() {
        self.scoreLabel.center.x += 3
    }
    
    func restart() {
        reset()
    }
    
    func reset() {
        player.runAction(SKAction.moveToX(self.frame.midX, duration: 0.39))
        delay(0.4){
            if self.restartTapped{
                self.delay(0.5){
                    self.restartButtonInPauseMenu.removeFromSuperview()
                    self.backButton.removeFromSuperview()
                }
                UIView.animateWithDuration(0.5, animations: {
                    self.restartButtonInPauseMenu.alpha = 0.0
                    self.backButton.alpha = 0.0
                    
                })
                self.restartTapped = false
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
            self.deleteNodes("cover")
            self.deleteNodes("coverShade")
            self.deleteNodes("shade")
            self.itIsPaused = false
            self.deleteNodes("fade")
            self.gameOver = false
            self.doneFalling = true
            self.makeCovers = true
            self.delayChange = 0.7
            self.durationChange = 0.3
            self.minDelay = 0.5
            self.minDur = 1.0
            self.duration = 3
            self.delayTime = 1
            self.radius = 100
            self.start = true
            self.score = 0
            self.scaleFactor = 0.9
        }
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

//
//  GameScene.swift
//  Take Cover
//
//  Created by Alexander Warren on 3/25/16.
//  Copyright © 2016 Alexander Warren. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, UIGestureRecognizerDelegate{
    
    let backButtonInGameOver = UIButton()
    var itIsPaused = false
    var pauseButton = UIButton()
    var scoreLabel = UILabel()
    var userIsTouching = false
    var location = CGPointMake(0, 0)
    let player = SKSpriteNode(imageNamed: "\(Cloud.playerString)\(Cloud.color)")
    var delayTime = 1.0
    var gameOver = false
    var arrayOfRectanglesUnderCovers = [SKShapeNode?]()
    var makeCoversIncrementer = 0
    var shadeFinalYCoordinate:CGFloat = -1360
    var moveToY = SKAction()
    var shade = SKShapeNode()
    var shadeFallDuration:NSTimeInterval = 3
    var doneFalling = true
    var shadeInitialYCoordinate:CGFloat = 600
    var makeCovers = true
    var delayChange = 0.1
    var durationChange = 0.4
    var minDelay = 0.5
    var minDuration = 1.0
    var playerSpeed:CGFloat = 4
    var userCanDie = true
    var score = 0
    var gameIsBeginning = true
    var arrayOfCovers = [SKShapeNode?]()
    let restartButtonInPauseMenu = UIButton()
    let backButton = UIButton()
    let background = SKSpriteNode()
    var coverRadius:CGFloat = 0
    var pauseView = UIView()
    var scaleFactor:CGFloat = 0.9
    let tutorialView = UIView()
    var tutorialBeingShown = Bool()
    
    let titleLabel = UILabel()
    
    let coverLabel = UILabel()
    let coverArrow = UIImageView(image: UIImage(named: "back-icon"))

    let roomArrow = UIImageView(image: UIImage(named: "back-icon"))
    let roomLabel = UILabel()

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        if Cloud.sound {
            delay(2.1){
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let titleMusicPlayer = appDelegate.musicPlayer
            titleMusicPlayer.stop()
            appDelegate.music = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("GameMusic", ofType: "mp3")!)
            titleMusicPlayer.volume = 1
            appDelegate.play()
            }
        }
        
        if Cloud.showTutorial {
            makeTutorialView()
            tutorialBeingShown = true
        }
        
        switch Cloud.themeString {
        case "dark":
            background.color = UIColor.lightGrayColor()
        case "disco":
            background.color = randColor()
        default:
            background.color = UIColor.whiteColor()
        }
        
        //Change size of covers according to screen size
        switch Cloud.model {
        case "iPhone 6":
            coverRadius = CGFloat(M_PI_4) * 100
            break
        case "iPhone 5":
            coverRadius = 90
            break
        case "iPhone 6+":
            coverRadius = 70
            break
        case "iPhone 4s":
            coverRadius = 85
            break
        default:
            break
        }
        
        //Back button
        setupButton(backButton,
                    center: CGPoint(x: view.frame.midX - 200, y: 210),
                    origin: nil,
                    size: CGSizeMake(120, 85),
                    image: (UIImage(named: "back-icon"))!,
                    title: nil,
                    selector: #selector(GameScene.backButtonPressed),
                    superview: nil)
        if Cloud.model == "iPhone 4s" {
            backButton.center.x += 40
        }
        
        //Restart button (in pause menu)
        setupButton(restartButtonInPauseMenu,
                    center: CGPoint(x: view.frame.midX, y: 210),
                    origin: nil,
                    size: CGSizeMake(100, 100),
                    image: (UIImage(named: "restart"))!,
                    title: nil,
                    selector: #selector(GameScene.restartButtonTapped),
                    superview: nil)
        
        self.moveToY = SKAction.moveToY(shadeFinalYCoordinate, duration: shadeFallDuration)
        
        //Pause button
        setupButton(pauseButton,
                    center: nil,
                    origin: CGPointMake(50, 50),
                    size: CGSizeMake(50, 50),
                    image: (UIImage(named: "pausebutton"))!,
                    title: nil,
                    selector: #selector(GameScene.pauseButtonPressed),
                    superview: nil)
        pauseButton.alpha = 0
        
        delay(0.5){
            self.view?.addSubview(self.pauseButton)
            UIView.animateWithDuration(0.5, animations: {
                self.pauseButton.alpha = 1.0
            })
        }
        
        //Score label
        setupLabel(scoreLabel,
                   center: nil,
                   origin: CGPointMake(20, 20),
                   size: CGSizeMake(30, 120),
                   text: "0",
                   superview: self.view!,
                   numberOfLines: 1)
        
        for _ in 1...3 {
            arrayOfRectanglesUnderCovers.append(nil)
            arrayOfCovers.append(nil)
        }
        
        //Background
        background.size = self.frame.size
        background.position = CGPoint(x:CGRectGetMidX(self.frame),y:CGRectGetMidY(self.frame))
        background.zPosition = 0
        self.addChild(background)
        
        //Player
        player.size = CGSize(width: 50, height: 50)
        player.position.x = self.frame.maxX / 2
        player.position.y = self.frame.minY + 200
        player.zPosition = 4
        self.addChild(player)
        
    }
    
    //When the pause button is pressed (because you can't pass parameters in selectors)
    func pauseButtonPressed() {
        pause(false)
    }
    
    //Back button pressed
    func backButtonPressed(){
        reset(false)
        scoreLabel.removeFromSuperview()
        pauseButton.removeFromSuperview()
        restartButtonInPauseMenu.removeFromSuperview()
        backButton.removeFromSuperview()
        pauseView.removeFromSuperview()
        let skView = self.view! as SKView
        let scene = TitleScene(fileNamed:"TitleScene")
        scene!.scaleMode = .AspectFill
        skView.presentScene(scene)
    }
    
    //Restart button pressed
    func restartButtonTapped(){
        reset(true)
    }
    
    func pause(isTutorial: Bool){
        itIsPaused = !itIsPaused
        let fade = SKShapeNode(rectOfSize: self.frame.size, cornerRadius: 0.0)
        fade.name = "fade"
        if itIsPaused {                                         //If it went from unpaused to paused
            if !isTutorial {                                    //If not tutorial
                view!.addSubview(restartButtonInPauseMenu)      //Add buttons
                view!.addSubview(backButton)
                restartButtonInPauseMenu.alpha = 0.0
                backButton.alpha = 0.0
                UIView.animateWithDuration(0.5, animations: {
                    self.restartButtonInPauseMenu.alpha = 1.0
                    self.backButton.alpha = 1.0
                })
            }else{                                              //If it is tutorial
                UIView.animateWithDuration(0.5, animations: {
                    self.pauseButton.alpha = 0
                })
            }
            
            //Pause scene
            self.scene?.paused = true
            
            fade.position = CGPoint(x: self.position.x + (self.size.width / 2), y: self.position.y + (self.size.height / 2))
            fade.fillColor = UIColor.whiteColor()
            self.addChild(fade)
            fade.alpha = 0.5
            fade.zPosition = 5
        }else{                                                  //If it went from paused to unpaused
            delay(0.5){
                self.restartButtonInPauseMenu.removeFromSuperview()
                self.backButton.removeFromSuperview()
            }
            deleteNodes("fade")
            UIView.animateWithDuration(0.5, animations: {
                self.restartButtonInPauseMenu.alpha = 0.0
                self.backButton.alpha = 0.0
                
            })
            
            //Unpause scene
            self.scene?.paused = false
            
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        userIsTouching = true
        for touch in touches {
            location = touch.locationInNode(self)
        }
        
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userIsTouching = true
        for touch in touches {
            location = touch.locationInNode(self)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        userIsTouching = false
    }
    
    override func update(currentTime: CFTimeInterval) {
        scoreLabel.text = String(score)
        if !gameOver {                                      //If the game is not over
            if doneFalling {                                //If the shade is done falling
                if !itIsPaused {                            //If the game is not paused
                    fall()                                  //Have the shade fall
                    
                    doneFalling = false
                    if delayTime >= minDelay {
                        delayTime -= delayChange
                    }
                    if shadeFallDuration > minDuration {
                        shadeFallDuration *= 0.98
                    }
                }
            }
            if gameIsBeginning {
                if makeCovers {
                    var color = UIColor()
                    
                    //Set color
                    switch Cloud.themeString {
                    case "dark":
                        color = UIColor.blackColor()
                    case "disco":
                        color = randColorThatsNotBackgroundColor()
                    default:
                        color = UIColor.lightGrayColor()
                    }
                    
                    //Make covers according to iPhone model
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
                gameIsBeginning = false
            }
            
            if userIsTouching && !itIsPaused {
                moveSprite(player)
            }
            var inRect = 0
            var deathCheckIncrementor = 1
            if userCanDie {
                
                //Death check
                for node in arrayOfRectanglesUnderCovers {
                    if ((node?.containsPoint(CGPoint(x: player.frame.minX, y: player.frame.maxY))) != false) || ((node?.containsPoint(CGPoint(x: player.frame.maxX, y: player.frame.maxY))) != false) {
                        inRect += 1
                    }
                    if ((node?.containsPoint(CGPoint(x: player.frame.minX, y: player.frame.maxY))) != false) && ((node?.containsPoint(CGPoint(x: player.frame.maxX, y: player.frame.maxY))) != false) {
                        break
                    }else{
                        if shade.containsPoint(CGPoint(x: player.frame.minX, y: player.frame.maxY)) != false || shade.containsPoint(CGPoint(x: player.frame.maxX, y: player.frame.maxY)) != false {
                            if !(inRect == 2) {
                                if deathCheckIncrementor % 3 == 0 {
                                    gameover()
                                    deathCheckIncrementor = 1
                                    break
                                }
                            }
                        }
                        deathCheckIncrementor += 1
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
        
        //Cover
        let cover = SKShapeNode(circleOfRadius: coverRadius)
        let circleWidth = cover.frame.size.width
        cover.position = position
        cover.strokeColor = SKColor.lightGrayColor()
        cover.glowWidth = 1
        cover.zPosition = 3
        cover.name = "cover"
        
        //Fill color according to theme
        switch Cloud.themeString {
        case "classic":
            cover.fillColor = UIColor.whiteColor()
            cover.fillTexture = SKTexture(imageNamed: "CircleGradient")
        default:
            cover.fillColor = color
        }
        
        self.addChild(cover)
        
        //Rectangle under cover
        let rect = SKShapeNode(rect: CGRectMake(position.x - (circleWidth / 2) + 1, position.y - self.frame.minY, circleWidth - 2, self.frame.minY - position.y))
        rect.fillColor = background.color
        rect.zPosition = 2
        rect.name = "coverShade"
        rect.strokeColor = UIColor.clearColor()
        self.addChild(rect)
        self.arrayOfRectanglesUnderCovers[makeCoversIncrementer] = rect
        self.arrayOfCovers[makeCoversIncrementer] = cover
        
        if makeCoversIncrementer == 2 {
            makeCoversIncrementer = 0
        }else{
            makeCoversIncrementer += 1
        }
        
    }
    
    func moveCovers() {
        if Cloud.themeString == "disco" {
            background.color = randColor()
            for node in arrayOfCovers {
                node!.fillColor = randColorThatsNotBackgroundColor()
            }
        }
        var incrementor = 0
        deleteNodes("coverShade")
        if scaleFactor >= 0.6 && score % 3 == 0 {   //Compute size of cover
            scaleFactor -= 0.05
        }
        for node in arrayOfCovers {
            let x = rand(1020)
            let moveCover = SKAction.moveToX(CGFloat(x), duration: delayTime)
            node!.runAction(moveCover)              //Move cover to random x coordinate
            let holderSizeNode = SKShapeNode(circleOfRadius: coverRadius)
            let scaleAction = SKAction.scaleTo(scaleFactor, duration: delayTime)
            if scaleFactor >= 0.5 && score % 3 == 0 {
                node?.runAction(scaleAction)        //Scale cover
            }
            
            //Compute rectangle size
            let rectangle = CGRectMake(CGFloat(x) - ((holderSizeNode.frame.width * scaleFactor) / 2), node!.position.y, ((holderSizeNode.frame.width) * scaleFactor), self.frame.minY - node!.position.y)
            let recta = SKShapeNode(rect: rectangle)
            recta.zPosition = 2
            recta.fillColor = background.color
            recta.name = "coverShade"
            recta.lineWidth = 0.0
            self.addChild(recta)
            arrayOfRectanglesUnderCovers[incrementor] = recta
            
            incrementor += 1
        }
    }
    
    //For the background in disco mode
    func randColor() -> SKColor {
        let arrayOfColors: [SKColor] = [SKColor.blueColor(), SKColor.redColor(), SKColor.magentaColor(), SKColor.yellowColor(), SKColor.greenColor()]
        return arrayOfColors[rand(5)]
    }
    
    //For the covers in disco mode
    func randColorThatsNotBackgroundColor() -> SKColor {
        let arrayOfColors: [SKColor] = [SKColor.redColor(), SKColor.blackColor(), SKColor.blueColor(), SKColor.yellowColor(), SKColor.greenColor()]
        let randNum = rand(5)
        if arrayOfColors[randNum] != background.color {
            return arrayOfColors[randNum]
        } else if randNum != 4 {
            return arrayOfColors[randNum + 1]
        } else {
            return arrayOfColors[randNum - 1]
        }
    }
    
    func rand(max: UInt32) -> Int {
        return Int(arc4random_uniform(max))
    }
    
    //Makes and returns the shade
    func makeShade() -> SKShapeNode {
        let shadeRect = CGRectMake(0, shadeInitialYCoordinate, self.frame.width, self.frame.height)
        let shade = SKShapeNode(rect: shadeRect)
        shade.name = "shade"
        shade.zPosition = 1
        shade.fillTexture = SKTexture(imageNamed: randShadeTex())
        shade.fillColor = UIColor.whiteColor()
        shade.lineWidth = 0
        return shade
    }
    
    func fall() {
        if !gameIsBeginning {
            score += 1
            Cloud.currency += 5
            NSUserDefaults.standardUserDefaults().setInteger(Cloud.currency, forKey: DefaultsKeys.currencyKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        //Moving shade
        let moveToY = SKAction.moveToY(shadeFinalYCoordinate, duration: shadeFallDuration)
        self.moveToY = moveToY
        
        //Shade
        self.shade = makeShade()
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
        Cloud.gameCounter += 1
        if Cloud.gameCounter % 10 == 0 {
            if Cloud.canAskForRating {
                askForRating()
            }
        }
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
        
        //Back button in the game ver menu
        setupButton(backButtonInGameOver,
                    center: nil,
                    origin: pauseButton.frame.origin,
                    size: CGSizeMake(120, 85),
                    image: (UIImage(named: "back-icon"))!,
                    title: nil,
                    selector: #selector(GameScene.backButtonPressed),
                    superview: self.view!)
        backButtonInGameOver.alpha = 0
        if Cloud.model == "iPhone 4s" {
            backButtonInGameOver.center.x -= 15
        }
        
        //Show pause view
        UIView.animateWithDuration(0.5, animations: {
            self.pauseView.alpha = 1.0
            self.pauseButton.alpha = 0.0
            self.backButtonInGameOver.alpha = 1.0
        })
    }
    
    func askForRating(){
        let theAlertVC = UIAlertController(title: "Rate Take Cover", message: "Would you like to rate our app on the app store?", preferredStyle: .Alert)
        theAlertVC.addAction(UIAlertAction(title: "Rate", style: UIAlertActionStyle.Default, handler: {
            (Bool) in
            Cloud.canAskForRating = false
            UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1126598806")!)
            
        }))
        theAlertVC.addAction(UIAlertAction(title: "Not Now", style: UIAlertActionStyle.Default, handler: nil))
        theAlertVC.addAction(UIAlertAction(title: "Do not ask again", style: UIAlertActionStyle.Destructive, handler: {
            (Bool) in
            Cloud.canAskForRating = false
        }))
        let currentViewController:UIViewController=UIApplication.sharedApplication().keyWindow!.rootViewController!
        currentViewController.presentViewController(theAlertVC, animated: true, completion: nil)

    }
    
    //Restart view
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
        let panelCent = self.view!.convertPoint(panel.center, toView: panel)
        let scoreLabelText = UILabel()
        
        //Score label
        setupLabel(scoreLabelText,
                   center: CGPointMake(75, 37.5),
                   origin: nil,
                   size: CGSizeMake(panelSize.width, 40),
                   text: "Score: \(score)",
                   superview: panel,
                   numberOfLines: 1)
        scoreLabelText.textAlignment = NSTextAlignment.Center
        
        //Restart button
        let restartButton = UIButton()
        setupButton(restartButton,
                    center: CGPointMake(panelCent.x, 75),
                    origin: nil,
                    size: CGSizeMake(panelSize.width - 10, 25),
                    image: nil,
                    title: "Restart",
                    selector: #selector(GameScene.reset),
                    superview: panel)
        restartButton.backgroundColor = UIColor.blackColor()
        scoreLabelText.textAlignment = NSTextAlignment.Center
        
        //Currency label
        let currencyLabel = UILabel()
        setupLabel(currencyLabel,
                   center: nil,
                   origin: CGPointMake(0, panelSize.height * (2.85/5)),
                   size: CGSizeMake(panelSize.width, 25),
                   text: "Coins: \(Cloud.currency)",
                   superview: panel,
                   numberOfLines: 1)
        currencyLabel.textAlignment = NSTextAlignment.Center
        
        //High score label
        let highScoreLabel = UILabel()
        setupLabel(highScoreLabel,
                   center: CGPointMake(panelCent.x, panelMax.y - 30),
                   origin: nil,
                   size: CGSizeMake(panelSize.width, 25),
                   text: "HighScore: \(Cloud.highScore)",
                   superview: panel,
                   numberOfLines: 1)
        highScoreLabel.textAlignment = NSTextAlignment.Center
        
        return panel
    }
    
    func reset(restartButtonWasTapped: Bool) {
        if (self.scene?.paused)! {
            self.scene?.paused = false
        }
        player.runAction(SKAction.moveToX(self.frame.midX, duration: 0.39)) //Moves player back to middle
        delay(0.4){
            if restartButtonWasTapped{
                //Fade and remove
                self.delay(0.5){
                    self.restartButtonInPauseMenu.removeFromSuperview()
                    self.backButton.removeFromSuperview()
                }
                UIView.animateWithDuration(0.5, animations: {
                    self.restartButtonInPauseMenu.alpha = 0.0
                    self.backButton.alpha = 0.0
                    
                })
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
            self.minDuration = 1.0
            self.shadeFallDuration = 3
            self.delayTime = 1
            self.gameIsBeginning = true
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
    
    //For shade
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
    
    //Tutorial
    func makeTutorialView() {
        delay(1){
            self.tutorialOne()
        }
    }
    
    //Tutorial one: explains the cover
    func tutorialOne() {
        let tutViewSizeRatioX: CGFloat = 3.5/5
        let tutViewSizeRatioY: CGFloat = 5/7
        self.tutorialView.frame.size = CGSizeMake(self.view!.frame.size.width * (tutViewSizeRatioX) - 50, (self.view!.frame.size.height * tutViewSizeRatioY) + 50)
        self.tutorialView.backgroundColor = UIColor.whiteColor()
        self.tutorialView.center = CGPointMake(self.view!.frame.maxX * (tutViewSizeRatioX) - 50, (self.view!.center.y * tutViewSizeRatioY) + (self.tutorialView.frame.size.height / 2) - 100)
        self.tutorialView.layer.borderWidth = 5
        self.tutorialView.layer.borderColor = UIColor.blueColor().CGColor
        self.tutorialView.layer.cornerRadius = 20
        self.tutorialView.alpha = 0
        
        //Title label
        self.setupLabel(titleLabel,
                        center: CGPointMake(self.view!.convertPoint(self.tutorialView.center, toView: self.tutorialView).x, 30),
                        origin: nil,
                        size: nil,
                        text: "TUTORIAL",
                        superview: self.tutorialView,
                        numberOfLines: 1)
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.alpha = 0

        let convertedTutCenter = self.view!.convertPoint(self.tutorialView.center, toView: self.tutorialView)

        //Cover label
        self.setupLabel(coverLabel,
                        center: CGPointMake(titleLabel.center.x, convertedTutCenter.y - 20),
                        origin: nil,
                        size: nil,
                        text: "This is a Cover.\nHide under it to survive",
                        superview: self.tutorialView,
                        numberOfLines: 2)
        coverLabel.textAlignment = NSTextAlignment.Center
        coverLabel.alpha = 0
        
        self.view!.addSubview(self.tutorialView)
        UIView.animateWithDuration(0.5, animations: {
            self.tutorialView.alpha = 1
            self.titleLabel.alpha = 1
        })
        self.pause(true)
        
        //Cover arrow
        coverArrow.frame = CGRectMake(25, coverLabel.center.y, 68, 28)
        coverArrow.alpha = 0
        self.tutorialView.addSubview(coverArrow)
        
        UIView.animateWithDuration(0.8, animations: {
            self.coverArrow.alpha = 1
            self.coverLabel.alpha = 1
            }, completion: { (Bool) in
                self.tutorialTwo()
        })
    }
    
    //Tutorial two: explains the rectangle under the cover
    func tutorialTwo() {
        
        let convertedTutCenter = self.view!.convertPoint(self.tutorialView.center, toView: self.tutorialView)
        
        //Room arrow
        roomArrow.frame = CGRectMake(25, convertedTutCenter.y + 100, 68, 28)
        roomArrow.alpha = 0
        self.tutorialView.addSubview(roomArrow)
        
        //Room label
        self.setupLabel(roomLabel,
                        center: CGPointMake(convertedTutCenter.x, roomArrow.center.y),
                        origin: nil,
                        size: nil,
                        text: "This is where you\nhave to go.",
                        superview: self.tutorialView,
                        numberOfLines: 2)
        roomLabel.textAlignment = NSTextAlignment.Center
        roomLabel.alpha = 0
        
        UIView.animateWithDuration(0.8, animations: {
            self.roomArrow.alpha = 1
            self.roomLabel.alpha = 1
        })
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(GameScene.tutorialThree(_:)))
        tutorialView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //Tutorial three: explains how to move
    func tutorialThree(sender: UITapGestureRecognizer) {
        self.tutorialView.removeGestureRecognizer(sender)
        self.tutorialFadeElementsWithDuration(0.8, element1: roomArrow, element2: roomLabel)
        self.tutorialFadeElementsWithDuration(0.8, element1: coverArrow, element2: coverLabel)
        
        
            let convertedTutCenter = self.view!.convertPoint(self.tutorialView.center, toView: self.tutorialView)
            
            //Tutorial finale label
            let endTutLabel = UILabel()
            self.setupLabel(endTutLabel,
                            center: convertedTutCenter,
                            origin: nil,
                            size: nil,
                            text: "Slide with your finger to take cover.",
                            superview: self.tutorialView,
                            numberOfLines: 1)
            endTutLabel.alpha = 0
            
            //Got it button (end button)
            let gotItButton = UIButton()
            self.setupButton(gotItButton,
                             center: nil,
                             origin: CGPointMake(convertedTutCenter.x - 22.5, convertedTutCenter.y + 30),
                             size: CGSizeMake(45, 34),
                             image: nil,
                             title: "Got It",
                             selector: #selector(GameScene.endTutorial),
                             superview: self.tutorialView)
            gotItButton.setTitleColor(self.view!.tintColor, forState: .Normal)
            gotItButton.setTitleColor(UIColor.blueColor(), forState: .Highlighted)
            gotItButton.alpha = 0
            
            UIView.animateWithDuration(0.8, animations: {
                endTutLabel.alpha = 1
                gotItButton.alpha = 1
            })
    }
    
    func tutorialFadeElementsWithDuration(duration: Double, element1: UIView, element2: UIView) {
        UIView.animateWithDuration(duration, animations: {
            element1.alpha = 0
            element2.alpha = 0
        })
    }
    
    func endTutorial() {
        //Fade out
        UIView.animateWithDuration(1, animations: {
            self.tutorialView.alpha = 0
            self.pauseButton.alpha = 1
            }, completion: { finished in
                self.pause(false)
                Cloud.showTutorial = false
                //Set defaults
                NSUserDefaults.standardUserDefaults().setBool(false, forKey: DefaultsKeys.showTutorialKey)
                NSUserDefaults.standardUserDefaults().synchronize()
                self.tutorialBeingShown = false
        })
    }

    
    func setupButton(button: UIButton, center: CGPoint?, origin: CGPoint?, size: CGSize?, image: UIImage?, title: String?, selector: Selector, superview: UIView?){
        if size != nil {
            button.frame.size = size!
        }
        if image != nil {
            button.setImage(image!, forState: .Normal)
        }else if title != nil{
            button.setTitle(title, forState: .Normal)
        }
        button.addTarget(self, action: selector, forControlEvents: .TouchUpInside)
        if origin != nil {
            button.frame.origin = origin!
        }else if center != nil {
            button.center = center!
        }
        if superview != nil {
            superview!.addSubview(button)
        }
    }
    
    func setupLabel(label: UILabel, center: CGPoint?, origin: CGPoint?, size: CGSize?, text: String, superview: UIView, numberOfLines: Int){
        label.text = text
        label.numberOfLines = numberOfLines
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
        superview.addSubview(label)
    }

}

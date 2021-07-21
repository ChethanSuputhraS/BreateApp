//
//  Stretch-Hero
//  StickHeroGameScene.swift
//
//  Created by Jeremy Labrado on 30/05/16.
//  jeremy.labrado@stretchsense.com
//  Copyright © 2016 StretchSense. All rights reserved.
//

import SpriteKit

class StretchHeroGameScene: SKScene, SKPhysicsContactDelegate {
    
    // Nodes Gaming
    var hero: Hero!
    var stick : SKSpriteNode = SKSpriteNode()
    var buildingLeft : Building!
    var buildingRight : Building!
    // Nodes Label
    let clickToStartLabel = SKLabelNode()
    let counterLabel = SKLabelNode()
    let gameOverLabel = SKLabelNode()
    let scoreLabel = SKLabelNode()
    let highscoreLabel = SKLabelNode()
    let perfectLabel = SKLabelNode()
    // variable
    var gap : CGFloat = 10
    var stickHeight:CGFloat = 0
    let HighScoreRepository = "com.stickHero.score"
    // Timer
    var repeateTimer = Timer()
    var counter = COUNTER_INITIAL_VALUE{
        willSet {
            counterLabel.alpha = 1
            counterLabel.text = "\(newValue)"
            counterLabel.run(SKAction.sequence([SKAction.scale(to: 2, duration: 0.1), SKAction.scale(to: 1, duration: 0.1)]))
        }
    }
    // game variable
    var isBegin = false
    var isEnd = false
    var gameOver = false {
        willSet {
            if (newValue) { // if gameOver = true
                checkHighScoreAndStore()
                
                gameOverLabel.run(blink)
                highscoreLabel.run(blink)
                
                stick.removeAllActions()
                stick.run(disappear)

                counterLabel.removeAllActions()
                counterLabel.run(disappear)
            }
            else{ // if gameOver = false
                gameOverLabel.removeAllActions()
                gameOverLabel.alpha = 0
                highscoreLabel.removeAllActions()
                highscoreLabel.alpha = 0
            }
        }
    }
    var score:Int = 0 {
        willSet {
            scoreLabel.text = "\(newValue)"
        }
    }
    var highscore = 0 {
        willSet {
            highscoreLabel.text = "HighScore: \(highscore)"
        }
    }
 
    //MARK: FUNCTIONS
    
    override init(size: CGSize) {
        print("init()")
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self
        
        isBegin = false
        isEnd = false
        
        highscore = UserDefaults.standard.integer(forKey: HighScoreRepository)
    }

    override func didMove(to view: SKView) {
        print("didMoveToView()")
        // load label and nodes
        loadEverything()
        // make the label clickToStart blink to ask the user to start
        clickToStartLabel.run(blink)
    }
    
    func loadEverything() {
        print("loadEverything()")
        removeAllChildren()
        
        loadBackground()
        loadScoreLabel()
        loadClickToStartLabel()
        loadGameOverLabel()
        loadHighScoreLabel()
        loadPerfectLabel()
        loadCounterLabel()
        
        loadBuildingLeft()
        loadHero()
        loadStick()
        loadBuildingRight()
        
        gameOver = false
        isBegin = false
        isEnd = false
        score = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touchBegan()")
        
        if gameOver {
            // If the game was over, restart everything
            gameOver = false
            self.loadEverything()
        }
        clickToStartLabel.removeAllActions()
        clickToStartLabel.alpha = 0
        startGame()
    }
    
    func startGame(){
        print("startGame()")
        if !isBegin && !isEnd {
            isBegin = true
            startPlaying()
        }
    }
    
    func startPlaying(){
        print("startPlaying()")
        if !gameOver {
            isBegin = true
            loadStick()
            if score > 7 {
                counter = 13
            }
            else{
                counter = 20 - score
            }
            // repeat the function stickIsTheSensor() until var repeateTimer is invalidate
            repeateTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(stickIsTheSensor), userInfo: nil, repeats: true)
        }
    }
    
    @objc func stickIsTheSensor(){
        print("stickIsTheSensor()")
        isBegin = true
        counter -= 1
        // The valueRelative is get from the sensor and its 0 < valueRelative < 1
        // We multiply by 1000 to reach the whole screen
        //let resizeStickAction = SKAction.resize(toHeight: CGFloat(valueRelative*1000), duration: 0.1)
        let resizeStickAction = SKAction.resize(toHeight: CGFloat(valueRelative*self.size.width), duration: 0.1)
        stick.run(resizeStickAction)
        
        if counter <= 0 {
            repeateTimer.invalidate()
            stick.removeAllActions()
            
            stickHeight = stick.size.height;
            
            let actionRotation = SKAction.rotate(toAngle: CGFloat(-M_PI / 2), duration: 0.4, shortestUnitArc: true)

            stick.run(SKAction.sequence([actionWait, actionRotation]), completion: {[unowned self] () -> Void in
                // after the stik's rotation, move the hero and check if he reach the right building
                self.moveHeroAndCheck(self.checkTouchTheRightBuilding())
                })
        }
    }
    
    fileprivate func moveHeroAndCheck(_ pass:Bool) {
        print("moveHeroAndCheck()")
        let PointToGo = stick.position.x + self.stickHeight
        
        if pass {
            hero.startRunning()
            hero.run(moveToX(PointToGo), completion: { [unowned self]() -> Void in
                self.score += 1
                self.hero.stop()
                self.moveEverythingAndCreateNewRightBuilding()
            }) 
        }
        else {
            hero.startRunning()
            hero.run(moveToX(PointToGo), completion: { [unowned self]() -> Void in
                self.stick.run(SKAction.rotate(toAngle: CGFloat(-M_PI), duration: 0.4))
                self.hero.fall()
                self.hero.stop()
                
                self.run(SKAction.wait(forDuration: 0.5), completion: {[unowned self] () -> Void in
                    self.gameOver = true
                    })
                }) 
            return
        }
    }

    fileprivate func checkTouchTheRightBuilding() -> Bool {
        print("checkTouchTheRightBuilding()")
        let touchingPointOfTheStick = stick.position.x + self.stickHeight
        
        let xMinOfBuildingRight = buildingRight.position.x - buildingRight.width / 2
        let xMaxOfBuildingRight = buildingRight.position.x + buildingRight.width / 2
        
        if (xMinOfBuildingRight < touchingPointOfTheStick) &&  (touchingPointOfTheStick <  xMaxOfBuildingRight){
            checkTouchMiddleOfTheBuilding(touchingPointOfTheStick)
            return true
        }
        else {
            return false
        }
    }
    
    func checkTouchMiddleOfTheBuilding(_ touchingPoint: CGFloat){
        if (buildingRight.position.x-20 < touchingPoint) &&  (touchingPoint <  buildingRight.position.x+20){
            let sequence = SKAction.sequence([appear, disappear])
            perfectLabel.run(sequence)
            perfectLabel.alpha = 0
            score += 1
        }
    }
    
    func moveEverythingAndCreateNewRightBuilding(){
        let actionMoveOnTheLeft = SKAction.move(by: CGVector(dx: -stickHeight - hero.size.width / 2, dy: 0), duration: 0.3)
        
        buildingRight?.run(actionMoveOnTheLeft)
        hero.run(actionMoveOnTheLeft)
        stick.run(actionMoveOnTheLeft)
        buildingLeft?.run(actionMoveOnTheLeft, completion: {[unowned self] () -> Void in
            self.stick.run(disappear)
            // The rightBuilding become the leftBuilding
            self.buildingLeft = self.buildingRight
            // Create a new rightBuilding
            self.loadBuildingRight()
            // Everything is set up, start a new game
            self.startPlaying()
            })
    }
    
    fileprivate func checkHighScoreAndStore() {
        highscore = UserDefaults.standard.integer(forKey: HighScoreRepository)
        if (score > Int(highscore)) {
            highscore = score
            launchFirework()
            highscoreLabel.text = "HighScore: \(score)"
            UserDefaults.standard.set(score, forKey: HighScoreRepository)
            UserDefaults.standard.synchronize()
        }
    }
    
    
    fileprivate func launchFirework() {
        fireworkActionAtPosition(CGPoint(x: 0, y: 0))
    }

  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//MARK: - load node
    
    // MARK: Load Label
    
    func loadBackground() {
        print("loadBackground()")
        
        let texture = SKTexture(image: UIImage(named: "stick_background.jpg")!)
        let background = SKSpriteNode(texture: texture)
        background.size = texture.size()
        background.zPosition = backgroundZposition
        self.physicsWorld.gravity = CGVector(dx: 0, dy: GRAVITY)
            
        addChild(background)
    }
    
    func loadScoreLabel() {
        print("loadScoreLabel()")

        let backgroundScoreLabel = SKShapeNode(rect: CGRect(x: 0-120, y: 1024-200-30, width: 240, height: 140), cornerRadius: 50)
        backgroundScoreLabel.zPosition = labelZpostion-1
        backgroundScoreLabel.fillColor = SKColor.black.withAlphaComponent(0.3)
        backgroundScoreLabel.strokeColor = SKColor.black.withAlphaComponent(0.3)
        addChild(backgroundScoreLabel)
        
        scoreLabel.text = "0"
        scoreLabel.fontName = "HelveticaNeue-Bold"
        scoreLabel.position = CGPoint(x: 0, y: screenHeight / 2 - 200)
        scoreLabel.fontColor = SKColor.white
        scoreLabel.fontSize = 100
        scoreLabel.zPosition = labelZpostion
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.alpha = 1

        addChild(scoreLabel)
    }
    
    func loadCounterLabel() {
        print("loadCounterLabel()")

        
        counterLabel.text = "\(COUNTER_INITIAL_VALUE)"
        //counterLabel.fontName = "HelveticaNeue-Bold"
        counterLabel.position = CGPoint(x: 0, y: screenHeight / 2 - 450 )
        counterLabel.fontColor = SKColor.blue
        counterLabel.fontSize = 100
        counterLabel.zPosition = labelZpostion
        counterLabel.horizontalAlignmentMode = .center
        counterLabel.alpha = 0
        
        addChild(counterLabel)
    }
    
    func loadClickToStartLabel() {
        print("loadClickToStartLabel()")

        
        clickToStartLabel.text = "Click to start"
        clickToStartLabel.fontName = "HelveticaNeue-Bold"
        clickToStartLabel.position = CGPoint(x: 0, y: -500)
        clickToStartLabel.fontColor = SKColor.red
        clickToStartLabel.fontSize = 150
        clickToStartLabel.zPosition = labelZpostion
        clickToStartLabel.horizontalAlignmentMode = .center
        clickToStartLabel.alpha = 1
    
        addChild(clickToStartLabel)
    }
    
    func loadPerfectLabel() {
        print("loadPerfectLabel()")

        perfectLabel.text = "Perfect +1"
        perfectLabel.fontName = "HelveticaNeue-Bold"
        perfectLabel.position = CGPoint(x: 0, y: -500)
        perfectLabel.fontColor = SKColor.red
        perfectLabel.fontSize = 150
        perfectLabel.zPosition = labelZpostion
        perfectLabel.horizontalAlignmentMode = .center
        perfectLabel.alpha = 0
        
        addChild(perfectLabel)
    }
    
    func loadGameOverLabel() {
        print("loadGameOverLabel()")

        
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontName = "HelveticaNeue-Bold"
        gameOverLabel.position = CGPoint(x: 0, y: -450)
        gameOverLabel.fontColor = SKColor.red
        gameOverLabel.fontSize = 150
        gameOverLabel.zPosition = labelZpostion
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.alpha = 0
        
        addChild(gameOverLabel)
        }

    func loadHighScoreLabel(){
        print("loadHighScoreLabel()")

        highscoreLabel.text = "HighScore: \(highscore)"
        highscoreLabel.fontName = "HelveticaNeue-Bold"
        highscoreLabel.position = CGPoint(x: 0, y: -550)
        highscoreLabel.fontColor = SKColor.red
        highscoreLabel.fontSize = 100
        highscoreLabel.zPosition = labelZpostion
        highscoreLabel.horizontalAlignmentMode = .center
        highscoreLabel.alpha = 1
        
        addChild(highscoreLabel)
    }
    
    // MARK: Load Game Node
    
    func loadStick(){
        print("loadStick()")

        stick = SKSpriteNode(color: SKColor.black, size: CGSize(width: 12, height: 1))
        stick.zPosition = stickZpostion
        stick.anchorPoint = CGPoint(x: 0.5, y: 0);
        stick.position = CGPoint(x: hero.position.x + hero.size.width / 2, y: hero.position.y - hero.size.height / 2)
        
        addChild(stick)
    }
    
    func loadBuildingLeft() {
        print("loadBuildingLeft()")

        buildingLeft = Building(widthParam: 100)
        buildingLeft.position.x = -screenWidth / 2 +  buildingLeft.width
        buildingLeft.position.y = -screenHeight / 2 + buildingLeft.height / 2
        buildingLeft.zPosition = buildingZposition
        
        addChild(buildingLeft)
    }
    
    func loadHero() {
        print("loadHero()")

        hero = Hero()
        hero.loadAppearance()
        
        let xHero = buildingLeft.position.x + buildingLeft.width / 2 - hero.size.width / 2
        let yHero = -screenHeight / 2 + BUILDING_HEIGHT + hero.size.height / 2
        hero.position = CGPoint(x: xHero,y: yHero)
        hero.zPosition = heroZposition
        
        hero.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 16, height: 18))
        hero.physicsBody?.affectedByGravity = false
        hero.physicsBody?.allowsRotation = false
        addChild(hero)
        
        //hero.breathe()
    }
    
    func loadBuildingRight() {
        print("loadBuildingRight()")

        buildingRight = Building()
        
        let maxGap = Int(screenWidth - 2 * BUILDING_MAX_WIDTH)
        //gap = CGFloat(randomInRange((BUILDING_GAP_MIN_WIDTH + Int(buildingRight.width))...maxGap)) // SWIFT2
        gap = CGFloat(maxGap) // SWIFT3

        buildingRight.position.x = buildingLeft.position.x + buildingLeft.width / 2 + gap
        buildingRight.position.y = -screenHeight / 2 + buildingRight.height / 2
        buildingRight.zPosition = buildingZposition
        
        addChild(buildingRight)
    }

    // MARK: Action
    func fireworkActionAtPosition(_ position: CGPoint) -> SKAction {
        print("fireworkActionAtPosition()")

        let emitter = SKEmitterNode(fileNamed: "StarExplosion")
        emitter?.position = position
        emitter?.zPosition = fireworkZpostion
        emitter?.alpha = 0.6
        addChild((emitter)!)
        
        let wait = SKAction.wait(forDuration: 0.15)
        
        return SKAction.run({ () -> Void in
            emitter?.run(wait)
        })
    }
    
}

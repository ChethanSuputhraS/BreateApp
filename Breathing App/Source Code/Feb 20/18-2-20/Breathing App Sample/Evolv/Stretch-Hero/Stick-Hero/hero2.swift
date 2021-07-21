//
//  hero.swift
//  Stretch-Hero
//
//  Created by Jeremy Labrado on 30/05/16.
//  jeremy.labrado@stretchsense.com
//  Copyright © 2016 StretchSense. All rights reserved.
//

import Foundation
import SpriteKit

class Hero2: SKSpriteNode {
    
    var body: SKSpriteNode!
    var arm: SKSpriteNode!
    var leftFoot: SKSpriteNode!
    var rightFoot: SKSpriteNode!
    
    init() {
        let size = CGSizeMake(64, 88)
        
        super.init(texture: nil, color: UIColor.clearColor(), size: size)
        
        loadAppearance()
    }
    
    func loadAppearance() {

        body = SKSpriteNode(color: UIColor.blueColor(), size: CGSizeMake(63, 40))
        body.position = CGPointMake(0, 2)
        addChild(body)
        
        let skinColor = UIColor(red: 207.0/255.0, green: 193.0/255.0, blue: 168.0/255.0, alpha:1.0)
        let goldColor = UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)
        let magentaColor = UIColor(red: 1, green: 0, blue: 1, alpha: 1)
        
        let face = SKSpriteNode(color: goldColor, size: CGSizeMake(40, 25))
        face.position = CGPointMake(30, 0)
        body.addChild(face)
        
        var bodyLine = SKSpriteNode(color: UIColor.magentaColor(), size: CGSizeMake(7, 18))
        bodyLine.position = CGPointMake(-21, 11)
        body.addChild(bodyLine)
        
        var bodyLine2 = bodyLine.copy() as! SKSpriteNode
        bodyLine2.position.x = -11
        body.addChild(bodyLine2)
        
        let eyeColor = UIColor.whiteColor()
        let leftEye = SKSpriteNode(color: eyeColor, size: CGSizeMake(10, 7))
        let rightEye = leftEye.copy() as! SKSpriteNode
        let pupil = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(5,4))
        let leftEar = SKSpriteNode(color: goldColor, size: CGSizeMake(7, 10))
        let rightEar = leftEar.copy() as! SKSpriteNode
        let mouth = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(15, 5))
        
        leftEar.position = CGPointMake(-10, 15)
        face.addChild(leftEar)
        
        rightEar.position = CGPointMake(10, 15)
        face.addChild(rightEar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fall() {
        physicsBody?.affectedByGravity = true
    }
    
    func startRunning() {
        //let rotateBack = SKAction.rotateByAngle(-CGFloat(M_PI)/2.0, duration: 1)
        //arm.runAction(rotateBack)
        
        let up = SKAction.moveByX(0, y: 50, duration: 2)
        let down = SKAction.moveByX(0, y: -50, duration: 2)
        
        body.runAction(up, completion: { () -> Void in
            self.body.runAction(down, completion: { () -> Void in
                self.startRunning()
                })
            })

        
        
        //performOneRunCycle()
    }
    
    func performOneRunCycle() {
        let up = SKAction.moveByX(0, y: 5, duration: 0.05)
        let down = SKAction.moveByX(0, y: -5, duration: 0.05)
        leftFoot.runAction(down, completion: { () -> Void in
            self.leftFoot.runAction(up)
            self.rightFoot.runAction(down, completion: { () -> Void in
                self.rightFoot.runAction(up, completion: { () -> Void in
                    self.performOneRunCycle()
                })
            })
        })
    }
    
    func breathe() {
        let breatheOut = SKAction.moveByX(0, y: -4, duration: 1)
        let breatheIn = SKAction.moveByX(0, y: 4, duration: 1)
        let breath = SKAction.sequence([breatheOut, breatheIn])
        body.runAction(SKAction.repeatActionForever(breath))
    }
    
    func stop() {
        body.removeAllActions()
        leftFoot.removeAllActions()
        rightFoot.removeAllActions()
    }
    
}
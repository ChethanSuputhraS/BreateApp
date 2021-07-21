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

class Hero: SKSpriteNode {
    
    var body: SKSpriteNode!
    var arm: SKSpriteNode!
    var leftFoot: SKSpriteNode!
    var rightFoot: SKSpriteNode!
    
    init() {
        let size = CGSize(width: 64, height: 88)
        
        super.init(texture: nil, color: UIColor.clear, size: size)
        
        loadAppearance()
    }
    
    func loadAppearance() {
        body = SKSpriteNode(color: UIColor.black, size: CGSize(width: self.frame.size.width, height: 80))
        body.position = CGPoint(x: 0, y: 4)
        addChild(body)
        
        let skinColor = UIColor(red: 207.0/255.0, green: 193.0/255.0, blue: 168.0/255.0, alpha: 1.0)
        let face = SKSpriteNode(color: skinColor, size: CGSize(width: self.frame.size.width, height: 24))
        face.position = CGPoint(x: 0, y: 12)
        body.addChild(face)
        
        let eyeColor = UIColor.white
        let leftEye = SKSpriteNode(color: eyeColor, size: CGSize(width: 12, height: 12))
        let rightEye = leftEye.copy() as! SKSpriteNode
        let pupil = SKSpriteNode(color: UIColor.black, size: CGSize(width: 6, height: 6))
        
        pupil.position = CGPoint(x: 4, y: 0)
        leftEye.addChild(pupil)
        rightEye.addChild(pupil.copy() as! SKSpriteNode)
        
        leftEye.position = CGPoint(x: -8, y: 0)
        face.addChild(leftEye)
        
        rightEye.position = CGPoint(x: 28, y: 0)
        face.addChild(rightEye)
        
        let eyebrow = SKSpriteNode(color: UIColor.black, size: CGSize(width: 22, height: 2))
        eyebrow.position = CGPoint(x: -2, y: leftEye.size.height/2)
        leftEye.addChild(eyebrow)
        rightEye.addChild(eyebrow.copy() as! SKSpriteNode)
        
        let armColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
        arm = SKSpriteNode(color: armColor, size: CGSize(width: 16, height: 28))
        arm.anchorPoint = CGPoint(x: 0.5, y: 0.9)
        arm.position = CGPoint(x: -20, y: -14)
        body.addChild(arm)
        
        let hand = SKSpriteNode(color: skinColor, size: CGSize(width: arm.size.width, height: 10))

        hand.position = CGPoint(x: 0, y: -arm.size.height*0.9 + hand.size.height/2)
        arm.addChild(hand)
        
        leftFoot = SKSpriteNode(color: UIColor.black, size: CGSize(width: 18, height: 8))
        leftFoot.position = CGPoint(x: -12, y: -size.height/2 + leftFoot.size.height/2)
        addChild(leftFoot)
        
        rightFoot = leftFoot.copy() as! SKSpriteNode
        rightFoot.position.x = 16
        addChild(rightFoot)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fall() {
        physicsBody?.affectedByGravity = true
    }
    
    func startRunning() {
        let rotateBack = SKAction.rotate(byAngle: -CGFloat(M_PI)/2.0, duration: 0.1)
        arm.run(rotateBack)
        performOneRunCycle()
    }
    
    func performOneRunCycle() {
        let up = SKAction.moveBy(x: 0, y: 5, duration: 0.05)
        let down = SKAction.moveBy(x: 0, y: -5, duration: 0.05)
        leftFoot.run(down, completion: { () -> Void in
            self.leftFoot.run(up)
            self.rightFoot.run(down, completion: { () -> Void in
                self.rightFoot.run(up, completion: { () -> Void in
                    self.performOneRunCycle()
                })
            })
        })
    }
    
    func breathe() {
        let breatheOut = SKAction.moveBy(x: 0, y: -4, duration: 1)
        let breatheIn = SKAction.moveBy(x: 0, y: 4, duration: 1)
        let breath = SKAction.sequence([breatheOut, breatheIn])
        body.run(SKAction.repeatForever(breath))
    }
    
    func stop() {
        body.removeAllActions()
        leftFoot.removeAllActions()
        rightFoot.removeAllActions()
    }
  
    
}

//
//  action.swift
//  Stretch-Hero
//
//  Created by Jeremy Labrado on 31/05/16.
//  jeremy.labrado@stretchsense.com
//  Copyright © 2016 koofrank. All rights reserved.
//

import Foundation
import SpriteKit

// MARK: Actions

let appear = SKAction.fadeAlpha(to: 1, duration: 1)
let disappear = SKAction.fadeAlpha(to: 0, duration: 1)
let blink = SKAction.repeatForever(SKAction.sequence([appear, disappear]))

let actionWait = SKAction.wait(forDuration: 0.2)

let wait = SKAction.wait(forDuration: 0.4)
let grow = SKAction.scale(to: 1.5, duration: 0.4)
let shrink = SKAction.scale(to: 1, duration: 0.2)

func moveToX(_ x:CGFloat) -> SKAction {
    return SKAction.moveTo(x: x, duration: 1 )
}

// MARK: Tool

func randomInRange(range: Range<Int>) -> Int {
    print("radomInRange()")
    let count = UInt32(range.upperBound - range.lowerBound)
    return  Int(arc4random_uniform(count)) + range.lowerBound
}


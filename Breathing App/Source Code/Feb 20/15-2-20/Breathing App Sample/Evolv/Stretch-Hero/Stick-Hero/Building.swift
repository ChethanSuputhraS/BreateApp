//
//  Building.swift
//  Stretch-Hero
//
//  Created by Jeremy Labrado on 30/05/16.
//  jeremy.labrado@stretchsense.com
//  Copyright © 2016 StretchSense. All rights reserved.
//

import Foundation
import SpriteKit

class Building: SKSpriteNode {
    
    var width : CGFloat = CGFloat()
    var height : CGFloat = CGFloat()
    
    var colorBuilding = colors[0].colorValueRGB
    
    var appear: Bool = false
    
    init() { // with: random
        
        let max = Int(BUILDING_MAX_WIDTH / 10)
        let min = Int(BUILDING_MIN_WIDTH / 10)
        //width = CGFloat(randomInRange(min...max) * 10) // SWIFT2
        width = CGFloat(randomInRange(range: Range(min...max)) * 10) // SWIFT3
        //width = CGFloat(min*10) // SWIFT3
        
        height = BUILDING_HEIGHT

        let size = CGSize(width: width, height: height)
        let randomNumberForColor = Int(randomInRange(range: Range(0...colors.count-1))) //SWIFT3

        colorBuilding = colors[randomNumberForColor].colorValueRGB
        
        super.init(texture: nil, color: colorBuilding, size: size)
        loadAppearance()
    }
    
    init(widthParam: CGFloat){ // width: fixed
        height = BUILDING_HEIGHT
        
        //let randomNumberForColor = Int(randomInRange(0...colors.count-1)) //SWIFT2
        //let randomNumberForColor = 0 // SWIFT3
        let randomNumberForColor = Int(randomInRange(range: Range(0...colors.count-1))) //SWIFT3

        colorBuilding = colors[randomNumberForColor].colorValueRGB
        
        let sizeInit2 = CGSize(width: widthParam, height: height)

        width = widthParam
        
        super.init(texture: nil, color: colorBuilding, size: sizeInit2)
        loadAppearance()
    }
    
    func loadAppearance(){
        loadRoof()
        generateWindows()
        loadPerfectPoint()
    }
    
    func loadRoof(){
        let roof = SKSpriteNode(color: UIColor.black, size: CGSize(width: self.frame.size.width + 10 , height: 10))
        roof.position = CGPoint(x: 0, y: height / 2 - 5)
        addChild(roof)
    }
    
    func loadPerfectPoint(){
        let perfectPoint = SKSpriteNode(color: UIColor.red, size: CGSize(width: 40 , height: 20))
        perfectPoint.position = CGPoint(x: 0, y: height / 2 - 10)
        addChild(perfectPoint)
    }
    
    func generateWindows(){
        if width <= 150 {
            let x : CGFloat = 0
            createWindows(x, y: height / 2 - 100)
            createWindows(x, y: height / 2 - 200)
            createWindows(x, y: height / 2 - 300)
        }
        else{
            let x : CGFloat = width/4
            createWindows(x, y: height / 2 - 100)
            createWindows(x, y: height / 2 - 200)
            createWindows(x, y: height / 2 - 300)
            createWindows(-x, y: height / 2 - 100)
            createWindows(-x, y: height / 2 - 200)
            createWindows(-x, y: height / 2 - 300)
        }
    }
    
    func createWindows(_ x: CGFloat, y: CGFloat){
        
        var colorRandom: UIColor
        let rand = arc4random_uniform(2)
        if rand == 0 {
            colorRandom = UIColor.darkGray
        }
        else {
            colorRandom = UIColor.yellow
        }
        
        let windows = SKSpriteNode(color: colorRandom, size: CGSize(width: 50, height: 50))
        windows.position = CGPoint(x: x, y: y)
        addChild(windows)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

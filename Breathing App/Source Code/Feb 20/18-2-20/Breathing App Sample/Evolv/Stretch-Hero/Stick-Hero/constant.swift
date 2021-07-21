//
//  constant.swift
//  Stretch-Hero
//
//  Created by Jeremy Labrado on 26/05/16.
//  jeremy.labrado@stretchsense.com
//  Copyright © 2016 koofrank. All rights reserved.
//

import Foundation
import SpriteKit

var screenWidth : CGFloat = 1536
var screenHeight : CGFloat = 2048

var COUNTER_INITIAL_VALUE = 20

var BUILDING_HEIGHT : CGFloat = 400.0
var BUILDING_MAX_WIDTH : CGFloat = 300.0
var BUILDING_MIN_WIDTH : CGFloat = 100.0

var BUILDING_GAP_MIN_WIDTH : Int = 100

var GRAVITY : CGFloat = -100.0

let backgroundZposition: CGFloat = 0
let buildingZposition: CGFloat = 10
let heroZposition: CGFloat = 20
let stickZpostion: CGFloat = 30
let labelZpostion: CGFloat = 40
let fireworkZpostion: CGFloat = 50

struct Color {
    /// The color name ( Blue, Orange, Green, Red, Purple, Brown, Pink, Grey)
    var colorName: String = "colorName"
    /// The value RGB of the color (Blue, Orange, Green, Red, Purple, Brown, Pink, Grey)
    var colorValueRGB: UIColor = UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1)
}

var colors : [Color] = [
    Color(colorName: "Blue", colorValueRGB: UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1)),
    Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.498039, blue: 0.054902, alpha: 1)),
    Color(colorName: "Green", colorValueRGB: UIColor(red: 0.172549, green: 0.627451, blue: 0.172549, alpha: 1)),
    Color(colorName: "Red", colorValueRGB: UIColor(red: 0.839216, green: 0.152941, blue: 0.156863, alpha: 1)),
    Color(colorName: "Purple", colorValueRGB: UIColor(red: 0.580392, green: 0.403922, blue: 0.741176, alpha: 1)),
    Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.54902, green: 0.337255, blue: 0.294118, alpha: 1)),
    Color(colorName: "Pink", colorValueRGB: UIColor(red: 0.890196, green: 0.466667, blue: 0.760784, alpha: 1)),
    Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
    Color(colorName: "NewColor", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1))
]

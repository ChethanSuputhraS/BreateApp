//
//  ViewController.swift
//  StretchSense Fabric App
//
//  Created by Jeremy Labrado on 26/04/16.
//  Copyright © 2016 StretchSense. All rights reserved.
//  labrado.jeremy@gmail.com

import UIKit
import QuartzCore
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


// MARK: - LINECHART CLASS

class LineChart: UIView {
    
    // MARK: DECLARATION STRUCTURE
    
    struct Grid {
        var visible: Bool = true
        var count: CGFloat = 10
        var color: UIColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1)
    }
    
    struct Axis {
        var visible: Bool = false
        var color: UIColor = UIColor(red: 96/255.0, green: 125/255.0, blue: 139/255.0, alpha: 1)
        var inset: CGFloat = 15//
    }
    
    struct Coordinate {
        // public
        var grid: Grid = Grid()
        var axis: Axis = Axis()
        // private
        fileprivate var linear: LinearScale!
        fileprivate var scale: ((CGFloat) -> CGFloat)!
        fileprivate var invert: ((CGFloat) -> CGFloat)!
        fileprivate var ticks: (CGFloat, CGFloat, CGFloat)!
    }
    
    struct Dots {
        var visible: Bool = true
        var color: UIColor = UIColor.white
        var innerRadius: CGFloat = 4
        var outerRadius: CGFloat = 8
        var innerRadiusHighlighted: CGFloat = 4
        var outerRadiusHighlighted: CGFloat = 8
    }
    
    struct Line {
        var dataStore: [CGFloat] = []
        var colorNumber: Int = 0
    }
    
    // MARK: VARIABLES
    
    var area: Bool = true
    var dots: Dots = Dots()
    var lineStore : [Line] = [Line()]
    var x: Coordinate = Coordinate()
    var y: Coordinate = Coordinate()
    
    var autoMinMax = true
    var max: CGFloat = 900.0
    var min: CGFloat = 0
    
    var lineWidth: CGFloat = 2
    
    // values calculated on init
    fileprivate var drawingHeight: CGFloat = 0 {
        didSet {
            if autoMinMax == true {
                min = getMinimumValue()
                max = getMaximumValue()
            }
            else{
                if max < getMaximumValue() {
                    max = getMaximumValue()
                }
                
                if min > getMinimumValue(){
                    min = getMinimumValue()
                }
            }
            
            y.linear = LinearScale(domain: [min, max], range: [0, drawingHeight])
            y.scale = y.linear.scale()
            y.ticks = y.linear.ticks(Int(y.grid.count))
        }
    }
    
    fileprivate var drawingWidth: CGFloat = 0 {
        didSet {
            //print("drawingWidth???????????????????????????")
            if lineStore.count != 0 {
                let data = lineStore[0].dataStore
                x.linear = LinearScale(domain: [0.0, CGFloat(data.count - 1)], range: [0, drawingWidth])
                x.scale = x.linear.scale()
                x.invert = x.linear.invert()
                x.ticks = x.linear.ticks(Int(x.grid.count))
                
            }
            else{
                let data = [0,0,0,0,0,0,0,0,0,0]
                x.linear = LinearScale(domain: [0.0, CGFloat(data.count - 1)], range: [0, drawingWidth])
                x.scale = x.linear.scale()
                x.invert = x.linear.invert()
                x.ticks = x.linear.ticks(Int(x.grid.count))
                
            }
            /*print("drawingWidth1")
             x.linear = LinearScale(domain: [0.0, CGFloat(data.count - 1)], range: [0, drawingWidth])
             print("drawingWidth2")
             x.scale = x.linear.scale()
             print("drawingWidth3")
             x.invert = x.linear.invert()
             print("drawingWidth4")
             x.ticks = x.linear.ticks(Int(x.grid.count))
             print("drawingWidth5")*/
            
        }
    }
    
    fileprivate var lineLayerStore: [CAShapeLayer] = []
    
    fileprivate var removeAll: Bool = false
    
    //Color of the line by index (1: Blue, 2: Orange ...)
    var colors: [UIColor] = [
        UIColor(red: 0.85, green: 0.38, blue: 0.31, alpha: 1),
        UIColor(red: 0, green: 1, blue: 1, alpha: 1),
        UIColor(red: 1, green: 0, blue: 127/255, alpha: 1),
        UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1),
        UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1),
        UIColor(red: 1, green: 1, blue: 0, alpha: 1),    //
        UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1),
        UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1),
        UIColor(red: 1, green: 0.5, blue: 0, alpha: 1),
        UIColor(red: 0, green: 1, blue: 0, alpha: 1),
        UIColor(red: 0.85, green: 0.38, blue: 0.31, alpha: 1),
        UIColor(red: 0, green: 1, blue: 1, alpha: 1),
        UIColor(red: 1, green: 0, blue: 127/255, alpha: 1),
        UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1),
        UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1),
        UIColor(red: 1, green: 1, blue: 0, alpha: 1),    //
        UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1),
        UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1),
        UIColor(red: 1, green: 0.5, blue: 0, alpha: 1),
        UIColor(red: 0, green: 1, blue: 0, alpha: 1),
        UIColor(red: 0.85, green: 0.38, blue: 0.31, alpha: 1),
        UIColor(red: 0, green: 1, blue: 1, alpha: 1),
        UIColor(red: 1, green: 0, blue: 127/255, alpha: 1),
        UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1),
        UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1),
        UIColor(red: 1, green: 1, blue: 0, alpha: 1),    //
        UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1),
        UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1),
        UIColor(red: 1, green: 0.5, blue: 0, alpha: 1),
        UIColor(red: 0, green: 1, blue: 0, alpha: 1),
        UIColor(red: 0.85, green: 0.38, blue: 0.31, alpha: 1),
        UIColor(red: 0, green: 1, blue: 1, alpha: 1),
        UIColor(red: 1, green: 0, blue: 127/255, alpha: 1),
        UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1),
        UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1),
        UIColor(red: 1, green: 1, blue: 0, alpha: 1),    //
        UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1),
        UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1),
        UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)
    ]
    
    
    
    
    
    
    // MARK: FUNCTIONS
    
    // MARK: View Functions
    
    override init(frame: CGRect) {
        //print("init()")
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    convenience init() {
        //print("convenience init()")
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //print("required init()")
        super.init(coder: aDecoder)
    }
    
    
    // MARK: Set Functions
    
    func setmax(_ valueIn: Int) {
        //print("setMax()")
        if valueIn > Int(min) {
            max = CGFloat(valueIn)
        }
        else {
            min = getMinimumValue()
            max = getMaximumValue()
        }
    }
    
    func setmin(_ valueIn : Int){
        //print("setMin()")
        if valueIn < Int(max) {
            min = CGFloat(valueIn)
        }
        else{
            min = getMinimumValue()
            max = getMaximumValue()
        }
    }
    
    // MARK: Draw Functions
    
    override func draw(_ rect: CGRect) {
        //print("draw()begin")
        
        if removeAll {
            
            let context = UIGraphicsGetCurrentContext()
            context?.clear(rect)
            
            return
        }
        
        self.drawingHeight = self.bounds.height - (2 * y.axis.inset)
        let temp = self.bounds.width - (2 * x.axis.inset)
        //self.drawingWidth = temp
        
        // remove all labels
        /*for view: AnyObject in self.subviews {
         print("draw()11111")
         
         view.removeFromSuperview()
         }*/
        
        // remove all lines on device rotation
        for lineLayer in lineLayerStore {
            
            lineLayer.removeFromSuperlayer()
        }
        lineLayerStore.removeAll()
        
        if self.drawingWidth == 0.0 {
            
            self.drawingWidth = 170.0
            
        }
        else {
            self.drawingWidth = temp
            
        }
        
        // draw grid
        if x.grid.visible && y.grid.visible { drawGrid() }
        // draw axes
//        if x.axis.visible && y.axis.visible { drawAxes() }
        // draw lines
        for line in lineStore {
            
            drawLine(line)
//            if area { drawAreaBeneathLineChart(line) }
        }
        
    }
    
    fileprivate func drawAxes() {
        /* Draw x and y axis */
        //print("drawAxes()")
        
        let height = self.bounds.height
        let width = self.bounds.width
        let path = UIBezierPath()
        // draw x-axis
        x.axis.color.setStroke()
        let y0 = height - self.y.scale(0) - y.axis.inset
        path.move(to: CGPoint(x: x.axis.inset, y: y0))
        path.addLine(to: CGPoint(x: width - x.axis.inset, y: y0))
        path.stroke()
        // draw y-axis
        y.axis.color.setStroke()
        path.move(to: CGPoint(x: x.axis.inset, y: height - y.axis.inset))
        path.addLine(to: CGPoint(x: x.axis.inset, y: y.axis.inset))
        path.stroke()
        
    }
    
    fileprivate func drawLine(_ line: Line) {
        /* Draw line */
        //print("drawLine()")
        if line.dataStore.count != 0 {
            var data = line.dataStore
            let color = line.colorNumber
            let path = UIBezierPath()
            
            var xValue = self.x.scale(0) + x.axis.inset
            var yValue = self.bounds.height - self.y.scale(data[0]) - y.axis.inset
            path.move(to: CGPoint(x: xValue, y: yValue))
            
            var xx : CGFloat = 0.0
            var yy : CGFloat = 0.0
            for index in 1..<data.count-1 {///////////////-1
                xValue = self.x.scale(CGFloat(index)) + x.axis.inset
                yValue = self.bounds.height - self.y.scale(data[index]) - y.axis.inset
                //print(" \(index) \(xValue) \(yValue)")
                if data[index] == 0.0
                {
                    return
                }
                path.addLine(to: CGPoint(x: xValue, y: yValue))
                xx = xValue
                yy = yValue
            }
            
            let layer = CAShapeLayer()
            layer.frame = self.bounds
            layer.path = path.cgPath
            
            
            layer.strokeColor = colors[color].cgColor
//            layer.strokeColor = UIColor.blue.cgColor
            
            layer.fillColor = nil
            layer.lineWidth = lineWidth
            
            self.layer.addSublayer(layer)
            
            let origins = [CGPoint(x: xx, y: yy-5)]
            let size = CGSize(width: 8, height: 8)
            
            for origin in origins {
                let quad = UIBezierPath.init(roundedRect: CGRect(origin: origin, size: size), cornerRadius: 4)
                colors[color].setFill()
                quad.fill()
                quad.stroke()
            }
            // add line layer to store
            lineLayerStore.append(layer)
            
            
        }
        
    }
    
    fileprivate func drawAreaBeneathLineChart(_ line: Line) {
        /* Fill area between line chart and x-axis */
        //print("drawAreaBeneathLineChart()")
        
        if line.dataStore.count != 0 {
            var data = line.dataStore
            let color = line.colorNumber
            
            let path = UIBezierPath()
            
            //colors[lineIndex].colorWithAlphaComponent(0.2).setFill()///////////////////////////////////////////////
            colors[color].withAlphaComponent(0.2).setFill()
            // move to origin
            path.move(to: CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
            // add line to first data point
            path.addLine(to: CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(data[0]) - y.axis.inset))
            // draw whole line chart
            for index in 1..<data.count {
                let x1 = self.x.scale(CGFloat(index)) + x.axis.inset
                let y1 = self.bounds.height - self.y.scale(data[index]) - y.axis.inset
                path.addLine(to: CGPoint(x: x1, y: y1))
            }
            // move down to x axis
            path.addLine(to: CGPoint(x: self.x.scale(CGFloat(data.count - 1)) + x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
            // move to origin
            path.addLine(to: CGPoint(x: x.axis.inset, y: self.bounds.height - self.y.scale(0) - y.axis.inset))
            path.fill()
        }
        
    }
    
    fileprivate func drawXGrid() {
        /* Draw x grid */
        //print("drawXGrid()")
        
        x.grid.color.setStroke()
        let path = UIBezierPath()
        var x1: CGFloat
        let y1: CGFloat = self.bounds.height - y.axis.inset
        let y2: CGFloat = y.axis.inset
        let (start, stop, step) = self.x.ticks
        //for var i: CGFloat = start; i <= stop; i += step {
        for i in stride(from: start, through: stop, by: step) {
            x1 = self.x.scale(i) + x.axis.inset
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x1, y: y2))
        }
        path.stroke()
        
    }
    
    fileprivate func drawYGrid() {
        /* Draw y grid */
        //print("drawYGrid()")
        
        self.y.grid.color.setStroke()
        let path = UIBezierPath()
        let x1: CGFloat = x.axis.inset
        let x2: CGFloat = self.bounds.width - x.axis.inset
        var y1: CGFloat
        let (start, stop, step) = self.y.ticks
        //print((start, stop, step))
        //for var i: CGFloat = start; i <= stop; i += step {
        for i in stride(from: start, through: stop, by: step) {
            
            y1 = self.bounds.height - self.y.scale(i) - y.axis.inset
            path.move(to: CGPoint(x: x1, y: y1))
            path.addLine(to: CGPoint(x: x2, y: y1))
        }
        path.stroke()
    }
    
    fileprivate func drawGrid() {
        /* Draw grid */
        //print("drawGrid()")
        
        drawXGrid()
        drawYGrid()
    }
    
    // MARK: Get Values Fonctions
    
    fileprivate func getYValuesForXValue(_ x: Int) -> [CGFloat] {
        /* Get y value for given x value. Or return zero or maximum value */
        //print("getYValuesForXValue()")
        
        var result: [CGFloat] = []
        for line in lineStore {
            if x < 0 {
                result.append(line.dataStore[0])
            } else if x > line.dataStore.count - 1 {
                result.append(line.dataStore[line.dataStore.count - 1])
            } else {
                result.append(line.dataStore[x])
            }
        }
        return result
    }
    
    fileprivate func getMaximumValue() -> CGFloat {
        /* Get maximum value in all arrays in data store */
        //print("getMaximumValue()")
        
        var max: CGFloat = 1
        for line in lineStore {
            if line.dataStore.count != 0 {
                let newMax = line.dataStore.max()
                if newMax > max {
                    max = newMax!
                }
            }
        }
        
        return max
    }
    
    fileprivate func getMinimumValue() -> CGFloat {
        /* Get minimum value in all arrays in data store */
        //print("getMinimumValue()")
        
        var min: CGFloat = 10000
        for line in lineStore {
            if line.dataStore.count != 0 {
                let newMin = line.dataStore.min()
                if newMin < min {
                    min = newMin!
                }
            }
        }
        
        return min
    }
    
    // MARK: Add and Delete Line
    
    func addLine(_ data: [CGFloat], colorNumber: Int) {
        /* Add line chart */
        //print("addLine()")
        
        let newLine : Line = Line(dataStore: data, colorNumber: colorNumber)
        self.lineStore.append(newLine)
        self.setNeedsDisplay()
    }
    
    
    func clearAll() {
        /* Make whole thing white again */
        //print("clearAll()")
        self.removeAll = true
        clear()
        self.setNeedsDisplay()
        self.removeAll = false
    }
    
    func clear() {
        /* Remove charts, areas and labels but keep axis and grid */
        //print("clear()")
        // clear data
        lineStore.removeAll()
        self.setNeedsDisplay()
    }
}


/*-------------------------------------------------------------------------------*/


// MARK: - CLASS LINERAR SCALE

class LinearScale {
    
    // MARK: VARIABLE
    
    var domain: [CGFloat]
    var range: [CGFloat]
    
    // MARK: FONCTIONS
    
    init(domain: [CGFloat] = [0, 1], range: [CGFloat] = [0, 1]) {
        self.domain = domain
        self.range = range
    }
    
    func scale() -> (_ x: CGFloat) -> CGFloat {
        //print("scale()")
        return bilinear(domain, range: range, uninterpolate: uninterpolate, interpolate: interpolate)
    }
    
    func invert() -> (_ x: CGFloat) -> CGFloat {
        //print("invert()")
        return bilinear(range, range: domain, uninterpolate: uninterpolate, interpolate: interpolate)
    }
    
    func ticks(_ m: Int) -> (CGFloat, CGFloat, CGFloat) {
        //print("ticks()")
        return scale_linearTicks(domain, m: m)
    }
    
    fileprivate func scale_linearTicks(_ domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
        //print("scale_linearTicks()")
        return scale_linearTickRange(domain, m: m)
    }
    
    fileprivate func scale_linearTickRange(_ domain: [CGFloat], m: Int) -> (CGFloat, CGFloat, CGFloat) {
        //print("scale_linearTickRange() ")
        var extent = scaleExtent(domain)
        let span = extent[1] - extent[0]
        var step = CGFloat(pow(10, floor(log(Double(span) / Double(m)) / M_LN10)))
        let err = CGFloat(m) / span * step
        
        // Filter ticks to get closer to the desired count.
        if (err <= 0.15) {
            step *= 10
        } else if (err <= 0.35) {
            step *= 5
        } else if (err <= 0.75) {
            step *= 2
        }
        
        // Round start and stop values to step interval.
        let start = ceil(extent[0] / step) * step
        let stop = floor(extent[1] / step) * step + step * 0.5 // inclusive
        
        return (start, stop, step)
    }
    
    fileprivate func scaleExtent(_ domain: [CGFloat]) -> [CGFloat] {
        //print("scaleExtent()"  )
        let start = domain[0]
        let stop = domain[domain.count - 1]
        
        return start < stop ? [start, stop] : [stop, start]
        
    }
    
    fileprivate func interpolate(_ a: CGFloat, b: CGFloat) -> (_ c: CGFloat) -> CGFloat {
        //print("interpolate()")
        var diff = b - a
        func f(_ c: CGFloat) -> CGFloat {
            return (a + diff) * c
        }
        return f
    }
    
    fileprivate func uninterpolate(_ a: CGFloat, b: CGFloat) -> (_ c: CGFloat) -> CGFloat {
        //print("uninterpolate()")
        var diff = b - a
        var re = diff != 0 ? 1 / diff : 0
        func f(_ c: CGFloat) -> CGFloat {
            return (c - a) * re
        }
        return f
    }
    
    fileprivate func bilinear(_ domain: [CGFloat], range: [CGFloat], uninterpolate: (_ a: CGFloat, _ b: CGFloat) -> (_ c: CGFloat) -> CGFloat, interpolate: (_ a: CGFloat, _ b: CGFloat) -> (_ c: CGFloat) -> CGFloat) -> (_ c: CGFloat) -> CGFloat {
        //print("bilinear()")
        var u: (_ c: CGFloat) -> CGFloat = uninterpolate(domain[0], domain[1])
        var i: (_ c: CGFloat) -> CGFloat = interpolate(range[0], range[1])
        func f(_ d: CGFloat) -> CGFloat {
            return i(u(d))
        }
        return f
    }
    
}

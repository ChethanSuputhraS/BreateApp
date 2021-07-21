//
//  GraphVC.swift
//  BreathingApp
//
//  Created by Ashwin on 2/10/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit
import SwiftCharts

class GraphVC: UIViewController
{
//    let graphView = UIView()
    let btnBack = UIButton()
//    override func viewDidLoad()
//    {
//        self.navigationController?.isNavigationBarHidden = true
//        self.view.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
//        graphView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//        graphView.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
//
//        self.view.addSubview(graphView)
//
//        let lblSession = UILabel()
//        lblSession.frame = CGRect(x: 0, y: 25, width: GlobalVariables.Device_Width, height: 50)
//        lblSession.text = "10/02/2020"
//        lblSession.font = UIFont.boldSystemFont(ofSize: 30)
//        lblSession.textAlignment = .center
//        lblSession.textColor = UIColor.white
//        graphView.addSubview(lblSession)
//
//        btnBack.frame = CGRect(x: 10, y: 25, width: 50, height: 50)
//        let btnImgViewBack = UIImageView()
//        btnImgViewBack.frame = CGRect(x: 10, y: 15, width: 20, height: 30)
//        btnImgViewBack.image = UIImage.init(named: "back.png")
//        btnBack.addSubview(btnImgViewBack)
//        btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
//        btnBack.backgroundColor = UIColor.clear
//        self.view.addSubview(btnBack)
//
        
        
         //MARK:- group BAR

         fileprivate var chart: Chart?

            fileprivate let dirSelectorHeight: CGFloat = 450
          
    
            fileprivate func barsChart(horizontal: Bool) -> Chart {
                let labelSettings = ChartLabelSettings(font: ExamplesDefaults.labelFont)
                
            self.navigationController?.isNavigationBarHidden = true
            self.view.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
                  
                
                let graphView = UIView()
                        graphView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                        graphView.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
                
                        self.view.addSubview(graphView)
                
                        let lblSession = UILabel()
                        lblSession.frame = CGRect(x: 0, y: 25, width: GlobalVariables.Device_Width, height: 50)
                        lblSession.text = "10/02/2020"
                        lblSession.font = UIFont.boldSystemFont(ofSize: 25)
                        lblSession.textAlignment = .center
                        lblSession.textColor = UIColor.white
                        graphView.addSubview(lblSession)
                
                        btnBack.frame = CGRect(x: 10, y: 25, width: 50, height: 50)
                        let btnImgViewBack = UIImageView()
                        btnImgViewBack.frame = CGRect(x: 10, y: 15, width: 20, height: 30)
                        btnImgViewBack.image = UIImage.init(named: "back.png")
                        btnBack.addSubview(btnImgViewBack)
                        btnBack.addTarget(self, action: #selector(btnBackClicked), for: .touchUpInside)
                        btnBack.backgroundColor = UIColor.clear
                        self.view.addSubview(btnBack)
                
                
                
                
                
                
                
                let groupsData: [(title: String, [(min: Double, max: Double)])] = [
                    ("10-02-2020", [
                        (60, 70),
                        (60, 100),
                        
                        ]),
                   ("00-00-2020", [
                           (60, 80),
                           (60, 75),
                          
                           ]),("00-00-2020", [
                            (60, 80),
                            (60, 75),
                           
                            ]),("00-00-2020", [
                             (60, 80),
                             (60, 75),
                            
                             ]),
                    ("10-20-2020", [
                        (60, 95),
                        (60, 98),
                   
                        ])
                ]
                
               
                
                let groupColors = [UIColor.white.withAlphaComponent(0.6), UIColor.yellow.withAlphaComponent(0.6), UIColor.green.withAlphaComponent(0.6)]
                
                let groups: [ChartPointsBarGroup] = groupsData.enumerated().map {index, entry in
                    let constant = ChartAxisValueDouble(index)
                    let bars = entry.1.enumerated().map {index, tuple in
                        ChartBarModel(constant: constant, axisValue1: ChartAxisValueDouble(tuple.min), axisValue2: ChartAxisValueDouble(tuple.max), bgColor: groupColors[index])
                    }
                    return ChartPointsBarGroup(constant: constant, bars: bars)
                }
                
        //Chethan code
                
//                let lblLableName = UILabel()
//                lblLableName.frame = CGRect(x: 100, y: self.view.frame.height-200, width: self.view.frame.width, height: 50)
//                lblLableName.text = "Chest"
//                lblLableName.font = UIFont.boldSystemFont(ofSize: 25)
//                self.view.addSubview(lblLableName)
//
//                let viewName = UIView()
//                viewName.frame = CGRect(x: 50, y: self.view.frame.height-190, width: 30, height: 30)
//                viewName.backgroundColor = UIColor.red.withAlphaComponent(0.6)
//                self.view.addSubview(viewName)
//
                
//                let lblLableName1 = UILabel()
//                lblLableName1.frame = CGRect(x: 100, y: self.view.frame.height-150, width: self.view.frame.width, height: 50)
//                lblLableName1.text = "Abdomen"
//                 lblLableName1.font = UIFont.boldSystemFont(ofSize: 25)
//                self.view.addSubview(lblLableName1)
//
//                let viewName1 = UIView()
//                viewName1.frame = CGRect(x: 50, y: self.view.frame.height-140, width: 30, height: 30)
//                viewName1.backgroundColor = UIColor.blue.withAlphaComponent(0.6)
//                self.view.addSubview(viewName1)
//
                
              //setting graph value
                
                let (axisValues1, axisValues2): ([ChartAxisValue], [ChartAxisValue]) = (
                    stride(from: 60, through: 100, by: 10).map {ChartAxisValueDouble(Double($0), labelSettings: labelSettings)},
                    [ChartAxisValueString(order: -1)] +
                        groupsData.enumerated().map {index, tuple in ChartAxisValueString(tuple.0, order: index, labelSettings: labelSettings)} +
                        [ChartAxisValueString(order: groupsData.count)]
                )
                let (xValues, yValues) = horizontal ? (axisValues1, axisValues2) : (axisValues2, axisValues1)
                
                let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Date", settings: labelSettings))
                let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Heart Beat", settings: labelSettings.defaultVertical()))
                
                let frame = ExamplesDefaults.chartFrame(view.bounds)
                let chartFrame = chart?.frame ?? CGRect(x: frame.origin.x, y: frame.origin.y+450, width: frame.size.width, height: frame.size.height - dirSelectorHeight)
                
                let chartSettings = ExamplesDefaults.chartSettingsWithPanZoom

                let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
                let (xAxisLayer, yAxisLayer, innerFrame) = (coordsSpace.xAxisLayer, coordsSpace.yAxisLayer, coordsSpace.chartInnerFrame)
                
                let barViewSettings = ChartBarViewSettings(animDuration: 0.5, selectionViewUpdater: ChartViewSelectorBrightness(selectedFactor: 0.5))
                
                let groupsLayer = ChartGroupedPlainBarsLayer(xAxis: xAxisLayer.axis, yAxis: yAxisLayer.axis, groups: groups, horizontal: horizontal, barSpacing: 2, groupSpacing: 25, settings: barViewSettings, tapHandler: { tappedGroupBar /*ChartTappedGroupBar*/ in
                    
                    let barPoint = horizontal ? CGPoint(x: tappedGroupBar.tappedBar.view.frame.maxX, y: tappedGroupBar.tappedBar.view.frame.midY) : CGPoint(x: tappedGroupBar.tappedBar.view.frame.midX, y: tappedGroupBar.tappedBar.view.frame.minY)
                    
                    guard let chart = self.chart, let chartViewPoint = tappedGroupBar.layer.contentToGlobalCoordinates(barPoint) else {return}
                    
                    let viewPoint = CGPoint(x: chartViewPoint.x, y: chartViewPoint.y)
                    
                    let infoBubble = InfoBubble(point: viewPoint, preferredSize: CGSize(width: 50, height: 40), superview: self.chart!.view, text: tappedGroupBar.tappedBar.model.axisValue2.description, font: ExamplesDefaults.labelFont, textColor: UIColor.green, bgColor: UIColor.clear, horizontal: horizontal)

                    let anchor: CGPoint =
                    {
                        switch (horizontal, infoBubble.inverted(chart.view))
                        {
                        case (true, true): return CGPoint(x: 1, y: 0.5)
                        case (true, false): return CGPoint(x: 0, y: 0.5)
                        case (false, true): return CGPoint(x: 0.5, y: 0)
                        case (false, false): return CGPoint(x: 0.5, y: 1)
                        }
                    }()
                    
                    let animatorsSettings = ChartViewAnimatorsSettings(animInitSpringVelocity: 5)
                    let animators = ChartViewAnimators(view: infoBubble, animators: ChartViewGrowAnimator(anchor: anchor), settings: animatorsSettings, invertSettings: animatorsSettings.withoutDamping(), onFinishInverts: {
                        infoBubble.removeFromSuperview()
                    })
                    
                    chart.view.addSubview(infoBubble)
                    
                    infoBubble.tapHandler = {
                        animators.invert()
                    }
                    
                    animators.animate()
                })
                
                let guidelinesSettings = ChartGuideLinesLayerSettings(linesColor: UIColor.clear, linesWidth: ExamplesDefaults.guidelinesWidth)
                let guidelinesLayer = ChartGuideLinesLayer(xAxisLayer: xAxisLayer, yAxisLayer: yAxisLayer, axis: horizontal ? .x : .y, settings: guidelinesSettings)
                
                return Chart(
                    frame: chartFrame,
                    innerFrame: innerFrame,
                    settings: chartSettings,
                    layers: [
                        xAxisLayer,
                        yAxisLayer,
                        guidelinesLayer,
                        groupsLayer
                    ]
                )
            }
            
            
            fileprivate func showChart(horizontal: Bool) {
                self.chart?.clearView()
                
                let chart = barsChart(horizontal: horizontal)
                view.addSubview(chart.view)
                self.chart = chart
            }
            override func viewDidLoad() {
                showChart(horizontal: false)
        //        if let chart = chart {
        //            let dirSelector = DirSelector(frame: CGRect(x: 0, y: chart.frame.origin.y + chart.frame.size.height, width: view.frame.size.width, height: dirSelectorHeight), controller: 0)
        //            view.addSubview(dirSelector)
        //        }
            }
            
            class DirSelector: UIView {
                
                let horizontal: UIButton
                let vertical: UIButton
                
                weak var controller: GroupedBarsExample?
                
                fileprivate let buttonDirs: [UIButton : Bool]
                
                init(frame: CGRect, controller: GroupedBarsExample) {
                    
                    self.controller = controller
                    
                    horizontal = UIButton()
                    horizontal.setTitle("Horizontal", for: UIControl.State())
                    vertical = UIButton()
                    vertical.setTitle("Vertical", for: UIControl.State())
                    
                    buttonDirs = [horizontal : true, vertical : false]
                    
                    super.init(frame: frame)
                    
                    addSubview(horizontal)
                    addSubview(vertical)
//
//                    for button in [horizontal, vertical] {
//                        button.titleLabel?.font = ExamplesDefaults.fontWithSize(14)
//                        button.setTitleColor(UIColor.blue, for: UIControl.State())
//                        button.addTarget(self, action: #selector(DirSelector.buttonTapped(_:)), for: .touchUpInside)
//                    }
                }
                
                @objc func buttonTapped(_ sender: UIButton) {
        //            let horizontal = sender == self.horizontal ? true : false
        //            controller?.showChart(horizontal: horizontal)
                }
                
                override func didMoveToSuperview() {
                    let views = [horizontal, vertical]
                    for v in views {
                        v.translatesAutoresizingMaskIntoConstraints = false
                    }
                    
                    let namedViews = views.enumerated().map{index, view in
                        ("v\(index)", view)
                    }
                    
                    var viewsDict = Dictionary<String, UIView>()
                    for namedView in namedViews {
                        viewsDict[namedView.0] = namedView.1
                    }
                    
                    let buttonsSpace: CGFloat = Env.iPad ? 20 : 10
                    
                    let hConstraintStr = namedViews.reduce("H:|") {str, tuple in
                        "\(str)-(\(buttonsSpace))-[\(tuple.0)]"
                    }
                    
                    let vConstraits = namedViews.flatMap {NSLayoutConstraint.constraints(withVisualFormat: "V:|[\($0.0)]", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict)}
                    
                    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: hConstraintStr, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict)
                        + vConstraits)
                }
                
                required init(coder aDecoder: NSCoder)
                {
                    fatalError("init(coder:) has not been implemented")
                }
            }
    
    
         // MARK: - Button
    @objc func btnBackClicked()
    {
        
    }

        }
                
        
        
        
        


   



    



//
//  RecordVC.swift
//  BreathingApp
//
//  Created by stuart watts on 12/02/2020.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit
import CoreBluetooth

var bodyBackView = UIView()
var btnBack = UIButton()
var lineChart: LineChart!
var listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
var numberOfSample = stretchsenseObject.numberOfSample
var numberOfThePeripheralToUpdate = 0
var valueAverage : UInt8 = 0
var newConnection : Bool = false
var previousNumberOfPeripheral = 0
var defaultValueOfTheNewSensor : CGFloat = 0
var timestampSampleRelativeTime = 0.0
var startTime = TimeInterval()

class RecordVC: UIViewController
{
    var sampleNumber = 0
    var isRecording = false
    var sentenceToRecord = ""
    var allSentencesRecorded : [String] = []
    var view2 =  UIView()
    var circleChest : UILabel!
    var circleAbdome : UILabel!
    var circlView : UIView!

    override func viewDidLoad()
    {
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(newValueDetected), name: NSNotification.Name(rawValue: "UpdateValueNotification"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(self.newInfoDetected), name: NSNotification.Name(rawValue: "UpdateInfo"),object: nil)

        
        let listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        for i in 0...listPeripheralsAvailable.count-1
        {
            let p  =  listPeripheralsAvailable[i]
            stretchsenseObject.discoverServicesforPeripherals(periph: p!)
        }

        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.init(red: 13.0/255, green: 42.0/255, blue: 67.0/255, alpha: 1)
        
        bodyBackView.frame = CGRect(x: 0, y: 0, width: constants.widths, height: constants.heighs)
        self.view.addSubview(bodyBackView)
        
        btnBack.frame = CGRect(x: 0, y: 10, width: 50, height: 65)
        btnBack.setTitleColor(.white, for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.setImage(UIImage.init(named: "back.png"), for: .normal)
        bodyBackView.addSubview(btnBack)

        
        self.view2.frame = CGRect(x: 0, y: 200, width: 375, height: 300)
        self.view.addSubview(self.view2)
        var views: [String: AnyObject] = [:]
        lineChart = LineChart()
        lineChart.area = false
        lineChart.x.grid.count = 1
        lineChart.y.grid.count = 1
        lineChart.autoMinMax = true
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        self.view2.addSubview(lineChart)
        
        lineChart.frame = CGRect(x: 0, y: 0, width: 375, height: 300)
        views["chart"] = lineChart
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @objc func btnBackClick()
    {
        
    }
    @objc func newInfoDetected()
    {
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
    }
    
    @objc func newValueDetected()
    {
        print("new value detected")
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        ask_new_data()
    }
    func ask_new_data()
    {
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        reloadGraph()
        
        if isRecording == true
        {
            if sampleNumber == 0
            {
                startTime = NSDate.timeIntervalSinceReferenceDate
                sentenceToRecord = "Sequence, Sample Number, Time, Sensor Value"
                allSentencesRecorded.append(sentenceToRecord)
            }
            sampleNumber += 1
            if (timestampSampleRelativeTime < 0)
            {
                timestampSampleRelativeTime = 0.0
            }
            else
            {
                timestampSampleRelativeTime = NSDate.timeIntervalSinceReferenceDate - startTime
            }
            // The sentence type is: sample number, time, capacitanceSensor1, capacitanceSensor2...
            sentenceToRecord = "\n" + String(Int(0)) + ", " + String(sampleNumber) + ", " + String(timestampSampleRelativeTime)
            
            for myPeripheralConnected in listPeripheralsConnected
            {
                let rawValueFromThePeripheral = myPeripheralConnected.previousValueRawFromTheSensor[myPeripheralConnected.previousValueRawFromTheSensor.count-1]
                let realValueFromThePeripheral = Int(rawValueFromThePeripheral /** 0.1*/)
                sentenceToRecord += ", " + "\(realValueFromThePeripheral)"
            }
            allSentencesRecorded.append(sentenceToRecord)
        }
    }
    
    func reloadGraph()
    {
        lineChart.clear()
        self.view2.frame = CGRect(x: 0, y: 200, width: 375, height: 300)
        lineChart.frame = CGRect(x: 0, y: 0, width: 375, height: 300)
        if listPeripheralsConnected.count != 0
        {
            for myPeripheralConnected in listPeripheralsConnected
            {
                let strChestUUID  = String(format: "%@", UserDefaults.standard.value(forKey: "ChestUUID") as! CVarArg)
                let strAbdomenUUID = String(format: "%@", UserDefaults.standard.value(forKey: "AbdomenUUID") as! CVarArg)
                if myPeripheralConnected.display == true
                {
                    let strUUID = myPeripheralConnected.uuid as String
                    var strType : Int =  1
                    
                    if strUUID == strChestUUID
                    {
                        strType = 0
                    }
                    else if strUUID == strAbdomenUUID
                    {
                        strType = 1
                    }
                    if isCircleAvail
                    {
                        if myPeripheralConnected.value != 0.0
                        {
                            var intVal : CGFloat = CGFloat(myPeripheralConnected.value - 280)
                            if intVal > 0
                            {
                                if intVal > 80
                                {
                                    intVal  = intVal / 5.0
                                }
                                UIView.animate(withDuration: Double(0.5), animations: {
                                    
                                    if strType == 0
                                    {
                                        var chestRect : CGRect = self.circleChest.frame
                                        let vwithd = CGFloat(300 + (intVal))
                                        chestRect.size.width = vwithd
                                        chestRect.size.height = vwithd
                                        chestRect.origin.x = CGFloat((self.circlView.frame.width - vwithd)/2)
                                        chestRect.origin.y = CGFloat((self.circlView.frame.width - vwithd)/2)
                                        self.circleChest.frame = chestRect
                                        self.circleChest.layer.cornerRadius = chestRect.size.height/2
                                    }
                                    else
                                    {
                                        var chestRect : CGRect = self.circleChest.frame
                                        let vwithd = CGFloat(300 + (intVal))
                                        chestRect.size.width = vwithd
                                        chestRect.size.height = vwithd
                                        chestRect.origin.x = CGFloat((self.circlView.frame.width - vwithd)/2)
                                        chestRect.origin.y = CGFloat((self.circlView.frame.width - vwithd)/2)
                                        self.circleChest.frame = chestRect
                                        self.circleChest.layer.cornerRadius = chestRect.size.height/2
                                    }
                                })
                            }
                            else
                            {
                            }
                        }
                    }
                    else
                    {
                        lineChart.addLine(myPeripheralConnected.previousValueAveraged, colorNumber: strType)
                    }
                }
            }
        }
    }
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>)
    {
        
    }
    @objc func recordPauseButton(_ sender: AnyObject)
    {
        print("button : record/pause")
        if listPeripheralsConnected.count == 0
        {
            print("button : record/pause - No Periph")
        }
        else
        {
            print("button : record/pause - Periph Detected")
            if isRecording == true
            {
                print("button : record/pause - Periph Detected - is recording")
                isRecording = false
                UIApplication.shared.isIdleTimerDisabled = false
            }
            else
            {
                print("button : record/pause - Periph Detected - is not recording")
                isRecording = true
                UIApplication.shared.isIdleTimerDisabled = true
            }
        }
    }
    @objc func deleteRecord(_ sender: AnyObject)
    {
        if listPeripheralsConnected.count == 0
        {
        }
        else
        {
            if isRecording == true
            {
//                self.labelRecord.text = "Stop Recording First"
            }
            else
            {
                // If the system is not recording, ask for permission to delete the data recorded
                let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete all recorded data? ", preferredStyle: UIAlertController.Style.alert)
                refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                    self.allSentencesRecorded = []
                    self.sampleNumber = 0
                }))
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                }))
                present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

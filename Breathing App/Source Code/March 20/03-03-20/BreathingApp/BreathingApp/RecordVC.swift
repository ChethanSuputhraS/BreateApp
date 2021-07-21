//
//  RecordVC.swift
//  BreathingApp
//
//  Created by stuart watts on 12/02/2020.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit
import CoreBluetooth

var rawChart: LineChart!
var smoothChart: LineChart!
var listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
var numberOfSample = stretchsenseObject.numberOfSample
var numberOfThePeripheralToUpdate = 0
var valueAverage : UInt8 = 0
var newConnection : Bool = false
var previousNumberOfPeripheral = 0
var defaultValueOfTheNewSensor : CGFloat = 0
var timestampSampleRelativeTime = 0.0
var startTime = TimeInterval()
var result: [PointEntry] = []
var curvedlineChart: NewLineCharts!
class RecordVC: UIViewController
{
    var sampleNumberC = 0
    var sampleNumberA = 0

    var isRecording = false
    var sentenceToRecord = ""
    var allRecordedChest : [String] = []
    var allRecordedAbd : [String] = []
    var circleChest : UILabel!
    var circleAbdome : UILabel!
    //    var visualview : UIView!
    let rawView = UIView()
    let smoothView = UIView()
    let visualview = UIView()
    
    //css
    let bottomView = UIView()
    let btnRaw = UIButton()
    let btnTimer = UIButton()
    let btnSmooth = UIButton()
    let btnVisual = UIButton()
    let imgRaw = UIImageView()
    let imgSmooth = UIImageView()
    let imgVisual = UIImageView()
    let viewSessionTime = UIView()
    var btnBack = UIButton()
    
    var btnGraphTouch = UIButton()
    var popViewAlert = UIView()
    var btnEndSession = UIButton()
    var btnContinueSession = UIButton()
    let btnAlertView = UIButton()

    var lblTime = UILabel()
    var count1 = 01
    var timer : Timer?
    var viewType = 1
    
    var chestTimer : Timer?
    var abdTimer : Timer?
    var isChestAllow = false
    var isAbdAllow = false
    var strSessionTime = NSString()
   

    override func viewDidLoad()
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        strSessionTime = formatter.string(from: Date()) as NSString

        //Navigation View Setup
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor.init(red: 5.0/255, green: 56.0/255, blue: 83.0/255, alpha: 1)
        
        //BLE Initialization
        self.BLEInitMethod()
        self.SetTopHintView()
        self.SetupBottomView()
        
        btnBack.frame = CGRect(x: 0, y: 10, width: 50, height: 65)
        btnBack.setTitleColor(.white, for: .normal)
        btnBack.addTarget(self, action: #selector(btnBackClick), for: .touchUpInside)
        btnBack.setImage(UIImage.init(named: "back.png"), for: .normal)
        self.view.addSubview(btnBack)
        
        // for image purpose i did width  and heigt less then i create image view for that.....
        btnTimer.frame = CGRect(x: constants.widths-40, y: 25, width: 20, height: 35)
        btnTimer.setTitleColor(.white, for: .normal)
        btnTimer.addTarget(self, action: #selector(btnTimerClick), for: .touchUpInside)
        btnTimer.setImage(UIImage.init(named: "timer.png"), for: .normal)
        self.view.addSubview(btnTimer)
        
        let viewHeight = constants.heighs-70-140
        rawView.frame = CGRect(x: 0, y: 140, width: constants.widths, height: viewHeight)
        rawView.backgroundColor = UIColor.clear
        self.view.addSubview(rawView)
        
        let chartHeight = constants.widths * 0.853
        
        let dataEntries = generateRandomEntries()

        curvedlineChart = NewLineCharts()
        curvedlineChart.frame = CGRect(x: 0, y: (rawView.frame.height-chartHeight)/2, width: constants.widths, height: constants.widths * 0.853)
        curvedlineChart.dataEntries = dataEntries
        curvedlineChart.isCurved = true

//        rawChart.area = true
//        rawChart.x.grid.count = 1
//        rawChart.y.grid.count = 1
//        rawChart.autoMinMax = false
//        rawChart.translatesAutoresizingMaskIntoConstraints = true
        self.rawView.addSubview(curvedlineChart)
        curvedlineChart.isCurved = true

//        var views: [String: AnyObject] = [:]
//        views["chart"] = rawChart
        
        smoothView.frame = CGRect(x: 0, y: 140, width: constants.widths, height: viewHeight)
        smoothView.backgroundColor = UIColor.clear
        smoothView.isHidden = true
        self.view.addSubview(smoothView)
        
        smoothChart = LineChart()
        smoothChart.frame = CGRect(x: 0, y: (smoothView.frame.height-chartHeight)/2, width: constants.widths, height: constants.widths * 0.853)
        smoothChart.area = true
        smoothChart.x.grid.count = 1
        smoothChart.y.grid.count = 1
        smoothChart.autoMinMax = false
        smoothChart.translatesAutoresizingMaskIntoConstraints = true
        self.smoothView.addSubview(smoothChart)
        
        var views1: [String: AnyObject] = [:]
        views1["chart"] = smoothChart
        
        visualview.frame = CGRect(x: 0, y: 140, width: constants.widths, height: viewHeight)
        visualview.backgroundColor = UIColor.clear
        visualview.isHidden = true
        self.view.addSubview(visualview)
        
        circleChest = UILabel()
        circleChest.frame = CGRect(x: (visualview.frame.width-300)/2, y: (visualview.frame.height-300)/2, width: 300, height: 300)
        circleChest.backgroundColor = UIColor.clear
        circleChest.layer.masksToBounds = true
        circleChest.layer.cornerRadius = 150
        circleChest.layer.borderWidth = 2.0
        circleChest.layer.borderColor = UIColor.init(red: 106.0/255, green: 227.0/255, blue: 255.0/255, alpha: 1).cgColor
        visualview.addSubview(circleChest)
        
        circleAbdome = UILabel()
        circleAbdome.frame = CGRect(x: (visualview.frame.width-240)/2, y: (visualview.frame.height-240)/2, width: 240, height: 240)
        circleAbdome.backgroundColor = UIColor.clear
        circleAbdome.layer.masksToBounds = true
        circleAbdome.layer.cornerRadius = 120
        circleAbdome.layer.borderWidth = 2.0
        circleAbdome.layer.borderColor = UIColor.yellow.cgColor
        visualview.addSubview(circleAbdome)
        
        btnGraphTouch.frame = CGRect(x: 0, y: 140, width: constants.widths, height: viewHeight)
        btnGraphTouch.addTarget(self, action: #selector(btnGraphTouchClick), for: .touchUpInside)
        btnGraphTouch.backgroundColor = UIColor.clear
        self.view.addSubview(btnGraphTouch)
        
        btnAlertView.frame = CGRect (x: 0, y: 60, width: constants.widths, height: constants.heighs)
        btnAlertView.backgroundColor = .clear
        btnAlertView.isHidden = true
        btnAlertView.addTarget(self, action: #selector(btnAltViewClick), for: .touchUpInside)
        self.view.addSubview(btnAlertView)
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector: #selector(timerAction),userInfo: nil,repeats: true)
        chestTimer = Timer.scheduledTimer(timeInterval: 0.10,target: self,selector: #selector(chestTimerAction),userInfo: nil,repeats: true)
        abdTimer = Timer.scheduledTimer(timeInterval: 0.10,target: self,selector: #selector(abdTimerAction),userInfo: nil,repeats: true)
        
        self.SetupPopupMethod()

        imgRaw.image = UIImage.init(named: "rawSelected.png")
        btnRaw.setTitleColor(.white, for: .normal)

//        let timerr = Timer.scheduledTimer(timeInterval: 0.40, target: self, selector: #selector(createData), userInfo: nil, repeats: true)

        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    private func generateRandomEntries() -> [PointEntry]
    {
        var result: [PointEntry] = []
        for i in 0..<10
        {
            //            intcount = intcount + 1
            
            let value = Int(arc4random() % 300)
            
            //            let formatter = DateFormatter()
            //            formatter.dateFormat = "d MMM"
            //            var date = Date()
            //            date.addTimeInterval(TimeInterval(24*60*60*i))
            let str = String.init(format: "", 0)
            result.append(PointEntry(value: value, label: "0"))
        }
        return result
    }

    @objc func createData()
    {
        curvedlineChart.drawCurvedChartwith(dataEnt: result)
        result = []
    }
    @objc func chestTimerAction()
    {
        isChestAllow = true
    }
    @objc func abdTimerAction()
    {
        isAbdAllow = true
    }
    @objc func BLEInitMethod()
    {
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(newValueDetected), name: NSNotification.Name(rawValue: "UpdateValueNotification"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(self.newInfoDetected), name: NSNotification.Name(rawValue: "UpdateInfo"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(self.kpRecordMethod), name: NSNotification.Name(rawValue: "kpRecordMethod"),object: nil)

        let listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        
        // for testing in simulator  commented this code
        
                for i in 0...listPeripheralsAvailable.count-1
                {
                    let p  =  listPeripheralsAvailable[i]
                    stretchsenseObject.discoverServicesforPeripherals(periph: p!)
                }
    }
    @objc func kpRecordMethod(notification: NSNotification)
    {
        let orderNumberInt  = (notification.object as AnyObject).integerValue
//        let valuee : NSInteger = notification.object as! NSInteger
        result.append(PointEntry(value: orderNumberInt ?? 0, label: "0"))
        print("->>>",notification.object)
    }
    @objc func SetupBottomView()
    {
        let btnWidth = constants.widths/3
        
        var  yViewButtom = CGFloat(constants.heighs-70)
        if (constants.IS_IPHONE_X)
        {
            yViewButtom = yViewButtom - 20
        }
        bottomView.frame = CGRect(x: 0, y: yViewButtom, width: constants.widths, height: 70)
        bottomView.backgroundColor = UIColor.clear
        self.view.addSubview(bottomView)
        
        //For Raw
        imgRaw.frame = CGRect(x: (btnWidth-30)/2, y: 15, width: 35, height: 30)
        imgRaw.image = UIImage.init(named: "rawUnSelect.png")
        bottomView.addSubview(imgRaw)
        
        btnRaw.frame = CGRect(x: 0, y: 0, width: btnWidth, height: 70)
        self.setButtonProperties(btnRaw, strTitle: "Raw", tagg: 1)
        
        //For Smooth
        imgSmooth.frame = CGRect(x: btnWidth + ((btnWidth-30)/2), y: 10, width: 40, height: 36)
        imgSmooth.image = UIImage.init(named: "smooth.png")
        bottomView.addSubview(imgSmooth)
        
        btnSmooth.frame = CGRect(x: btnWidth, y: 0, width: btnWidth, height: 70)
        self.setButtonProperties(btnSmooth, strTitle: "Smooth", tagg: 2)
        
        //For Visual
        imgVisual.frame = CGRect(x: (btnWidth * 2) + ((btnWidth-30)/2), y: 10, width: 30, height: 30)
        imgVisual.image = UIImage.init(named: "Visual.png")
        bottomView.addSubview(imgVisual)
        
        btnVisual.frame = CGRect(x: btnWidth*2, y: 0, width: btnWidth, height: 70)
        self.setButtonProperties(btnVisual, strTitle: "Visual", tagg: 3)
    }
    @objc func setButtonProperties(_ btn : UIButton, strTitle : NSString, tagg : NSInteger)
    {
        btn.setTitle(strTitle as String, for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.addTarget(self, action: #selector(btnBottomMenuClick), for: .touchUpInside)
        btn.backgroundColor = UIColor.clear
        btn.contentVerticalAlignment = UIControl.ContentVerticalAlignment.bottom
        btn.tag = tagg
        bottomView.addSubview(btn)
    }
    @objc func SetTopHintView()
    {
        viewSessionTime.frame = CGRect(x: 25, y: 70, width: constants.widths-50, height: 80)
        viewSessionTime.backgroundColor = UIColor.init(red: 22.0/255, green: 68.0/255, blue: 93.0/255, alpha: 1)
        viewSessionTime.layer.cornerRadius = 44
        self.view.addSubview(viewSessionTime)
        
        let lblChest = UILabel()
        lblChest.frame = CGRect(x: 50, y: 10, width: 100, height: 30)
        lblChest.text = "Chest"
        lblChest.textColor = .white
        viewSessionTime.addSubview(lblChest)
        
        let lblAbdomen = UILabel()
        lblAbdomen.frame = CGRect(x: 50, y: 40, width: 100, height: 30)
        lblAbdomen.text = "Abdomen"
        lblAbdomen.textColor = .white
        viewSessionTime.addSubview(lblAbdomen)
        
        let lblSession = UILabel()
        lblSession.frame = CGRect(x: 190, y: 10, width: 100, height: 30)
        lblSession.text = "Session Time"
        lblSession.font = UIFont.boldSystemFont(ofSize: 15)
        lblSession.textColor = .white
        viewSessionTime.addSubview(lblSession)
        
        lblTime.frame = CGRect(x: 190, y: 40, width: 150, height: 30)
        lblTime.text = "00:00"
        lblTime.textColor = .white
        lblTime.font = UIFont.boldSystemFont(ofSize: 35)
        viewSessionTime.addSubview(lblTime)
        
        let lblYellowRing = UILabel()
        lblYellowRing.frame = CGRect(x: 20, y: 45, width: 20, height: 20)
        lblYellowRing.layer.borderWidth = 3
        lblYellowRing.layer.cornerRadius = 10
        lblYellowRing.layer.borderColor = UIColor.yellow.cgColor
        viewSessionTime.addSubview(lblYellowRing)
        
        let lblBlueRing = UILabel()
        lblBlueRing.frame = CGRect(x: 20, y: 15, width: 20, height: 20)
        lblBlueRing.layer.borderWidth = 3
        lblBlueRing.layer.cornerRadius = 10
        lblBlueRing.layer.borderColor = UIColor.init(red: 106.0/255, green: 227.0/255, blue: 255.0/255, alpha: 1).cgColor
        viewSessionTime.addSubview(lblBlueRing)
    }
    
    @objc func SetupPopupMethod()
    {
        popViewAlert.frame = CGRect(x: 20, y: constants.heighs, width: constants.widths-40, height: 200)
        popViewAlert.backgroundColor = UIColor.init(red: 25.0/255, green: 78.0/255, blue: 107.0/255, alpha: 0.5)
        popViewAlert.layer.cornerRadius = 25
        self.view.addSubview(popViewAlert)
        
        btnEndSession.frame = CGRect(x: 20, y: 40, width: 300, height: 50)
        btnEndSession.backgroundColor = UIColor.init(red: 87.0/255, green: 155.0/255, blue: 191.0/255, alpha: 1)
        btnEndSession.addTarget(self, action: #selector(btnEndSessinClick), for: .touchUpInside)
        btnEndSession.setTitle("End session & Save data", for: .normal)
        btnEndSession.setTitleColor(.white, for: .normal)
        btnEndSession.layer.cornerRadius = 26
        popViewAlert.addSubview(btnEndSession)
        
        btnContinueSession.frame = CGRect(x: 20, y: 110, width: 300, height: 50)
        btnContinueSession.backgroundColor = UIColor.init(red: 87.0/255, green: 155.0/255, blue: 191.0/255, alpha: 1)
        btnContinueSession.addTarget(self, action: #selector(btnContinueSessionClick), for: .touchUpInside)
        btnContinueSession.setTitle("Continue Session", for: .normal)
        btnContinueSession.setTitleColor(.white, for: .normal)
        btnContinueSession.layer.cornerRadius = 26
        popViewAlert.addSubview(btnContinueSession)
        

//        var data = readDataFromCSV(fileName: "StretchSense_2020-02-24 15:46:28", fileType: "csv")
//
//        data = cleanRows(file: data!)
//        let csvRows = csv(data: data!)
//        print(csvRows)
        
        
    }
    //MARK:- Buttons
    
    @objc func btnBackClick()
    {
        bottomView.isHidden = false
        viewSessionTime.isHidden = false
        btnBack.isHidden = false
        btnTimer.isHidden = false
        btnAlertView.isHidden = true
      btnBack.setImage(UIImage.init(named: "back.png"), for: .normal)
        
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,target: self, selector: #selector(self.timerAction),userInfo: nil,repeats: true)
    }
    @objc func btnAltViewClick()
    {
        btnBack.isHidden = true
        btnTimer.isHidden = true
        bottomView.isHidden = true
        timer?.invalidate()
                UIView.transition(with: popViewAlert, duration: 0.5, options: .curveEaseIn, animations:
                    {
            self.popViewAlert.frame = CGRect(x: 20, y: (constants.heighs-200)/2, width: constants.widths-40, height: 200)
                }, completion: {( finished: Bool) -> () in
        
                })
            }
    @objc func newInfoDetected()
    {
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
    }
    @objc func btnBottomMenuClick (_ sender: AnyObject)
    {
        print("tag click",sender.tag ?? 0)
        viewType = sender.tag
        
        if sender.tag == 1
        {
            isCircleAvail = false
            
            imgRaw.image = UIImage.init(named: "rawSelected.png")
            btnRaw.setTitleColor(.white, for: .normal)
            imgSmooth.image = UIImage.init(named: "smooth.png")
            btnSmooth.setTitleColor(.lightGray, for: .normal)
            imgVisual.image = UIImage.init(named: "Visual.png")
            btnVisual.setTitleColor(.lightGray, for: .normal)
            
            rawView.isHidden = false
            smoothView.isHidden = true
            visualview.isHidden = true
        }
        else if sender.tag == 2
        {
            isCircleAvail = false
            
            imgSmooth.image = UIImage.init(named: "smoothSelected.png")
            btnSmooth.setTitleColor(.white, for: .normal)
            
            imgVisual.image = UIImage.init(named: "Visual.png")
            btnVisual.setTitleColor(.lightGray, for: .normal)
            imgRaw.image = UIImage.init(named: "rawUnSelect.png")
            btnRaw.setTitleColor(.lightGray, for: .normal)
            rawView.isHidden = true
            smoothView.isHidden = false
            visualview.isHidden = true
            
        }
        else if sender.tag == 3
        {
            isCircleAvail = true
            
            imgVisual.image = UIImage.init(named: "VisualSelected.png")
            btnVisual.setTitleColor(.white, for: .normal)
            
            imgSmooth.image = UIImage.init(named: "smooth.png")
            btnSmooth.setTitleColor(.lightGray, for: .normal)
            imgRaw.image = UIImage.init(named: "rawUnSelect.png")
            btnRaw.setTitleColor(.lightGray, for: .normal)
            visualview.isHidden = false
            rawView.isHidden = true
            smoothView.isHidden = true
        }
    }
    @objc func btnGraphTouchClick()
    {
        bottomView.isHidden = true
        viewSessionTime.isHidden = true
        btnBack.isHidden = false
        btnAlertView.isHidden = false
        btnTimer.isHidden = true
        btnBack.setImage(UIImage.init(named: "cancel.png"), for: .normal)
        timer?.invalidate()
    }
    @objc func btnEndSessinClick()
    {
        let strStatus = "1"
        
        let strChestPath = self.SaveCSVfiletoDatabase(strfilepath: "Chest")
        let strAbdPath = self.SaveCSVfiletoDatabase(strfilepath: "Abdomen")
        let update = "INSERT INTO Readings (session_time, chest_name, abdomen_name, status) VALUES ('\(strSessionTime)', '\(strChestPath)', '\(strAbdPath)', '\(strStatus)')"
        print("Database Query",update)

        if DataBaseController.shared.execute(sqlStatement: update) == true
        {
            print("Success")
        }
        else
        {
            print("Error")
        }

        
//        let firstActivityItem = URL(fileURLWithPath: exportFilePath)
//        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
//        self.present(activityViewController, animated: true, completion: nil)
    }
    @objc func SaveCSVfiletoDatabase(strfilepath : NSString) -> NSString
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var myString = formatter.string(from: Date())
        myString = myString.replacingOccurrences(of: ":", with: "")
        myString = myString.replacingOccurrences(of: "-", with: "")
        myString = myString.replacingOccurrences(of: " ", with: "")

        print(myString)
        
        let strPath = "\(strfilepath)" + "\(myString)" + ".csv"
        let exportFilePath = NSTemporaryDirectory() + strPath
        let exportFileURL = URL(fileURLWithPath: exportFilePath)
        FileManager.default.createFile(atPath: exportFilePath, contents: Data(), attributes: nil)
        //var fileHandleError: NSError? = nil
        var fileHandle: FileHandle? = nil
        do {
            fileHandle = try FileHandle(forWritingTo: exportFileURL)
        } catch {
            print( "Error with fileHandle")
        }
        if fileHandle != nil {
            fileHandle!.seekToEndOfFile()
            let nsdataToShare: Data = stringArrayToNSData(allRecordedChest)
            fileHandle!.write(/*csvData!*/ nsdataToShare)
            fileHandle!.closeFile()
        }
        return strPath as NSString
    }
    @objc func btnContinueSessionClick()
    {
        bottomView.isHidden = false
        viewSessionTime.isHidden = false
        btnBack.isHidden = false
        btnTimer.isHidden = false
        btnAlertView.isHidden = true
        btnBack.setImage(UIImage.init(named: "back.png"), for: .normal)
        UIView.transition(with: popViewAlert, duration: 0.5, options: .curveEaseIn, animations:
            {
                self.popViewAlert.frame = CGRect(x: 20, y: constants.heighs, width: constants.widths-40, height: 200)
                
                self.timer?.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 1.0,target: self, selector: #selector(self.timerAction),userInfo: nil,repeats: true)
        }, completion: {( finished: Bool) -> () in
            
        })
    }
    @objc func btnTimerClick()
    {
        
    }
    @objc func timerAction()
    {
        if(count1 > 0)
        {
            if count1 != 0
            {
                count1 += 1
            }
            else
            {
                if let timer = self.timer
                {
                    timer.invalidate()
                    self.timer = nil
                }
            }
            self.lblTime.text = self.timeFormatted(self.count1)
        }
    }
    func timeFormatted(_ totalSeconds: Int) -> String
    {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //MARK:- BLE Methods

    @objc func newValueDetected()
    {
        //        print("new value detected")
        result = []
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        for myPeripheralConnected in listPeripheralsConnected
        {
            for i in 0...myPeripheralConnected.previousValueAveraged.count-1
            {
                let p  =  myPeripheralConnected.previousValueAveraged[i]
                        print("new value detected",p)
                result.append(PointEntry(value: Int(p ), label: "0"))
            }
            curvedlineChart.drawCurvedChartwith(dataEnt: result)

//            rawChart.addLine(myPeripheralConnected.previousValueAveraged, colorNumber: strType)

        }
//        ask_new_data()
    }
    func ask_new_data()
    {
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        reloadGraph()
        if listPeripheralsConnected.count != 0
        {
            for myPeripheralConnected in listPeripheralsConnected
            {
                let strChestUUID: NSString = UserDefaults.standard.value(forKey: "ChestUUID") as? NSString ?? "NA"
                let strAbdUUID: NSString = UserDefaults.standard.value(forKey: "AbdomenUUID") as? NSString ?? "NA"
                let strUUID = myPeripheralConnected.uuid as String
                sentenceToRecord = "\n"
                let rawValueFromThePeripheral = myPeripheralConnected.previousValueRawFromTheSensor[myPeripheralConnected.previousValueRawFromTheSensor.count-1]
                let realValueFromThePeripheral = Int(rawValueFromThePeripheral /** 0.1*/)
                sentenceToRecord += "\(realValueFromThePeripheral)"
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss.SSS"
                let myString = formatter.string(from: Date())
                
                if strUUID == strChestUUID as String
                {
                    if isChestAllow == true
                    {
                        if sampleNumberC == 0
                        {
                            startTime = NSDate.timeIntervalSinceReferenceDate
                            sentenceToRecord = "Sensor Value"
                        }
                        allRecordedChest.append(sentenceToRecord)
                        sampleNumberC += 1
                        isChestAllow = false
                        print("Chest Value=",myString, sentenceToRecord)
                    }
                }
                else if strUUID == strAbdUUID as String
                {
                    if isAbdAllow == true
                    {
                        if sampleNumberA == 0
                        {
                            startTime = NSDate.timeIntervalSinceReferenceDate
                            sentenceToRecord = "Sensor Value"
                        }
                        allRecordedAbd.append(sentenceToRecord)
                        sampleNumberA += 1
                        isAbdAllow = false
                        print("ABD Value=",realValueFromThePeripheral,myString)
                    }
                }
            }
        }
    }
    func stringArrayToNSData(_ array: [String]) -> Data {
        print("stringArrayToNSData()")
        
        let data = NSMutableData()
        let terminator = [0]
        for string in array {
            if let encodedString = string.data(using: String.Encoding.utf8) {
                data.append(encodedString)
                data.append(terminator, length: 1)
            }
            else {
                NSLog("Cannot encode string \"\(string)\"")
            }
        }
        return data as Data
    }
    
    func reloadGraph()
    {
        rawChart.clear()
        smoothChart.clear()
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
                                        chestRect.origin.x = CGFloat((self.visualview.frame.width - vwithd)/2)
                                        chestRect.origin.y = CGFloat((self.visualview.frame.height - vwithd)/2)
                                        self.circleChest.frame = chestRect
                                        self.circleChest.layer.cornerRadius = chestRect.size.height/2
                                    }
                                    else
                                    {
                                        var chestRect : CGRect = self.circleAbdome.frame
                                        let vwithd = CGFloat(240 + (intVal))
                                        chestRect.size.width = vwithd
                                        chestRect.size.height = vwithd
                                        chestRect.origin.x = CGFloat((self.visualview.frame.width - vwithd)/2)
                                        chestRect.origin.y = CGFloat((self.visualview.frame.height - vwithd)/2)
                                        self.circleAbdome.frame = chestRect
                                        self.circleAbdome.layer.cornerRadius = chestRect.size.height/2
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
                        if (viewType == 1)
                        {
                            rawChart.addLine(myPeripheralConnected.previousValueAveraged, colorNumber: strType)//raw
                        }
                        else if (viewType == 2 )
                        {
                            smoothChart.addLine(myPeripheralConnected.previousValueAveraged, colorNumber: strType)
                        }
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
                    self.allRecordedChest = []
                    self.allRecordedAbd = []

                    self.sampleNumberC = 0
                    self.sampleNumberA = 0

                }))
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                }))
                present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Reading CSV file
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";;", with: "")
        //        cleanFile = cleanFile.replacingOccurrences(of: ";\n", with: "")
        return cleanFile
    }
    
}

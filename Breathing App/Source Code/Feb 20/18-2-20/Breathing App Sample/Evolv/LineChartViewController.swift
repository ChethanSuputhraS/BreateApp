//
//  ViewController.swift
//
//  Created by Jeremy Labrado on 11/04/16.
//  Copyright © 2016 StretchSense. All rights reserved.
//

import UIKit

class LineChartViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: VARIABLES
    
    // MARK: Variable for the lineChart
    var lineChart: LineChart!
    var circleChest : UILabel!
    var circleAbdome : UILabel!
    var circlView : UIView!

    // MARK: Variables for the sensors
    var listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
    var numberOfSample = stretchsenseObject.numberOfSample
    var numberOfThePeripheralToUpdate = 0 // the unique number of the sensor needed to be update
    
    // MARK: Variables of the slider
    var valueAverage : UInt8 = 0
    //var valueSamplingTime : UInt8 = 0
    
    // MARK: Variables for the new connection
    var newConnection : Bool = false
    var previousNumberOfPeripheral = 0 // to know if a new sensor is connected
    var defaultValueOfTheNewSensor : CGFloat = 0 //  to know if the new sensor is ready
    
    // MARK: Variables for the timestamps
    var timestampSampleRelativeTime = 0.0 // relative time
    var startTime = TimeInterval()

    // MARK: Variables for the object of the view(label, popupView...)
    @IBOutlet weak var tableValue: UITableView!
    @IBOutlet weak var view2: UIView! // View of the graph
    @IBOutlet weak var buttonRecord: UIBarButtonItem!
    //@IBOutlet weak var sliderSampling: UISlider!
    @IBOutlet weak var sliderFiltering: UISlider!
    
    // MARK:  Variables for the record
    var sampleNumber = 0
    var isRecording = false
    var sentenceToRecord = ""
    var allSentencesRecorded : [String] = [] // All the information recorded (numberOfTheSample, Time, ValueSensor1, ValueSensor2...)
    @IBOutlet weak var popupLabelTemporary: UIView! // PopupView for the record information
    @IBOutlet weak var labelRecord: UILabel! // The feedback to display on the Popup view
    
    // MARK: FUNCTIONS
    
    // MARK: View Functions
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when the view controller is Loaded
    /////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        /* This function is called as the initialiser of the view controller */
        print("viewDidLoad()")
        super.viewDidLoad()
        
        // Set the notifier
        let defaultCenter = NotificationCenter.default
        
        // Set the observer for 10 sensors, just add lines and functions to add more sensor
        defaultCenter.addObserver(self, selector: #selector(TableViewController.newValueDetected), name: NSNotification.Name(rawValue: "UpdateValueNotification"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(TableViewController.newValueDetected), name: NSNotification.Name(rawValue: "UpdateValueNotification "),object: nil)
        defaultCenter.addObserver(self, selector: #selector(TableViewController.newInfoDetected), name: NSNotification.Name(rawValue: "UpdateInfo"),object: nil)
        
        // Init the view
        var views: [String: AnyObject] = [:]
        // Init the lineChart in the previous views with constraint
        lineChart = LineChart()
        lineChart.area = false // color beneath the line
        lineChart.x.grid.count = 1
        lineChart.y.grid.count = 1
        lineChart.autoMinMax = false // by default, the lineChart auto rescale, if we press a "scale button" the auto stop
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        self.view2.addSubview(lineChart)
        
        self.view2.frame = CGRect(x: 0, y: 200, width: 375, height: 300)
        lineChart.frame = CGRect(x: 0, y: 0, width: 375, height: 300)
        views["chart"] = lineChart
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[chart]|", options: [], metrics: nil, views: views))
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[chart]|", options: [], metrics: nil, views: views))
//        self.tableValue.isHidden = true
        
        // Init the table
//        self.tableValue.delegate = self
//        self.tableValue.dataSource = self
//        tableValue.reloadData()
        
        sliderFiltering.value = Float(stretchsenseObject.filteringNumber)
        labelValueFiltering.text = String(Int(sliderFiltering.value))
        
        print("end of viewDidLoad")
        
        circlView = UIView()
        circlView.frame = CGRect(x: 0, y: 200, width: 375, height: 375)
        circlView.backgroundColor = UIColor.green
        self.view.addSubview(circlView)
        
        circleChest = UILabel()
        circleChest.frame = CGRect(x: 37, y: 37, width: 300, height: 300)
        circleChest.backgroundColor = UIColor.clear
        circleChest.layer.masksToBounds = true
        circleChest.layer.cornerRadius = 150
        circleChest.layer.borderWidth = 2.0
        circleChest.layer.borderColor = UIColor.blue.cgColor
        circlView.addSubview(circleChest)
        
        circleAbdome = UILabel()
        circleAbdome.frame = CGRect(x: 67, y: 67, width: 270, height: 270)
        circleAbdome.backgroundColor = UIColor.clear
        circleAbdome.layer.masksToBounds = true
        circleAbdome.layer.cornerRadius = 135
        circleAbdome.layer.borderWidth = 2.0
        circleAbdome.layer.borderColor = UIColor.red.cgColor
        circlView.addSubview(circleAbdome)
        
        //
    }  /* End of viewDidLoad() */
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when the view controller will appear
    /////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        // When we click on "Back", the function viewDidDisappear is called
        // We delete all the files recorded
        print("viewWillAppear()")
    }  /* End of viewWillAppear() */
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when the view controller will disappear
    /////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        
        // Reset the buffer of values after changing a view
        allSentencesRecorded = []
        sampleNumber = 0
    }  /* End of viewWillDisappear() */
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when the view controller disappear
    /////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidDisappear(_ animated: Bool) {
        print("viewDidDisapear")
        
        // Reset the buffer of values after sharing
        //allSentencesRecorded = []
        //sampleNumber = 0
        
        viewWillAppear(true)
    }  /* End of viewDidDisappear() */

    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    // MARK: New Value Functions (notification)
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when a new value is received from the API
    /////////////////////////////////////////////////////////////////////////////////////////
    func newInfoDetected() {
        print("NewInfoDetected()")
        /* if a notification is received, change label value*/
//        tableValue.reloadData()
        
        // Update the local list of peripheral
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when a new value is received from the API
    /////////////////////////////////////////////////////////////////////////////////////////
    func newValueDetected() {
        //print("NewValueDetected()")
        // Update the tables
        
//        tableValue.reloadData()        // Left table
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        
        ask_new_data()
        
        
    }  /* End of newValueDetected() */

    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is used to add the values in a buffer every time it is called
    /////////////////////////////////////////////////////////////////////////////////////////

    func ask_new_data(){
        //print("    func ask_new_data()")
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
//        print(listPeripheralsConnected.description)
        //newConnection = false
        reloadGraph()
//        tableValue.reloadData()

        displayValueMax()
        displayValueMin()


                    // If It's recording
                    if isRecording == true {
                        if sampleNumber == 0 {
                            // Set up the start timestamp with the first sample
                            startTime = NSDate.timeIntervalSinceReferenceDate

                            sentenceToRecord = "Sequence, Sample Number, Time, Sensor Value"
                            allSentencesRecorded.append(sentenceToRecord)

                        }
                        // For each new sample, get the time difference with the first sample
                        sampleNumber += 1
            
                        if (timestampSampleRelativeTime < 0){
                            timestampSampleRelativeTime = 0.0
                        }
                        else {
                            timestampSampleRelativeTime = NSDate.timeIntervalSinceReferenceDate - startTime
                        }
                        // The sentence type is: sample number, time, capacitanceSensor1, capacitanceSensor2...
                        sentenceToRecord = "\n" + String(Int(sliderFiltering.value)) + ", " + String(sampleNumber) + ", " + String(timestampSampleRelativeTime)

                        for myPeripheralConnected in listPeripheralsConnected{
                            
                            let rawValueFromThePeripheral = myPeripheralConnected.previousValueRawFromTheSensor[myPeripheralConnected.previousValueRawFromTheSensor.count-1]
                            let realValueFromThePeripheral = Int(rawValueFromThePeripheral /** 0.1*/)
                            sentenceToRecord += ", " + "\(realValueFromThePeripheral)"
                        }
                    
                        // We add the new
                        allSentencesRecorded.append(sentenceToRecord)
                    }

    }
    
    func reloadGraph(){
        //print("reloadGraph()")
        // Delete all the previous line
        lineChart.clear()

        self.view2.frame = CGRect(x: 0, y: 200, width: 375, height: 300)
        lineChart.frame = CGRect(x: 0, y: 0, width: 375, height: 300)

        // Display all the line from the connected peripheral list
        if listPeripheralsConnected.count != 0 {

            for myPeripheralConnected in listPeripheralsConnected {

                let strChestUUID  = String(format: "%@", UserDefaults.standard.value(forKey: "ChestUUID") as! CVarArg)
                let strAbdomenUUID = String(format: "%@", UserDefaults.standard.value(forKey: "AbdomenUUID") as! CVarArg)

                if myPeripheralConnected.display == true
                {
                    let strUUID = myPeripheralConnected.uuid as String
                    var strType : Int =  1
                    
                    if strUUID == strChestUUID
                    {
                        strType = 0
//                        print("Chest")
                    }
                    else if strUUID == strAbdomenUUID
                    {
                        strType = 1
//                        print("abdomen")
                    }
                    if isCircleAvail
                    {
                        if myPeripheralConnected.value != 0.0
                        {
                            var intVal : CGFloat = CGFloat(myPeripheralConnected.value - 280)
                            if intVal > 0
                            {
//                                print("valuesss",intVal)
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

    // MARK: Line chart Functions
    
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        /* Line chart delegate method. */
        //print("didSelectDataPoint()")
        //label.text = "x: \(x)     y: \(yValues)"
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        /* Redraw chart on device rotation. */
        //print("didRotateFromInterface()")
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }
    
    // MARK: Average function
    
    

    // MARK: ACTIONS

    // MARK: Add Peripheral Buttons
    
    @IBAction func barButtonTapped(_ sender: AnyObject) {
        /* This action is called when the '+' button is tapped */
        print("Button: barButtontapped")
        // Open the popoverController.swift
        let VC = storyboard?.instantiateViewController(withIdentifier: "PopOverController") as! PopOverViewController
        VC.preferredContentSize = CGSize(width: 300, height: 500)
        let navController = UINavigationController(rootViewController: VC)
        navController.modalPresentationStyle = UIModalPresentationStyle.popover
        let popOver = navController.popoverPresentationController
        popOver?.delegate = self
        popOver?.barButtonItem = sender as? UIBarButtonItem
        self.present(navController, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    // MARK: Set Min Max Buttons
    
    @IBOutlet weak var labelValueMax: UILabel!
    
    @IBAction func ButtonSetMax(_ sender: AnyObject) {
        /* This action is called when the 'rescale top' button is tapped */
        print("Button: SetMax()")
        // If we rescale manualy, we don't need the auto rescale
        lineChart.autoMinMax = false
        
        var maxValue = 0.0 as CGFloat
        if listPeripheralsConnected.count>0 {
            for myPeripheralConnected in listPeripheralsConnected{
                if myPeripheralConnected.display == true {
                    if Int(myPeripheralConnected.value) > Int(maxValue) {
                        maxValue = myPeripheralConnected.value
                        lineChart.setmax(Int(maxValue))
                    }
                    labelValueMax.text = "Max: " + String(describing: Int(maxValue/**0.1*/)) + " pF"
                }
            }
        }
    }
    
    func displayValueMax(){
        if listPeripheralsConnected.count>0 {
            var maxValue = 0.0 as CGFloat
            for myPeripheralConnected in listPeripheralsConnected{
                if myPeripheralConnected.display == true {
                    if Int(myPeripheralConnected.value) > Int(maxValue) {
                        maxValue = myPeripheralConnected.value
                    }
                    labelValueMax.text = "Max: " + String(describing: Int(maxValue/**0.1*/)) + " pF"
                }
            }
        }
    }
    @IBOutlet weak var labelValueMin: UILabel!

    func displayValueMin(){
        //print("displayValueMin()")
        var minValue = 90000.0 as CGFloat
        if listPeripheralsConnected.count>0 {
            for myPeripheralConnected in listPeripheralsConnected{
                if myPeripheralConnected.display == true {
                    
                    switch myPeripheralConnected.gen {
                    case "Accelerometer": ()
                        
                    case "Gyroscope": ()
                        
                    default: // "StretchSense Sensors"
                        if Int(myPeripheralConnected.value) < Int(minValue) {
                            minValue = CGFloat(myPeripheralConnected.value)
                        }
                        labelValueMin.text = "Min: " + String(describing: Int(minValue/**0.1*/)) + " pF"

                    }
                    
                    //if Int(myPeripheralConnected.value) < Int(minValue) {
                    //    minValue = CGFloat(myPeripheralConnected.value)
                    //}
                    //labelValueMin.text = "Min: " + String(describing: Int(minValue/**0.1*/)) + " pF"
                }
            }
        }
    }
    
    @IBAction func ButtonSetMin(_ sender: AnyObject) {
        /* This action is called when the 'rescale bottom' button is tapped */
        print("Button: SetMin()")
        // If we rescale manualy, we don't need the auto rescale
        lineChart.autoMinMax = false
        
        var minValue = 90000.0 as CGFloat
        if listPeripheralsConnected.count>0 {
            for myPeripheralConnected in listPeripheralsConnected{
                if myPeripheralConnected.display == true {
                    if Int(myPeripheralConnected.value) < Int(minValue) {
                        minValue = CGFloat(myPeripheralConnected.value)
                        lineChart.setmin(Int(minValue))
                    }
                    labelValueMin.text = "Min: " + String(describing: Int(minValue/**0.1*/)) + " pF"
                }
            }
        }
        
        
        
            }
    
    // MARK: Sliders
    
     /* Choose Frequency & Slider Average */
    
    //@IBOutlet weak var labelValuePeriod: UILabel!
    @IBOutlet weak var labelValueFiltering: UILabel!
    
    
    
    @IBAction func sliderAverage(_ sender: UISlider) {
        print("Slider: Average")
        /* This action is called when the 'average slider' is moving */
        stretchsenseObject.filteringNumber = UInt8(sender.value)

        labelValueFiltering.text = String(Int(sender.value)) + " pt"
        
    }
    
    
    
    // MARK: Buttons for the record
    
    
    
    @IBAction func recordPauseButton(_ sender: AnyObject) {
        /* This action is called when the 'record/pause' button is tapped */
        print("button : record/pause")
        if listPeripheralsConnected.count == 0 {
            print("button : record/pause - No Periph")

            // Display "No Sensor connected" during 2sec as a feedback information
            popupLabelTemporary.isHidden = false
            popupLabelTemporary.alpha = 1.0
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
            self.labelRecord.text = "No sensors connected"
        }
        else{
            print("button : record/pause - Periph Detected")

            if isRecording == true {
                print("button : record/pause - Periph Detected - is recording")

                // If the system is recording, go in pause mode
                isRecording = false
                // Reenable the sleep mode after a setted time
                UIApplication.shared.isIdleTimerDisabled = false
                // Display "Pause" during 2sec as a feedback information
                popupLabelTemporary.isHidden = false
                popupLabelTemporary.alpha = 1.0
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
                self.labelRecord.text = "Pause"
                // Change the icon of the play/pause button to blue
//                sender.setImage(UIImage(named: "recording"), for: UIControlState())
            }
            else {
                print("button : record/pause - Periph Detected - is not recording")

                // If the system is not recording, go in record mode
                isRecording = true
                // Disable the sleep mode after a setted time
                UIApplication.shared.isIdleTimerDisabled = true
                // Display "Recording" during 2sec as a feedback information
                popupLabelTemporary.isHidden = false
                popupLabelTemporary.alpha = 1.0
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
                self.labelRecord.text = "Recording"
                // Change the icon of the play/pause button to red
//                sender.setImage(UIImage(named: "recordPause"), for: UIControlState())
                print("button : record/pause - Periph Detected - is not recording - end of else")
            }
        }
    }

    
    @IBAction func deleteRecord(_ sender: AnyObject) {
        /* This action is called when the 'record/pause' button is tapped */
        print("button4: Clean record")
        
        if listPeripheralsConnected.count == 0 {
            // Display "No sensor connected" during 2sec as a feedback information
            popupLabelTemporary.isHidden = false
            popupLabelTemporary.alpha = 1.0
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
            self.labelRecord.text = "No sensors connected"
        }
        else{
            if isRecording == true {
                // If the system is recording, ask to stop recording first
                // Display "Stop Recording first" during 2sec as a feedback information
                popupLabelTemporary.isHidden = false
                popupLabelTemporary.alpha = 1.0
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
                self.labelRecord.text = "Stop Recording First"
                
            }
            else {
                // If the system is not recording, ask for permission to delete the data recorded

                let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete all recorded data? ", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                    // If the delete is confirmed, delete everything
                    // Reinitialize timestamp
                    self.timestampSampleRelativeTime = 0.0
                    // Reinitialize the array of record
                    self.allSentencesRecorded = []
                    // Reinitialize the sample number
                    self.sampleNumber = 0
                    
                    // Display "Deleted" during 2sec as a feedback information
                    self.popupLabelTemporary.isHidden = false
                    self.popupLabelTemporary.alpha = 1.0
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
                    self.labelRecord.text = "Deleted"
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                    // If the delete is not confirmed, do not delete
                    // Display "Canceled" during 2sec as a feedback information
                    self.popupLabelTemporary.isHidden = false
                    self.popupLabelTemporary.alpha = 1.0
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
                    self.labelRecord.text = "Canceled"
                }))
                
                present(refreshAlert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func shareButton(_ sender: AnyObject) {
        
        /* This action is called when the 'record/pause' button is tapped */
        print("button : share")
        
        if listPeripheralsConnected.count == 0 {
            // Display "Nothing to Share" during 2sec as a feedback information
            popupLabelTemporary.isHidden = false
            popupLabelTemporary.alpha = 1.0
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
            self.labelRecord.text = "Nothing to Share"
        }
        else {
            if isRecording == false {
                print("isRecording=false")

                if allSentencesRecorded == [] {
                    print("isRecording=false - allSentencesRecorded==[]")

                    // Display "Sharing" during 2sec as a feedback information
                    popupLabelTemporary.isHidden = false
                    popupLabelTemporary.alpha = 1.0
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
                    self.labelRecord.text = "Nothing to Share"
                }
                else{
                    print("isRecording=false - else")
                    // Display "Sharing" during 2sec as a feedback information
                    popupLabelTemporary.isHidden = false
                    popupLabelTemporary.alpha = 1.0
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
                    self.labelRecord.text = "Sharing"
                    // Share all the sentences recorded
                    print("share")
                    saveAndExport(allSentencesRecorded)
                    print("isRecording=false - else end")
                }
            }
            else {
                // Display "Stop Recording first" during 2sec as a feedback information
                print("isRecording=true")

                popupLabelTemporary.isHidden = false
                popupLabelTemporary.alpha = 1.0
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
                self.labelRecord.text = "Stop Recording First"
            }
        }
        print("button : share end")

    }
    
    @objc func waitFor2sec() {
        print("waitFor2sec()")
        UIView.animate(withDuration: 2.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.popupLabelTemporary.alpha = 0.0
            }, completion: nil)
    }

    // MARK: TABLE

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRowInSection()")
        // Set the number of Rows in the Table
        var nSensor = 0

        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        for myPeripheral in listPeripheralsConnected{
            switch myPeripheral.gen {
                case "Accelerometer": ()
            
                case "Gyroscope": ()
            
                default: // "StretchSense Sensors"
                    nSensor = nSensor + 1
            }
        }
    
        return nSensor
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSectionsInTableView()")
        // Set the number of Section in the table
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // print("cellForRowAtIndexPath()")
        // This function filled each cell with the UUID and set the background color depending on the sensors's state
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        
        if listPeripheralsConnected.count != 0 {
            // For each row, we complete it with the UUID of the sensor
            if listPeripheralsConnected.count-1 >= (indexPath as NSIndexPath).row {

                let currentPeripheral = listPeripheralsConnected[(indexPath as NSIndexPath).row]
                let rawValueFromThePeripheral = currentPeripheral.previousValueAveraged[currentPeripheral.previousValueRawFromTheSensor.count-1]
                
                let stringValue = String(format: "%.2f", (rawValueFromThePeripheral/* * 0.1*/))
                
                //cell.textLabel?.text = "\((rawValueFromThePeripheral * 0.1))" + " pF"
                cell.textLabel?.text = stringValue + " pF"
                //cell.backgroundColor = colors[listPeripheralsConnected[indexPath.row].uniqueNumber]
                let myPeripheral = listPeripheralsConnected[(indexPath as NSIndexPath).row]

                if myPeripheral.display == true {
                    cell.backgroundColor = myPeripheral.colors[myPeripheral.uniqueNumber].colorValueRGB//SWIFT2
                    
                    switch myPeripheral.value {
                    case 50..<1000: //greater or equal than 50 and less than 1000
                        cell.backgroundColor = myPeripheral.colors[myPeripheral.uniqueNumber].colorValueRGB//SWIFT2
                    default:
                        cell.backgroundColor = UIColor.red
                    }

                    
                    
                }
                else{
                    cell.backgroundColor = UIColor(white: 1, alpha: 0.5)
                }
            }
        }
        
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAtIndexPath()")
        print(indexPath.row)
        
        var numberOfPeripheralToDisplay = 0
        for myPeripheralConnected in listPeripheralsConnected{
            if (myPeripheralConnected.display == true){
                numberOfPeripheralToDisplay += 1
            }
        }
        
        let myPeripheral = listPeripheralsConnected[(indexPath as NSIndexPath).row]
        if myPeripheral.display == true {
            if numberOfPeripheralToDisplay > 1 {
                myPeripheral.display = false
            }
        }
        else{
            myPeripheral.display = true
        }
//        tableValue.reloadData()
    }
  
}
 //CHest - 0.65, abdoement - 0.58
 

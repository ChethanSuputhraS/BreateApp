//
//  ViewController.swift
//
//  Created by Jeremy Labrado on 11/04/16.
//  Copyright © 2016 StretchSense. All rights reserved.
//

import UIKit

class BarGraphViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: VARIABLES

    // MARK: Variable for the lineChart
    var lineChart: LineChart!
    
   // MARK: Variables for the sensors
    var listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
    //var listPeriph : [String] = []
    var numberOfSample = 10
    var arrayData = [[CGFloat]](repeating: [CGFloat](repeating: CGFloat(0), count: 10), count: 1)
    var arrayDataBarGraph = [[CGFloat]](repeating: [CGFloat](repeating: CGFloat(0), count: 2), count: 1)
    var numberOfThePeripheralToUpdate = 0
    
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
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var buttonRecord: UIBarButtonItem!
    //@IBOutlet weak var sliderSampling: UISlider!
    @IBOutlet weak var sliderFiltering: UISlider!
    
    // MARK: Variables for the record
    var sampleNumber = 0
    var isRecording = false
    var sentenceToRecord = ""
    var allSentencesRecorded : [String] = [] // All the information recorded (numberOfTheSample, Time, ValueSensor1, ValueSensor2...)
    @IBOutlet weak var popupLabelTemporary: UIView! // PopupView for the record information
    @IBOutlet weak var labelRecord: UILabel! // The feedback to display on the Popup view

    
    // MARK: FUNCTIONS
    
    // MARK: View Functions

    override func viewDidLoad() {
        // This function is called as the initialiser of the view controller
        //print("viewDidLoad()")
        super.viewDidLoad()
        
        // Set the notifier
        let defaultCenter = NotificationCenter.default
        // Set the observer for 10 sensors, just add lines and functions to add more sensor
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected), name: NSNotification.Name(rawValue: "UpdateValueNotification"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected), name: NSNotification.Name(rawValue: "UpdateValueNotification "),object: nil)
        
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected0), name: NSNotification.Name(rawValue: "UpdateValueNotification0"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected1), name: NSNotification.Name(rawValue: "UpdateValueNotification1"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected2), name: NSNotification.Name(rawValue: "UpdateValueNotification2"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected3), name: NSNotification.Name(rawValue: "UpdateValueNotification3"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected4), name: NSNotification.Name(rawValue: "UpdateValueNotification4"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected5), name: NSNotification.Name(rawValue: "UpdateValueNotification5"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected6), name: NSNotification.Name(rawValue: "UpdateValueNotification6"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected7), name: NSNotification.Name(rawValue: "UpdateValueNotification7"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected8), name: NSNotification.Name(rawValue: "UpdateValueNotification8"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(BarGraphViewController.newValueDetected9), name: NSNotification.Name(rawValue: "UpdateValueNotification9"),object: nil)
        
        /*defaultCenter.addObserver(self, selector: #selector(PopOverViewController.newInfoDetected), name: NSNotification.Name(rawValue: "UpdateInfo"),object: nil)*/

        
        // Init the view
        var views: [String: AnyObject] = [:]
        // Init the lineChart in the previous views with constraint
        lineChart = LineChart()
        lineChart.area = true // color beneath the line
        lineChart.x.grid.count = 1
        lineChart.y.grid.count = 4
        lineChart.autoMinMax = false // by default, the lineChart auto rescale, if we press a "scale button" the auto stop
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        self.view2.addSubview(lineChart)
        views["chart"] = lineChart
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[chart]|", options: [], metrics: nil, views: views))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[chart]|", options: [], metrics: nil, views: views))
        // Init the table
        self.tableValue.delegate = self
        self.tableValue.dataSource = self
        tableValue.reloadData()
        
        //temporary label/////////////////////////////////////////////////////////
        popupLabelTemporary.isHidden = true
        popupLabelTemporary.layer.cornerRadius = 5;
        popupLabelTemporary.layer.masksToBounds = true////////////////////////////
        
        //sliderSampling.value = Float(stretchsenseObject.samplingTimeNumber)
        sliderFiltering.value = Float(stretchsenseObject.filteringNumber)
        //labelValuePeriod.text = String(Int((stretchsenseObject.samplingTimeNumber) + 1) * 40) + " ms"
        labelValueFiltering.text = String(Int(stretchsenseObject.filteringNumber)) + " pts"
    }

    override func viewWillDisappear(_ animated: Bool) {
        // When we click on "Back", the function viewDidDisappear is called
        // We delete all the files recorded
        print("viewWillDisappear()")

        self.allSentencesRecorded = []
        //self.sampleNumber = 0
    }
    
    // MARK: New Info Function
    
    func newInfoDetected() {
        print("newInfoDetected()")
        // if a notification is received, change label Informations Feedback
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
    }
    
    // MARK: New Value Functions
    //
    @objc func newValueDetected0() {
        //*When a new value from the sensor 0 is detected, we update the numberOfThePeripheralToUpdate to 0 */
        numberOfThePeripheralToUpdate = 0
        newValueDetected()
    }
    @objc func newValueDetected1() {
        //*When a new value from the sensor 1 is detected, we update the numberOfThePeripheralToUpdate to 1 */
        numberOfThePeripheralToUpdate = 1
        newValueDetected()
    }
    @objc func newValueDetected2() {
        //*When a new value from the sensor 2 is detected, we update the numberOfThePeripheralToUpdate to 2 */
        numberOfThePeripheralToUpdate = 2
        newValueDetected()
    }
    @objc func newValueDetected3() {
        //*When a new value from the sensor 3 is detected, we update the numberOfThePeripheralToUpdate to 3 */
        numberOfThePeripheralToUpdate = 3
        newValueDetected()
    }
    @objc func newValueDetected4() {
        //*When a new value from the sensor 4 is detected, we update the numberOfThePeripheralToUpdate to 4 */
        numberOfThePeripheralToUpdate = 4
        newValueDetected()
    }
    @objc func newValueDetected5() {
        //*When a new value from the sensor 5 is detected, we update the numberOfThePeripheralToUpdate to 5 */
        numberOfThePeripheralToUpdate = 5
        newValueDetected()
    }
    @objc func newValueDetected6() {
        //*When a new value from the sensor 6 is detected, we update the numberOfThePeripheralToUpdate to 6 */
        numberOfThePeripheralToUpdate = 6
        newValueDetected()
    }
    @objc func newValueDetected7() {
        //*When a new value from the sensor 7 is detected, we update the numberOfThePeripheralToUpdate to 7 */
        numberOfThePeripheralToUpdate = 7
        newValueDetected()
    }
    @objc func newValueDetected8() {
        //*When a new value from the sensor 8 is detected, we update the numberOfThePeripheralToUpdate to 8 */
        numberOfThePeripheralToUpdate = 8
        newValueDetected()
    }
    @objc func newValueDetected9() {
        //*When a new value from the sensor 9 is detected, we update the numberOfThePeripheralToUpdate to 9 */
        numberOfThePeripheralToUpdate = 9
        newValueDetected()
    }
    @objc func newValueDetected() {
        //print("newValueDetected()")
        reloadGraph()
        tableValue.reloadData()
        displayValueMax()
        displayValueMin()

        
                // If It's recording
                if isRecording == true {
                    if sampleNumber == 0 {
                        // Set up the start timestamp with the first sample
                        startTime = Date.timeIntervalSinceReferenceDate
                        
                        sentenceToRecord = "Sample Number, Time, Sensor Value"
                        allSentencesRecorded.append(sentenceToRecord)
                    }
                    // For each new sample, get the time difference with the first sample
                    sampleNumber += 1
                    if (timestampSampleRelativeTime < 0){
                        timestampSampleRelativeTime = 0.0
                    }
                    else {
                        timestampSampleRelativeTime = Date.timeIntervalSinceReferenceDate - startTime
                    }
                    

                    // The sentence type is: sample number, time, capacitanceSensor1, capacitanceSensor2...
                    sentenceToRecord = "\n" + String(sampleNumber) + ", " + String(timestampSampleRelativeTime)
                    
                    for myPeripheralConnected in listPeripheralsConnected{
                        
                        let rawValueFromThePeripheral = myPeripheralConnected.previousValueRawFromTheSensor[myPeripheralConnected.previousValueRawFromTheSensor.count-1]
                        let realValueFromThePeripheral = Int(rawValueFromThePeripheral)
                        sentenceToRecord += ", " + "\(realValueFromThePeripheral)"
                    }
                    print(sentenceToRecord)
                    
                    // We add the new
                    allSentencesRecorded.append(sentenceToRecord)
                }
/*
            }
        }*/
    }

    func reloadGraph(){
        //print("reloadGraph()")
        // Delete all the previous line
        lineChart.clear()
        // Display all the line from the connected peripheral list
        if listPeripheralsConnected.count != 0 {
            for myPeripheralConnected in listPeripheralsConnected {
                if myPeripheralConnected.display == true{

                    // create an array of 2 same point (the last value of the previous values array)
                    let array2Values = [myPeripheralConnected.previousValueRawFromTheSensor[myPeripheralConnected.previousValueRawFromTheSensor.count-1], myPeripheralConnected.previousValueRawFromTheSensor[myPeripheralConnected.previousValueRawFromTheSensor.count-1],]

                    lineChart.addLine(array2Values, colorNumber: myPeripheralConnected.uniqueNumber)
                }
            }
        }
    }
    
    // MARK: Line chart Functions
    
    /* Line chart delegate method. */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        print("didSelectDataPoint()")
        //label.text = "x: \(x)     y: \(yValues)"
    }
    
    /* Redraw chart on device rotation. */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        /* Redraw chart on device rotation. */
        print("didRotateFromInterface()")
        
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }

    // MARK: Average function
    
    /*func average(newValueInt: CGFloat, averageNumber: Int, sensorNumber: Int) -> CGFloat{
        print("average()")
        /* this function return the average of the last values */
        /* 10 values averaged maximum */
        
        // if average = 0 or 1, no average needed
        if averageNumber == 0 || averageNumber == 1{
            return newValueInt
        }
        else {
            // average the 'averageNumber-1' previous values and the new value 'newValueInt'
            var sumAverageNumber: CGFloat = 0
            
            for myPeripheralConnected in listPeripheralsConnected{
                if myPeripheralConnected.uniqueNumber == sensorNumber{
                    for i in 1 ... averageNumber-1{
                        sumAverageNumber += myPeripheralConnected.previousValue[numberOfSample-1-i]
                    }
                }
            }
            return CGFloat((sumAverageNumber+newValueInt)/CGFloat(averageNumber))
        }
    }
    */
    // MARK: ACTIONS
    
    // MARK: Add Peripheral Buttons
    
    @IBAction func barButtonTapped(_ sender: AnyObject) {
        /* This action is called when the '+' button is tapped */
        print("Button: barButtonTapped")
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
        print("adapativePresentationStyle()")
        return .none
    }

    // MARK: Set Min Max Buttons
    
    @IBOutlet weak var labelValueMin: UILabel!
    
    @IBAction func ButtonSetMin(_ sender: UIButton) {
        /* This action is called when the 'rescale bottom' button is tapped */
        print("Button: SetMin()")
        // If we rescale manualy, we don't need the auto rescale
        lineChart.autoMinMax = true
        
        // Set the highest value the top of the chart
        if listPeripheralsConnected.count==1 {
            lineChart.setmin(Int(listPeripheralsConnected[0].value))
            labelValueMax.text = "Min: " + String(describing: listPeripheralsConnected[0].value) + " pF"
        }
        if listPeripheralsConnected.count>1 {
            var minValue = 1000
            for myPeripheralConnected in listPeripheralsConnected{
                if Int(myPeripheralConnected.value) < minValue {
                    minValue = Int(myPeripheralConnected.value)
                }
                lineChart.setmin(minValue)
                labelValueMax.text = "Min: " + String(minValue) + " pF"
            }
        }
    }
    
    @IBOutlet weak var labelValueMax: UILabel!
    
    @IBAction func buttonSetMax(_ sender: UIButton) {
        /* This action is called when the 'rescale top' button is tapped */
        print("Button: SetMax()")
        // If we rescale manualy, we don't need the auto rescale
        lineChart.autoMinMax = true
        
        // Set the highest value the top of the chart
        if listPeripheralsConnected.count==1 {
            /*lineChart.setmax(Int(listPeripheralsConnected[0].value))
            labelValueMax.text = "Max: " + String(describing: listPeripheralsConnected[0].value) + " pF"
        }
        if listPeripheralsConnected.count>1 {*/
            var maxValue = 0
            for myPeripheralConnected in listPeripheralsConnected{
                if Int(myPeripheralConnected.value) > maxValue {
                    maxValue = Int(myPeripheralConnected.value)
                }
                lineChart.setmax(maxValue)
                labelValueMax.text = "Max: " + String(maxValue) + " pF"
            }
        }
    }
    
    func displayValueMax(){
        if listPeripheralsConnected.count==1 {
            //lineChart.setmax(Int(listPeripheralsConnected[0].value))
            let valueToDisplay = listPeripheralsConnected[0].value
            labelValueMax.text = "Max: " + String(describing: valueToDisplay) + " pF"
        }
        if listPeripheralsConnected.count>1 {
            var maxValue = 0.0 as CGFloat
            for myPeripheralConnected in listPeripheralsConnected{
                if Int(myPeripheralConnected.value) > Int(maxValue) {
                    maxValue = myPeripheralConnected.value
                }
                labelValueMax.text = "Max: " + String(describing: Int(maxValue)) + " pF"
            }
        }

    }
    
    func displayValueMin(){
        //print("displayValueMin()")
        var minValue = 90000.0 as CGFloat
        if listPeripheralsConnected.count>0 {
            for myPeripheralConnected in listPeripheralsConnected{
                if myPeripheralConnected.display == true {
                    if Int(myPeripheralConnected.value) < Int(minValue) {
                        minValue = CGFloat(myPeripheralConnected.value)
                    }
                    labelValueMin.text = "Min: " + String(describing: Int(minValue)) + " pF"
                }
            }
        }
    }

    // MARK: Sliders
    
    /* Choose Frequency & Slider Average */

    //@IBOutlet weak var labelValuePeriod: UILabel!
    @IBOutlet weak var labelValueFiltering: UILabel!
    
    
    /*@IBAction func sliderSamplingTime(_ sender: UISlider) {
        /* This action is called when the 'sampling time slider' is moving */
        //sampling time = (x+1)*40
        print("Slider: SamplingTime")
        
        stretchsenseObject.samplingTimeNumber = UInt8(sender.value)
        labelValuePeriod.text = String(Int(sender.value+1)*40) + " ms"
        if (listPeripheralsConnected.count != 0){
            valueSamplingTime = UInt8(sender.value)
            let listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
            for myPeripheralAvailable in listPeripheralsAvailable {
                stretchsenseObject.writeSamplingTime(UInt8(sender.value), myPeripheral: myPeripheralAvailable)
            }
        }
    }*/
    
    @IBAction func sliderAverage(_ sender: UISlider) {
        //print("Slider: Average")
        /* This action is called when the 'average slider' is moving */
        stretchsenseObject.filteringNumber = UInt8(sender.value)

        labelValueFiltering.text = String(Int(sender.value))
        /*if (listPeripheralsConnected.count != 0){
            valueAverage = UInt8(sender.value)
            print(valueAverage)
            let listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
            for myPeripheralAvailable in listPeripheralsAvailable {
                stretchsenseObject.writeAverage(valueAverage, myPeripheral: myPeripheralAvailable)
            }
        }*/
    }
    
    
    // MARK: Buttons for the record
    
    @IBAction func recordStop(_ sender: AnyObject) {
        /* This action is called when the 'record/pause' button is tapped */
        //print("button : record/pause")
        
        if listPeripheralsConnected.count == 0 {
            // Display "No Sensor connected" during 2sec as a feedback information
            popupLabelTemporary.isHidden = false
            popupLabelTemporary.alpha = 1.0
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
            self.labelRecord.text = "No sensors connected"
        }
        else{
            if isRecording == true {
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
                sender.setImage(UIImage(named: "recording"), for: UIControlState())
            }
            else {
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
                sender.setImage(UIImage(named: "recordPause"), for: UIControlState())
            }
        }
    }
    
    @IBAction func deleteRecord(_ sender: AnyObject) {
        /* This action is called when the 'record/pause' button is tapped */
        //print("button4: Clean record")
        
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
                self.labelRecord.text = "Stop Recording first"
            }
            else {
                // If the system is not recording, ask for permission to delete the data recorded
                
                let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to delete all recorded data? ", preferredStyle: UIAlertControllerStyle.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                    // If the delete is confirmed, delete everything
                    // Reinitialize timestamp
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
        //print("button : share")
        
        if listPeripheralsConnected.count == 0 {
            // Display "Nothing to Share" during 2sec as a feedback information
            popupLabelTemporary.isHidden = false
            popupLabelTemporary.alpha = 1.0
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
            self.labelRecord.text = "Nothing to Share"
        }
        else {
            if isRecording == false {
                if allSentencesRecorded != [] {

                    // Display "Sharing" during 2sec as a feedback information
                    popupLabelTemporary.isHidden = false
                    popupLabelTemporary.alpha = 1.0
                    Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
                    self.labelRecord.text = "Sharing"
                    // Share all the sentences recorded
                    saveAndExport(allSentencesRecorded)
                }
            }
            else {
                // Display "Stop Recording first" during 2sec as a feedback information
                popupLabelTemporary.isHidden = false
                popupLabelTemporary.alpha = 1.0
                Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(LineChartViewController.waitFor2sec), userInfo: nil, repeats: false)
                self.labelRecord.text = "Stop Recording First"
            }
        }
    }
    
    func waitFor2sec() {
        //print("waitFor2sec()")
        UIView.animate(withDuration: 2.0, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.popupLabelTemporary.alpha = 0.0
            }, completion: nil)
    }
    
    // MARK: TABLE
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRowInSection()")
        // Set the number of Rows in the Table
        
        return stretchsenseObject.getNumberOfPeripheralConnected()

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSectionsInTableView()")
        // Set the number of Section in the table
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath()")
        // This function filled each cell with the UUID and set the background color depending on the sensors's state
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        
        if listPeripheralsConnected.count != 0 {
            // For each row, we complete it with the UUID of the sensor
            if listPeripheralsConnected.count-1 >= (indexPath as NSIndexPath).row {

                let currentPeripheral = listPeripheralsConnected[(indexPath as NSIndexPath).row]
                let rawValueFromThePeripheral = currentPeripheral.previousValueAveraged[currentPeripheral.previousValueRawFromTheSensor.count-1]
                
                let stringValue = String(format: "%.2f", (rawValueFromThePeripheral))
                
                //cell.textLabel?.text = "\((rawValueFromThePeripheral * 0.1))" + " pF"
                cell.textLabel?.text = stringValue + " pF"
                //cell.backgroundColor = colors[listPeripheralsConnected[indexPath.row].uniqueNumber]
                let myPeripheral = listPeripheralsConnected[(indexPath as NSIndexPath).row]
                
                if myPeripheral.display == true {
                    cell.backgroundColor = myPeripheral.colors[myPeripheral.uniqueNumber].colorValueRGB//SWIFT2
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
        tableValue.reloadData()
    }
    
}

 

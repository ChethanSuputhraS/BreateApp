//
//  ViewController.swift
//
//  Created by Jeremy Labrado on 11/04/16.
//  Copyright © 2016 StretchSense. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: VARIABLES

    // MARK: Variables for the sensors
    var numberOfThePeripheralToUpdate = 0

    // MARK: Variable for the table Value
    @IBOutlet weak var myTableView: UITableView!

    @IBOutlet weak var ShareButton: UIBarButtonItem!
    @IBOutlet weak var ShareUIButton: UIButton!

    // MARK: Variables for the record
    var sampleNumber = 0                                    // The number of sample recorded
    var isRecording = false                                 // Bool
    var sentenceToRecord = ""                               // A line of the csv file
    var allSentencesRecorded : [String] = []                // Buffer of all the information recorded (numberOfTheSample, Time, L1...L96, R1...R96)
    var timestampSampleRelativeTime = 0.0                   // relative time
    var startTime = TimeInterval()                          // Value at the beggining of the record
    var timer = Timer()
    var previousValueTimer = 1.00                           //  1 second
    
    var listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()             // The list of all the left leg connected to the app

    // MARK: FUNCTIONS
    
    // MARK: View Functions
    
    override func viewDidLoad() {
        //print("viewDidLoad()")
        /* This function is called as the initialiser of the view controller */
        super.viewDidLoad()

        // Set the notifier
        let defaultCenter = NotificationCenter.default
        // Set the observer for 10 sensors, just add lines and functions to add more sensor
        defaultCenter.addObserver(self, selector: #selector(TableViewController.newValueDetected), name: NSNotification.Name(rawValue: "UpdateValueNotification"),object: nil)
        defaultCenter.addObserver(self, selector: #selector(TableViewController.newValueDetected), name: NSNotification.Name(rawValue: "UpdateValueNotification "),object: nil)
        defaultCenter.addObserver(self, selector: #selector(TableViewController.newInfoDetected), name: NSNotification.Name(rawValue: "UpdateInfo"),object: nil)
        
        // Init the table
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        myTableView.reloadData()
        self.myTableView.rowHeight = 40;

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
        //allSentencesRecorded = []
        //sampleNumber = 0
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
    @objc func newInfoDetected() {
        print("NewInfoDetected()")
        /* if a notification is received, change label value*/
        myTableView.reloadData()
        
        // Update the local list of peripheral
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when a new value is received from the API
    /////////////////////////////////////////////////////////////////////////////////////////
    @objc func newValueDetected() {
        print("NewValueDetected()")
        // Update the tables
        
        myTableView.reloadData()        // Left table
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()

        ask_new_data()

        
    }  /* End of newValueDetected() */

    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is used to add the values in a buffer every time it is called
    /////////////////////////////////////////////////////////////////////////////////////////
    func ask_new_data(){
        //print("ask_new_data()")
        
        // Ask the StretchSense API to read the value of the sensors connected
        //stretchsenseObject.updateCapacitanceTako()
        
        // If both left and right leg are connected
        print("getNumberConnected: ", stretchsenseObject.getNumberOfPeripheralConnected())
        if (stretchsenseObject.getNumberOfPeripheralConnected() != 0){
            print("sampleNumber0: ", sampleNumber)

            // Initialisation of the buffer
            if sampleNumber == 0 {
                // Set up the start timestamp with the first sample
                startTime = Date.timeIntervalSinceReferenceDate
                
                // The header of the file
                sentenceToRecord = "Sample Number, Time, "
                for myPeripheralConnected in stretchsenseObject.getListPeripheralsConnected(){
                    //sentenceToRecord += "\(myPeripheralConnected.gen)" + "Ch , "

                    switch myPeripheralConnected.gen{
                    case "15"   : (sentenceToRecord += "1 , ")
                    case "17"   : (sentenceToRecord += "10 , ")
                    case "96"   : (sentenceToRecord += "Left , ")
                    case "97"   : (sentenceToRecord += "Right , ")
                    case "98"   : (sentenceToRecord += "Front , ")
                    case "99"   : (sentenceToRecord += "Back , ")

                    default     : (sentenceToRecord += "\(myPeripheralConnected.gen)" + "Ch , ")
                    }
                }

                // Add the header to the buffer
                allSentencesRecorded.append(sentenceToRecord)
            }
            
            // Calculation of the timestamps
            
            if (timestampSampleRelativeTime < 0){
                timestampSampleRelativeTime = 0.0
            }
            else {
                timestampSampleRelativeTime = Date.timeIntervalSinceReferenceDate - startTime
            }
            
            // Wait 5 values from the circuits to have the values stabilized
            if sampleNumber < 5 {
                // Disable the Share button during the five first samples
                ShareUIButton.isEnabled = false
                // Put the share button red to say to wait
                ShareUIButton.setImage(#imageLiteral(resourceName: "share_red"), for: .normal)
            }
            
            // When you have more than 5 values, the circuits capacitance are stabilized and you can add them to the buffer
            if sampleNumber > 5 {
                
                if sampleNumber > 10 {
                    // 10 values are enough to have a good average
                    ShareUIButton.setImage(#imageLiteral(resourceName: "share_green"), for: .normal)
                }
                else{
                    // 5 values are possibly enough to have a good average but not recommanded
                    ShareUIButton.setImage(#imageLiteral(resourceName: "share_orange"), for: .normal)
                    ShareUIButton.isEnabled = true
                    
                }
                
                // Add the first 2 column in the sentence to record (sample number and timestamps)
                sentenceToRecord = "\n" + String(sampleNumber-5) + ", " + String(timestampSampleRelativeTime)
                
                // Add the L1...L96 values to the sentence to record
                for myPeripheralConnected in stretchsenseObject.getListPeripheralsConnected(){
                    let valueFromThePeripheral = myPeripheralConnected.value
                    let realValueFromThePeripheral = (valueFromThePeripheral)
                    sentenceToRecord += ", " + "\(realValueFromThePeripheral)"
                }
                
                // Add the sentence recorded to the buffer
                //print(sentenceToRecord)
                allSentencesRecorded.append(sentenceToRecord)
                
            }
            // This samples is added to the recorded buffer
            sampleNumber += 1
            print("sample number1: " , sampleNumber)
        }
    }  /* End of ask_new_data() */
    
    

    // MARK:  TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRowInSection()")
        return stretchsenseObject.getNumberOfPeripheralConnected()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSectionsInTableView()")
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAt")
        
        var listPeripheralsConnected = [StretchSensePeripheral]()
        listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        
        // Declaration of the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellValue", for: indexPath) as UITableViewCell
        
        // Each row is updated with the corresponding capacitance, BLE module and color depending on the capacitance value
        if (indexPath as NSIndexPath).row <= listPeripheralsConnected.count-1 {
            //print(listPeripheralsConnected[1].value)
            
            //Declaration
            let index_of_the_cell = (indexPath as NSIndexPath).row
            var peripheral_of_the_cell = listPeripheralsConnected[index_of_the_cell]
            
            // Text
            var unit = ""
            
            switch peripheral_of_the_cell.gen {
            case "Accelerometer":
                unit = " g"
                
                // Background color
                switch peripheral_of_the_cell.value {
                case -20..<20: //greater or equal than -20 and less than 20
                    cell.backgroundColor = UIColor.green
                default:
                    cell.backgroundColor = UIColor.red
                }
                
            case "Gyroscope":
                unit = " degrees"
                
                // Background color
                switch peripheral_of_the_cell.value {
                case -360..<360: //greater or equal than -360 and less than 360
                    cell.backgroundColor = UIColor.green

                default:
                    cell.backgroundColor = UIColor.red
                }
                
            default: // "StretchSense Sensors"
                unit = " pf"
                
                // Background color
                switch peripheral_of_the_cell.value {
                case 20..<50: //greater or equal than 20 and less than 50
                    cell.backgroundColor = UIColor.orange
                case 50..<1200: //greater or equal than 50 and less than 1000
                    cell.backgroundColor = UIColor.green
                case 1200..<1500: //greater or equal than 1000 and less than 1500
                    cell.backgroundColor = UIColor.red
                default:
                    cell.backgroundColor = UIColor.red
                }
                
            }
        
            cell.textLabel?.text = "\((peripheral_of_the_cell.value))" + unit
            
            
            // Subtitles text
            cell.detailTextLabel?.text = "\(peripheral_of_the_cell.uniqueNumber+1)" + ") Type: " + "\(String(describing: String(peripheral_of_the_cell.gen)))"
            
            
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("didSelectRowAtIndexPath()")
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    // MARK: ACTIONS
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is used to explain what to do when we click on the bluetooth button
    /////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func barButtonTapped(_ sender: AnyObject) {
        /* This action is called when the '+' button is tapped */
        //print("barButtonTapped()")
        
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
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is used to explain what to do when we click on the share button
    /////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func shareUIButtonItem_Pressed(_ sender: UIBarButtonItem) {
        print("action : shareUIButtonItem_Pressed()")
    }
    @IBAction func shareButton_touchUpInside(_ sender: Any) {
        print("action : shareButton_touchUpInside()")
        

        if allSentencesRecorded != [] {
            // Share as a scv file all the sentences recorded from both legs (numberOfTheSample, Time, L1...L96, R1...R96)
            saveAndExport(allSentencesRecorded)
            // Reset the buffer of values after sharing
            allSentencesRecorded = []
            sampleNumber = 0
        }
    } /* End of action shareButton_touchUpInside() */
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is used to set up the style of the view controller
    /////////////////////////////////////////////////////////////////////////////////////////
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //print("adaptivePresentationStyleFor()")
        return .none
    } /* End of adaptivePresentationStyle() */
}


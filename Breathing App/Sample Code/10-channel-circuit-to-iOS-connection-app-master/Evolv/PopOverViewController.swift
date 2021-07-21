//
//  PopOverViewController.swift
//
//  Created by Jeremy Labrado on 26/04/16.
//  Copyright © 2016 StretchSense. All rights reserved.
//  labrado.jeremy@gmail.com
//

import UIKit
import CoreBluetooth

// MARK: Class PopOverViewController

class PopOverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    // MARK: VARIABLES
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    
    @IBOutlet weak var LabelInfo: UILabel!
    @IBOutlet weak var tableViewPeripheralAvailable: UITableView!

    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    // MARK: FUNCTIONS
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    // MARK: View Functions
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when the view controller is loaded
    /////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        print("viewDidLoad()")
        /* This function is called as the initialiser of the view controller */
        super.viewDidLoad()
        
        // Start scanning for new peripheral
        stretchsenseObject.startScanning()
        // initialazing the table view
        self.tableViewPeripheralAvailable.delegate = self
        self.tableViewPeripheralAvailable.dataSource = self
        tableViewPeripheralAvailable.reloadData()
        // setting the observer waiting for notification
        let defaultCenter = NotificationCenter.default
        // when a notification "UpdateInfo" is detected, go to the function newInfoDetected()
        defaultCenter.addObserver(self, selector: #selector(PopOverViewController.newInfoDetected), name: NSNotification.Name(rawValue: "UpdateInfo"),object: nil)
        tableViewPeripheralAvailable.reloadData()
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(PopOverViewController.update), userInfo: nil, repeats: false)
    } /* End of viewDidLoad() */
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when the view controller will appear
    /////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillAppear(_ animated: Bool) {
        // When we click on "Back", the function viewDidDisappear is called
        // We delete all the files recorded
        print("viewWillDisappear()")
        
        tableViewPeripheralAvailable.reloadData()
    } /* End of viewWillAppear() */

    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when the view controller disappear
    /////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidDisappear(_ animated: Bool) {
        //print("viewDidDisapear")
        parent?.viewWillAppear(true)
        viewWillAppear(true)
    } /* End of viewDidDisappear() */
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when the view controller will disappear
    /////////////////////////////////////////////////////////////////////////////////////////
    override func viewWillDisappear(_ animated: Bool) {
        //print("viewWillDisappear")
        parent?.viewWillAppear(true)
        viewWillAppear(true)
        
        presentedViewController?.viewWillAppear(true)
    } /* End of viewWillDisappear() */
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    // MARK: New Value Functions (notification)
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called when a new information is received from the API
    /////////////////////////////////////////////////////////////////////////////////////////
    @objc func newInfoDetected() {
        print("newInfoDetected()")
        // if a notification is received, change label Informations Feedback
        LabelInfo.text = stretchsenseObject.getLastInformation()
        
        print(stretchsenseObject.getLastInformation())
        /*if stretchsenseObject.getLastInformation() == "Old firmware"{
            print(stretchsenseObject.getLastInformation())
            let alert = UIAlertController(title: "Alert", message: "Your sensor's firmware version is not compatible with the StretchSense iOS application. \n You may experience disconnection issues. \n Please contact support@stretchsense.com if you intend to continue using this device with iOS.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }*/
        
        // We called the function update for the next 2 seconds to be sure the Feedback is well arrived
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(PopOverViewController.update), userInfo: nil, repeats: false)
        tableViewPeripheralAvailable.reloadData()
    } /* End of newInfoDetected() */
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is called to reaload the table
    /////////////////////////////////////////////////////////////////////////////////////////
    @objc func update() {
        //print("update()")
        tableViewPeripheralAvailable.reloadData()
    } /* End of update() */
    
    
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    // MARK:  TableView Functions
    /////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is used to define the number of rows of the table
    /////////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print("numberOfRowInSection()")
        // Set the number of Rows in the Table
        return stretchsenseObject.getNumberOfPeripheralAvailable()
    } /* End of numberOfRowsInSection() */

    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is used to define the number of columns of the table
    /////////////////////////////////////////////////////////////////////////////////////////
    func numberOfSections(in tableView: UITableView) -> Int {
        //print("numberOfSectionsInTableView()")
        // Set the number of Section in the table
        return 1
    } /* End of numberOfSections() */
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is used to declare what is on each cell of the tables
    /// It is called each time we have a new value
    /////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print("cellForRowAtIndexPath()")
        // This function filled each cell with the UUID and set the background color depending on the sensors's state
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        var listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        let listperipheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        
        if listPeripheralsAvailable.count != 0 {
            // If the sensor is connected, the background is green and we display his color in the subtitle
            if listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.state == CBPeripheralState.connected{
                cell.backgroundColor = UIColor.green
                
                for myPeripheralConnected in listperipheralsConnected{
                    if myPeripheralConnected.uuid == (cell.textLabel?.text)!{
                        var _ : String = (myPeripheralConnected.gen.description)
                        var colorString = myPeripheralConnected.colors[myPeripheralConnected.uniqueNumber].colorName


                        switch myPeripheralConnected.gen {
                        case "15"   : (cell.detailTextLabel?.text = "1Ch  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "17"   : (cell.detailTextLabel?.text = "10Ch  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "96"   : (cell.detailTextLabel?.text = "96 Left  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "97"   : (cell.detailTextLabel?.text = "96 Right  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "98"   : (cell.detailTextLabel?.text = "96 Front  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "99"   : (cell.detailTextLabel?.text = "96 Back  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "80"   : (cell.detailTextLabel?.text = "80 Left  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "81"   : (cell.detailTextLabel?.text = "80 Right  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "82"   : (cell.detailTextLabel?.text = "80 Front  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "83"   : (cell.detailTextLabel?.text = "80 Back  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "50"   : (cell.detailTextLabel?.text = "50 Left  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "51"   : (cell.detailTextLabel?.text = "50 Right  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "52"   : (cell.detailTextLabel?.text = "50 Front  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        case "53"   : (cell.detailTextLabel?.text = "50 Back  " + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        default     : (cell.detailTextLabel?.text = myPeripheralConnected.gen + ": " + String(myPeripheralConnected.uuid.characters.prefix(4)))
                        }

                    }
                }

                
            }
                // If the sensor is disconnected, the background is grey
            else if listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.state == CBPeripheralState.disconnected{
                cell.backgroundColor = UIColor.lightGray
            }
        }
        // For each row, we complete it with the UUID of the sensor
        cell.textLabel?.text = "\(listPeripheralsAvailable[(indexPath as NSIndexPath).row]!.identifier.uuidString)"
        return cell
    } /* End of cellForRowAt() */

    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////
    /// This function is used to define what is happening if we click on a cell
    /////////////////////////////////////////////////////////////////////////////////////////
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAtIndexPath()")
        // This function is called when we click on one cell
        // We want to connect or disconnect the sensor clicked
        
        let cell = tableView.cellForRow(at: indexPath)
        var listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        var listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        
        // If the sensor is connected we want to disconnect it by asking the confirmation
        if listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.state == CBPeripheralState.connected{
            let refreshAlert = UIAlertController(title: "Disconnect", message: "Are you sure you want to disconnect the peripheral? ", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (action: UIAlertAction!) in
                // If we confirm, we disconnect this sensor
                stretchsenseObject.disconnectOnePeripheralWithUUID(cell!.textLabel!.text!)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action: UIAlertAction!) in
                // Else we let the sensor connected
            }))
            present(refreshAlert, animated: true, completion: nil)
        }

        // If the sensor is disconnected, we connect it
        else if listPeripheralsAvailable[(indexPath as NSIndexPath).row]?.state == CBPeripheralState.disconnected{
            if (indexPath as NSIndexPath).row <= listPeripheralsAvailable.count{
                //if ( listPeripheralsConnected.count == 0 ){
                //    print("Go to connect Function")
                    stretchsenseObject.connectToPeripheralWithUUID(cell!.textLabel!.text!)
                //}
            }
        }
    }
    
    /* Swipe to delete */
    /*func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]?
    {
        //print("editActionForRowAtIndexPath()")
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        var listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        let option1 = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "test1"){(UITableViewRowAction,NSIndexPath) -> Void in
            
            print("Press Option1")
            print(cell!.textLabel!.text!)
            
        }
        let option2 = UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "nickname"){(UITableViewRowAction,NSIndexPath) -> Void in
            
            print("Press Option2")

        }
        option1.backgroundColor = UIColor.cyanColor()
        option2.backgroundColor = UIColor.orangeColor()
        return [option1,option2]
    }*/
    
    // MARK: Actions
    
    @IBAction func buttonScan(_ sender: AnyObject) {
        print("buttonScan()")
        // This action start looking for new sensor available
        // It is linked to the "ReScan" Button
        stretchsenseObject.removeAll();
        stretchsenseObject.startScanning()
        tableViewPeripheralAvailable.reloadData()
    }

    @IBAction func buttonDisconnectAllSensors(_ sender: AnyObject) {
        // When we click on the button "disconnect all", we want to disconnect all the sensor
        // After disconnecting, we restart the StretchSense library and start looking for new sensor
        // We refresh the display of the number of sensor connected
        print("buttonDisconnectAllSensors()")
        if stretchsenseObject.getNumberOfPeripheralAvailable() != 0 {
            stretchsenseObject.disconnectAllPeripheral()
            
            stretchsenseObject = StretchSenseAPI()
            stretchsenseObject.startBluetooth()
        }
        
    
    }
}

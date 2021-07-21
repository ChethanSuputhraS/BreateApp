//
//  PopOverViewController.swift
//
//  Created by Jeremy Labrado on 26/04/16.
//  Copyright © 2016 StretchSense. All rights reserved.
//
//  jeremy.labrado@stretchsense.com
//

import UIKit
import CoreBluetooth

// MARK: Class PopOverViewController

class PopOverViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    // MARK: VARIABLES
    
    // MARK: Variables for the object of the view(label, table)

    @IBOutlet weak var LabelInfo: UILabel!
    @IBOutlet weak var tableViewPeripheralAvailable: UITableView!
    
    // MARK: FUNCTIONS

    // MARK: View Functions

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
        let defaultCenter = NSNotificationCenter.defaultCenter()
        // when a notification "UpdateInfo" is detected, go to the function newInfoDetected()
        defaultCenter.addObserver(self, selector: #selector(PopOverViewController.newInfoDetected), name: "UpdateInfo",object: nil)
        tableViewPeripheralAvailable.reloadData()
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(PopOverViewController.update), userInfo: nil, repeats: false)

    }
    
    /*override func viewWillAppear(animated: Bool) {
        // When we click on "Back", the function viewDidDisappear is called
        // We delete all the files recorded
        print("viewWillDisappear()")
        
        tableViewPeripheralAvailable.reloadData()
    }
    
    override func viewDidDisappear(animated: Bool) {
        print("viewDidDisapear")
        parentViewController?.viewWillAppear(true)
        viewWillAppear(true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        print("viewWillDisappear")
        parentViewController?.viewWillAppear(true)
        viewWillAppear(true)
        
        presentedViewController?.viewWillAppear(true)
    }*/
    
    // MARK: New Info Functions

    func newInfoDetected() {
        print("newInfoDetected()")
        // if a notification is received, change label Informations Feedback
        LabelInfo.text = stretchsenseObject.getLastInformation()
        // We called the function update for the next 2 seconds to be sure the Feedback is well arrived
        NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(PopOverViewController.update), userInfo: nil, repeats: false)
        tableViewPeripheralAvailable.reloadData()
    }
    
    func update() {
        print("update()")
        tableViewPeripheralAvailable.reloadData()
    }
    
    
    // MARK:  TableView Functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberOfRowInSection()")
        // Set the number of Rows in the Table
        return stretchsenseObject.getNumberOfPeripheralAvailable()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("numberOfSectionsInTableView()")
        // Set the number of Section in the table
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("cellForRowAtIndexPath()")
        // This function filled each cell with the UUID and set the background color depending on the sensors's state
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        var listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        let listperipheralsConnected = stretchsenseObject.getListPeripheralsConnected()

        if listPeripheralsAvailable.count != 0 {
            // If the sensor is connected, the background is green and we display his color in the subtitle
            if listPeripheralsAvailable[indexPath.row]?.state == CBPeripheralState.Connected{
                cell.backgroundColor = UIColor.greenColor()
                for myPeripheralConnected in listperipheralsConnected{
                    print(myPeripheralConnected.uuid)
                    print((cell.textLabel?.text)!)
                    if myPeripheralConnected.uuid == (cell.textLabel?.text)!{
                        //cell.detailTextLabel?.text = myPeripheralConnected.colorName[myPeripheralConnected.uniqueNumber]
                        //cell.detailTextLabel?.text = myPeripheralConnected.colors[myPeripheralConnected.uniqueNumber].colorName
                        cell.detailTextLabel?.text = String(myPeripheralConnected.value * 0.1)
                    }
                    else{
                    }
                }
            }
            // If the sensor is disconnected, the background is grey
            else if listPeripheralsAvailable[indexPath.row]?.state == CBPeripheralState.Disconnected{
                cell.backgroundColor = UIColor.lightGrayColor()
            }
        }
        // For each row, we complete it with the UUID of the sensor
        cell.textLabel?.text = "\(listPeripheralsAvailable[indexPath.row]!.identifier.UUIDString)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("didSelectRowAtIndexPath()")
        // This function is called when we click on one cell
        // We want to connect or disconnect the sensor clicked
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        var listPeripheralsAvailable = stretchsenseObject.getListPeripheralsAvailable()
        
        // If the sensor is connected we want to disconnect it by asking the confirmation
        if listPeripheralsAvailable[indexPath.row]?.state == CBPeripheralState.Connected{
            let refreshAlert = UIAlertController(title: "Delete", message: "Are you sure you want to disconnect the peripheral? ", preferredStyle: UIAlertControllerStyle.Alert)
            refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
                // If we confirm, we disconnect this sensor
                stretchsenseObject.disconnectOnePeripheralWithUUID(cell!.textLabel!.text!)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
                // Else we let the sensor connected
            }))
            presentViewController(refreshAlert, animated: true, completion: nil)
        }

        // If the sensor is disconnected, we connect it
        else if listPeripheralsAvailable[indexPath.row]?.state == CBPeripheralState.Disconnected{
            if indexPath.row <= listPeripheralsAvailable.count{
                //print("Go to connect Function")
                stretchsenseObject.connectToPeripheralWithUUID(cell!.textLabel!.text!)
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
    @IBAction func buttonScan(sender: AnyObject) {
        print("buttonScan()")
        // This action start looking for new sensor available
        // It is linked to the "ReScan" Button
        stretchsenseObject.startScanning()
        tableViewPeripheralAvailable.reloadData()
    }

    @IBAction func buttonDisconnectAllSensors(sender: AnyObject) {
        // When we click on the button "disconnect all", we want to disconnect all the sensor
        // After disconnecting, we restart the StretchSense library and start looking for new sensor
        // We refresh the display of the number of sensor connected
        print("buttonDisconnectAllSensors()")
        if stretchsenseObject.getNumberOfPeripheralConnected() != 0 {
            stretchsenseObject.disconnectAllPeripheral()
            
            stretchsenseObject = StretchSenseAPI()
            stretchsenseObject.startBluetooth()
        }
    }
}

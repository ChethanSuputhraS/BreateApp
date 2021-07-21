//
//  Stretch-Hero
//   MainViewController.swift
//
//  Created by Jeremy Labrado on 30/05/16.
//  jeremy.labrado@stretchsense.com
//  Copyright © 2016 StretchSense. All rights reserved.
//

import UIKit

/*-------------------------------------------------------------------------------*/

// MARK: GLOBAL VARIABLE

// This object is "global", it means it can be used in any other swift file
var peripheralConnected : StretchSensePeripheral = StretchSensePeripheral()
var valueRelative : CGFloat = 0
var minSensor : CGFloat = 0.01
var maxSensor : CGFloat = 1

/*-------------------------------------------------------------------------------*/

// MARK: CLASS VIEW CONTROLLER
class MainViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        //stretchsenseObject.startBluetooth()
        // Set the notifier
        let defaultCenter = NotificationCenter.default
        // Set the observer for 10 sensors, just add lines and functions to add more sensor
        defaultCenter.addObserver(self, selector: #selector(newValueDetected0), name: NSNotification.Name(rawValue: "UpdateValueNotification"),object: nil)
    }
    
    @objc func newValueDetected0() {
        print("newValueDetected0")
        var listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        if listPeripheralsConnected.count != 0 {
            peripheralConnected = listPeripheralsConnected[0]
            
            if peripheralConnected.value > maxSensor {
                maxSensor = peripheralConnected.value
            }
            if peripheralConnected.value < minSensor {
                minSensor = peripheralConnected.value
            }
            valueRelative = ((peripheralConnected.value-minSensor)/(maxSensor-minSensor)) // = (x-min)/(max-min) 
            print(valueRelative)
            // limit: 0 <= valueRelative <= 1
            // Doing this, when the sensor is at the minimum, the value is 0 and when it's at the maximun it's 1
            // Then you just multiply by the value you want do fill your screen
        }
    }
   
    @IBAction func setMin(_ sender: AnyObject) {

        print("setMin()")
        let listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        if listPeripheralsConnected.count != 0 {
            minSensor = peripheralConnected.value
        }
    }
    
    @IBAction func setMax(_ sender: AnyObject) {

        print("setMax()")
        let listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
        if listPeripheralsConnected.count != 0 {
            maxSensor = peripheralConnected.value
        }
    }
    
    // MARK: PopOver Connection View Controller
    /* Pop Over */
    @IBAction func barButtonTapped(_ sender: AnyObject) {

        //print("Button: barButtonTapped()")
        // This action is used to display the connection popUp
        // It is liked to the bluetooth button
        // We first create a new PopOverViewController calling the PopOverViewController.swift
        // To come back to the main view controller, you have to click back on the barButton
        let VC = storyboard?.instantiateViewController(withIdentifier: "PopOverController") as! PopOverViewController
        let navController = UINavigationController(rootViewController: VC)
        navController.modalPresentationStyle = UIModalPresentationStyle.popover
        let popOver = navController.popoverPresentationController
        popOver?.delegate = self
        popOver?.barButtonItem = sender as? UIBarButtonItem
        self.present(navController, animated: true, completion: nil)
        // We call the viewWillAppear of the main view controller to refresh the number of sensor displayed
        viewWillAppear(true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        //print("adapatativePresentationStyle()")
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        //print("popoverPresentationContrller()")
        viewWillAppear(true)
    }
    /* */

}

//
//  ViewController.swift
//  StretchSense Fabric App
//
//  Created by Jeremy Labrado on 26/04/16.
//  Copyright © 2016 StretchSense. All rights reserved.
//  labrado.jeremy@gmail.com

import UIKit
/* for the email csv */
import MessageUI
/* */


/*-------------------------------------------------------------------------------*/

// MARK: GLOBAL VARIABLE

// This object is "global", it means it can be used in any other swift file
var stretchsenseObject = StretchSenseAPI()

/*-------------------------------------------------------------------------------*/

// MARK: CLASS VIEW CONTROLLER
class ViewController: UIViewController, UIPopoverPresentationControllerDelegate  {
    /* this View Controller is the main view controller, it will be the first one called */
    
    // MARK: VARIABLE

    // Those 2 labels are use to display the number of sensors connected
    @IBOutlet weak var labelSensorsConnected: UILabel!
    @IBOutlet weak var buttonStartGame: UIButton!
    var gameMenu = false

    // MARK: FUNCTIONS

    // MARK: View Functions

    override func viewDidLoad() {
        // This function is called as the initialiser of the view controller
        super.viewDidLoad()
        stretchsenseObject.startBluetooth()
        
        // If first launch
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "InfoViewController")
            self.show(vc as! UIViewController, sender: vc)
        }
        
        
        // Block the swipe to go back
        /*if navigationController!.responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            navigationController!.view.removeGestureRecognizer(navigationController!.interactivePopGestureRecognizer!)
        }*/
        //
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.Long)) //Long function will call when user long press on button.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.Tap))
        buttonStartGame.addGestureRecognizer(tapGesture)
        buttonStartGame.addGestureRecognizer(longGesture)
        
        let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "Application Name") as! String
        self.navigationItem.title = appVersion;

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // This function is called when we came back to this view Controller
        // We use this function to refresh the number of sensor connected
        let number = stretchsenseObject.getListPeripheralsConnected()
        if (number.count < 1) || (number.count == 0) {
            labelSensorsConnected.text = String(number.count) + " Sensor Connected"
        }
        else {
            labelSensorsConnected.text = String(number.count) + " Channels Connected"
        }
        gameMenu = false

    }
    
    
    // MARK: Actions

    @IBAction func disconnectAllSensor(_ sender: AnyObject) {
        //print("Button: DisconnectAllSensor")
        // When we click on the button "disconnect all", we want to disconnect all the sensor
        // After disconnecting, we restart the StretchSense library and start looking for new sensor
        // We refresh the display of the number of sensor connected
        if stretchsenseObject.getNumberOfPeripheralAvailable() != 0 {
            stretchsenseObject.disconnectAllPeripheral()
            
            stretchsenseObject = StretchSenseAPI()
            stretchsenseObject.startBluetooth()
            
            let listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
            labelSensorsConnected.text = String(listPeripheralsConnected.count) + " Sensor Connected"
            //print(stretchsenseObject.getNumberOfDeviceAvailable())
        }
    }
    
    
    @objc func Long() {
        
        print("Long press")
        //performSegueWithIdentifier("viewnext", sender: self)
        if gameMenu == false {
            let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "MainViewController")
            self.show(vc as! UIViewController, sender: vc)
            gameMenu = true
        }
        
    }
    
    @objc func Tap(){
        UIApplication.shared.openURL(URL(string: "http://stretchsense.com/")!)
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
    
    /* for the email csv */
    // Variables
    var toDoItems:[String] = ["1", "2", "3"]
    var convertMutable: NSMutableString!
    var incomingString: String = ""
    var datastring: NSString!
    
    // Mail alert if user does not have email setup on device
    /*func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }*/
    
    /*@IBAction func test(sender: AnyObject) {
        // CSV Export Button
            // Convert tableView String Data to NSMutableString
            convertMutable = NSMutableString();
            /*for item in toDoItems
            {
                convertMutable.appendFormat("%@\r", item)
            }*/
        
            convertMutable.appendFormat("%™\r", toDoItems)
            
            print("NSMutableString: \(convertMutable)")
            
            // Convert above NSMutableString to NSData
            let data = convertMutable.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            if let d = data { // Unwrap since data is optional and print
                print("NSData: \(d)")
            }
            
            //Email Functions
            func configuredMailComposeViewController() -> MFMailComposeViewController {
                let mailComposerVC = MFMailComposeViewController()
                //mailComposerVC.mailComposeDelegate = self
                mailComposerVC.setSubject("CSV File Export")
                mailComposerVC.setMessageBody("", isHTML: false)
                mailComposerVC.addAttachmentData(data!, mimeType: "text/csv", fileName: "TodoList.csv")
                
                return mailComposerVC
            }
            
            // Compose Email
            let mailComposeViewController = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert() // One of the MAIL functions
            }
    }
    
    
    
    @IBAction func test2(sender: AnyObject) {
       
    }*/
    
    /* */
    
}




    /**
     - note: StretchSenseLibrary.swift
     
     - Important: This StretchSense library has been designed to enable the connection of one or more "StretchSense Fabric Evaluation Sensor" and "StretchSenset 10 Channels Sensors" to your iOS application
     
     - Author: Jeremy Labrado
     
     - Copyright:  2016 StretchSense
     
     - Date: 22/11/2016
     
     - Version:    2.0.0
     
     **Definitions:**
     - **Peripheral**: Bluetooth 4.0 enabled sensors
     - **Manager**: Bluetooth 4.0 enabled iOS device
     
     */
    
    
    import UIKit
    import Foundation
    import CoreBluetooth // To use the bluetooth
    import MessageUI
    fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
        switch (lhs, rhs) {
        case let (l?, r?):
            return l < r
        case (nil, _?):
            return true
        default:
            return false
        }
    }
    
    
    
    /*-------------------------------------------------------------------------------*/
    // MARK: - CLASS STRETCHSENSEPERIPHERAL
    
    /**
     This class defines a single Fabric Evaluation StretchSense sensor
     
     - note: Each sensor is defined by:
     - A universal unique identifier UUID
     - A unique number, based on the order when the sensor is connected
     - A unique color, choose with his unique number
     - A current capacitance value
     - An array of the previous capacitance raw values
     - An array of the previous capacitance averaged values
     
     
     ```swift
     // Example: Display the sensors connected in a table
     
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     // Determine the total number of sensors connected (i.e. total number of elements within a table)
     return stretchsenseObject.getNumberOfPeripheralConnected()
     }
     
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     // This function is called to populate each row in the table
     // The row number of the table is define with his indexPath.row
     
     // The current cell
     let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
     // The current peripheral
     let myPeripheral = listPeripheralsConnected[indexPath.row]
     
     // display the title: capactiance value of the sensor
     cell.textLabel?.text = myPeripheralConnected.value
     // display the subtitle: identifier color (text) of the sensor
     cell.detailTextLabel?.text = myPeripheral.colors[myPeripheral.uniqueNumber].colorName
     // change the background color of the cell: indentifier color of the sensor
     cell.backgroundColor = myPeripheral.colors[myPeripheral.uniqueNumber].valueRGB
     }
     
     */
    class StretchSensePeripheral{
        // ----------------------------------------------------------------------------
        // MARK: VARIABLES
        // ----------------------------------------------------------------------------
        
        /// Universal Unique IDentifier
        var uuid = "";
        /// Current capacitance value of the sensor
        var value = CGFloat();
        /// A unique number for each sensor, based on the order when the sensor is connected
        var uniqueNumber = 0;
        /// The 30 previous samples averaged
        var previousValueAveraged = [CGFloat](repeating: 0, count: 30)
        /// The 30 previous samples raw
        var previousValueRawFromTheSensor = [CGFloat](repeating: 0, count: 30)
        /// Bool used to validate the display of the sensor in the graph
        var display = true
        /// Generation of the circuit, for the moment gen 2 or gen 3
        var gen = "3";
        
        var indexNotificationUpdated = [Int](repeating: 0, count: 10)
        
        
        /// Structure of Color: (name: String, valueRGB: UIColor)
        struct Color {
            /// The color name (Blue, Orange, Green, Red, Purple, Brown, Pink, Grey)
            var colorName: String = "colorName"
            /// The value (RGB) of the color (Blue, Orange, Green, Red, Purple, Brown, Pink, Grey)
            var colorValueRGB: UIColor = UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1)
        }
        
        /// Array of color already implemented (Blue, Orange, Green, Red, Purple, Brown...)
        /// The colors list is copy/paste a few time to avoid range issue
        /// Advice: use the variable uniqueNumber as reference of this array to have a unique color for each sensor
        var colors : [Color] = [
            Color(colorName: "Jelly Bean", colorValueRGB: UIColor(red: 0.85, green: 0.38, blue: 0.31, alpha: 1)),
            Color(colorName: "Electric Blue", colorValueRGB: UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Rose", colorValueRGB: UIColor(red: 1, green: 0, blue: 127/255, alpha: 1)),
            Color(colorName: "Emeraude", colorValueRGB: UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1)),
            Color(colorName: "Magenta", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Jelly Bean", colorValueRGB: UIColor(red: 0.85, green: 0.38, blue: 0.31, alpha: 1)),
            Color(colorName: "Electric Blue", colorValueRGB: UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Rose", colorValueRGB: UIColor(red: 1, green: 0, blue: 127/255, alpha: 1)),
            Color(colorName: "Emeraude", colorValueRGB: UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1)),
            Color(colorName: "Magenta", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Jelly Bean", colorValueRGB: UIColor(red: 0.85, green: 0.38, blue: 0.31, alpha: 1)),
            Color(colorName: "Electric Blue", colorValueRGB: UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Rose", colorValueRGB: UIColor(red: 1, green: 0, blue: 127/255, alpha: 1)),
            Color(colorName: "Emeraude", colorValueRGB: UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1)),
            Color(colorName: "Magenta", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),

            
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            
            
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),	//
            
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            
            
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            
            
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
            
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            
            
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            Color(colorName: "Red", colorValueRGB: UIColor(red: 1, green: 0, blue: 0, alpha: 1)),
            
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            Color(colorName: "Purple", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
            
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            Color(colorName: "Brown", colorValueRGB: UIColor(red: 0.6, green: 0.4, blue: 0.2, alpha: 1)),
            
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            Color(colorName: "Cyan", colorValueRGB:  UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
            
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
            
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            Color(colorName: "Pink", colorValueRGB: UIColor(red: 1, green: 0, blue: 1, alpha: 1)),
            
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            Color(colorName: "Blue", colorValueRGB: UIColor(red: 0, green: 0.5, blue: 0.8, alpha: 1)),
            
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
            
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
            Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1))
        ]
    }
    
    
    
    /*-------------------------------------------------------------------------------*/
    // ----------------------------------------------------------------------------
    // MARK: - CLASS STRETCHSENSEAPI
    // ----------------------------------------------------------------------------
    
    /**
     ## StretchSenseAPI ##
     
     The StretchSense API defines all functions required to connect to, and stream data from, the StretchSense Fabric Sensors linked to your iOS application
     
     - Author: StretchSense
     
     - Copyright:  2016 StretchSense
     
     - Date: 1/06/2016
     
     - Version:    1.0.0
     
     - note: Within the StretchSenseClass
     -	Peripherals lists (available, connected, saved)
     -	General settings  (number of samples to hold in memory, sampling time, average filtering value)
     -	Feedback information
     
     ```swift
     //Example 1: Connect to the available sensors
     
     class ViewController: UIViewController {
     
     var stretchsenseObject = StretchSenseAPI()
     
     override func viewDidLoad() {
     // This function is the first function called by the View Controller
     super.viewDidLoad()
     
     // Init the StretchSense API and Bluetooth
     stretchsenseObject.startBluetooth()
     // Start Scanning new peripheral
     stretchsenseObject.startScanning()
     }
     
     @IBAction func connect(sender: AnyObject) {
     // Get all available peripherals
     var listPeripheralAvailable = stretchsenseObject.getListPeripheralsAvailable()
     // Explore all the available peripherals
     for myPeripheralAvailable in listPeripheralAvailable{
     // Connect to all available, peripheral devices
     stretchsenseObject.connectToPeripheralWithCBPeripheral(myPeripheralAvailable)
     print(myPeripheralAvailable)
     }
     }
     
     @IBAction func printValue(sender: AnyObject) {
     // Get a list of all connect perihpheral devices
     var listPeripheralConnect = stretchsenseObject.getListPeripheralsConnected()
     // Print current capacitance value from all of the connected peripherals
     for myPeripheralConnected in listPeripheralConnect{
     // Print the value of all the peripheral connected
     print(myPeripheralConnected.value)
     }
     }
     }
     
     
     //Example 2: Use notifications to trigger continuous, real-time sampling of capacitance values from 3 sensors (already connected)
     
     class ViewController: UIViewController {
     
     override func viewDidLoad() {
     // This function is the first function called by the View Controller
     super.viewDidLoad()
     
     // Create the notifier
     let defaultCenter = NSNotificationCenter.defaultCenter()
     // Set the observers for each of the 3 sensors (just add lines and functions to add more sensors)
     defaultCenter.addObserver(self, selector: #selector(ViewController.newValueDetected0), name: "UpdateValueNotification0",object: nil)
     defaultCenter.addObserver(self, selector: #selector(ViewController.newValueDetected1), name: "UpdateValueNotification1",object: nil)
     defaultCenter.addObserver(self, selector: #selector(ViewController.newValueDetected2), name: "UpdateValueNotification2",object: nil)
     }
     
     func newValueDetected0() {
     // A notification has been detected from the sensor 0, the function newValueDetected0() is called
     if listPeripheralConnected.count > 0 {
     listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
     print("value sensor 0 updated, new value: (\listPeripheralsConnected[0].value) ")
     }
     }
     
     func newValueDetected1() {
     // A notification has been detected from the sensor 1, the function newValueDetected1() is called
     if listPeripheralConnected.count > 1 {
     listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
     print("value sensor 1 updated, new value: (\listPeripheralsConnected[1].value) ")
     }
     }
     
     func newValueDetected2() {
     // A notification has been detected from the sensor 2, the function newValueDetected2() is called
     if listPeripheralConnected.count > 2 {
     listPeripheralsConnected = stretchsenseObject.getListPeripheralsConnected()
     print("value sensor 2 updated, new value: (\listPeripheralsConnected[2].value) ")
     }
     }
     */
    class StretchSenseAPI: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
        
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // MARK: - VARIABLES
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        
        // ----------------------------------------------------------------------------
        // MARK: - Variables : Manager & List Peripherals
        // ----------------------------------------------------------------------------
        
        /// The manager of all the discovered peripherals
        fileprivate var centralManager : CBCentralManager!
        
        /** The list of all the **peripherals available** detected nearby the user device (during a bluetooth scan event)
         - note:  Before being connected, the peripheral object is typed CBPeripheral (identifier.UUIDString, CBPeripheralState.Connected, CBPeripheralState.Disconnected)
         */
        fileprivate var listPeripheralAvailable : [CBPeripheral?] = []
        
        /** The list of **peripherals currently connected** to the centralManager
         - note: Once a sensor is connected, it becomes an object instance of the class StretchSensePeripheral (UUID, Value, Color)
         */
        fileprivate var listPeripheralsConnected = [StretchSensePeripheral]()
        fileprivate var listPeripheralsConnectedLeft = [StretchSensePeripheral]()
        fileprivate var listPeripheralsConnectedRight = [StretchSensePeripheral]()
        fileprivate var listPeripheralsConnectedFront = [StretchSensePeripheral]()
        fileprivate var listPeripheralsConnectedBack = [StretchSensePeripheral]()
        fileprivate var listPeripheralsConnectedExternal = [StretchSensePeripheral]()
        
        /** The **saved peripherals** that where once connected to the centralManager
         - note: Once a sensor is connected, it becomes an object instance of the class StretchSensePeripheral (UUID, Value, Color)
         */
        fileprivate var listPeripheralsOnceConnected : [StretchSensePeripheral] = [StretchSensePeripheral()]
        
        
        
        
        // ----------------------------------------------------------------------------
        // MARK:  Variables : Services & Characteristics UUID
        // ----------------------------------------------------------------------------
        
        /// The **name** used to filter bluetooth scan results and find only the StretchSense Sensor
        fileprivate var deviceName = "StretchSense"
        fileprivate var deviceName2 = "StretchSense_Tako"
        fileprivate var deviceNameT01 = "StretchSense_T01"
        fileprivate var deviceNameT02 = "StretchSense_T02"
        fileprivate var deviceNameT03 = "StretchSense_T03"
        fileprivate var deviceNameT04 = "StretchSense_T04"
        fileprivate var deviceNameT05 = "StretchSense_T05"
        fileprivate var deviceNameT06 = "StretchSense_T06"
        fileprivate var deviceNameT07 = "StretchSense_T07"
        fileprivate var deviceNameT08 = "StretchSense_T08"
        fileprivate var deviceNameT09 = "StretchSense_T09"
        fileprivate var deviceNameT10 = "StretchSense_T10"

        /// The UUID used to filter bluetooth scan results and find the **services** from the StretchSense Sensor
        fileprivate var serviceUUID10CH = CBUUID(string: "00001701-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **data characteristic** from the StretchSense Sensor
        fileprivate var dataUUID10CH = CBUUID(string: "00001702-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **shutdown characteristic**from the StretchSense Sensor
        fileprivate var shutdownUUID10CH = CBUUID(string: "00001704-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **samplingTime characteristic** from the StretchSense Sensor
        fileprivate var samplingTimeUUID10CH = CBUUID(string: "00001705-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **average characteristic** from the StretchSense Sensor
        fileprivate var averageUUID10CH = CBUUID(string: "00001706-7374-7265-7563-6873656e7365")

        
        /// The UUID used to filter bluetooth scan results and find the **services** from the StretchSense Sensor
        fileprivate var serviceUUID10CHTT = CBUUID(string: "00601001-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **data characteristic** from the StretchSense Sensor
        fileprivate var dataUUID10CHTT = CBUUID(string: "00601002-7374-7265-7563-6873656e7365")
        fileprivate var imuUUID10CHTT = CBUUID(string: "00601050-7374-7265-7563-6873656e7365")

        
        
        /// The UUID used to filter bluetooth scan results and find the **services** from the Tako Left
        fileprivate var serviceUUID14CH = CBUUID(string: "00001401-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **data characteristic** from the StretchSense Tako Left
        fileprivate var dataUUID14CH1 = CBUUID(string: "00001402-7374-7265-7563-6873656e7365")
        fileprivate var dataUUID14CH2 = CBUUID(string: "00001407-7374-7265-7563-6873656e7365")

        /// The UUID used to filter device characterisitics and find the **shutdown characteristic**from the StretchSense Tako Left
        fileprivate var shutdownUUID14CH = CBUUID(string: "00001404-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **samplingTime characteristic** from the StretchSense Tako Left
        fileprivate var samplingTimeUUID14CH = CBUUID(string: "00001405-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **average characteristic** from the StretchSense Tako Left
        fileprivate var averageUUID14CH = CBUUID(string: "00001406-7374-7265-7563-6873656e7365")
        
        
        /// The UUID used to filter bluetooth scan results and find the **services** from the Tako Left
        fileprivate var serviceUUIDtakoLeft = CBUUID(string: "00009601-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **data characteristic** from the StretchSense Tako Left
        fileprivate var dataUUIDtakoLeft1 = CBUUID(string: "00009602-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoLeft2 = CBUUID(string: "00009607-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoLeft3 = CBUUID(string: "00009608-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoLeft4 = CBUUID(string: "00009609-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoLeft5 = CBUUID(string: "00009610-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoLeft6 = CBUUID(string: "00009611-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoLeft7 = CBUUID(string: "00009612-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoLeft8 = CBUUID(string: "00009613-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoLeft9 = CBUUID(string: "00009614-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoLeft10 = CBUUID(string: "00009615-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **shutdown characteristic**from the StretchSense Tako Left
        fileprivate var shutdownUUIDtakoLeft = CBUUID(string: "00009604-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **samplingTime characteristic** from the StretchSense Tako Left
        fileprivate var samplingTimeUUIDtakoLeft = CBUUID(string: "00009605-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **average characteristic** from the StretchSense Tako Left
        fileprivate var averageUUIDtakoLeft = CBUUID(string: "00009606-7374-7265-7563-6873656e7365")
        
        
        /// The UUID used to filter bluetooth scan results and find the **services** from the Tako Right
        fileprivate var serviceUUIDtakoRight = CBUUID(string: "00009701-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **data characteristic** from the StretchSense Tako Right
        fileprivate var dataUUIDtakoRight1 = CBUUID(string: "00009702-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoRight2 = CBUUID(string: "00009707-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoRight3 = CBUUID(string: "00009708-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoRight4 = CBUUID(string: "00009709-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoRight5 = CBUUID(string: "00009710-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoRight6 = CBUUID(string: "00009711-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoRight7 = CBUUID(string: "00009712-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoRight8 = CBUUID(string: "00009713-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoRight9 = CBUUID(string: "00009714-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoRight10 = CBUUID(string: "00009715-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **shutdown characteristic**from the StretchSense Tako Right
        fileprivate var shutdownUUIDtakoRight = CBUUID(string: "00009704-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **samplingTime characteristic** from the StretchSense Tako Right
        fileprivate var samplingTimeUUIDtakoRight = CBUUID(string: "00009705-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **average characteristic** from the StretchSense Tako Right
        fileprivate var averageUUIDtakoRight = CBUUID(string: "00009706-7374-7265-7563-6873656e7365")
        
        
        /// The UUID used to filter bluetooth scan results and find the **services** from the Tako Front
        fileprivate var serviceUUIDtakoFront = CBUUID(string: "00009801-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **data characteristic** from the StretchSense Tako Front
        fileprivate var dataUUIDtakoFront1 = CBUUID(string: "00009802-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoFront2 = CBUUID(string: "00009807-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoFront3 = CBUUID(string: "00009808-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoFront4 = CBUUID(string: "00009809-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoFront5 = CBUUID(string: "00009810-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoFront6 = CBUUID(string: "00009811-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoFront7 = CBUUID(string: "00009812-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoFront8 = CBUUID(string: "00009813-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoFront9 = CBUUID(string: "00009814-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoFront10 = CBUUID(string: "00009815-7374-7265-7563-6873656e7365")
        
        /// The UUID used to filter device characterisitics and find the **shutdown characteristic**from the StretchSense Tako Front
        fileprivate var shutdownUUIDtakoFront = CBUUID(string: "00009804-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **samplingTime characteristic** from the StretchSense Tako Front
        fileprivate var samplingTimeUUIDtakoFront = CBUUID(string: "00009805-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **average characteristic** from the StretchSense Tako Front
        fileprivate var averageUUIDtakoFront = CBUUID(string: "00009806-7374-7265-7563-6873656e7365")
        
        
        /// The UUID used to filter bluetooth scan results and find the **services** from the Tako Front
        fileprivate var serviceUUIDtakoBack = CBUUID(string: "00009901-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **data characteristic** from the StretchSense Tako Front
        fileprivate var dataUUIDtakoBack1 = CBUUID(string: "00009902-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoBack2 = CBUUID(string: "00009907-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoBack3 = CBUUID(string: "00009908-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoBack4 = CBUUID(string: "00009909-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoBack5 = CBUUID(string: "00009910-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoBack6 = CBUUID(string: "00009911-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoBack7 = CBUUID(string: "00009912-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoBack8 = CBUUID(string: "00009913-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoBack9 = CBUUID(string: "00009914-7374-7265-7563-6873656e7365")
        fileprivate var dataUUIDtakoBack10 = CBUUID(string: "00009915-7374-7265-7563-6873656e7365")
        
        /// The UUID used to filter device characterisitics and find the **shutdown characteristic**from the StretchSense Tako Front
        fileprivate var shutdownUUIDtakoBack = CBUUID(string: "00009904-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **samplingTime characteristic** from the StretchSense Tako Front
        fileprivate var samplingTimeUUIDtakoBack = CBUUID(string: "00009905-7374-7265-7563-6873656e7365")
        /// The UUID used to filter device characterisitics and find the **average characteristic** from the StretchSense Tako Front
        fileprivate var averageUUIDtakoBack = CBUUID(string: "00009906-7374-7265-7563-6873656e7365")
        
        // ----------------------------------------------------------------------------
        // MARK:  Variables : Set sensor & Info
        // ----------------------------------------------------------------------------
        
        /// Number of **data samples** within the filtering array
        var numberOfSample = 30
        /// Initialisation value of the **sampling time value**
        /// notes: SamplingTime = (value + 1) * 40ms
        var samplingTimeNumber : UInt8 = 0
        /// Size of the filter based on the **Number of samples**
        var filteringNumber : UInt8 = 0
        /// **Feedback** from the sensor
        fileprivate var informationFeedBack = ""
        
        
        
        
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        // MARK: -  FUNCTIONS
        // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        // ----------------------------------------------------------------------------
        // MARK: - Function: Scan/Connect/Disconnect
        // ----------------------------------------------------------------------------
        
        
        /**
         Initialisation of the **Manager**
         
         - note: Must be the first function called, to check if bluetooth is enabled and initialise the manager
         
         - parameter: Nothing
         
         - returns: Nothing
         
         */
        func startBluetooth(){
            centralManager = CBCentralManager(delegate: self, queue: nil)
        } /* end of startBluetooth() */
        
        
        
        /**
         **Start scanning** for new peripheral
         
         - parameter  Nothing:
         
         - returns: Nothing
         
         */
        func startScanning() {
            print("startScanning()")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } /* end of startScanning() */
        
        
        
        /**
         **Stop the bluetooth** scanning
         
         - parameter Nothing
         
         - returns: Nothing
         
         */
        func stopScanning(){
            print("stopScanning()")
            
            self.centralManager.stopScan()
        } /* end of stopScanning() */
        
        
        
        
        /**
         Function to **connect** the manager to an available peripheral
         
         - note: If the string UUID given does not refer to an available peripheral, do nothing
         - note: Variation of the function connectToPeripheralWithCBPeripheral
         
         - parameter uuid : the string UUID of the available peripheral you want to connect.
         
         - returns: Nothing
         
         */
        func connectToPeripheralWithUUID(_ uuid : String){
            print("connectToPeripheralWithUUID()")
            
            let listOfPeripheralAvailable = self.getListPeripheralsAvailable()
            
            if listOfPeripheralAvailable.count != 0 {
                for myPeripheralAvailable in listOfPeripheralAvailable{
                    if (uuid == myPeripheralAvailable!.identifier.uuidString){
                        if (myPeripheralAvailable!.state == CBPeripheralState.disconnected){
                            self.centralManager.connect(myPeripheralAvailable!, options: nil)
                        }
                    }
                }
            }
        } /* end of connectToPeripheralWithUUID() */
        
        
        
        
        /**
         Function to **connect** the manager to an available peripheral
         
         - parameter myPeripheral : the peripheral available (type: CBPeripheral) you want to connect
         
         - returns: Nothing
         
         */
        func connectToPeripheralWithCBPeripheral(_ myPeripheral : CBPeripheral?){
            print("connectToPeripheralWithCBPeripheral()")
            
            self.centralManager.connect(myPeripheral!, options: nil)
            myPeripheral!.discoverServices(nil)
        } /* end of connectToPeripheralWithCBPeripheral() */
        
        
        
        
        /**
         Function to **disconnect** from a connected peripheral
         
         - note: If the UUID given does not refer to a connected peripheral, do nothing
         
         - parameter uuid : the string UUID of the peripheral you want to disconnect.
         
         - returns: Nothing
         
         */
        func disconnectOnePeripheralWithUUID(_ uuid : String){
            print("disconnectOnePeripheralWithUUID()")
            
            let listOfPeripheralAvailable = self.getListPeripheralsAvailable()
            
            if listOfPeripheralAvailable.count != 0 {
                for myPeripheral in listOfPeripheralAvailable{
                    if (uuid == myPeripheral!.identifier.uuidString){
                        if (myPeripheral!.state == CBPeripheralState.connected){
                            self.centralManager.cancelPeripheralConnection(myPeripheral!)
                        }
                    }
                }
            }
        } /* end of disconnectOnePeripheralWithUUID() */
        
        
        
        
        /**
         Function to **disconnect** from a connected peripheral
         
         - note: Variation of the function connectToPeripheralWithUUID
         
         - parameter myPeripheral : the peripheral connected (type CBPeripheral) you want to disconnect.
         
         - returns: Nothing
         
         */
        func disconnectOnePeripheralWithCBPeripheral(_ myPeripheral : CBPeripheral){
            print("disconnectOnePeripheralWithCBPeripheral()")
            
            centralManager.cancelPeripheralConnection(myPeripheral)
        } /* end of disconnectOnePeripheralWithCBPeripheral() */
        
        
        
        /**
         Function to **disconnect all** peripherals
         
         - parameter Nothing
         
         - returns: Nothing
         
         */
        func disconnectAllPeripheral(){
            //print("disconnectAllPeripheral()")
            
            for myPeripheral in listPeripheralAvailable {
                centralManager.cancelPeripheralConnection(myPeripheral!)
            }
        } /* end of disconnectAllPeripheral() */
        
        
        
        
        // ----------------------------------------------------------------------------
        // MARK: Function: Lists of peripherals
        // ----------------------------------------------------------------------------
        
        
        /**
         Get the list of all the **available peripherals** with their information (Identifier, UUID, name, state)
         
         - parameter Nothing
         
         - returns: The available peripherals
         
         */
        func getListPeripheralsAvailable() -> [CBPeripheral?]   {
            //print("getListPeripheralsAvailable()")
            
            return listPeripheralAvailable
        } /* end of getListPeripheralsAvailable() */
        
        
        
        
        /**
         Return the list of the **UUID's of the available peripherals**
         
         - parameter Nothing
         
         - returns: The UUID of all the peripheral available
         
         */
        func getListUUIDPeripheralsAvailable() -> [String] {
            //print("getListUUIDPeripheralsAvailable()")
            
            var uuid : [String] = []
            let numberOfPeripheralAvailable = listPeripheralAvailable.count
            if numberOfPeripheralAvailable != 0 {
                for i in 0...numberOfPeripheralAvailable-1 {
                    uuid += [(listPeripheralAvailable[i]!.identifier.uuidString)]
                }
            }
            return uuid
        } /* end of getListUUIDPeripheralsAvailable() */
        
        
        
        
        /**
         Get the list of all the **connected peripherals** with their information (UUID, values, color )
         
         - parameter Nothing
         
         - returns: The peripherals connected
         
         */
        func getListPeripheralsConnectedLeft() -> [StretchSensePeripheral]{
            //print("getListPeripheralsConnected()")
            
            return listPeripheralsConnectedLeft
        }
        /* end of getListPeripheralsConnected() */
        
        
        /**
         Get the list of all the **connected peripherals** with their information (UUID, values, color )
         
         - parameter Nothing
         
         - returns: The peripherals connected
         
         */
        func getListPeripheralsConnected() -> [StretchSensePeripheral]{
            //print("getListPeripheralsConnected()")
            
            return listPeripheralsConnected
        }
        /* end of getListPeripheralsConnected() */
        
        
        
        /**
         Get the list of all the **connected peripherals** with their information (UUID, values, color )
         
         - parameter Nothing
         
         - returns: The peripherals connected
         
         */
        func getListPeripheralsConnectedRight() -> [StretchSensePeripheral]{
            //print("getListPeripheralsConnected()")
            
            return listPeripheralsConnectedRight
        }
        /* end of getListPeripheralsConnected() */
        
        /**
         Get the list of all the **connected peripherals** with their information (UUID, values, color )
         
         - parameter Nothing
         
         - returns: The peripherals connected
         
         */
        func getListPeripheralsConnectedFront() -> [StretchSensePeripheral]{
            //print("getListPeripheralsConnectedFront()")
            
            return listPeripheralsConnectedFront
        }
        /* end of getListPeripheralsConnected() */
        
        /**
         Get the list of all the **connected peripherals** with their information (UUID, values, color )
         
         - parameter Nothing
         
         - returns: The peripherals connected
         
         */
        func getListPeripheralsConnectedBack() -> [StretchSensePeripheral]{
            //print("getListPeripheralsConnectedBack()")
            
            return listPeripheralsConnectedBack
        }
        /* end of getListPeripheralsConnected() */
        
        
        
        /**
         Get the list of all the **peripherals that have been or currently are connected** with their information (UUID, values, color )
         
         - parameter Nothing
         
         - returns: The peripherals that have been or currently are connected to the manager
         */
        func getListPeripheralsOnceConnected() -> [StretchSensePeripheral]{
            //print("getListPeripheralsOnceConnected()")
            
            return listPeripheralsOnceConnected
        } /* end of getListPeripheralsOnceConnected() */
        
        
        
        // ----------------------------------------------------------------------------
        // MARK: Function: samplingTime / Shutdown
        // ----------------------------------------------------------------------------
        
        
        /**
         Ask the circuit to read the value of all the tako board
         
         - note:
         
         */
        func updateCapacitanceTako(){
            print("updateCapacitanceTako()")
            
            for myPeripheral in listPeripheralAvailable {
                
                if (myPeripheral!.state == CBPeripheralState.connected){
                    if myPeripheral!.services != nil {
                        for service in myPeripheral!.services! {
                            print(service)
                            
                            if service.uuid == serviceUUIDtakoLeft {
                                if service.characteristics != nil {
                                    for charateristic in service.characteristics! {
                                        if charateristic.uuid == dataUUIDtakoLeft1 {
                                            myPeripheral?.readValue(for: charateristic)
                                        }
                                    }
                                }
                            }
                            
                            if service.uuid == serviceUUIDtakoRight {
                                if service.characteristics != nil {
                                    for charateristic in service.characteristics! {
                                        if charateristic.uuid == dataUUIDtakoRight1 {
                                            myPeripheral?.readValue(for: charateristic)
                                        }
                                    }
                                }
                            }
                            
                            if service.uuid == serviceUUIDtakoFront {
                                if service.characteristics != nil {
                                    for charateristic in service.characteristics! {
                                        if charateristic.uuid == dataUUIDtakoFront1 {
                                            myPeripheral?.readValue(for: charateristic)
                                        }
                                    }
                                }
                            }
                            
                            if service.uuid == serviceUUIDtakoBack {
                                if service.characteristics != nil {
                                    for charateristic in service.characteristics! {
                                        if charateristic.uuid == dataUUIDtakoBack1 {
                                            myPeripheral?.readValue(for: charateristic)
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }
            }
        } /* end of updateCapacitanceTako() */
        
        
        
        
        
        
        
        
        /**
         Change the **value of the shutdown** from the peripheral
         
         - note: unused functions
         
         - parameter myPeripheral: The peripheral you want to update
         - parameter dataIn: The shutdown value you want to set for this peripheral [0 - Stay on, 1 - Shutdown]
         
         - returns: Nothing
         
         */
        func writeShutdown(_ dataIn: UInt8, myPeripheral : CBPeripheral?) {
            print("writeShutdown()")
            
            // The UInt8 need to be convert in NSData before be send
            
            /*var dataUint8: UInt8 = dataIn
             let dataNSData = Data(bytes: UnsafePointer<UInt8>(&dataUint8), count: 1)
             for service in myPeripheral!.services! {
             let thisService = service as CBService
             if thisService.uuid == serviceUUID {
             for charateristic in service.characteristics! {
             let thisCharacteristic = charateristic as CBCharacteristic
             if thisCharacteristic.uuid == shutdownUUID {
             // Once we have the good Characteristic and Characteristic, we can send the data
             myPeripheral!.writeValue(dataNSData, for: thisCharacteristic, type: CBCharacteristicWriteType.withResponse)
             }
             }
             }
             }*/
        } /* end of writeShutdown() */
        
        
        
        
        // ----------------------------------------------------------------------------
        // MARK:  Function: Optional
        // ----------------------------------------------------------------------------
        
        
        /**
         **Convert** the Raw data from the sensor characterisitic to a capacitance value, units pF (picoFarads)
         
         - note: Capacitance(pF) = RawData * 0.10pF
         
         - parameter rawData: The raw data from the peripheral
         
         - returns: The real capacitace value in pF
         
         */
        func convertRawDataToCapacitance(_ rawDataInt: Int) -> Float{
            //print("convertRawDataToCapacitance()")
            
            // Capacitance(pF) = RawData * 0.10pF
            return Float(rawDataInt)*1
        } /* end of convertRawDataToCapacitance() */
        
        
        
        
        /**
         Returns the number available peripheral devices that are not connected
         
         - parameter Nothing
         
         - returns: The number of peripherals available
         
         */
        func getNumberOfPeripheralAvailable() -> Int {
            //print("getNumberOfPeripheralAvailable()")
            
            return listPeripheralAvailable.count
        } /* end of getNumberOfPeripheralAvailable() */
        
        
        
        
        /**
         Returns the number of connected peripheral on both leg
         
         - parameter Nothing
         
         - returns: The number of connected peripherals
         
         */
        func getNumberOfPeripheralConnected() -> Int {
            //print("getNumberOfPeripheralConnected()")
            return listPeripheralsConnected.count 
        } /* end of getNumberOfPeripheralConnected() */
        
        
        /**
         Returns the number of connected peripheral on the left leg
         
         - parameter Nothing
         
         - returns: The number of connected peripherals
         
         */
        func getNumberOfPeripheralConnectedLeft() -> Int {
            //print("getNumberOfPeripheralConnected()")
            return listPeripheralsConnectedLeft.count
        } /* end of getNumberOfPeripheralConnectedLeft() */
        
        
        
        /**
         Returns the number of connected peripheral on the right leg
         
         - parameter Nothing
         
         - returns: The number of connected peripherals
         
         */
        func getNumberOfPeripheralConnectedRight() -> Int {
            //print("getNumberOfPeripheralConnected()")
            return listPeripheralsConnectedRight.count
        } /* end of getNumberOfPeripheralConnectedRight() */
        
        /**
         Returns the number of connected peripheral on the front
         
         - parameter Nothing
         
         - returns: The number of connected peripherals
         
         */
        func getNumberOfPeripheralConnectedFront() -> Int {
            //print("getNumberOfPeripheralConnectedFront()")
            return listPeripheralsConnectedFront.count
        } /* end of getNumberOfPeripheralConnectedFront() */
        
        
        /**
         Returns the number of connected peripheral on the back
         
         - parameter Nothing
         
         - returns: The number of connected peripherals
         
         */
        func getNumberOfPeripheralConnectedBack() -> Int {
            //print("getNumberOfPeripheralConnectedBack()")
            return listPeripheralsConnectedBack.count
        } /* end of getNumberOfPeripheralConnectedBack() */
        
        
        
        
        
        
        /**
         Return the last **information** (event update) received from the sensor
         
         - parameter Nothing
         
         - returns: The last information from the sensor
         
         */
        func getLastInformation() -> String{
            //print("getLastInformation()")
            
            return informationFeedBack
        } /* end of getLastInformation() */
        
        
        
        
        func averageIIR(_ averageNumber: Int, mySensor: StretchSensePeripheral)-> CGFloat{
            //print("averageIIR()")
            
            if averageNumber == 0 || averageNumber == 1 {
                return mySensor.value
            }
            else {
                // we add the lastvalue (mySensor.value) and the 'averageNumber' values from the sensor
                var sumValue = mySensor.value
                for i in 0 ... averageNumber-2 {
                    sumValue += mySensor.previousValueAveraged[mySensor.previousValueAveraged.count-1 - i]
                }
                // Then we divide by the number of values added to get the average
                return CGFloat(sumValue/CGFloat(averageNumber))
            }
        }

        
        
        
        
        // ----------------------------------------------------------------------------
        // MARK: - Background Function: Central & Peripheral Manager
        // ----------------------------------------------------------------------------
        
        
        /**
         Function to Check the state of the Bluetooth Low Energy
         
         - note:
         
         */
        func centralManagerDidUpdateState(_ central: CBCentralManager) {
            print("centralManagerDidUpdateState()")
            
            switch (central.state){
            case .poweredOff:
                // Bluetooth on this device is currently powered off
                informationFeedBack = "BLE is powered off"
            case .poweredOn:
                // Bluetooth LE is turned on and ready for communication
                informationFeedBack = "Bluetooth is powered on"
            case .resetting:
                // The BLE Manager is resetting; a state update is pending
                informationFeedBack = "BLE is resetting"
            case .unauthorized:
                // This app is not authorized to use Bluetooth Low Energy
                informationFeedBack = "BLE is unauthorized"
            case .unknown:
                // The state of the BLE Manager is unknown, wait for another event
                informationFeedBack = "BLE is unknown"
            case .unsupported:
                // This device does not support Bluetooth Low Energy.
                informationFeedBack = "BLE is not supported"
            }
            
            // Notify the viewController when the state has updated, this can be used to prompt events
            let defaultCenter = NotificationCenter.default
            defaultCenter.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil)
        } /* end of centralManagerDidUpdateState() */
        
        
        
        
        /**
         Function to Scan and filter all Bluetooth Low energy devices to find any available StretchSense peripherals
         
         - note:
         
         */
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral?, advertisementData: [String : Any], rssi RSSI: NSNumber){
            //print("didDiscoverPeripheral()")
            
            // Update information
            informationFeedBack = "Searching for peripherals"
            // Notify the viewController that the state has updated, this can be used to prompt events
            let defaultCenter = NotificationCenter.default//SWIFT2
            defaultCenter.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil) //SWIFT2
            
            if (central.state == CBManagerState.poweredOn){ //SWIFT3
                var inTheList = false
                let peripheralCurrent = peripheral
                
                for periphOnceConnected in self.listPeripheralsOnceConnected {
                    
                        // If the peripheral discovered was never connected to the app we identify it
                        let nameOfPeripheralFound = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString
                        if ((nameOfPeripheralFound == deviceName as NSString?)       ||
                            (nameOfPeripheralFound == deviceName2 as NSString?)      ||
                            (nameOfPeripheralFound == deviceNameT01 as NSString?)    ||
                            (nameOfPeripheralFound == deviceNameT02 as NSString?)    ||
                            (nameOfPeripheralFound == deviceNameT03 as NSString?)    ||
                            (nameOfPeripheralFound == deviceNameT04 as NSString?)    ||
                            (nameOfPeripheralFound == deviceNameT05 as NSString?)    ||
                            (nameOfPeripheralFound == deviceNameT06 as NSString?)    ||
                            (nameOfPeripheralFound == deviceNameT07 as NSString?)    ||
                            (nameOfPeripheralFound == deviceNameT08 as NSString?)    ||
                            (nameOfPeripheralFound == deviceNameT09 as NSString?)    ||
                            (nameOfPeripheralFound == deviceNameT10 as NSString?))
                            {
                            // If it's a stretchsense device
                            print("New StretchSense peripheral discover")
                            // Update information
                            informationFeedBack = "New Sensor Detected, Click to Connect/Disconnect"
                            
                            if (self.listPeripheralAvailable.count == 0) {
                                // If the list is empty, we add the new peripheral detected directly
                                self.listPeripheralAvailable.append(peripheralCurrent)
                            }
                            else{
                                // Else we have to look if it's not yet in the list
                                for periphInList in self.listPeripheralAvailable{
                                    if peripheral!.identifier == periphInList?.identifier{
                                        inTheList = true
                                    }
                                }
                                if inTheList == false{
                                    // If the new peripheral detected is not in the list, we add it to the list
                                    self.listPeripheralAvailable.append(peripheralCurrent)
                                }
                            }
                        }
                    
                }
            }
        } /* end of didDiscover() */
        
        
        
        /**
         Function to Establish a connection with a peripheral and initialise a StretchSensePeriph object
         
         - note:
         
         */
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            print("didConnectPeripheral()")
            
            // Update information
            informationFeedBack = "Peripheral connected"
            // Notify the viewController that the info has been updated and so has to be reload
            let defaultCenter = NotificationCenter.default
            defaultCenter.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil)
            peripheral.delegate = self
            // Stop scanning for new devices
            stopScanning()
            peripheral.discoverServices(nil)
        } /* end of didConnect() */
        
        
        func removeAll(){

            for (index, myPeripheralAvailable) in listPeripheralAvailable.enumerated() {
                let indexPositionToDelete = listPeripheralsConnected.contains(where: { $0.uuid == (myPeripheralAvailable?.identifier.uuidString)  }) // looking for the index of the peripheral to delete in the list
                if(!indexPositionToDelete){
                    if let elementIndex = listPeripheralAvailable.index(of: myPeripheralAvailable) {
                        listPeripheralAvailable.remove(at: elementIndex)
                    }
                }
            }
        
        }
        
        
        /**
         Function to When a device is disconnected, we remove it from the value list and the peripheralListAvailable
         
         - note:
         
         */
        func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
            print("didDisconnectPeripheral()")
            
            // Check errors
            if (error != nil) {
                //print("didDisconnectPeripheral() ERROR")
                
                print("didDisconnectPeripheral Error :  \(String(describing: error?.localizedDescription))");
                //print(error ?? <#default value#>)
            }
            for myPeripheralConnected in listPeripheralsConnected{
                if (peripheral.identifier.uuidString == myPeripheralConnected.uuid){
                    let indexPositionToDelete = listPeripheralsConnected.index(where: { $0.uuid == myPeripheralConnected.uuid  }) // looking for the index of the peripheral to delete in the list
                    print(Int(indexPositionToDelete!));
                    listPeripheralsConnected.remove(at: Int(indexPositionToDelete!))  // remove the peripheral from the list
                }
            }
                       
            // Update information
            informationFeedBack = "Peripheral Disconnected"
            // Notify the viewController that the info has been updated and so has to be reloaded
            let defaultCenter0 = NotificationCenter.default
            defaultCenter0.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil)
            
        } /* end of didDisconnectPeripheral() */
        
        
        
        /**
         When the specified services are discovered, the peripheral calls the peripheral:didDiscoverServices: method of its delegate object
         
         - note:
         
         */
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            print("didDiscoverServices()")
            
            // Check errors
            if (error != nil) {
                print("Error :  \(String(describing: error?.localizedDescription))");
            }
            
            // Update information
            informationFeedBack = "Discovering peripheral services"
            
            
            for service in peripheral.services! {
                print(service.uuid)
                let thisService = service as CBService
                if(service.uuid.uuidString.characters.count == 36){

                    let uuid_generation = service.uuid.uuidString[4...5]
                    let uuid_nExternalValues = service.uuid.uuidString[1...2]
                    let uuid_stretchsense = service.uuid.uuidString[9...35]
                
                    var nExternalValues = Int(uuid_nExternalValues)!

                    print(uuid_stretchsense)
                    if uuid_stretchsense == "7374-7265-7563-6873656E7365" {
                        generateGenTako(peripheral: peripheral, generation: uuid_generation, nExternal: nExternalValues)
                        peripheral.discoverCharacteristics(nil, for: thisService) //call the didDiscoverCharacteristicForService()
                    }
                }
            }
        } /* end of didDiscoverServices() */

        
        
        /**
         Function to generate a 96 Tako sensor
         
         - note: In the API, ten sensors are added to the listOfPeripheralConnected
         
         */
        func generateGenTako(peripheral: CBPeripheral, generation: String , nExternal: Int){
            // We create a newSensor with the UUID and set his unique color with his number of appearance in the listPeripheralOnceConnected
            print("generateGenTako")
            
            var nSensor = 0
            nSensor = Int(generation)!
            
            switch nSensor{
            case 14    : (nSensor = 14)
            case 15    : (nSensor = 1)
            case 17    : (nSensor = 10)
            case 50    : (nSensor = 50)
            case 51    : (nSensor = 50)
            case 52    : (nSensor = 50)
            case 53    : (nSensor = 50)
            case 80    : (nSensor = 80)
            case 81    : (nSensor = 80)
            case 82    : (nSensor = 80)
            case 83    : (nSensor = 80)
            case 96    : (nSensor = 96)
            case 97    : (nSensor = 96)
            case 98    : (nSensor = 96)
            case 99    : (nSensor = 96)
            default    : ()
            }
            if nSensor != 0{
                print("generate sensors:")
                print(nSensor)
                for i in 0...(nSensor-1) {
                    print(i)
                    let newSensor = StretchSensePeripheral()
                    newSensor.uuid = peripheral.identifier.uuidString
                    newSensor.value = 0
                    newSensor.uniqueNumber = i
                    newSensor.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
                    newSensor.gen = String(Int(generation)!)
                
                    listPeripheralsOnceConnected.append(newSensor)
                    listPeripheralsConnected.append(newSensor)
                }
            }

            if nExternal != 0{
                print("generate external:")
                for i in 0...(nExternal-1) {
                    print(i)
                    let newSensor = StretchSensePeripheral()
                    newSensor.uuid = peripheral.identifier.uuidString
                    newSensor.value = 0
                    newSensor.uniqueNumber = i
                    newSensor.previousValueAveraged = [CGFloat](repeating: 0, count: numberOfSample)
                    newSensor.gen = "IMU 6x"
                    if i < 3 {
                        newSensor.gen = "Gyroscope"
                    }
                    else {
                        newSensor.gen = "Accelerometer"
                    }
                
                    listPeripheralsOnceConnected.append(newSensor)
                    listPeripheralsConnected.append(newSensor)
                }
            }
            
        } /* end of generateGenTako() */
        
        
        /**
         Once connected to a peripheral, enable notifications on the Sensor characteristic
         
         - note:
         
         */
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            print("didDiscoverCharacteristicsForService()")
            
            
            
            // Check the UUID of each characteristic to find config and data characteristics
            for charateristic in service.characteristics! {
                print(charateristic.uuid.uuidString)
                let thisCharacteristic = charateristic as CBCharacteristic
                
                let uuid_generation = thisCharacteristic.uuid.uuidString[4...5]
                let uuid_nExternalValues = thisCharacteristic.uuid.uuidString[1...2]
                let uuid_stretchsense = thisCharacteristic.uuid.uuidString[9...35]
                let uuid_position = thisCharacteristic.uuid.uuidString[6...7]

                if uuid_stretchsense == "7374-7265-7563-6873656E7365" {
                    switch uuid_position{
                    case "02"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    case "07"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    case "08"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    case "09"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    case "10"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    case "11"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    case "12"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    case "13"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    case "14"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    case "15"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    case "50"    : (peripheral.setNotifyValue(true, for: thisCharacteristic))
                    default    : ()
                    }
                }

                
            }
        } /* end of didDiscoverCharacteristicsFor() */
        
        
        
        /**
         Get/read capacitance data from the peripheral device when a notificiation is received
         
         - note:
         
         */
        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
//            print("didUpdateValueForCharacteristic()", characteristic.value)
            
            
            // Check errors
            if (error != nil) {
                print("Error Upload :  \(String(describing: error?.localizedDescription))");
            }

            //print(characteristic.uuid.uuidString)
            didUpdateValueGenTako(peripheral, characteristic: characteristic)


        } /* end of didUpdateValueFor() */
        
        
        
        
        
        
        /**
         Update the value of all the channel of the generation Tako
         
         - note:
         
         */
        func didUpdateValueGenTako(_ peripheral: CBPeripheral, characteristic: CBCharacteristic){
            
            let ValueData = characteristic.value!
            
            var offset = 0
            var offset_imu = 0
            //print(characteristic.uuid.uuidString)
            let uuid_generation = characteristic.uuid.uuidString[4...5]
            let uuid_position = characteristic.uuid.uuidString[6...7]
            let uuid_nExternalValues = characteristic.uuid.uuidString[1...2]

            var nSensor = Int(uuid_generation)!
            var nPosition = Int(uuid_position)!
            var nExternalValues = Int(uuid_nExternalValues)!

            var generation = ""
            var listPeripheralConnectedTako = [StretchSensePeripheral]()
            
            switch uuid_position{
            case "02"   : (offset = 0)
            case "07"   : (offset = 1)
            case "08"   : (offset = 2)
            case "09"   : (offset = 3)
            case "10"   : (offset = 4)
            case "11"   : (offset = 5)
            case "12"   : (offset = 6)
            case "13"   : (offset = 7)
            case "14"   : (offset = 8)
            case "15"   : (offset = 9)
            default     : (offset = 0)
            }
            
            
            switch uuid_generation{
            case "96"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedLeft)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Left")
                (nSensor = 96)
                
            case "97"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedRight)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Right")
                (nSensor = 96)

            case "98"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedFront)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Front")
                (nSensor = 96)

            case "99"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedBack)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Back")
                (nSensor = 96)
             
            case "17"   :
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "")
                (nSensor = 10)
                
            case "15"   :
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "")
                (nSensor = 1)
                
            case "80"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedLeft)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Left")
                (nSensor = 80)
                
            case "81"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedRight)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Right")
                (nSensor = 80)
                
            case "82"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedFront)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Front")
                (nSensor = 80)
                
            case "83"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedBack)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Back")
                (nSensor = 80)
                
            case "50"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedLeft)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Left")
                (nSensor = 50)
                
            case "51"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedRight)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Right")
                (nSensor = 50)
                
            case "52"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedFront)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Front")
                (nSensor = 50)
                
            case "53"   :
                //(listPeripheralConnectedTako = listPeripheralsConnectedBack)
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = "Back")
                (nSensor = 50)
                
                
            default     :
                (listPeripheralConnectedTako = listPeripheralsConnected)
                (generation = uuid_generation)
            }
            
            var nNotificationToSend = 1+((nSensor-1)/10)
            //print("notif to send: ", nNotificationToSend)

            if characteristic.uuid == imuUUID10CHTT {
                offset_imu = nNotificationToSend*10
            }
            
            innerLoop: for myPeripheral in listPeripheralConnectedTako{
                if myPeripheral.uuid == peripheral.identifier.uuidString{
                    let indexOfperipheral = listPeripheralConnectedTako.index(where: {$0.uuid == myPeripheral.uuid})
                    //print("didUpdateTako" , generation , "")
                    var j = 0;
                    //for i in 0...(ValueData.count/2)-1 {
                    
                    var nSensorInCaracteristic = nSensor - offset*10
                    if nSensorInCaracteristic > 10{
                        nSensorInCaracteristic = 10
                    }
                    
                    //print(nPosition)
                    // EXTERNAL VALUES
                    if ( nPosition == 50){
                        //print("external")
                        for i in 0...(nExternalValues)-1 {
                            let valueRawSensor1 = ValueData.subdata(in: Range(j...j+1))//SWIFT3
                            let valueIntSense1:Int! = Int(valueRawSensor1.hexadecimalString()!, radix: 16)!
                            switch i{
                            case 0:     listPeripheralConnectedTako[indexOfperipheral!+i+offset*10+offset_imu].value = 0.001*round(1000*( CGFloat(valueIntSense1)/100.0        ))
                            case 1:     listPeripheralConnectedTako[indexOfperipheral!+i+offset*10+offset_imu].value = 0.001*round(1000*( CGFloat(valueIntSense1)/100.0 - 90.0 ))
                            case 2:     listPeripheralConnectedTako[indexOfperipheral!+i+offset*10+offset_imu].value = 0.001*round(1000*( CGFloat(valueIntSense1)/100.0 - 180.0))
                            case 3:     listPeripheralConnectedTako[indexOfperipheral!+i+offset*10+offset_imu].value = 0.001*round(1000*( (CGFloat(valueIntSense1)/100.0) - 2.0  ))
                            case 4:     listPeripheralConnectedTako[indexOfperipheral!+i+offset*10+offset_imu].value = 0.001*round(1000*( (CGFloat(valueIntSense1)/100.0) - 2.0  ))
                            case 5:     listPeripheralConnectedTako[indexOfperipheral!+i+offset*10+offset_imu].value = 0.001*round(1000*( (CGFloat(valueIntSense1)/100.0) - 2.0  ))
                            default :   listPeripheralConnectedTako[indexOfperipheral!+i+offset*10+offset_imu].value = CGFloat(valueIntSense1)
                            }

                            //listPeripheralConnectedTako[indexOfperipheral!+i+offset*10+offset_imu].value = CGFloat(valueIntSense1)
                            //print(indexOfperipheral!+i+offset*10+offset_imu)
                            //print(CGFloat(valueIntSense1))
                            //print(listPeripheralConnectedTako[indexOfperipheral!+i+offset*10+offset_imu].value)
                            j=j+2
                        }
                    }
                    // STRETCHSENSE VALUES
                    else{
                        for i in 0...(nSensorInCaracteristic)-1 {
                            //print(nSensorInCaracteristic)

                            let valueRawSensor1 = ValueData.subdata(in: Range(j...j+1))//SWIFT3
                            let valueIntSense1:Int! = Int(valueRawSensor1.hexadecimalString()!, radix: 16)!
                        
                            let capacitance_value_in_pf = CGFloat(valueIntSense1)/10.0
                            listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].value = capacitance_value_in_pf
//                            print(capacitance_value_in_pf)

                            
                            
                            //
                            
                            ////////////// NOT WORKING
                            /*var sum_of_capa_for_filtering : CGFloat = 0
                            
                            var filtering_value = 5
                            for filtering_index in ((30-filtering_value) ... 28).reversed(){
                                sum_of_capa_for_filtering =  sum_of_capa_for_filtering + listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].previousValueAveraged[filtering_index]
                                print(listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].previousValueAveraged[filtering_index])
                            }
                            sum_of_capa_for_filtering += capacitance_value_in_pf
                            print(sum_of_capa_for_filtering)

                            sum_of_capa_for_filtering = sum_of_capa_for_filtering/(CGFloat(filtering_value))
                            listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].value = sum_of_capa_for_filtering/10
                            */
                            ///////////
                            //
                            j=j+2

                            // Shift the value for the line graph
                            var peripheralToShift = listPeripheralsConnected[indexOfperipheral!+i]

                            for k in 0 ... listPeripheralsConnected[indexOfperipheral!+0].previousValueAveraged.count-2{
                                peripheralToShift.previousValueAveraged[k] = peripheralToShift.previousValueAveraged[k+1]
                                peripheralToShift.previousValueRawFromTheSensor[k] = peripheralToShift.previousValueRawFromTheSensor[k+1]
                            }
                            peripheralToShift = listPeripheralsConnected[indexOfperipheral!+i]
                            peripheralToShift.previousValueRawFromTheSensor[peripheralToShift.previousValueRawFromTheSensor.count-1] = peripheralToShift.value
                            peripheralToShift.previousValueAveraged[peripheralToShift.previousValueAveraged.count-1] = peripheralToShift.value
                            
                            
                            
                            // Add some filtering on the values
                            var sum_of_capa_for_filtering : CGFloat = 0
                            var capa_averaged_after_filtering : CGFloat = 0
                            
                            var filtering_value : Int =  Int(filteringNumber)
                            //print(filtering_value)
                            
                            if ( filtering_value >= 2){
                                for filtering_index in ((30-filtering_value) ... 28).reversed(){
                                    //sum_of_capa_for_filtering +=  listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].previousValueRawFromTheSensor[filtering_index]
                                    sum_of_capa_for_filtering +=  listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].previousValueRawFromTheSensor[filtering_index]
                                }
                                sum_of_capa_for_filtering += capacitance_value_in_pf
                             
                                capa_averaged_after_filtering = sum_of_capa_for_filtering/(CGFloat(filtering_value))
                                //print("sum_of_capa_for_filtering")
                                //listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].value = sum_of_capa_for_filtering/10
                                peripheralToShift.previousValueAveraged[peripheralToShift.previousValueAveraged.count-1] = capa_averaged_after_filtering
                                peripheralToShift.value = capa_averaged_after_filtering
                            }
 
                            ///////////
                            
                            //print(myPeripheral.previousValueAveraged)
                            
                            
                        }
                    }
                    myPeripheral.indexNotificationUpdated[offset] = 1
                    var sumIndex = 0
                    for index in myPeripheral.indexNotificationUpdated{
                        sumIndex += index
                    }
                    //print("sumIndex ", sumIndex)

                    if sumIndex == nNotificationToSend {
                        //print("NOTIF")
                        // Notify the viewController that the value has been updated and so has to be reloaded
                        let defaultCenter = NotificationCenter.default
                        // We send a notification with the number of the sensor
                        defaultCenter.post(name: Notification.Name(rawValue: "UpdateValueNotification"/*+generation*/), object: nil, userInfo: nil)
                        
                        myPeripheral.indexNotificationUpdated = [Int](repeating: 0, count: nNotificationToSend)
                    }
                    break innerLoop
                }
            }
            
            
            
        } /* end of didUpdateValueGenTako() */
        
        
        
        
    }/* end of the API */
    
    
    
    
    
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    // MARK: - EXTENSION
    // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    extension Data {
        
        /**
         Convert the hexadecimal value into a String
         
         - parameter Nothing
         
         - returns: The value converted
         
         */
        func hexadecimalString() -> String? {
            /* Used to convert NSData to String */
            //print("hexadecimalString()")
            if let buffer = Optional((self as NSData).bytes.bindMemory(to: UInt8.self, capacity: self.count)) {
                var hexadecimalString = String()
                for i in 0..<self.count {
                    hexadecimalString += String(format: "%02x", buffer.advanced(by: i).pointee)
                }
                return hexadecimalString
            }
            return nil
        }
        
        
    func subdata(in range: ClosedRange<Index>) -> Data {
        return subdata(in: range.lowerBound ..< range.upperBound + 1)
    }
        func scanValue<T>(start: Int, length: Int) -> T {
            return self.subdata(in: start..<start+length).withUnsafeBytes { $0.pointee }
        }
        
}
    
    
    extension BarGraphViewController : MFMailComposeViewControllerDelegate {
        
        /**
         Convert a [String] to NSData
         
         - parameter arr	ay: the array of String
         
         - returns: array of String converted
         
         */
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
        } /* end of stringArrayToNSData() */
        
        
        
        /**
         Save and Share a [String]
         - Note: Format and save recorded capacitance data to file (.csv)
         
         - parameter array: the array of String
         
         - returns: Nothing
         
         */
        func saveAndExport(_ stringArrayToShare: [String]) {
            print("saveAndExport()")
            
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: Date())
            print(myString)
            
            //let exportFilePath = NSTemporaryDirectory() + "StretchSense_Record.csv"
            let exportFilePath = NSTemporaryDirectory() + "StretchSense_" + "\(myString)" + ".csv"
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
                let nsdataToShare: Data = stringArrayToNSData(stringArrayToShare)
                
                fileHandle!.write(/*csvData!*/ nsdataToShare)
                
                fileHandle!.closeFile()
                
                // Item to share
                let firstActivityItem = URL(fileURLWithPath: exportFilePath)
                
                // Create share activity view controller and give the csv file
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
                
                // Display share activity view controller
                //if iPhone
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                    self.present(activityViewController, animated: true, completion: nil)
                } else { //if iPad
                    // Change Rect to position Popover
                    let popoverCntlr = UIPopoverController(contentViewController: activityViewController)
                    popoverCntlr.present(from: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/4, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
                }
            }
        } /* end of saveAndExport() */
        
        
    } /* end of extension BarGraphViewController */
    
    
    
    
    
    extension TableViewController : MFMailComposeViewControllerDelegate {
        
        /**
         Convert a [String] to NSData
         
         - parameter array: the array of String
         
         - returns: array of String converted
         
         */
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
        } /* end of stringArrayToNSData() */
        
        
        
        /**
         Save and Share a [String]
         - Note: Format and save recorded capacitance data to file (.csv)
         
         - parameter array: the array of String
         
         - returns: Nothing
         
         */
        func saveAndExport(_ stringArrayToShare: [String]) {
            print("saveAndExport()")
            
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: Date())
            print(myString)
            
            //let exportFilePath = NSTemporaryDirectory() + "StretchSense_Record.csv"
            let exportFilePath = NSTemporaryDirectory() + "StretchSense_" + "\(myString)" + ".csv"
            
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
                let nsdataToShare: Data = stringArrayToNSData(stringArrayToShare)
                
                fileHandle!.write(/*csvData!*/ nsdataToShare)
                
                fileHandle!.closeFile()
                
                let firstActivityItem = URL(fileURLWithPath: exportFilePath)
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
                
                //if iPhone
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                    self.present(activityViewController, animated: true, completion: nil)
                } else { //if iPad
                    // Change Rect to position Popover
                    let popoverCntlr = UIPopoverController(contentViewController: activityViewController)
                    popoverCntlr.present(from: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/4, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
                }
            }
        } /* end of saveAndExport() */
        
        
    } /* end of extension TableViewController */
    
    
    
    
    
    
    extension LineChartViewController : MFMailComposeViewControllerDelegate {
        
        
        /**
         Convert a [String] to NSData
         
         - parameter array: the array of String
         
         - returns: array of String converted
         
         */
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
        } /* end of stringArrayToNSData() */
        
        
        
        /**
         Save and Share a [String]
         - Note: Format and save recorded capacitance data to file (.csv)
         
         - parameter array: the array of String
         
         - returns: Nothing
         
         */
        func saveAndExport(_ stringArrayToShare: [String]) {
            print("saveAndExport()")
            
            let formatter = DateFormatter()
            // initially set the format based on your datepicker date
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let myString = formatter.string(from: Date())
            print(myString)
            
            //let exportFilePath = NSTemporaryDirectory() + "StretchSense_Record.csv"
            let exportFilePath = NSTemporaryDirectory() + "StretchSense_" + "\(myString)" + ".csv"
            
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
                let nsdataToShare: Data = stringArrayToNSData(stringArrayToShare)
                
                fileHandle!.write(/*csvData!*/ nsdataToShare)
                
                fileHandle!.closeFile()
                
                let firstActivityItem = URL(fileURLWithPath: exportFilePath)
                let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
                
                //if iPhone
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone) {
                    self.present(activityViewController, animated: true, completion: nil)
                } else { //if iPad
                    // Change Rect to position Popover
                    let popoverCntlr = UIPopoverController(contentViewController: activityViewController)
                    popoverCntlr.present(from: CGRect(x: self.view.frame.size.width/2, y: self.view.frame.size.height/4, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.any, animated: true)
                }
            }
        } /* end of saveAndExport() */

        
        
    } /* end of extension LineChartViewController */
    
    
    extension String {
        subscript(pos: Int) -> String {
            precondition(pos >= 0, "character position can't be negative")
            return self[pos...pos]
        }
        subscript(range: Range<Int>) -> String {
            precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
            let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
            return String(self[lowerIndex..<(index(lowerIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)])
        }
        subscript(range: ClosedRange<Int>) -> String {
            precondition(range.lowerBound >= 0, "range lowerBound can't be negative")
            let lowerIndex = index(startIndex, offsetBy: range.lowerBound, limitedBy: endIndex) ?? endIndex
            return String(self[lowerIndex..<(index(lowerIndex, offsetBy: range.count, limitedBy: endIndex) ?? endIndex)])
        }
    }



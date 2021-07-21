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
    

    class StretchSenseAPI: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate
    {
        var lastTimeVal : CGFloat = 0
        var lastVal : CGFloat = 0

        func discoverServicesforPeripherals( periph : CBPeripheral)
        {
            periph.discoverServices(nil)
        }
        func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber){
            informationFeedBack = "Searching for peripherals"
            let defaultCenter = NotificationCenter.default//SWIFT2
            defaultCenter.post(name: Notification.Name(rawValue: "UpdateInfo"), object: nil, userInfo: nil) //SWIFT2
            
            if #available(iOS 10.0, *) {
                if (central.state == CBManagerState.poweredOn){ //SWIFT3
                    var inTheList = false
                    let peripheralCurrent = peripheral
                    
                    for periphOnceConnected in self.listPeripheralsOnceConnected {
                        
                        // If the peripheral discovered was never connected to the app we identify it
                        let pName = (advertisementData as NSDictionary).object(forKey: CBAdvertisementDataLocalNameKey) as? NSString
                        if ((pName == "StretchSense") || (pName == "StretchSense_Tako") || (pName == "StretchSense_T01") || (pName == "StretchSense_T02") || (pName == "StretchSense_T03") || (pName == "StretchSense_T04") || (pName == "StretchSense_T05") || (pName == "StretchSense_T06") || (pName == "StretchSense_T07") || (pName == "StretchSense_T08") || (pName == "StretchSense_T09") || (pName == "StretchSense_T10"))
                        {
                            print("New StretchSense peripheral discover")
                            informationFeedBack = "New Sensor Detected, Click to Connect/Disconnect"
                            
                            if (self.listPeripheralAvailable.count == 0) {
                                self.listPeripheralAvailable.append(peripheralCurrent)
                            }
                            else{
                                for periphInList in self.listPeripheralAvailable{
                                    if peripheral.identifier == periphInList?.identifier{
                                        inTheList = true
                                    }
                                }
                                if inTheList == false{
                                    self.listPeripheralAvailable.append(peripheralCurrent)
                                }
                            }
                        }
                        
                    }
                }
            } else {
                // Fallback on earlier versions
            }
        }
        
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
        }

        
        func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
            print("didConnectPeripheral()")
            
            informationFeedBack = "Peripheral connected"
            let defaultCenter = NotificationCenter.default
            defaultCenter.post(name: Notification.Name(rawValue: "deviceDidConnected"), object: nil, userInfo: nil)
            peripheral.delegate = self
            stopScanning()
//            peripheral.discoverServices(nil)
        }
        
        
        
        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            print("didDiscoverServices()")
            if (error != nil) {
                print("Error :  \(String(describing: error?.localizedDescription))");
            }
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
        }

        
        
        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            print("didDiscoverCharacteristicsForService()")
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
        }
        func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
            print("didDisconnectPeripheral()")
            
            // Check errors
            if (error != nil) {
                print("didDisconnectPeripheral Error :  \(String(describing: error?.localizedDescription))");
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

        
        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
            //            //print("didUpdateValueForCharacteristic()",characteristic.value as Any)
            //            print("value----------->>>>>>",String(describing: characteristic.value))
            //            let str = String(data: characteristic.value!, encoding: String.Encoding.utf8) as! String
            let dataf = characteristic.value! as NSData
            let datastring = NSString(data: dataf as Data, encoding: String.Encoding.utf8.rawValue)
//            print(dataf)
            
            // Check errors
            if (error != nil) {
                //print("Error Upload :  \(String(describing: error?.localizedDescription))");
            }
            let ValueData = characteristic.value!
            let valueRawSensor1 = ValueData.subdata(in: Range(0...1))//SWIFT3
            let valueIntSense1:Int! = Int(valueRawSensor1.hexadecimalString()!, radix: 16)!
            
            
                if (isAllowScan == true)
                {
                    didUpdateValueGenTako(peripheral, characteristic: characteristic)
                    isAllowScan = false
                }
        } /* end of didUpdateValueFor() */
        

        
        @objc func UpdateTimer()
        {
            isAllowScan = true
        }
        
        func didUpdateValueGenTako(_ peripheral: CBPeripheral, characteristic: CBCharacteristic){
            
            let ValueData = characteristic.value!
            
            var offset = 0
            var offset_imu = 0
            ////print(characteristic.uuid.uuidString)
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
            ////print("notif to send: ", nNotificationToSend)
            
           
            
            innerLoop: for myPeripheral in listPeripheralConnectedTako{
                if myPeripheral.uuid == peripheral.identifier.uuidString{
                    let indexOfperipheral = listPeripheralConnectedTako.index(where: {$0.uuid == myPeripheral.uuid})
                    ////print("didUpdateTako" , generation , "")
                    var j = 0;
                    //for i in 0...(ValueData.count/2)-1 {
                    
                    var nSensorInCaracteristic = nSensor - offset*10
                    if nSensorInCaracteristic > 10{
                        nSensorInCaracteristic = 10
                    }
                    nSensorInCaracteristic = 1
                    ////print(nPosition)
                    // EXTERNAL VALUES
                    
                        for i in 0...(nSensorInCaracteristic)-1 {
                            ////print(nSensorInCaracteristic)
                            
                            let valueRawSensor1 = ValueData.subdata(in: Range(j...j+1))//SWIFT3
                            let valueIntSense1:Int! = Int(valueRawSensor1.hexadecimalString()!, radix: 16)!
                            
                            var capacitance_value_in_pf = CGFloat(valueIntSense1)/10.0
                            listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].value = capacitance_value_in_pf
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
                            
                            if isSmoothChart == true
                            {
                                let filtering_value : Int =  Int(28)
                                if ( filtering_value >= 2){
                                    for filtering_index in ((30-filtering_value) ... 28).reversed(){
                                        //sum_of_capa_for_filtering +=  listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].previousValueRawFromTheSensor[filtering_index]
                                        sum_of_capa_for_filtering +=  listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].previousValueRawFromTheSensor[filtering_index]
                                    }
                                    sum_of_capa_for_filtering += capacitance_value_in_pf
                                    
                                    capa_averaged_after_filtering = sum_of_capa_for_filtering/(CGFloat(filtering_value))
                                    ////print("sum_of_capa_for_filtering")
                                    //listPeripheralConnectedTako[indexOfperipheral!+i+offset*10].value = sum_of_capa_for_filtering/10
                                    peripheralToShift.previousValueAveraged[peripheralToShift.previousValueAveraged.count-1] = capa_averaged_after_filtering
                                    peripheralToShift.value = capa_averaged_after_filtering
                                }

                            }
                        }
                    myPeripheral.indexNotificationUpdated[offset] = 1
                    var sumIndex = 0
                    for index in myPeripheral.indexNotificationUpdated{
                        sumIndex += index
                    }
                    ////print("sumIndex ", sumIndex)
                    
                    if sumIndex == nNotificationToSend {
                        ////print("NOTIF")
                        // Notify the viewController that the value has been updated and so has to be reloaded
                        let defaultCenter = NotificationCenter.default
                        // We send a notification with the number of the sensor
                        defaultCenter.post(name: Notification.Name(rawValue: "UpdateValueNotification"/*+generation*/), object: nil, userInfo: nil)
                        
                        myPeripheral.indexNotificationUpdated = [Int](repeating: 0, count: nNotificationToSend)
                    }
                    break innerLoop
                }
            }
            
            
            
        }
        
        func generateGenTako(peripheral: CBPeripheral, generation: String , nExternal: Int){
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
        

        // MARK: - Other Methods

        /// The manager of all the discovered peripherals
        fileprivate var centralManager : CBCentralManager!
        fileprivate var listPeripheralAvailable : [CBPeripheral?] = []
        fileprivate var listPeripheralsConnected = [StretchSensePeripheral]()
        fileprivate var listPeripheralsConnectedLeft = [StretchSensePeripheral]()
        fileprivate var listPeripheralsConnectedRight = [StretchSensePeripheral]()
        fileprivate var listPeripheralsConnectedFront = [StretchSensePeripheral]()
        fileprivate var listPeripheralsConnectedBack = [StretchSensePeripheral]()
        fileprivate var listPeripheralsConnectedExternal = [StretchSensePeripheral]()
        fileprivate var listPeripheralsOnceConnected : [StretchSensePeripheral] = [StretchSensePeripheral()]
        var numberOfSample = 30
        var samplingTimeNumber : UInt8 = 0
        var filteringNumber : UInt8 = 0
        fileprivate var informationFeedBack = ""
        var scanTimer = Timer()
        var isAllowScan : Bool = true

        func startBluetooth()
        {
            scanTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            centralManager = CBCentralManager(delegate: self, queue: nil)
        }
        
        func startScanning() {
            print("startScanning()")
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
        
        func stopScanning(){
            print("stopScanning()")
            self.centralManager.stopScan()
        }


        func connectToPeripheralWithCBPeripheral(_ myPeripheral : CBPeripheral?){
            print("connectToPeripheralWithCBPeripheral()")
            self.centralManager.connect(myPeripheral!, options: nil)
            myPeripheral!.discoverServices(nil)
        }

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
        }

        
        func disconnectOnePeripheralWithCBPeripheral(_ myPeripheral : CBPeripheral){
            print("disconnectOnePeripheralWithCBPeripheral()")
            centralManager.cancelPeripheralConnection(myPeripheral)
        }
        
        
        func disconnectAllPeripheral(){
            for myPeripheral in listPeripheralAvailable {
                centralManager.cancelPeripheralConnection(myPeripheral!)
            }
        }


        func getListPeripheralsAvailable() -> [CBPeripheral?]   {
            return listPeripheralAvailable
        }


        func getListUUIDPeripheralsAvailable() -> [String] {
            var uuid : [String] = []
            let numberOfPeripheralAvailable = listPeripheralAvailable.count
            if numberOfPeripheralAvailable != 0 {
                for i in 0...numberOfPeripheralAvailable-1 {
                    uuid += [(listPeripheralAvailable[i]!.identifier.uuidString)]
                }
            }
            return uuid
        }


        func getListPeripheralsConnectedLeft() -> [StretchSensePeripheral]{
            return listPeripheralsConnectedLeft
        }

        
        func getListPeripheralsConnected() -> [StretchSensePeripheral]{
            return listPeripheralsConnected
        }
        
        
        func getListPeripheralsConnectedRight() -> [StretchSensePeripheral]{
            return listPeripheralsConnectedRight
        }


        func getListPeripheralsConnectedFront() -> [StretchSensePeripheral]{
            return listPeripheralsConnectedFront
        }


        func getListPeripheralsConnectedBack() -> [StretchSensePeripheral]{
            return listPeripheralsConnectedBack
        }

        
        func getListPeripheralsOnceConnected() -> [StretchSensePeripheral]{
            return listPeripheralsOnceConnected
        }
        func writeShutdown(_ dataIn: UInt8, myPeripheral : CBPeripheral?) {
            print("writeShutdown()")
        }
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

 /* end of didDiscover() */

        
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
         Once connected to a peripheral, enable notifications on the Sensor characteristic
         
         - note:
         
         */

        
        
        
        /**
         Get/read capacitance data from the peripheral device when a notificiation is received
         
         - note:
         
         */
        
        
        
        
        
        /**
         Update the value of all the channel of the generation Tako
         
         - note:
         
         */
         /* end of didUpdateValueGenTako() */
        
        
        
        
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

        
        
        
  
        
        
        
    }/* end of the API */
    
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
    var times = [CGFloat](repeating: 0, count: 30)

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
        Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),    //
        Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
        Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
        Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
        Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
        Color(colorName: "Jelly Bean", colorValueRGB: UIColor(red: 0.85, green: 0.38, blue: 0.31, alpha: 1)),
        Color(colorName: "Electric Blue", colorValueRGB: UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
        Color(colorName: "Rose", colorValueRGB: UIColor(red: 1, green: 0, blue: 127/255, alpha: 1)),
        Color(colorName: "Emeraude", colorValueRGB: UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1)),
        Color(colorName: "Magenta", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
        Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),    //
        Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
        Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
        Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
        Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1)),
        Color(colorName: "Jelly Bean", colorValueRGB: UIColor(red: 0.85, green: 0.38, blue: 0.31, alpha: 1)),
        Color(colorName: "Electric Blue", colorValueRGB: UIColor(red: 0, green: 1, blue: 1, alpha: 1)),
        Color(colorName: "Rose", colorValueRGB: UIColor(red: 1, green: 0, blue: 127/255, alpha: 1)),
        Color(colorName: "Emeraude", colorValueRGB: UIColor(red: 0.31, green: 0.78, blue: 0.47, alpha: 1)),
        Color(colorName: "Magenta", colorValueRGB:  UIColor(red: 0.5, green: 0, blue: 0.5, alpha: 1)),
        Color(colorName: "Yellow", colorValueRGB:  UIColor(red: 1, green: 1, blue: 0, alpha: 1)),    //
        Color(colorName: "Grey", colorValueRGB: UIColor(red: 0.498039, green: 0.498039, blue: 0.498039, alpha: 1)),
        Color(colorName: "Gold", colorValueRGB:  UIColor(red: 0.737255, green: 0.741176, blue: 0.133333, alpha: 1)),
        Color(colorName: "Orange", colorValueRGB: UIColor(red: 1, green: 0.5, blue: 0, alpha: 1)),
        Color(colorName: "Green", colorValueRGB: UIColor(red: 0, green: 1, blue: 0, alpha: 1))
    ]
}
    
    
    
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



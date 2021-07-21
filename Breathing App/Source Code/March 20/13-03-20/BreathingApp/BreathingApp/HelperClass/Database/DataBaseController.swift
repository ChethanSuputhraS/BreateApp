//
//  DataBaseController.swift
//  LocalDB
//
//  Created by srivatsa s pobbathi on 31/12/19.
//  Copyright © 2019 srivatsa s pobbathi. All rights reserved.
//

import UIKit
import SQLite3
class DataBaseController: NSObject
{
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    static let shared = DataBaseController()
    var db: OpaquePointer?

    override init(){}
    var UserList = [userDataDB]()
    var DeviceList = [devicesDB]()
    var ReadingsList = [readingsDB]()
    
    var arryUserData = [[String:String]]()
    var arrayDevices = [[String:String]]()
    var arrayReadings = [[String:String]]()
    

    @objc func createDB()
    {
        //the database file
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("Breathing.sqlite")
      
        print("Local Db Path is : \(fileURL)")

        //opening the database
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
        }
        
        //creating table
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS UserData (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT , email TEXT, password TEXT , isActive TEXT , serverID TEXT)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        //u can create more tables here
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Devices (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT , userID TEXT , deviceName TEXT , deviceType TEXT , UUID TEXT , isActive TEXT )", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        
        //u can create more tables here
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS Readings (id INTEGER PRIMARY KEY AUTOINCREMENT, session_time TEXT , chest_name TEXT , abdomen_name TEXT , deviceType TEXT , readings TEXT , status TEXT )", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }


    }
    // db User DATA
@objc func insertIntoTableuserDataDB(name: NSString , email: NSString , password:NSString , isActive:NSString , serverID:NSString)
    {
        // inserting into tables
        
        var stmt: OpaquePointer?
        
        let queryString = "INSERT INTO UserData (name , email , password , isActive , serverID) VALUES (?,?,?,?,?)"
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
       
        
        //for text
        
        
        if sqlite3_bind_text(stmt, 1, name.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, email.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding email: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 3, password.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding password: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 4, isActive.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding password: \(errmsg)")
            return
        }
        if sqlite3_bind_text(stmt, 5, serverID.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding password: \(errmsg)")
            return
        }
        
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }

    }
  // db of Devices
@objc func insertIntoTabledevicesDB(name: NSString , userID: NSString , deviceName:NSString , deviceType:NSString , UUID:NSString, isActive:NSString)
    {


        // inserting into tables

        var stmt: OpaquePointer?

        let queryString = "INSERT INTO Devices (name , userID , deviceName , deviceType , UUID , isActive ) VALUES (?,?,?,?,?,?)"

        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK
        {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        //for text

               if sqlite3_bind_text(stmt, 1, name.utf8String, -1, nil) != SQLITE_OK{
                   let errmsg = String(cString: sqlite3_errmsg(db)!)
                   print("failure binding name: \(errmsg)")
                   return
               }

               if sqlite3_bind_text(stmt, 2, userID.utf8String, -1, nil) != SQLITE_OK{
                   let errmsg = String(cString: sqlite3_errmsg(db)!)
                   print("failure binding email: \(errmsg)")
                   return
               }

               if sqlite3_bind_text(stmt, 3, deviceName.utf8String, -1, nil) != SQLITE_OK{
                   let errmsg = String(cString: sqlite3_errmsg(db)!)
                   print("failure binding password: \(errmsg)")
                   return
               }
               if sqlite3_bind_text(stmt, 4, deviceType.utf8String, -1, nil) != SQLITE_OK{
                   let errmsg = String(cString: sqlite3_errmsg(db)!)
                   print("failure binding password: \(errmsg)")
                   return
               }
               if sqlite3_bind_text(stmt, 5, UUID.utf8String, -1, nil) != SQLITE_OK{
                   let errmsg = String(cString: sqlite3_errmsg(db)!)
                   print("failure binding password: \(errmsg)")
                   return
               }
        if sqlite3_bind_text(stmt, 6, isActive.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding password: \(errmsg)")
            return
        }
               if sqlite3_step(stmt) != SQLITE_DONE {
                   let errmsg = String(cString: sqlite3_errmsg(db)!)
                   print("failure inserting hero: \(errmsg)")
                   return
               }

    }
      // db of Readings
    @objc func insertIntoTablereadingsDB(session: NSString , UUID: NSString , deviceID:NSString , deviceType:NSString , readings:NSString, status:NSString)
        {

            // inserting into tables

            var stmt: OpaquePointer?

            let queryString = "INSERT INTO Readings (session , UUID , deviceID , deviceType , readings , status ) VALUES (?,?,?,?,?,?)"

            if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK
            {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error preparing insert: \(errmsg)")
                return
            }
            //for text

                   if sqlite3_bind_text(stmt, 1, session.utf8String, -1, nil) != SQLITE_OK{
                       let errmsg = String(cString: sqlite3_errmsg(db)!)
                       print("failure binding name: \(errmsg)")
                       return
                   }

                   if sqlite3_bind_text(stmt, 2, UUID.utf8String, -1, nil) != SQLITE_OK{
                       let errmsg = String(cString: sqlite3_errmsg(db)!)
                       print("failure binding email: \(errmsg)")
                       return
                   }

                   if sqlite3_bind_text(stmt, 3, deviceID.utf8String, -1, nil) != SQLITE_OK{
                       let errmsg = String(cString: sqlite3_errmsg(db)!)
                       print("failure binding password: \(errmsg)")
                       return
                   }
                   if sqlite3_bind_text(stmt, 4, deviceType.utf8String, -1, nil) != SQLITE_OK{
                       let errmsg = String(cString: sqlite3_errmsg(db)!)
                       print("failure binding password: \(errmsg)")
                       return
                   }
                   if sqlite3_bind_text(stmt, 5, readings.utf8String, -1, nil) != SQLITE_OK{
                       let errmsg = String(cString: sqlite3_errmsg(db)!)
                       print("failure binding password: \(errmsg)")
                       return
                   }
            if sqlite3_bind_text(stmt, 6, status.utf8String, -1, nil) != SQLITE_OK{
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("failure binding password: \(errmsg)")
                return
            }
                   if sqlite3_step(stmt) != SQLITE_DONE {
                       let errmsg = String(cString: sqlite3_errmsg(db)!)
                       print("failure inserting hero: \(errmsg)")
                       return
                   }

        }
        
    
 // DB  User DATA
    func getTableUserDataFromDB() -> [[String:String]]
    {
        UserList.removeAll()
        arryUserData.removeAll()
        let queryString = "SELECT name FROM UserData"
        
        var stmt:OpaquePointer?
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return arryUserData
            
        }

        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let email = String(cString: sqlite3_column_text(stmt, 2))
            let password = String(cString: sqlite3_column_text(stmt, 3))
            let isActive = String(cString: sqlite3_column_text(stmt, 4))
             let serverID = String(cString: sqlite3_column_text(stmt, 5))

            
            UserList.append(userDataDB(id: Int(id), name: String(describing: name), email: String(describing: email), password: String(describing: password), isActive: String(describing: isActive), serverID: String(describing: serverID)))
         
            if arryUserData.count > 0
            {
                let dict = ["id": id, "name": name, "email": email,"password": password, "isActive":isActive, "serverID":serverID] as [String : Any]
                var newdict = [String:String]()
                for (key, value) in dict {
                    newdict[key] = "\(value)"
                }
                arryUserData.append(newdict)
            }
        }
        print("array User Data is \(arryUserData)")
        
        return arryUserData
    }
   
    
    // DB Devices
    
func getTableDevicesFromDB() -> [[String:String]]
    {
        DeviceList.removeAll()
        arrayDevices.removeAll()
        let queryString = "SELECT * FROM Devices"

        var stmt:OpaquePointer?

        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return arrayDevices

        }

        while(sqlite3_step(stmt) == SQLITE_ROW){
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let userID = String(cString: sqlite3_column_text(stmt, 2))
            let deviceName = String(cString: sqlite3_column_text(stmt, 3))
            let deviceType = String(cString: sqlite3_column_text(stmt, 4))
             let UUID = String(cString: sqlite3_column_text(stmt, 5))
              let isActive = String(cString: sqlite3_column_text(stmt, 6))

            DeviceList.append(devicesDB(id: Int(id), name: String(describing: name), userID: String(describing: userID), deviceName: String(describing: deviceName), deviceType: String(describing: deviceType), UUID: String(describing: UUID), isActive: String(describing: isActive)))

            if arrayDevices.count > 0
            {
                let dict1 = ["id": id, "name": name, "userID": userID,"deviceName": deviceName, "deviceType":deviceType, "UUID":UUID, "isActive":isActive] as [String : Any]
                var newdict1 = [String:String]()
                for (key, value) in dict1 {
                    newdict1[key] = "\(value)"
                }
                arrayDevices.append(newdict1)
            }
        }
        print("array Devices is \(arrayDevices)")

        return arrayDevices
    }
    // DB  Readings
      /* func getTableReadingsFromDB() -> [[String:String]]
       {
           ReadingsList.removeAll()
           arrayReadings.removeAll()
           let queryString = "SELECT * FROM Readings"
           
           var stmt:OpaquePointer?
           
           
           if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
               let errmsg = String(cString: sqlite3_errmsg(db)!)
               print("error preparing insert: \(errmsg)")
               return arrayReadings
               
           }

           while(sqlite3_step(stmt) == SQLITE_ROW){
               let id = sqlite3_column_int(stmt, 0)
               let session = String(cString: sqlite3_column_text(stmt, 1))
               let UUID = String(cString: sqlite3_column_text(stmt, 2))
               let deviceID = String(cString: sqlite3_column_text(stmt, 3))
               let deviceType = String(cString: sqlite3_column_text(stmt, 4))
                let readings = String(cString: sqlite3_column_text(stmt, 5))
               let status = String(cString: sqlite3_column_text(stmt, 6))
               
               
                //    init(id: Int, session: String?, UUID: String?, deviceID:String?, deviceType:String?,readings:String?,status:String?)
               
               
               ReadingsList.append(readingsDB(id: Int(id), session: String(describing: session), UUID: String(describing: UUID), deviceID: String(describing: deviceID), deviceType: String(describing: deviceType), readings: String(describing: readings), status: String(describing: status)))
            
               if arrayReadings.count > 0
               {
                   let dict2 = ["id": id, "session": session, "UUID": UUID,"deviceID": deviceID, "deviceType":deviceType, "readings":readings, "status":status] as [String : Any]
                   var newdict2 = [String:String]()
                   for (key, value) in dict2 {
                       newdict2[key] = "\(value)"
                   }
                   arrayReadings.append(newdict2)
               }
           }
           print("array ReadingsData is \(arrayReadings)")
           
           return arrayReadings
       }*/
    
    @objc func deleteuserDataDB(row : Int)
    {
        let deleteStatementStirng = "DELETE FROM userDataDB WHERE id = ?;"
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(deleteStatement, 1, Int32(row))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE
            {
                print("Successfully deleted row.")
            }
            else
            {
                print("Could not delete row.")
            }
        }
        else
        {
            print("DELETE statement could not be prepared")
        }
        
        sqlite3_finalize(deleteStatement)
        print("delete")

    }
    
    //delete DeviceDB
    
    @objc func deletedevicesDB(row : Int)
       {
           let deleteStatementStirng = "DELETE FROM devicesDB WHERE id = ?;"
           
           var deleteStatement: OpaquePointer? = nil
           if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
               
               sqlite3_bind_int(deleteStatement, 1, Int32(row))
               
               if sqlite3_step(deleteStatement) == SQLITE_DONE
               {
                   print("Successfully deleted row.")
               }
               else
               {
                   print("Could not delete row.")
               }
           }
           else
           {
               print("DELETE statement could not be prepared")
           }
           
           sqlite3_finalize(deleteStatement)
           print("delete")

       }
    
    //delete Readings
    
    @objc func deleteReadingsDB(row : Int)
       {
           let deleteStatementStirng = "DELETE FROM readingsDB WHERE id = ?;"
           
           var deleteStatement: OpaquePointer? = nil
           if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
               
               sqlite3_bind_int(deleteStatement, 1, Int32(row))
               
               if sqlite3_step(deleteStatement) == SQLITE_DONE
               {
                   print("Successfully deleted row.")
               }
               else
               {
                   print("Could not delete row.")
               }
           }
           else
           {
               print("DELETE statement could not be prepared")
           }
           
           sqlite3_finalize(deleteStatement)
           print("delete")

       }
    
    @objc func getDocumentsDirectory() -> URL
    {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        
        
        return documentsDirectory
        
    }
    
    @objc func execute(sqlStatement : String) -> Bool
    {
        let deleteStatementStirng = sqlStatement
        var status = false
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK
        {
            status = true
        }
        else
        {
            status = false
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error creating table: \(errmsg)")
        }
        if sqlite3_step(deleteStatement) == SQLITE_DONE
        {
            print("Successfully executed.")
        }
        else
        {
            print("error in execution.")
        }

        sqlite3_finalize(deleteStatement)
        return status
    }
    
    func getTableReadingsFromDB() -> [String : String]
    {
        var newdict2 = [String:String]()
        ReadingsList.removeAll()
        arrayReadings.removeAll()
        let queryString = "SELECT * FROM Readings"
        
        var stmt:OpaquePointer?
        
        
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return ["NA" : "NA"]
            
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW)
        {
            let id = sqlite3_column_int(stmt, 0)
            let sessiontime = String(cString: sqlite3_column_text(stmt, 1))
            let chest_name = String(cString: sqlite3_column_text(stmt, 2))
            let abdomen_name = String(cString: sqlite3_column_text(stmt, 3))
            let deviceType = String(cString: sqlite3_column_text(stmt, 4))
            let readings = String(cString: sqlite3_column_text(stmt, 5))
            let status = String(cString: sqlite3_column_text(stmt, 6))

            ReadingsList.append(readingsDB(id: Int(id), session: String(describing: sessiontime), UUID: String(describing: chest_name), deviceID: String(describing: abdomen_name), deviceType: String(describing: deviceType), readings: String(describing: readings), status: String(describing: status)))
            
            
            let dict2 = ["id": id, "session": sessiontime, "chest_name": chest_name,"abdomen_name": abdomen_name, "deviceType":deviceType, "readings":readings, "status":status] as [String : Any]
            
            for (key, value) in dict2
            {
                newdict2[key] = "\(value)"
            }

        }
        
        return newdict2
    }
    /*-(BOOL) execute:(NSString*)sqlQuery resultsArray:(NSMutableArray*)dataTable
    {
    
    char** azResult = NULL;
    int nRows = 0;
    int nColumns = 0;
    querystatus = FALSE;
    char* errorMsg; //= malloc(255); // this is not required as sqlite do it itself
    const char* sql = [sqlQuery UTF8String];
    sqlite3_get_table(
    _database,  /* An open database */
    sql,     /* SQL to be evaluated */
    &azResult,          /* Results of the query */
    &nRows,                 /* Number of result rows written here */
    &nColumns,              /* Number of result columns written here */
    &errorMsg      /* Error msg written here */
    );
    
    if(azResult != NULL)
    {
    nRows++; //because the header row is not account for in nRows
    
    for (int i = 1; i < nRows; i++)
    {
    NSMutableDictionary* row = [[NSMutableDictionary alloc]initWithCapacity:nColumns];
    for(int j = 0; j < nColumns; j++)
    {
    NSString*  value = nil;
    NSString* key = [NSString stringWithUTF8String:azResult[j]];
    if (azResult[(i*nColumns)+j]==NULL)
    {
    value = [NSString stringWithUTF8String:[[NSString string] UTF8String]];
    }
    else
    {
    value = [NSString stringWithUTF8String:azResult[(i*nColumns)+j]];
    }
    
    [row setValue:value forKey:key];
    }
    [dataTable addObject:row];
    }
    querystatus = TRUE;
    sqlite3_free_table(azResult);
    }
    else
    {
    NSAssert1(0,@"Failed to execute query with message '%s'.",errorMsg);
    querystatus = FALSE;
    }
    
    return 0;
    }*/
}

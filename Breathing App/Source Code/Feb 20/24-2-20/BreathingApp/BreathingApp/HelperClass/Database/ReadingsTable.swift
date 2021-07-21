//
//  ReadingsTable.swift
//  BreathingApp
//
//  Created by Ashwin on 2/10/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit

class readingsDB
{
    var id: Int
    var session : String
    var UUID: String
    var deviceID: String
    var deviceType: String
    var readings : String
     var status : String
    
    init(id: Int, session: String?, UUID: String?, deviceID:String?, deviceType:String?,readings:String?,status:String?)
    {
        self.id = id
        self.session = ""
        self.UUID = ""
        self.deviceID = ""
        self.deviceType = ""
        self.readings = ""
        self.status = ""
    }
    
}


//
//  DeviceTable.swift
//  BreathingApp
//
//  Created by Ashwin on 2/10/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit

class devicesDB
{
    var id: Int
    var name : String
    var userID: String
    var deviceName: String
    var deviceType: String
    var UUID : String
    var isActive : String
    
    init(id: Int, name: String?, userID: String?, deviceName:String?, deviceType:String?,UUID:String?,isActive:String?)
    {
        self.id = id
        self.name = ""
        self.userID = ""
        self.deviceName = ""
        self.deviceType = ""
        self.UUID = ""
        self.isActive = ""
    }
    
}

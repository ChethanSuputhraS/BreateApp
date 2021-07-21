//
//  UserDataTable.swift
//  BreathingApp
//
//  Created by Ashwin on 2/8/20.
//  Copyright © 2020 Ashwin. All rights reserved.
//

import UIKit

class userDataDB
{
    var id: Int
    var name : String
    var email: String
    var password: String
    var isActive: String
    var serverID : String
    
    
    init(id: Int, name: String?, email: String?, password:String?, isActive:String?,serverID:String?)
    {
        self.id = id
        self.name = ""
        self.email = ""
        self.password = ""
        self.isActive = "1"
        self.serverID = "1"
    }
    
}

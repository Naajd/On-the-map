//
//  StudentInfo.swift
//  OnTheMap
//
//  Created by Najd  on 17/11/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    
    let createdAt : String?
    let firstName : String?
    let lastName : String?
    var latitude : Double?
    var longitude : Double?
    let mapString : String?
    let mediaURL : String?
    let objectId : String?
    let uniqueKey : String?
    let updatedAt : String?

static var password :String = " "
static var locationAdded = false
static var udacity = sLocations()

//static var results: [sLocations] = []
    
}

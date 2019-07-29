//
//  Client.swift
//  OnTheMap
//
//  Created by Najd  on 19/11/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
struct Client : Codable{
    var account : Account?
}
struct Account : Codable {
    var key : String?
}

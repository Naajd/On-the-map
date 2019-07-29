//
//  API.swift
//  OnTheMap
//
//  Created by Najd  on 19/11/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import UIKit

class API : Codable {
    static func login (username:String , password:String , completion: @escaping ( String,Error?)->()){
        var requestUrl = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        requestUrl.httpMethod = "POST"
        requestUrl.addValue("application/json", forHTTPHeaderField: "Accept")
        requestUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestUrl.httpBody  = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let sessionUrl = URLSession.shared
        let task = sessionUrl.dataTask(with: requestUrl) { data, response, error in
            if error != nil {
                completion("",error)
            }
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            if let statusCode = statusCode{
                if statusCode < 200  || statusCode > 300 {
                    completion("",nil)
                }
                else{
                    let range = 5..<data!.count
                    let new = data?.subdata(in: range)
                    let decoder = JSONDecoder()
                    do{
                        let students = try decoder.decode(Client.self, from: new!)
                        let studentKey = students.account?.key // as! String
                        completion(studentKey!,nil)
                    }catch let error{
                        print (error)
                    }
                }
            }
            else{
                completion("No response",nil)
            }
            
            
            
            
        }
        task.resume()
        
        
    }

    static func logOut(completion: @escaping (Error?) -> ()){
        var requestUrl = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        requestUrl.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            requestUrl.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let sessionUrl = URLSession.shared
        let task = sessionUrl.dataTask(with: requestUrl) { data, response, error in
            if error != nil {
                completion(error)
            }
             
            completion(nil)
        }
        task.resume()
    }
    
    
    
    static func getLocations (completion: @escaping (Bool, Error?) -> ()) {
        var requestUrl = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!)
        requestUrl.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        requestUrl.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let sessionUrl = URLSession.shared
        let task = sessionUrl.dataTask(with: requestUrl) { data, response, error in
            if error != nil {
                completion(false,error)
            }
           do{
                let decoder = JSONDecoder()
                let students = try decoder.decode(sLocations.self, from: data!)
                DispatchQueue.main.async {
                    StudentInformation.udacity = students
                    completion(true,error)
                }
            }catch let error {
                print (error)
            }
        }
        task.resume()
        
    }
    
         static  func postLocation(mapString : String ,mediaURL : String ,latitude : Double ,longitude: Double,completion: @escaping (Error?) -> ()){
        var requestUrl = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        requestUrl.httpMethod = "POST"
        requestUrl.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        requestUrl.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        requestUrl.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        requestUrl.httpBody = "{\"uniqueKey\": \"\(StudentInformation.password)\", \"firstName\": \"Najd\", \"lastName\": \"Aljebreen\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: .utf8)
        
        let sessionUrl = URLSession.shared
        let task = sessionUrl.dataTask(with: requestUrl) { data, response, error in
            if error != nil {
                completion(error)
                return
            }
            print(String(data: data!, encoding: .utf8)!)
            completion(nil)
        }
        task.resume()
    }
    
    
    
    
    
}


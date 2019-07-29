//
//  TableViewControler.swift
//  OnTheMap
//
//  Created by Najd  on 17/11/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import MapKit
import UIKit

 class tableViewController: UIViewController {
    @IBOutlet weak var tableVC: UITableView!
    
    var studentTable : [StudentInformation]!{
        return StudentInformation.udacity.results }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableVC.reloadData()
}
    
    @objc private func addLocation(_ sender: Any){
        let addVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! AddLocationViewController
        
        present(addVC, animated: true, completion: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        API.logOut { (error) in
                if error != nil {
                    self.Alert("Logout", "Are you sure you want to logout?")
                }
                else{
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }
    

     @IBAction  func refrehLocationTapped(_ sender: Any){
        API.getLocations { (works, error) in
        if error != nil {
            self.Alert( "Erorr", "sorry there is an error")
            return
        }
        else {
            self.tableVC.reloadData()
            self.tableVC.endUpdates()

            }
        }}


        
        
  /*  extension TableViewController  {

         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return  savedStudentInformation.results.count
        }
    
    
        
        
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(StudentInformation.results[indexPath.row].firstName ?? "") \(StudentInformation.results[indexPath.row].lastName ?? "")  \(StudentInformation.results[indexPath.row].mediaURL ?? "" )"
            
            return cell
        }
        
        
        
         func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let Url = StudentInformation.results[indexPath.row].mediaURL
            let StudentUrl = URL(string: Url )
            
            if let studentUrl = studentUrl  {
                if (Url.hasPrefix("http://")) || (Url.hasPrefix("https://")) {
                    UIApplication.shared.open(studentUrl, options: [:], completionHandler: nil)
                } else {
                    self.Alert("Error", " You must include http:// or https:// in the url ")
                }
            }
        }
        
    }*/
    }

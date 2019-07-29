//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Najd  on 17/11/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController : UIViewController {
@IBOutlet weak var location: UITextField!
@IBOutlet weak var Link: UITextField!
@IBOutlet weak var FindLocation: UIButton!
var studentInfo : StudentInformation?

    
    override func viewDidLoad() {
        super.viewDidLoad()
         
    }

    func getCoordinate(addressString: String, completion: @escaping(CLLocationCoordinate2D, NSError?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            
            if error == nil {
                
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    completion(location.coordinate, nil)
                }
            }
            else {
                completion(kCLLocationCoordinate2DInvalid, error as NSError?)
            }
        }
    }
    
    @IBAction func Cancel(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    



    @IBAction func FindLocation(_ sender: Any) {
        
        if location.text == "" {
            Alert( "","Are you sure you entered a location?")
        }
        else if Link.text == "" {
            Alert("","Are you sure you entered a link?")
        }
        else {
            let activityIndicator = showActivityIndicator()

            var studentLocation = StudentInformation(mapString: location.text!,  mediaURL: Link.text!, uniqueKey: StudentInformation.password)
            CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMark, error) in
                activityIndicator.stopAnimating()
                guard let theLocation = placeMark?.first?.location else {
                    self.Alert("can't find location ", "Please enter a real location")
                    return
                }
                
                studentLocation.latitude = theLocation.coordinate.latitude
                studentLocation.longitude = theLocation.coordinate.longitude
                
                
                let addLoc = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
                addLoc.studentInfo = studentLocation
                
                self.present(addLoc, animated: true, completion: nil)
      }
        }
        
        
        
    }
}
extension StudentInformation {
    init(mapString: String?, mediaURL: String?, uniqueKey: String?) {
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.uniqueKey = uniqueKey
        self.createdAt = nil
        self.firstName = nil
        self.lastName = nil
        self.latitude = nil
        self.longitude = nil
        self.objectId = nil
        self.updatedAt = nil
    }

/*
            if self.Link.text != "" {
getCoordinate(addressString: location.text ?? "") { (coordinate, error) in

if (self.Link.text?.hasPrefix("http://"))! || (self.Link.text?.hasPrefix("https://"))!  {
                    
savedStudentInformation.latitude = coordinate.latitude
savedStudentInformation.longitude = coordinate.longitude
savedStudentInformation.mapString = self.location.text ?? ""
savedStudentInformation.mediaURL = self.Link.text ?? ""
                    
                    
                    self.performSegue(withIdentifier: "toSubmit", sender: nil)
                    
                } else {
                    self.Alert("Error", " You must include http:// or https:// in the start of the url ")
                }
                
            }
            }
            
        }
        
    }*/
}

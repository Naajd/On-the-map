//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by Najd  on 17/11/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class NewLocationViewController: UIViewController , MKMapViewDelegate{
    var studentInfo : StudentInformation?

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var NewLocationButton: UIButton!

    
    override func viewWillAppear(_ animated: Bool) {

        var annotations = [MKPointAnnotation]()
        let lat = CLLocationDegrees(studentInfo?.latitude ?? 0)
        let long = CLLocationDegrees(studentInfo?.longitude ?? 0)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)

        let first = studentInfo?.firstName ?? ""
        let last = studentInfo?.lastName ?? ""
        let mediaURL = studentInfo?.mediaURL
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL 
        annotations.append(annotation)

       self.mapView.addAnnotation(annotation)
    }


    @IBAction func NewLocation(_ sender: Any) {
        /*
        let new = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController")
        
        if savedStudentInformation.objectId != "" {
            API.getLocations{ (success , error) in
                if success {
                    self.Alert("submited ", "")
                    self.present(new!, animated: true, completion: nil)
                } else {
                    self.Alert("Error", error?.localizedDescription ?? "")
                }
            }
        } else {*/

            API.postLocation(mapString: (studentInfo?.mapString)! , mediaURL: (studentInfo?.mediaURL)!, latitude: (studentInfo?.latitude)!, longitude: (studentInfo?.longitude)!){ (error) in
                if error != nil  {
                    self.Alert("there is a location already ", "")
                }else{
                    self.navigationController!.popToRootViewController(animated: true) }
        }
}
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin" ) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

}



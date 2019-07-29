//
//  MaoViewController.swift
//  OnTheMap
//
//  Created by Najd  on 07/10/1440 AH.
//  Copyright © 1440 Udacity. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController ,MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentsArray: [StudentInformation]! {
        return StudentInformation.udacity.results
    }
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadStudentLocations()
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle ?? nil,
                let url = URL(string: toOpen),app.canOpenURL(url){
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction  func addLocation(_ sender: Any){
        let addVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationNavigationController") as! AddLocationViewController
        
        present(addVC, animated: true, completion: nil)
    }
    
    
    @IBAction func logout(_ sender: Any) {
        API.logOut { (error) in
            if error != nil {
                self.Alert("Logout","Are you sure you want to logout?")
            }
            else{
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction  func refrehLocationTapped(_ sender: Any){
        self.mapView.removeAnnotations(self.mapView.annotations)
        
        loadStudentLocations()
    }
    
    func loadStudentLocations(){
        API.getLocations { (works, error) in
            DispatchQueue.main.async {

            if error != nil {
                self.Alert("Erorr", "Soory there was an error while prossing")
                return
            }
            guard let studentlocations = self.studentsArray else{
                self.Alert("Erorr ", "Soory there was an error while prossing")
                return
            }
            var annotations = [MKPointAnnotation]()
            for location in self.studentsArray {

            let lat = CLLocationDegrees(location.latitude ?? 0)
            let long = CLLocationDegrees(location.longitude ?? 0)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location.firstName ?? ""
            let last = location.lastName ?? ""
            let mediaURL = location.mediaURL
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
            }
            self.mapView.addAnnotations(annotations)
            }}}

    
    
}


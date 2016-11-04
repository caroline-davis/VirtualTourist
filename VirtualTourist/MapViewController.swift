//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Caroline Davis on 31/10/2016.
//  Copyright © 2016 Caroline Davis. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var stack: CoreDataStack!
    
    func handleLongPress(pressRecognizer: UIGestureRecognizer){
        if pressRecognizer.state != .began { return }
        
        let touchPoint = pressRecognizer.location(in: self.mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        
        mapView.addAnnotation(annotation)
    }
    
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(pressRecognizer:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
        
        // Get the Stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
        
        
        // We will create an MKPointAnnotation for each dictionary in "locations". The
        // point annotations will be stored in this array, and then provided to the map view.
        var annotations = [MKPointAnnotation]()
        let request: NSFetchRequest<NSFetchRequestResult> = Pin.fetchRequest()
        do {
            let locations = try stack.context.fetch(request) as? [Pin]
            for location in locations! {
                
                if location.latitude != nil || location.longitude != nil {
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(location.latitude)
                    let long = CLLocationDegrees(location.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        self.mapView.addAnnotations(annotations)
        //centerMapOnLocation(annotations.last!, regionRadius: 1000.0)
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.pinTintColor = .green
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }

    
    // This delegate method is implemented to respond to taps. It needs to segue to the collectionview controller
    
    // *** when pin is tapped it segues to collection view controller**** + load the images.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
     //       let app = UIApplication.shared
       //     if let toOpen = view.annotation?.subtitle! {
                
          //  }
        }
    }
    


    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        

}

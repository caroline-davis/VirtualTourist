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

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var stack: CoreDataStack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        // Get the Stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
        
        
        // Calls the function to place pins and sets the press duration
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(pressRecognizer:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
        
        self.loadPins()
    }
    
    func savePin(lat: Double, long: Double) {
        //Save pin to Core Data
        let pin = Pin(latitude: lat, longitude: long, context: stack.context)
        do {
            try stack.saveContext()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func loadPins() {
        //  get context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        do {
            var annotations = [MKPointAnnotation]()
            if let pins = try? stack.context.fetch(fetchRequest) as! [Pin] {
                // create annotations for pins
                for pin in pins {
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(pin.latitude)
                    let long = CLLocationDegrees(pin.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                self.mapView.addAnnotations(annotations)
                // centerMapOnLocation(annotations.last!, regionRadius: 1000.0)
            }
        }
    }
    // MARK: - MKMapViewDelegate
    
    // Create the pins
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
    
    
    // When the user presses on the map a pin comes up
    func handleLongPress(pressRecognizer: UIGestureRecognizer){
        if pressRecognizer.state != .began { return }
        
        let touchPoint = pressRecognizer.location(in: self.mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = touchMapCoordinate
        self.savePin(lat: annotation.coordinate.latitude, long: annotation.coordinate.longitude)
        mapView.addAnnotation(annotation)
    }
    
    // When pin is tapped it segues over to the collectionviewcontroller
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        Client.sharedInstance().latitude = view.annotation?.coordinate.latitude
        Client.sharedInstance().longitude = view.annotation?.coordinate.longitude
        mapView.deselectAnnotation(view.annotation, animated: true)
        performSegue(withIdentifier: "displayPhotos", sender: view)
    }
    
    
}


//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Caroline Davis on 10/11/2016.
//  Copyright © 2016 Caroline Davis. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
    
    var stack: CoreDataStack!
    var pin: Pin?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the Stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        stack = delegate.stack
        
        let lat = Client.sharedInstance().latitude!
        let long = Client.sharedInstance().longitude!
        self.checkPins(lat: lat, long: long)
        
        var region: MKCoordinateRegion = self.map.region
        
        region.center.latitude = (Client.sharedInstance().latitude)!
        region.center.longitude = (Client.sharedInstance().longitude)!
        
        region.span = MKCoordinateSpanMake(0.5, 0.5)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate.latitude = Client.sharedInstance().latitude!
        annotation.coordinate.longitude = Client.sharedInstance().longitude!

        self.map.addAnnotation(annotation)
        self.map.setRegion(region, animated: true)
    }
    
    func viewDidDisappear() {
        // remove all photos from the tableData
        self.tableData.removeAll()
        self.cachedImages.removeAll()
    }
    
    @IBOutlet weak var refreshCollection: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tableData: [AnyObject] = []
    var cachedImages = [IndexPath: UIImage]()
    var page = 1
    
    func checkPins(lat: Double, long: Double) {
        // fetch the pin for this page using
        let fetchPin = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fetchPin.predicate = NSPredicate(format: "latitude == %lf AND longitude == %lf", lat, long)
        
        if let pins = try? stack.context.fetch(fetchPin) as! [Pin] {
            // the pin will always be the first in the array
            pin = pins.first
            // get all saved pin photos
            let photos = self.getPinPhotos()
            // if we found any photos, add them to tableData
            if photos.count > 0 {
                for photo in photos {
                    self.tableData.append(photo.image! as NSData)
                }
                // reload the page with our new images
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            } else {
                // if we found no saved images, fetch new ones
                self.findPhotos()
            }
            
        }
    }

    func findPhotos() {
        // pass lat and long params
        let parameters = ["lat": Client.sharedInstance().latitude, "lon": Client.sharedInstance().longitude, "page": self.page] as [String : Any]
        Client.sharedInstance().taskForGETMethod(parameters: parameters as [String : AnyObject]) { (results, error) in
            if (results != nil) {
                print(results?.count)
                for photo in results as [[String:AnyObject]]! {
                    self.tableData.append(photo as AnyObject)
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    func savePhoto(data: NSData, pin: Pin ) {
        // save a new image
        let photo = Photo(image: data, pin: pin, context: stack.context)
        do {
            try stack.saveContext()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func deletePhoto(photo: Photo) {
        do {
            try stack.delete(obj: photo)
            try stack.saveContext()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func clear() {
        // remove all photos from the tableData
        self.tableData.removeAll()
        self.cachedImages.removeAll()
        
        // reload the view to show empty tableData
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
        // delete all saved photos for this pin
        let photos = self.getPinPhotos()
        if photos.count > 0 {
            for photo in photos {
                self.deletePhoto(photo: photo)
            }
        }
        
        // update the page we want to fetch from flickr
        self.page = self.page + 1
        
        // load new photos
        self.findPhotos()
    }
    
    func getPinPhotos() -> [Photo] {
        // search all photos whose pin matches the current one
        let fetchPhotos = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchPhotos.predicate = NSPredicate(format: "pin == %@", pin!)
        if let photos = try? stack.context.fetch(fetchPhotos) as! [Photo] {
            return photos
        }
        // return empty array if none are found
        return []
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
        // delete from array
        self.tableData.remove(at: indexPath.item)
        
        // reload the view to show empty tableData
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        
        // clear the cell and animate the indicator
        DispatchQueue.main.async {
            cell.img.image = nil
            cell.indicator.startAnimating()
        }
        
        // get the photo from tableData
        let photo = self.tableData[indexPath.item]

        // if the photo is NSData (is saved to CoreData), render immediately
        if let NSphoto = photo as? NSData {
            DispatchQueue.main.async {
                if let image = UIImage(data: NSphoto as Data) {
                    cell.img.image = image
                    cell.indicator.stopAnimating()
                }
            }
        } else {
            // if the photo is a dictionary, fetch the photo data with the url_m url
            if let item = self.cachedImages[indexPath] {
                // if image has been cached display it
                DispatchQueue.main.async {
                    cell.img.image = item
                    cell.indicator.stopAnimating()
                }
            } else {
                let url = photo["url_m"] as! String
                let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string:url)!), completionHandler: { (data, response, error) in
                    if error == nil {
                        // save photo to CoreData
                        self.savePhoto(data: data! as NSData, pin: self.pin!)
                        DispatchQueue.main.async {
                            if let image = UIImage(data: data!) {
                                // cache image to avoid downloading the image for each cell reuse
                                self.cachedImages[indexPath] = image
                                // display image and stop loader
                                cell.img.image = image
                                cell.indicator.stopAnimating()
                            }
                        }
                    }
                })
                task.resume()
            }
            }
        return cell
     
    }
    
    @IBAction func reloadCells() {
        clear()
    }
    
    
    
}

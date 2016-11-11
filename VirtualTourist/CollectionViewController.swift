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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.findPhotos()
        
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
    
    @IBOutlet weak var refreshCollection: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tableData: [[String:AnyObject]] = []
    var page = 1
    
    func findPhotos() {
        let parameters = ["lat": Client.sharedInstance().latitude, "lon": Client.sharedInstance().longitude, "page": self.page] as [String : Any]
        Client.sharedInstance().taskForGETMethod(parameters: parameters as [String : AnyObject]) { (results, error) in
            if (results != nil) {
                for photo in results as [[String:AnyObject]]! {
                    self.tableData.append(photo)
                }
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    func clear() {
        self.tableData.removeAll()
        self.page = self.page + 1
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(findPhotos), userInfo: nil, repeats: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        DispatchQueue.main.async {
            cell.img.image = nil
            cell.indicator.startAnimating()
        }
        let photo = self.tableData[indexPath.item]
        let url = photo["url_m"] as! String
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string:url)!), completionHandler: { (data, response, error) in
            // print(data, error)
            if error == nil {
                DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        cell.img.image = image
                        cell.indicator.stopAnimating()
                    }
                }
            }
        })
        task.resume()
        return cell
     
    }
    
    @IBAction func reloadCells() {
        clear()
    }
    
    
    
}

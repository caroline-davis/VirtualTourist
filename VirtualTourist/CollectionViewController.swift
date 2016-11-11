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
    }
    
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var tableData: [[String:AnyObject]] = []
    var tableImages: [String] = ["evox.jpg","458.jpg","gtr.jpg"]
    
    func findPhotos() {
        let parameters = ["lat": Client.sharedInstance().latitude, "lon": Client.sharedInstance().longitude]
        Client.sharedInstance().taskForGETMethod(parameters: parameters as [String:AnyObject]) { (results, error) in
            print(results, error)
            if (results != nil) {
                for photo in results as! [[String:AnyObject]]! {
                    print(photo)
                    self.tableData.append(photo)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.indicator.startAnimating()
        let photo = self.tableData[indexPath.item]
        let url = photo["url_m"] as! String
        let task = URLSession.shared.dataTask(with: URLRequest(url: URL(string:url)!), completionHandler: { (data, response, error) in
            print(data, error)
            if error == nil {
                DispatchQueue.main.async {
                    cell.indicator.stopAnimating()
                    if let image = UIImage(data: data!) {
                        cell.img.image = image
                    }
                }
            }
        })
        task.resume()
        return cell
     
    }
}

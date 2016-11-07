//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Caroline Davis on 2/11/2016.
//  Copyright © 2016 Caroline Davis. All rights reserved.
//


import UIKit
import MapKit
import CoreData


class CollectionViewController: CoreDataCollectionViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NOT SURE WHERE TO PUT THIS METHOD YET... possibly in here, but cannot access [0] or index path because i havent done the api calls yet??
      /*  // Create Fetch Request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        
        fr.sortDescriptors = [NSSortDescriptor(key: "image", ascending: true)]
        
        // So far we have a search that will match ALL notes. However, we're
        // only interested in those within the current notebook:
        // NSPredicate to the rescue!
        let indexPaths = collectionView?.indexPathsForSelectedItems
        let indexPath = indexPaths?[0]
        let photo = fetchedResultsController?.object(at: indexPath! as IndexPath)
        
        let pred = NSPredicate(format: "photo = %@", argumentArray: [photo!])
        
        fr.predicate = pred
        
        // Create FetchedResultsController
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext:fetchedResultsController!.managedObjectContext, sectionNameKeyPath: "humanReadableImage", cacheName: nil)
        
        // Inject it into the notesVC
        self.fetchedResultsController = fc
        
        
       */ // END OF RANDOM METHOD
        
        
        
        // Get the Stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create the fetch request
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fr.sortDescriptors = [NSSortDescriptor(key: "image", ascending: true)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
               
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Find the photo
        let photo = fetchedResultsController!.object(at: indexPath as IndexPath) as! Photo
        
        // Create the Cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        
        // Sync photo to cell
       // cell from flickr api? or something.
        
        return cell
    }
    
    // shows the mapview inside the header of the collectionView + remember to use tag 100 to refer to it
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "headerId", for: indexPath as IndexPath)
        return headerView
    }
 
   
    
}

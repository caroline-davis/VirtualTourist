//
//  CoreDataTableViewController.swift
//  VirtualTourist
//
//  Created by Caroline Davis on 2/11/2016.
//  Copyright © 2016 Caroline Davis. All rights reserved.
//

import UIKit
import CoreData

class CoreDataCollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
            collectionView?.reloadData()
        }
    }
    
}

// MARK: - CoreDataTableViewController (For Subclasses)

extension CoreDataCollectionViewController {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        fatalError("This method MUST be implemented by a subclass of CoreDataTableViewController")
    }
}

extension CoreDataCollectionViewController {
    
     func numberOfSectionsInTableView(collectionView: UICollectionView) -> Int {
        if let fc = fetchedResultsController {
            return (fc.sections?.count)!
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let fc = fetchedResultsController {
            return fc.sections![section].numberOfObjects
        } else {
            return 0
        }
    }
}

// MARK: - CoreDataTableViewController (Fetches)

extension CoreDataCollectionViewController {
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
    
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier! == "displayPhotos" {
            
            if let photoVC = segue.destination as? CollectionViewController {
                
                // Create Fetch Request
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
                photoVC.fetchedResultsController = fc
            }
        }
    }

}

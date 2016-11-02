//
//  CoreDataTableViewController.swift
//  VirtualTourist
//
//  Created by Caroline Davis on 2/11/2016.
//  Copyright © 2016 Caroline Davis. All rights reserved.
//

import UIKit
import CoreData

class CoreDataCollectionViewController: UICollectionViewController {
    
    var fetchedResultsController : NSFetchedResultsController? {
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
}

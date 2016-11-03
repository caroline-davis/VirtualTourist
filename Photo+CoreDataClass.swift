//
//  Photo+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Caroline Davis on 31/10/2016.
//  Copyright © 2016 Caroline Davis. All rights reserved.
//

import Foundation
import CoreData
import UIKit


public class Photo: NSManagedObject {
    
    // MARK: Initializer
    convenience init(image: NSData, context: NSManagedObjectContext){
        
        // An EntityDescription is an object that has access to all
        // the information you provided in the Entity part of the model
        // you need it to create an instance of this class.
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.image = image
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    // MARK: Computed Property
    
    var humanReadableImage: AnyObject? {
        get {
           let swiftImage : UIImage = UIImage(data: image as! Data)!
            return swiftImage
        }
    }


}

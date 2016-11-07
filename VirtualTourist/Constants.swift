//
//  Constants.swift
//  VirtualTourist
//
//  Created by Caroline Davis on 7/11/2016.
//  Copyright © 2016 Caroline Davis. All rights reserved.
//

import UIKit

struct Constants {
    
    struct Flickr {
        static let ApiScheme = "https"
        static let ApiHost = "api.flickr.com"
        static let ApiPath = "/services/rest"
        
        static let SearchBBoxHalfWdith = 1.0
        static let SearchBBoxHalfHeight = 1.0
        static let SearchLat = (-90.0, 90.0)
        static let SearchLong = (-180.0, 180.0)
    }
    
    struct FlickrParameterKeys {
        static let APIKey = "api_key"
        static let MethodName = "method"
        static let Extras = "extras"
        static let Format = "format"
        static let NoJSONCallback = "nojsoncallback"
        static let SafeSearch = "safe_search"
        static let Page = "page"
        static let BBox = "bbox"
        
    }
    
    struct FlickrParameterValues {
        static let APIKey = "f01e81b08dfb4b36009fdc28820497c3"
        static let SearchPhotos = "flickr.photos.search"
        static let MediumURL = "url_m"
        static let ResponseFormat = "json"
        static let DisableJSONCallback = "1"
        static let SafeSearch = "1"
    }
    
    struct FlickrResponseKeys {
        static let Status = "stat"
        static let Photos = "photos"
        static let Photo = "photo"
        static let MediumURL = "url_m"
        static let Pages = "pages"
        static let Total = "total"
    }
    
    struct FlickrResponseValues {
        static let OKStatus = "ok"
    }
    
 }

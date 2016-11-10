//
//  CollectionViewController.swift
//  VirtualTourist
//
//  Created by Caroline Davis on 10/11/2016.
//  Copyright © 2016 Caroline Davis. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tableData: [String] = ["eve", "458", "GTR"]
    var tableImages: [String] = ["evox.jpg","458.jpg","gtr.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.label.text = tableData[indexPath.row]
        cell.img.image = UIImage(named: tableImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell \(indexPath.row) selected")
    }
}

//
//  SitePhotosCollectionViewCell.swift
//  Appa
//
//  Created by Drew Cappel on 4/26/19.
//  Copyright © 2019 Drew Cappel. All rights reserved.
//

import UIKit

class SitePhotosCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            photoImageView.image = photo.image
        }
    }
}

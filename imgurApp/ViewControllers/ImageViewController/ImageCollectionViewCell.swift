//
//  ImageCollectionViewCell.swift
//  imgurApp
//
//  Created by Максим Лисица on 05/10/2019.
//  Copyright © 2019 Максим Лисица. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: ImageCollectionViewCellDelegate?
    
    @IBOutlet weak var imageViewPicture: UIImageView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapPhoto))
            self.imageViewPicture.addGestureRecognizer(tap)
            self.imageViewPicture.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var titlePictureLabel: UILabel!
    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    
    var indexPath: IndexPath?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.imageViewPicture.image = nil
        self.imageActivityIndicator.startAnimating()
    }
    
    @objc func tapPhoto() {
        delegate?.didPressPicture(indexPathCurrentItem: indexPath ?? IndexPath(row: 0, section: 0))
    } 
}

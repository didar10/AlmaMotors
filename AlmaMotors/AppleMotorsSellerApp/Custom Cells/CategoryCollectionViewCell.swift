//
//  CategoryCollectionViewCell.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/12/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
        
     
        @IBOutlet weak var nameLabel: UILabel!
        
        func generateCell(_ category: Category) {
            
            nameLabel.text = category.name
            imageView.image = category.image
        }
        
        override func layoutSubviews() {
            // cell rounded section
            self.layer.cornerRadius = 15.0
            self.layer.borderWidth = 5.0
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.masksToBounds = true
            
    //        // cell shadow section
    //        self.contentView.layer.cornerRadius = 15.0
    //        self.contentView.layer.borderWidth = 5.0
    //        self.contentView.layer.borderColor = UIColor.clear.cgColor
    //        self.contentView.layer.masksToBounds = true
    //        self.layer.shadowColor = UIColor.black.cgColor
    //        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
    //        self.layer.shadowRadius = 2.0
    //        self.layer.shadowOpacity = 0.6
    //        self.layer.cornerRadius = 8.0
    //        self.layer.masksToBounds = false
    //        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        }
        
    }

//
//  ItemTableViewCell.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/12/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
        
        @IBOutlet weak var priceTxt: UILabel!
        
        @IBOutlet weak var nameTxt: UILabel!
        
        @IBOutlet weak var modelTxt: UILabel!
        
        @IBOutlet weak var statusTxt: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
        }
        
        func generateCell(_ item: Item) {
            
            priceTxt.text = item.price
            nameTxt.text = item.name
            modelTxt.text = item.carModel
            statusTxt.text = item.status
            
            if item.imageLinks != nil && item.imageLinks.count > 0 {
                
                downloadImages(imageUrls: [item.imageLinks.first!]) { (images) in
                    self.itemImageView.image = images.first as? UIImage
                }
            }
        }


    }

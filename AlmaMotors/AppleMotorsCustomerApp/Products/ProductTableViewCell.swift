//
//  ProductTableViewCell.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 6/2/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var priceTxt: UILabel!
    
    @IBOutlet weak var nameTxt: UILabel!
    
    @IBOutlet weak var modelTxt: UILabel!
    
    @IBOutlet weak var statusTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

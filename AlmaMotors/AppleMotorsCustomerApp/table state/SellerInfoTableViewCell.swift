////
////  SellerInfoTableViewCell.swift
////  AppleMotorsCustomerApp
////
////  Created by Didar Bakhitzhanov on 5/12/20.
////  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
////
//
//import UIKit
//
//class SellerInfoTableViewCell: UITableViewCell {
//
//    @IBOutlet weak var emailTxt: UILabel!
//    @IBOutlet weak var nameTxt: UILabel!
//    @IBOutlet weak var addressTxt: UILabel!
//    @IBOutlet weak var phoneTxt: UILabel!
//    @IBOutlet weak var storeNameTxt: UILabel!
//    @IBOutlet weak var latitudeTxt: UILabel!
//    @IBOutlet weak var longitudeTxt: UILabel!
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//
//    func generateCell(_ seller: Seller) {
//
//        emailTxt.text = seller.email
//        nameTxt.text = seller.sellerName
//        addressTxt.text = seller.address
//        storeNameTxt.text = seller.storeName
//        latitudeTxt.text = "\(seller.latitude)"
//        longitudeTxt.text = "\(seller.longitude)"
//
//    }
//
//}

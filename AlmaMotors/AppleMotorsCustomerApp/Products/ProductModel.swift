//
//  ItemModel.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 6/2/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation

typealias products = [Product]

struct Product: Codable {
    
    var id: String!
//    var ownerId: String!
//    var categoryId: String!
    var partName: String!
    var categoryName: String!
    var storeNamee: String!
    var storeAddress: String!
    var price: String!
    var description: String!
    var carBrand: String!
    var model: String!
    var carGeneration: String!
    var availability: String!
    var status: String!
    var image: String!
    
    
}

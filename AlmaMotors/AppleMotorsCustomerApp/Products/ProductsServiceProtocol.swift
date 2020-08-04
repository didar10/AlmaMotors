//
//  ProductsServiceProtocol.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 6/2/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import UIKit

protocol ProductsServiceProtocol {
    
    func getTires(success: @escaping(_ tires: products) -> Void, failure: @escaping(_ alert: String) -> Void)
}

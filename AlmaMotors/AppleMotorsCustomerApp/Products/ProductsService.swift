//
//  ProductsService.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 6/2/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import CodableFirebase
import FirebaseFirestore
import FirebaseStorage

class ProductsService: ProductsServiceProtocol {
    func getTires(success: @escaping (products) -> Void, failure: @escaping (String) -> Void) {
        Fire.shared.database.collection("Items").addSnapshotListener { (query, error) in
            if let err = error{
                failure(err.localizedDescription)
            } else{
                var alltires = products()
                if let tire = query?.documents{
                    if tire.isEmpty {
                        debugPrint("EMPTY BOOK")
                    } else {
                        for data in tire {
                            let mytire = try! FirebaseDecoder().decode(Product.self, from: data.data())
                            alltires.append(mytire)
                        }
                    }
                }
                success(alltires)
            }
        }
    }
}

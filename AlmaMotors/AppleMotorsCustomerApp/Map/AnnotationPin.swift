//
//  AnnotationPin.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/27/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Mapbox

class AnnotationPin: MGLPointAnnotation {
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    var seller: Seller!
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
    init(_ coordinate: CLLocationCoordinate2D, _ seller: Seller) {
        super.init()
        self.seller = seller
        self.coordinate = coordinate
        self.title = seller.storeName
        self.subtitle = seller.address
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //
    
}

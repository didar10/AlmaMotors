//
//  ScrollToSelectedUserProtocol + Extension.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/27/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import Mapbox

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //

protocol ScrollToSelectedUser {
    func zoomToSelectedFriend(seller: Seller)
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------- //

extension MapsVC: ScrollToSelectedUser {

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //

    func zoomToSelectedFriend(seller: Seller) {
        selectedSeller = seller
        isSellerSelected = true
    }

    // ---------------------------------------------------------------------------------------------------------------------------------------------------- //

}


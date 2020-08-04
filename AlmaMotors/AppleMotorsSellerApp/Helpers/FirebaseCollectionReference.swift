//
//  FirebaseCollectionReference.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/7/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case Seller
    case Category
    case Items
    case Favourites
    case Customer
}

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    
    return Firestore.firestore().collection(collectionReference.rawValue)
}

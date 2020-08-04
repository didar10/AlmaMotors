//
//  Fire.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 6/2/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Fire{
    
    static var shared = Fire()
    
    let database = Firestore.firestore()
    
}


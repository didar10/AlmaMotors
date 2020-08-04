//
//  AlgoliaService.swift
//  Apple Motors Car Parts
//
//  Created by Didar Bakhitzhanov on 5/31/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import InstantSearchClient

class AlgoliaService {
    
    static let shared = AlgoliaService()
    
    let client = Client(appID: kALGOLIA_APP_ID, apiKey: kALGOLIA_ADMIN_KEY)
    let index = Client(appID: kALGOLIA_APP_ID, apiKey: kALGOLIA_ADMIN_KEY).index(withName: "item_Name")
    
    private init() {}
}


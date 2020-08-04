//
//  Favourites.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 6/1/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation


class Favourites {
    
    var id: String!
    var addedBy: String!
    var itemIds: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        addedBy = _dictionary[kADDEDBY] as? String
        itemIds = _dictionary[kITEMIDS] as? [String]
    }
}


//MARK: - Download items
func downloadFavouritesFromFirestore(_ addedBy: String, completion: @escaping (_ favourites: Favourites?)-> Void) {
    
    FirebaseReference(.Favourites).whereField(kADDEDBY, isEqualTo: addedBy).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let favourites = Favourites(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(favourites)
        } else {
            completion(nil)
        }
    }
}


//MARK: - Save to Firebase
func saveFavouritesToFirestore(_ favourites: Favourites) {
    
    FirebaseReference(.Favourites).document(favourites.id).setData(favouritesDictionaryFrom(favourites) as! [String: Any])
}


//MARK: Helper functions

func favouritesDictionaryFrom(_ favourites: Favourites) -> NSDictionary {
    
    return NSDictionary(objects: [favourites.id, favourites.addedBy, favourites.itemIds], forKeys: [kOBJECTID as NSCopying, kADDEDBY as NSCopying, kITEMIDS as NSCopying])
}

//MARK: - Update favourites
func updateFavouritesInFirestore(_ favourites: Favourites, withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    FirebaseReference(.Favourites).document(favourites.id).updateData(withValues) { (error) in
        completion(error)
    }
}







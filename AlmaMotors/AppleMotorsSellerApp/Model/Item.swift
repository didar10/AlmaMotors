//
//  Item.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/12/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchClient

class Item {
    
    var id: String!
    var ownerId: String!
    var categoryId: String!
    var name: String!
    var categoryName: String!
    var storeNamee: String!
    var storeAddress: String!
    var price: String!
    var description: String!
    var carBrand: String!
    var carModel: String!
    var carGeneration: String!
    var availability: String!
    var status: String!
    var imageLinks: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        
        id = _dictionary[kOBJECTID] as? String
        ownerId = _dictionary[kOWNERID] as? String
        categoryId = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kPARTNAME] as? String
        categoryName = _dictionary[kCATEGORYNAME] as? String
        storeNamee = _dictionary[kSTORENAMEE] as? String
        storeAddress = _dictionary[kSTOREADDRESS] as? String
        price = _dictionary[kPRICE] as? String
        description = _dictionary[kDESCRIPTION] as? String
        carBrand = _dictionary[kBRAND] as? String
        carModel = _dictionary[kMODEL] as? String
        carGeneration = _dictionary[kGENERATION] as? String
        availability = _dictionary[kAVAILABILITY] as? String
        status = _dictionary[kSTATUS] as? String
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
    }
}

//MARK: - Save items function

func saveItemToFirestore(_ item: Item) {
    
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String : Any])
}

//MARK: - Helper function
func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id,item.ownerId,item.categoryId, item.name,item.categoryName,item.storeNamee,item.storeAddress,item.price, item.description,item.carBrand, item.carModel, item.carGeneration,item.availability,item.status, item.imageLinks], forKeys: [kOBJECTID as NSCopying,kOWNERID as NSCopying, kCATEGORYID as NSCopying, kPARTNAME as NSCopying,kCATEGORYNAME as NSCopying, kSTORENAMEE as NSCopying, kSTOREADDRESS as NSCopying , kPRICE as NSCopying, kDESCRIPTION as NSCopying, kBRAND as NSCopying,kMODEL as NSCopying,kGENERATION as NSCopying,kAVAILABILITY as NSCopying, kSTATUS as NSCopying, kIMAGELINKS as NSCopying])
}

//MARK: Download Func
func downloadItemsFromFirebase(_ ownerId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var itemArray: [Item] = []
    
    FirebaseReference(.Items).whereField(kOWNERID, isEqualTo: ownerId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {

            for itemDict in snapshot.documents {

                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            }
        }

        completion(itemArray)
//        if !snapshot.isEmpty && snapshot.documents.count > 0 {
//            let item = Item(_dictionary: snapshot.documents.first!.data() as NSDictionary)
//            completion([item])
//        } else {
//            completion(itemArray)
//        }

    }
    
}

func downloadItems(_ withIds: [String], completion: @escaping (_ itemArray: [Item]) ->Void) {
    
    var count = 0
    var itemArray: [Item] = []
    
    if withIds.count > 0 {
        
        for itemId in withIds {

            FirebaseReference(.Items).document(itemId).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(itemArray)
                    return
                }

                if snapshot.exists {

                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                }
                
                if count == withIds.count {
                    completion(itemArray)
                }
                
            }
        }
    } else {
        completion(itemArray)
    }
}

//MARK: - Algolia Funcs

func saveItemToAlgolia(item: Item) {
    
    let index = AlgoliaService.shared.index
    
    let itemToSave = itemDictionaryFrom(item) as! [String : Any]
    
    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in
        
        
        if error != nil {
            print("error saving to algolia", error!.localizedDescription)
        } else {
            print("added to algolia")
        }
    }
}

func searchAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void) {

    let index = AlgoliaService.shared.index
    var resultIds: [String] = []
    
    let query = Query(query: searchString)
    
    query.attributesToRetrieve = ["name", "description", "carBrand", "carModel", "categoryName"]
    
    index.search(query) { (content, error) in
        
        if error == nil {
            let cont = content!["hits"] as! [[String : Any]]
            
            resultIds = []
            
            for result in cont {
                resultIds.append(result["objectID"] as! String)
            }
            
            completion(resultIds)
        } else {
            print("Error algolia search ", error!.localizedDescription)
            completion(resultIds)
        }
    }
}




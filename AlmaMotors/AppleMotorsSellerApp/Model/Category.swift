//
//  Category.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/12/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import UIKit

class Category {
    
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?
    
    init(_name: String, _imageName: String) {
        
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
}

//MARK: Download category from firebase

func downloadCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void) {
    
    var categoryArray: [Category] = []
    
    FirebaseReference(.Category).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for categoryDict in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
            }
        }
        
        completion(categoryArray)
    }
}

//MARK: Save category function

func saveCategoryToFirebase(_ category: Category) {
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category) as! [String : Any])
}

//MARK: Helpers

func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id, category.name, category.imageName], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
}

//use only one time
func createCategorySet() {

    let tire1 = Category(_name: "Шины", _imageName: "tires")
    let tire2 = Category(_name: "Двигатели", _imageName: "engines")
    let tire3 = Category(_name: "Ходовка", _imageName: "hodovka")
    let tire4 = Category(_name: "Интерьер" , _imageName: "interior")
    let tire5 = Category(_name: "Диски", _imageName: "disks")
    let tire6 = Category(_name: "Экстерьер", _imageName: "exterior")
    let tire7 = Category(_name: "Жидкости", _imageName: "liquids")
    let tire8 = Category(_name: "Мотоциклы", _imageName: "moto")

    let arrayOfCategories = [tire1, tire2, tire3, tire4, tire5, tire6, tire7, tire8]

    for category in arrayOfCategories {
        saveCategoryToFirebase(category)
    }

}

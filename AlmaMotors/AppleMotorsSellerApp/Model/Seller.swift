//
//  User.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/7/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import FirebaseAuth

class Seller {
    
    let sellerId: String?
    var email: String?
    var sellerName: String?
    var address: String?
    var telephone: String?
    var storeName: String?
    var latitude: Double?
    var longitude: Double?
    
    
    //MARK: - Initializers
    
    init(_userId: String, _email: String, _sellerName: String, _address: String, _telephone: String, _storeName: String, _latitude: Double, _longitude: Double) {
        
        sellerId = _userId
        email = _email
        sellerName = _sellerName
        address = _address
        telephone = _telephone
        storeName = _storeName
        latitude = _latitude
        longitude = _longitude
    }

    init(_dictionary: NSDictionary) {
        
        sellerId = _dictionary[kUSERID] as? String
        
        if let mail = _dictionary[kEMAIL] {
            email = mail as? String
        } else {
            email = ""
        }
        
        if let selname = _dictionary[kSELLERNAME] {
            sellerName = selname as? String
        } else {
            sellerName = ""
        }
        
        if let storeAddress = _dictionary[kADDRESS] {
           address = storeAddress as? String
        } else {
           address = ""
        }
        
        if let telNumber = _dictionary[kPHONE] {
           telephone = telNumber as? String
        } else {
           telephone = ""
        }
        
        if let partsStoreName = _dictionary[kSTORENAME] {
           storeName = partsStoreName as? String
        } else {
           storeName = ""
        }
        if let storeLatitude = _dictionary[kLATITUDE] {
            latitude = storeLatitude as? Double
        } else {
            latitude = 0.0
        }
        if let storeLongitude = _dictionary[kLONGITUDE] {
            longitude = storeLongitude as? Double
        } else {
            longitude = 0.0
        }
        
    }
    
    
    //MARK: - Return current user
    
    class func currentId() -> String {
    
        return Auth.auth().currentUser!.uid
    }
    
//    class func currentId() -> String {
//        return Auth.auth().currentUser!.phoneNumber!
//    }
    
    class func currentUser() -> Seller? {
        
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return Seller.init(_dictionary: dictionary as! NSDictionary)
            }
       
        return nil
    }
    
    //MARK: - Login func
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                
                if authDataResult!.user.isEmailVerified {
                    downloadUser(userId: authDataResult!.user.uid, email: email)
                    print("Saved locally")
                    completion(error, true)
                } else {
                    
                    print("email is not varified")
                    completion(error, false)
                }
                
            } else {
                completion(error, false)
            }
        }
    }

    
    //MARK: - Register user
    
    class func registerUserWith(email: String, password: String,sellerName: String, address: String, telephone: String, storeName: String, latitude: Double, longitude: Double , completion: @escaping (_ error: Error?) ->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                
                //send email verification
                authDataResult!.user.sendEmailVerification { (error) in
                    print("auth email verification error : ", error?.localizedDescription)
                }
                
                saveUserToDatabase(userId: authDataResult!.user.uid, email: email, sellerName: sellerName, address: address, telephone: telephone, storeName: storeName, latitude: latitude, longitude: longitude )
                
            }
        }
    }

    
    //MARK: - Resend link methods

    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print(" resend email error: ", error?.localizedDescription)
                
                completion(error)
            })
        })
    }
    
    class func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.set(false, forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)

        } catch let error as NSError {
            completion(error)
        }
        
        
    }

}//end of class

//MARK: - DownloadUser

func downloadSellerFromFirebase(completion: @escaping (_ sellerArray: [Seller]) -> Void) {
    
    var sellerArray: [Seller] = []
    
    FirebaseReference(.Seller).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(sellerArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for sellerDict in snapshot.documents {
                sellerArray.append(Seller(_dictionary: sellerDict.data() as NSDictionary))
            }
        }
        
        completion(sellerArray)
    }
}

func saveUserToDatabase(userId: String, email: String, sellerName: String, address: String, telephone: String, storeName: String, latitude: Double, longitude: Double) {
            //there is no user, save new in firestore
            let user = Seller(_userId: userId, _email: email, _sellerName: sellerName, _address: address, _telephone: telephone, _storeName: storeName, _latitude: latitude, _longitude: longitude)
            saveUserLocally(mUserDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(Seller: user)
            
        
    }
    



func downloadUser(userId: String, email: String) {
    
    FirebaseReference(.Seller).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        
        if snapshot.exists {
            print("download current user from firestore")
        }
    }
    
}





//MARK: - Save user to firebase

func saveUserToFirestore(Seller: Seller) {
    
    FirebaseReference(.Seller).document(Seller.sellerId!).setData(userDictionaryFrom(user: Seller) as! [String : Any]) { (error) in
        
        if error != nil {
            print("error saving user \(error!.localizedDescription)")
        }
    }
}


func saveUserLocally(mUserDictionary: NSDictionary) {
    
    UserDefaults.standard.set(mUserDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}


//MARK: - Helper Function

func userDictionaryFrom(user: Seller) -> NSDictionary {
    
    return NSDictionary(objects: [user.sellerId, user.email, user.sellerName,  user.address, user.telephone, user.storeName, user.latitude, user.longitude], forKeys: [kUSERID as NSCopying, kEMAIL as NSCopying, kSELLERNAME as NSCopying, kADDRESS as NSCopying, kPHONE as NSCopying, kSTORENAME as NSCopying, kLATITUDE as NSCopying, kLONGITUDE as NSCopying])
}





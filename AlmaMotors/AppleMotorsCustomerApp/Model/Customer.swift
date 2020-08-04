//
//  Customer.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/31/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import FirebaseAuth

class Customer {
    
    let customerId: String?
    var email: String?
    var customerName: String?
    var customerLastName: String?
    var onBoard: Bool
    
    
    //MARK: - Initializers
    
    init(_customerId: String, _email: String, _customerName: String, _customerLastName: String) {
        
        customerId = _customerId
        email = _email
        customerName = _customerName
        customerLastName = _customerLastName
        onBoard = false
    }

    init(_dictionary: NSDictionary) {
        
        customerId = _dictionary[kUSERID] as? String
        
        if let mail = _dictionary[kEMAIL] {
            email = mail as? String
        } else {
            email = ""
        }
        
        if let cusname = _dictionary[kCUSTOMERNAME] {
            customerName = cusname as? String
        } else {
            customerName = ""
        }
        
        if let cusLastName = _dictionary[kCUSTOMERLASTNAME] {
                   customerLastName = cusLastName as? String
        } else {
                   customerLastName = ""
        }
        
        if let onB = _dictionary[kONBOARD] {
          onBoard = onB as! Bool
        } else {
          onBoard = false
        }
        
    }
    
    
    //MARK: - Return current user
    
    class func currentId() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> Customer? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return Customer.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        
        return nil
    }
    
    //MARK: - Login func
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                
                if authDataResult!.user.isEmailVerified {
                    downloadCustomerFromFirestore(customerId: authDataResult!.user.uid, email: email)
                    completion(error, true)
                } else {
                    
                    print("email is not verified")
                    completion(error, false)
                }
                
            } else {
                completion(error, false)
            }
        }
    }

    
    //MARK: - Register user
    
    class func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) ->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                
                //send email verification
                authDataResult!.user.sendEmailVerification { (error) in
                    print("auth email verification error : ", error?.localizedDescription)
                }
                
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
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)

        } catch let error as NSError {
            completion(error)
        }
        
        
    }

}//end of class

//MARK: - DownloadUser
func downloadCustomerFromFirestore(customerId: String, email: String) {
    
    FirebaseReference(.Customer).document(customerId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        
        if snapshot.exists {
            print("download current user from firestore")
            saveUserLocally(mUserDictionary: snapshot.data()! as NSDictionary)
        } else {
            let user = Customer(_customerId: customerId, _email: email, _customerName: "", _customerLastName: "")
            saveCustomerLocally(mUserDictionary: customerDictionaryFrom(customer: user))
            saveCustomerToFirestore(Customer: user)
        }
    }
    

}
//MARK: - Save user to firebase

func saveCustomerToFirestore(Customer: Customer) {
    
    FirebaseReference(.Customer).document(Customer.customerId!).setData(customerDictionaryFrom(customer: Customer) as! [String : Any]) { (error) in
        
        if error != nil {
            print("error saving user \(error!.localizedDescription)")
        }
    }
}


func saveCustomerLocally(mUserDictionary: NSDictionary) {
    
    UserDefaults.standard.set(mUserDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}


//MARK: - Helper Function

func customerDictionaryFrom(customer: Customer) -> NSDictionary {
    
    return NSDictionary(objects: [customer.customerId, customer.email, customer.customerName, customer.customerLastName], forKeys: [kUSERID as NSCopying, kEMAIL as NSCopying, kCUSTOMERNAME as NSCopying, kCUSTOMERLASTNAME as NSCopying])
}

func updateCurrentCustomerInFirestore(withValues: [String : Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
        
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        FirebaseReference(.Customer).document(Customer.currentId()).updateData(withValues) { (error) in
            
            completion(error)
            
            if error == nil {
                saveUserLocally(mUserDictionary: userObject)
            }
        }
    }
}




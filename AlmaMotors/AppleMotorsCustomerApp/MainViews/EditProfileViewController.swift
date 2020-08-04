//
//  EditProfileViewController.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/31/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    
    //MARK: - Vars
    let hud = JGProgressHUD(style: .dark)

    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserInfo()
    }
    
    
    //MARK: - IBActions
    
    @IBAction func saveBarButtonPressed(_ sender: Any) {
        
        dismissKeyboard()
        
        if textFieldsHaveText() {
            
            let withValues = [kCUSTOMERNAME : nameTextField.text!, kCUSTOMERLASTNAME : surnameTextField.text!]
            
            updateCurrentCustomerInFirestore(withValues: withValues) { (error) in
                
                if error == nil {
                    self.hud.textLabel.text = "Обновлено!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                    
                } else {
                    print("erro updating user ", error!.localizedDescription)
                   self.hud.textLabel.text = error!.localizedDescription
                   self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                   self.hud.show(in: self.view)
                   self.hud.dismiss(afterDelay: 2.0)
                }
            }
            
        } else {
            hud.textLabel.text = "All fields are required!"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
            
        }
    }
    
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        logOutUser()
    }
    
    
    //MARK: - UpdateUI
    
    private func loadUserInfo() {
        
        if Customer.currentUser() != nil {
            let currentUser = Customer.currentUser()!
            
            nameTextField.text = currentUser.customerName
            surnameTextField.text = currentUser.customerLastName
        }
    }

    //MARK: - Helper funcs
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }

    private func textFieldsHaveText() -> Bool {
        
        return (nameTextField.text != "" && surnameTextField.text != "")
    }
    
    private func logOutUser() {
        Customer.logOutCurrentUser { (error) in
            
            if error == nil {
                print("logged out")
                self.navigationController?.popViewController(animated: true)
            }  else {
                print("error login out ", error!.localizedDescription)
            }
        }
        
    }
    
}

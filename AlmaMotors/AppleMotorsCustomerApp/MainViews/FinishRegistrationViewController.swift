//
//  FinishRegistrationViewController.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/31/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import JGProgressHUD


class FinishRegistrationViewController: UIViewController {

    //MARK: - IBOutlets
    

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    //MARK: - Vars
    let hud = JGProgressHUD(style: .dark)

    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        
        nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        surnameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    
    //MARK: - IBActions
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        finishOnboarding()
    }
    
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        updateDoneButtonStatus()
    }

    
    //MARK: - Helper
    private func updateDoneButtonStatus() {
        
        if nameTextField.text != "" && surnameTextField.text != "" {
            
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.4391592741, green: 0.5353201628, blue: 0.9573212266, alpha: 1)
            doneButtonOutlet.isEnabled = true
        } else {
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
            doneButtonOutlet.isEnabled = false

        }
        
    }
    
    private func finishOnboarding() {
        
        let withValues = [kCUSTOMERNAME : nameTextField.text!, kCUSTOMERLASTNAME : surnameTextField.text!, kONBOARD : true] as [String : Any]
        
        
        updateCurrentCustomerInFirestore(withValues: withValues) { (error) in
            
            if error == nil {
                self.hud.textLabel.text = "Обновлено!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)

                self.dismiss(animated: true, completion: nil)
            } else {
                
                print("error updating user \(error!.localizedDescription)")
                
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }

}

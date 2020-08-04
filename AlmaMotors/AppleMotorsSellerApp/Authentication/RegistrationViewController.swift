//
//  RegistrationViewController.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/8/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class RegistrationViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var phoneTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var storeNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var coordinatesLabel: UILabel!
    
    //MARK: - Vars
    
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    //MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoard()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           setNeedsStatusBarAppearanceUpdate()
       }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1.0), padding: nil)
    }
    
    //MARK: - IBActions
    

    
    @IBAction func registerButtonPressed(_ sender: Any) {
    
        print("register")
               
        if textFieldsHaveText() {
            registerUser()
        } else {
            hud.textLabel.text = "All fields are required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
        
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        self.coordinatesLabel.text = "\(latitude) and \(longitude)"
    }
    //MARK: - Register User
    
    private func registerUser() {
        
        showLoadingIndicator()
        let defaults = UserDefaults.standard
        
        Seller.registerUserWith(email: emailTxt.text!, password: passwordTxt.text!, sellerName:nameTxt.text!, address:addressTxt.text!,telephone:phoneTxt.text!, storeName:storeNameTxt.text!, latitude:latitude, longitude:longitude) { (error) in

            if error == nil {
                self.hud.textLabel.text = "Verification Email sent!"
                defaults.set(true, forKey:kCURRENTUSER)
//                self.performSegue(withIdentifier: "userSignedUpSegue", sender: nil)
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            } else {
                print("error registering", error!.localizedDescription)
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }


            self.hideLoadingIndicator()
        }
        
    }
    //MARK: - Helpers
    private func textFieldsHaveText() -> Bool {
        return (nameTxt.text != "" && phoneTxt.text != "" && addressTxt.text != "" && storeNameTxt.text != "" && emailTxt.text != "" && passwordTxt.text != "")
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func showLoadingIndicator() {
        
        if activityIdicator != nil {
            self.view.addSubview(activityIdicator!)
            activityIdicator!.startAnimating()
        }
        
    }

    private func hideLoadingIndicator() {
        
        if activityIdicator != nil {
            activityIdicator!.removeFromSuperview()
            activityIdicator!.stopAnimating()
        }
    }

}

//MARK: - Hide Keyboard
extension RegistrationViewController{
    func hideKeyBoard(){
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(Tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

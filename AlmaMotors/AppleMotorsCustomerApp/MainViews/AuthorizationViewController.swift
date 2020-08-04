//
//  AuthorizationViewController.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/31/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class AuthorizationViewController: UIViewController {

    //MARK: - IBOutlets
        
        @IBOutlet weak var emailTextField: UITextField!
        @IBOutlet weak var passwordTextField: UITextField!
        @IBOutlet weak var resendButtonOutlet: UIButton!
        
        
        //MARK: - Vars
        
        let hud = JGProgressHUD(style: .dark)
        var activityIdicator: NVActivityIndicatorView?

        
        //MARK: - View Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            activityIdicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 0.9998469949, green: 0.4941213727, blue: 0.4734867811, alpha: 1.0), padding: nil)
        }
        
        
        //MARK: - IBActions
        
        @IBAction func cancelButtonPressed(_ sender: Any) {
            dismissView()
        }
        
        @IBAction func loginButtonPressed(_ sender: Any) {
            
            if textFieldsHaveText() {
                
                loginUser()
            } else {
                hud.textLabel.text = "All fields are required"
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 2.0)
            }

        }
        
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
        

        @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
            print("forgot pass")

            if emailTextField.text != "" {
                resetThePassword()
            } else {
                hud.textLabel.text = "Please insert email!"
                hud.indicatorView = JGProgressHUDErrorIndicatorView()
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 2.0)
            }
            
        }
        
        @IBAction func resendEmailButtonPressed(_ sender: Any) {
            print("resend email")
            
            Customer.resendVerificationEmail(email: emailTextField.text!) { (error) in
                
                print("error resending email", error?.localizedDescription)
            }
            
        }
        
        //MARK: - Login User
        
        private func loginUser() {
            
            showLoadingIdicator()
            
            Customer.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
                
                if error == nil {
                    
                    if  isEmailVerified {
                        self.dismissView()
                        print("Email is verified")
                    } else {
                        self.hud.textLabel.text = "Please Verify your email!"
                        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        self.hud.show(in: self.view)
                        self.hud.dismiss(afterDelay: 2.0)
                        self.resendButtonOutlet.isHidden = false
                    }

                } else {
                    print("error loging in the iser", error!.localizedDescription)
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
                
                
                self.hideLoadingIdicator()
            }
            
        }

        
        //MARK: - Register User
        
        private func registerUser() {
            
            showLoadingIdicator()
            
            Customer.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                
                if error == nil {
                    self.hud.textLabel.text = "Varification Email sent!"
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
                
                
                self.hideLoadingIdicator()
            }
            
        }

        
        
        //MARK: - Helpers
        
        private func resetThePassword() {
            
            Customer.resetPasswordFor(email: emailTextField.text!) { (error) in
                
                if error == nil {
                    self.hud.textLabel.text = "Reset password email sent!"
                    self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                } else {
                    self.hud.textLabel.text = error!.localizedDescription
                    self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                    self.hud.show(in: self.view)
                    self.hud.dismiss(afterDelay: 2.0)
                }
            }
        }
        
        private func textFieldsHaveText() -> Bool {
            return (emailTextField.text != "" && passwordTextField.text != "")
        }
        
        private func dismissView() {
            self.dismiss(animated: true, completion: nil)
        }
        
        //MARK: - Activity Indicator
        
        private func showLoadingIdicator() {
            
            if activityIdicator != nil {
                self.view.addSubview(activityIdicator!)
                activityIdicator!.startAnimating()
            }
            
        }

        private func hideLoadingIdicator() {
            
            if activityIdicator != nil {
                activityIdicator!.removeFromSuperview()
                activityIdicator!.stopAnimating()
            }
        }

    }

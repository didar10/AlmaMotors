//
//  LoginViewController.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/8/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class LoginViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var resendButtonOutlet: UIButton!
    
    //MARK: - Vars
    
    let hud = JGProgressHUD(style: .dark)
    var activityIdicator: NVActivityIndicatorView?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        print("forgot pass")

        if emailTxt.text != "" {
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
        
        Seller.resendVerificationEmail(email: emailTxt.text!) { (error) in
            
            print("error resending email", error?.localizedDescription)
        }
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        hideKeyBoard()
    }
    //MARK: - Login User
    
    private func loginUser() {
        
        showLoadingIndicator()
        
        Seller.loginUserWith(email: emailTxt.text!, password: passwordTxt.text!) { (error, isEmailVerified) in
            let defaults = UserDefaults.standard
            if error == nil {
                
                if  isEmailVerified {
//                    let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//                    let tabBar = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! MainTabBarController
//                    tabBar.modalPresentationStyle = .fullScreen
//                    self.present(tabBar, animated: true, completion: nil)

                    defaults.set(true, forKey: kCURRENTUSER)
                    self.performSegue(withIdentifier: "userSignedInSegue", sender: nil)
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
            
            
            self.hideLoadingIndicator()
        }
        
    }
    
    //MARK: - Helpers
    
    private func resetThePassword() {
        
        Seller.resetPasswordFor(email: emailTxt.text!) { (error) in
            
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
        return (emailTxt.text != "" && passwordTxt.text != "")
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Activity Indicator
    
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
extension LoginViewController{
    func hideKeyBoard(){
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(Tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

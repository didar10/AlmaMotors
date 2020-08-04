//
//  ProfileTableViewController.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/31/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var finishRegistrationButtonOutlet: UIButton!
    
    //MARK: - Vars
    var editBarButtonOutlet: UIBarButtonItem!

    
    //MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        
         
                 
         if #available(iOS 13.0, *) {
           let navBarAppearance = UINavigationBarAppearance()
           navBarAppearance.configureWithOpaqueBackground()
           navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
           navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
           navBarAppearance.backgroundColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.00)
           self.navigationController?.navigationBar.standardAppearance = navBarAppearance
           self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("will")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("yoo")
        checkLoginStatus()
        checkOnboardingStatus()
    }

    // MARK: - Table view data source

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 3
//    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }


    
    //MARK: - Helpers
    
    private func checkOnboardingStatus() {
        print("....\(Customer.currentUser())")
        if Customer.currentUser() != nil {
            
            if Customer.currentUser()!.onBoard {
                finishRegistrationButtonOutlet.setTitle("Аккаунт активен", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = false
            } else {
                
                finishRegistrationButtonOutlet.setTitle("Введите ваши данные", for: .normal)
                finishRegistrationButtonOutlet.isEnabled = true
                finishRegistrationButtonOutlet.tintColor = .red
            }
       
            
        } else {
            finishRegistrationButtonOutlet.setTitle("Нужна авторизация", for: .normal)
            finishRegistrationButtonOutlet.isEnabled = false
        }
    }
    
    private func checkLoginStatus() {
        
        if Customer.currentUser() == nil {
            createRightBarButton(title: "Войти")
        } else {
            createRightBarButton(title: "Изменить")
        }
    }

    
    private func createRightBarButton(title: String) {
        
        editBarButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemPressed))
        
        self.navigationItem.rightBarButtonItem = editBarButtonOutlet
    }
    
    //MARK: - IBActions
    
    @objc func rightBarButtonItemPressed() {
        
        if editBarButtonOutlet.title == "Войти" {
            showLoginView()
        } else {
            goToEditProfile()
        }
    }



    private func showLoginView() {

        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        
        loginView.modalPresentationStyle = .fullScreen //<------
        self.present(loginView, animated: true, completion: nil)
    }
    
    private func goToEditProfile() {
        performSegue(withIdentifier: "profileToEditSeg", sender: self)
    }
    
    
}



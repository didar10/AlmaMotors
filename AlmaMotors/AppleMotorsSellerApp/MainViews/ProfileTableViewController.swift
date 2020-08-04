//
//  ProfileTableTableViewController.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/10/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

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
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }


    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        logOutUser()
    }
    
    private func logOutUser() {
        Seller.logOutCurrentUser { (error) in
            
            if error == nil {
                print("logged out")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let welcomeView = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
                welcomeView.modalPresentationStyle = .fullScreen
                self.present(welcomeView, animated: true, completion: nil)
            }  else {
                print("error login out ", error!.localizedDescription)
            }
        }
        
    }
}

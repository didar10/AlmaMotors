////
////  SellerInfoTableViewController.swift
////  AppleMotorsCustomerApp
////
////  Created by Didar Bakhitzhanov on 5/12/20.
////  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
////
//
//import UIKit
//
//class SellerInfoTableViewController: UITableViewController {
//    
//    //MARK: Vars
//    var sellerArray: [Seller] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        loadSellers()
//    }
//
//    // MARK: - Table view data source
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return sellerArray.count
//    }
//    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SellerInfoTableViewCell
//
//        cell.generateCell(sellerArray[indexPath.row])
//        
//        return cell
//    }
//    
//    private func loadSellers() {
//        downloadSellerFromFirebase { (allseller) in
//            self.sellerArray = allseller
//            self.tableView.reloadData()
//        }
//    }
//
//   
//}

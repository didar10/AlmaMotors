//
//  FavouritesViewController.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/31/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import JGProgressHUD
import EmptyDataSet_Swift

class FavouritesViewController: UIViewController {
    
    //MARK: - IBOutlets


    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Vars
    var favourites: Favourites?
    var allProducts: [Item] = []
    
    let hud = JGProgressHUD(style: .dark)

    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 13.0, *) {
           let navBarAppearance = UINavigationBarAppearance()
           navBarAppearance.configureWithOpaqueBackground()
           navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
           navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
           navBarAppearance.backgroundColor = UIColor(red:0.08, green:0.08, blue:0.08, alpha:1.00)
           self.navigationController?.navigationBar.standardAppearance = navBarAppearance
           self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }

        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Customer.currentUser() != nil {
            loadFavouritesFromFirestore()
        }
    }
    
       
       //MARK: - Download basket
       private func loadFavouritesFromFirestore() {
           
           downloadFavouritesFromFirestore(Customer.currentId()) { (favourites) in

               self.favourites = favourites
               self.getFavouritesItems()
           
           }
       }
       
       private func getFavouritesItems() {
           
           if favourites != nil {
               
               downloadItems(favourites!.itemIds) { (allItems) in

                   self.allProducts = allItems
                   self.tableView.reloadData()
               }
           }
       }
       
       //MARK: - Navigation
       
       private func showItemView(withItem: Item) {
           
           let itemVC = UIStoryboard.init(name: "DetailItem", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
           
           itemVC.item = withItem
           
           self.navigationController?.pushViewController(itemVC, animated: true)
       }


     
       
       private func removeItemFromFavourites(itemId: String) {
           
           for i in 0..<favourites!.itemIds.count {
               
               if itemId == favourites!.itemIds[i] {
                   favourites!.itemIds.remove(at: i)
                   
                   return
               }
           }
       }
       
       
   }


   extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return allProducts.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
           
           cell.generateCell(allProducts[indexPath.row])
           
           return cell
           
       }
       
       
       //MARK: - UITableview Delegate
       
       func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           return true
       }
       
       
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
           
           if editingStyle == .delete {
               
               let itemToDelete = allProducts[indexPath.row]
               
               allProducts.remove(at: indexPath.row)
               tableView.reloadData()
               
               removeItemFromFavourites(itemId: itemToDelete.id)

               updateFavouritesInFirestore(favourites!, withValues: [kITEMIDS : favourites!.itemIds]) { (error) in
                   
                   if error != nil {
                       print("error updating the favourites", error!.localizedDescription)
                   }
                   
                   self.getFavouritesItems()
               }
           }
       }

       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           tableView.deselectRow(at: indexPath, animated: true)
           showItemView(withItem: allProducts[indexPath.row])
       }
       
   }
extension FavouritesViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "В избранных нету товара")
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Добавьте товар в избраннное на странице поиска")
    }
    
    
}



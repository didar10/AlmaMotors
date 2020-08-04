//
//  ItemsTableViewController.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/12/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import JGProgressHUD
import EmptyDataSet_Swift

class ItemsTableViewController: UITableViewController {
    
    //MARK: - Vars
    var category: Category?
    var itemArray: [Item] = []
    let hud = JGProgressHUD(style: .dark)
 
    //MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.tableFooterView = UIView()
        
        self.title = category?.name
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //MARK: - Load Items
        if Seller.currentId() != nil {
            loadItems()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell

        cell.generateCell(itemArray[indexPath.row])
        
        return cell
    }

    //MARK: - Table View Delegate
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //            performSegue(withIdentifier: "itemsDetail", sender: itemArray[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(itemArray[indexPath.row])
    }

    
   
    //MARK: - Navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if MUser.currentUser()!.onBoard {
//        if segue.identifier == "itemToAddItemSeg"{
//            let vc = segue.destination as! AddItemViewController
//            vc.category = category!
//        }
//        } else {
//            showFinishRegView()
//        }
//
//    }
    
    private func showItemView(_ item: Item) {
        
        //MARK: - Storyboard move to other view controller
        
        let itemVC = UIStoryboard.init(name: "DetailItem", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        
        itemVC.item = item
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
    
  
    
    //MARK: - Load Items
      
      private func loadItems() {
          downloadItemsFromFirebase(Seller.currentId()) { (allItems) in
              self.itemArray = allItems
              self.tableView.reloadData()
          }
      }
    
    private func showNotification(text: String, isError: Bool) {
        
        if isError {
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else {
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        
        self.hud.textLabel.text = text
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }

}

extension ItemsTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "У вас пока нету товаров")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Добавьте товар на первой странице")
    }
    
}

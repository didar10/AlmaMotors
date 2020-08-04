//
//  SearchViewController.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/30/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import EmptyDataSet_Swift

class SearchViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchOptionsView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    var searchResults: [Item] = []
    var activityIndicator: NVActivityIndicatorView?
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()

        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .ballPulse, color: #colorLiteral(red: 0.4391592741, green: 0.5353201628, blue: 0.9573212266, alpha: 1), padding: nil)
    }
    
    //MARK: - Actions
    
    @IBAction func showSearchBarButtonPressed(_ sender: Any) {
        dismissKeyboard()
        showSearchField()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        if searchTextField.text != "" {
            
            searchInFirebase(forName: searchTextField.text!)
            emptyTextField()
            animateSearchOptionsIn()
            dismissKeyboard()
        }
    }
    
    //MARK: - Search database
    
    private func searchInFirebase(forName: String) {
        
        showLoadingIndicator()
        
        searchAlgolia(searchString: forName) { (itemIds) in
            
            downloadItems(itemIds) { (allItems) in
                
                self.searchResults = allItems
                self.tableView.reloadData()
                
                self.hideLoadingIndicator()
            }
        }
    }
    
    //MARK: - Helpers
    
    private func emptyTextField() {
        searchTextField.text = ""
    }
    
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    @objc func textFieldDidChange (_ textField: UITextField) {
        
        searchButtonOutlet.isEnabled = textField.text != ""
        
        if searchButtonOutlet.isEnabled {
            searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.4391592741, green: 0.5353201628, blue: 0.9573212266, alpha: 1)
        } else {
            disableSearchButton()
        }
        
    }
    
    
    private func disableSearchButton() {
        searchButtonOutlet.isEnabled = false
        searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }

    private func showSearchField() {
        
        disableSearchButton()
        emptyTextField()
        animateSearchOptionsIn()
    }
    
    //MARK: - Animations
    
    private func animateSearchOptionsIn() {
        
        UIView.animate(withDuration: 0.5) {
            self.searchOptionsView.isHidden = !self.searchOptionsView.isHidden
        }
    }

    //MARK: - Activity indicator
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
    }

    
    private func hideLoadingIndicator() {
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
        }
    }
    
    private func showItemView(withItem: Item) {
        
        let itemVC = UIStoryboard.init(name: "DetailItem", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        
        itemVC.item = withItem
        
        self.navigationController?.pushViewController(itemVC, animated: true)
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(searchResults[indexPath.row])
        
        return cell
        
    }
    
    //MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: searchResults[indexPath.row])
    }
    
    
}

extension SearchViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "Нажмите кнопку поиска")
    }
    
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return NSAttributedString(string: "Вы можете искать по названию, описанию товара. Так же вы можете искать товар по марке и модели авто")
    }
    
    
}

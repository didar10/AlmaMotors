//
//  SettingsSlideUpController.swift
//  AppleMotorsCustomerApp
//
//  Created by Didar Bakhitzhanov on 5/29/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsSlideUpControllerDelegate: class {
    func handleEdit()
    func handleDone()
}

class SettingsSlideUpController: UITableViewController {

    weak var delegate: SettingsSlideUpControllerDelegate?
    var annotation: AnnotationPin!
    

    var editItem: UIBarButtonItem!
    var doneItem: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Account"

        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.isTranslucent = false

        tableView.backgroundColor = .lightGrey
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.register(AccountItemCell.self, forCellReuseIdentifier: "seller")

        editItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(handleEdit))
        doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.leftBarButtonItem = editItem
    }

    @objc fileprivate func handleEdit(sender: UIBarButtonItem) {
        navigationItem.leftBarButtonItem = doneItem
        tableView.isScrollEnabled = true
        delegate?.handleEdit()
    }

    @objc fileprivate func handleDone(sender: UIBarButtonItem) {
        navigationItem.leftBarButtonItem = editItem
        tableView.isScrollEnabled = false
        delegate?.handleDone()
    }
}

extension SettingsSlideUpController {
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let menuHeaderView = SellerInfoView()
//        return menuHeaderView
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < 1 {
            let cell = AccountItemCell(style: .default, reuseIdentifier: nil)
            return cell
        } else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Add existing Account"
            cell.textLabel?.textColor = .blue
            return cell
        }
    }
}


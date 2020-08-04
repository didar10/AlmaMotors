//
//  CategoryCollectionViewController.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/12/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit

class CategoryCollectionViewController: UICollectionViewController {

    //MARK: Vars
        var categoryArray: [Category] = []
        
        let itemsPerRow: CGFloat = 2
        let sectionInsets = UIEdgeInsets(top: 16, left: 22, bottom: 16, right: 22)
        
    //    override var preferredStatusBarStyle: UIStatusBarStyle{
    //           return .lightContent
    //       }
        
        //MARK: View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
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
            
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            loadCategories()
        }

        // MARK: UICollectionViewDataSource


        override func numberOfSections(in collectionView: UICollectionView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }

        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return categoryArray.count
        }

        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CategoryCollectionViewCell
        
            
            
            
            cell.generateCell(categoryArray[indexPath.row])
            
            return cell
        }
        
        //MARK: UICollectionView Delegate
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if Seller.currentId() != nil {
            performSegue(withIdentifier: "categoryToAddItemsSeg", sender: categoryArray[indexPath.row])
            }
        }

        //MARK: Download categories
        private func loadCategories() {
            
            downloadCategoriesFromFirebase { (allCategories) in

               
                self.categoryArray = allCategories
                self.collectionView.reloadData()
            }
        }
        
        //MARK: Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            if segue.identifier == "categoryToAddItemsSeg" {
                
                let vc = segue.destination as! AddItemViewController
                vc.category = sender as? Category
            }
        }
        
        //MARK: - Show login view
           
                   
    }

    extension CategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
        
        //размер ячеек
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            
            let paddingWidth = sectionInsets.left * (itemsPerRow + 1.1)
            let availableWidth = collectionView.frame.width - paddingWidth
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: collectionView.frame.width/1.8)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return sectionInsets.left
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return sectionInsets.left
        }
    }

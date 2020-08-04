//
//  ItemViewController.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/12/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import JGProgressHUD
import FirebaseAuth

class ItemViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var availLabel: UILabel!
    
    @IBOutlet weak var brandLabel: UILabel!
    
    @IBOutlet weak var modelLabel: UILabel!
    
    @IBOutlet weak var generationLabel: UILabel!
    
    @IBOutlet weak var storeLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - Vars
    var item: Item!
    var itemImages: [UIImage] = []
    let hud = JGProgressHUD(style: .dark)
    
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    private let cellHeight : CGFloat = 196.0
    private let itemsPerRow: CGFloat = 1
    
     //MARK: - ViewLifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        downloadPictures()
        
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "addToBasket"), style: .plain, target: self, action: #selector(self.addToFavouritesButtonPressed))]
   
    }
    
    //MARK: - Download Pictures
    
    private func downloadPictures() {
        
        if item != nil && item.imageLinks != nil {
            downloadImages(imageUrls: item.imageLinks) { (allImages) in
                if allImages.count > 0 {
                    self.itemImages = allImages as! [UIImage]
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Setup UI
    
    private func setupUI() {
        
        if item != nil {
            self.title = item.name
            nameLabel.text = item.name
            categoryLabel.text = item.categoryName
            priceLabel.text = item.price
            statusLabel.text = item.status
            availLabel.text = item.availability
            brandLabel.text = item.carBrand
            modelLabel.text = item.carModel
            generationLabel.text = item.carGeneration
            descriptionTextView.text = item.description
            
        }
        
    }
    
    @objc func addToFavouritesButtonPressed() {
        
        if Customer.currentUser() != nil {
            
            downloadFavouritesFromFirestore(Customer.currentId()) { (favourites) in

                if favourites == nil {
                    self.createFavouritesList()
                } else {
                    favourites!.itemIds.append(self.item.id)
                    self.updateFavourites(favourites: favourites!, withValues: [kITEMIDS : favourites!.itemIds])
                }
            }

        } else {
            showLoginView()
        }
    }

    //MARK: - Add to basket
    
    private func createFavouritesList() {
        
        let newFavouritesList = Favourites()
        newFavouritesList.id = UUID().uuidString
        newFavouritesList.addedBy = Customer.currentId()
        newFavouritesList.itemIds = [self.item.id]
        saveFavouritesToFirestore(newFavouritesList)
        
        self.hud.textLabel.text = "Добавлено в избранное!"
        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func updateFavourites(favourites: Favourites, withValues: [String : Any]) {
        
        updateFavouritesInFirestore(favourites, withValues: withValues) { (error) in
            
            if error != nil {
                
                self.hud.textLabel.text = "Error: \(error!.localizedDescription)"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)

                print("error updating basket", error!.localizedDescription)
            } else {
                
                self.hud.textLabel.text = "Добавлено в избранное!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
            }
        }
    }
    
    
    //MARK: - Show login view
    
    private func showLoginView() {
        
        let loginView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "loginView")
        
        self.present(loginView, animated: true, completion: nil)
    }
    

}

extension ItemViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return itemImages.count == 0 ? 1 : itemImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCollectionViewCell

        if itemImages.count > 0 {
            cell.setupImageWith(itemImage: itemImages[indexPath.row])
        }
        
        return cell
        
    }
}

extension ItemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableWidth = collectionView.frame.width - sectionInsets.left
        print(availableWidth)
        return CGSize(width: availableWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
    }
}

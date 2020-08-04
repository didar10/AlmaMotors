//
//  AddItemViewController.swift
//  AppleMotorsSellerApp
//
//  Created by Didar Bakhitzhanov on 5/12/20.
//  Copyright © 2020 Didar Bakhitzhanov. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UITableViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var brandTxt: UITextField!
    @IBOutlet weak var modelTxt: UITextField!
    @IBOutlet weak var generationTxt: UITextField!
    @IBOutlet weak var availabTxt: UITextField!
    @IBOutlet weak var statusTxt: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    //MARK: - Variables
    var category: Category!
    var seller: Seller!
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    var itemImages: [UIImage?] = []
    
    var selectedBrand: String?
    var selectedModel: String?
    var selectedGener: String?
    var selectedAvail: String?
    var selectedStatus: String?
    var brandList = ["Toyota", "ВАЗ(Lada)", "Nissan", "Kia", "Hyundai"]
    var modelList = ["Camry", "Priora", "Qashqai", "Rio", "Elantra"]
    var generList = ["(2004 - 2006)", "(2006 - 2009)", "(2009 - 2011)", "(2011 - 2014)", "(2014 - 2018)"]
    var availList = ["В наличии", "На заказ"]
    var statusList = ["Новый","Б/У"]
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyBoard()
        createPickerView()
        dismissPickerView()
        self.title = category?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .circleStrokeSpin, color: #colorLiteral(red: 0.4391592741, green: 0.5353201628, blue: 0.9573212266, alpha: 1), padding: nil)
    }
    
    @objc func action() {
       view.endEditing(true)
    }
    
    //MARK: - IBActions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        hideKeyBoard()
        
        if fieldsAreCompleted() {
            saveToFirebase()
        } else {
            self.hud.textLabel.text = "All fields are required!"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
        }
        
    }
    
    @IBAction func photoButtonPressed(_ sender: Any) {
        itemImages = []
        showImageGallery()
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        hideKeyBoard()
    }
    
    //MARK: - Helper functions
    
    private func fieldsAreCompleted() -> Bool {
        
        return (nameTxt.text != "" && priceTxt.text != "" && brandTxt.text != "" && modelTxt.text != "" && generationTxt.text != "" && availabTxt.text != "" && statusTxt.text != "" && descriptionTextView.text != "")
    }
    
    private func popTheView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    //MARK: - Save Item
    private func saveToFirebase() {
        
        showLoadingIndicator()
        
        let item = Item()
        item.id = UUID().uuidString
        item.ownerId = Seller.currentId()
        item.name = nameTxt.text!
        item.categoryName = category.name
        item.categoryId = category.id
        item.price = priceTxt.text!
        item.carBrand = brandTxt.text!
        item.carModel = modelTxt.text!
        item.carGeneration = generationTxt.text!
        item.availability = availabTxt.text!
        item.status = statusTxt.text!
        item.description = descriptionTextView.text
//        let currentUser = Seller.currentUser()!
//        item.storeNamee = currentUser.storeName
//        item.storeAddress = currentUser.address
        
        
        
        if itemImages.count > 0 {

            uploadImages(images: itemImages, itemId: item.id) { (imageLikArray) in

                item.imageLinks = imageLikArray

                saveItemToFirestore(item)
                saveItemToAlgolia(item: item)

                self.hideLoadingIndicator()
                self.popTheView()
            }

        } else {
            saveItemToFirestore(item)
            saveItemToAlgolia(item: item)
            popTheView()
        }
        
    }
    
    //MARK: - Activity Indicator
    
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
    
    //MARK: - Show Gallery
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 3
        
        self.present(self.gallery, animated: true, completion: nil)
    }
    
    

}

//MARK: - Hide Keyboard
extension AddItemViewController{
    func hideKeyBoard(){
        let Tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(Tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
}

//MARK: - GalleryController

extension AddItemViewController: GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.itemImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }

    
}



//MARK: - Picker View
extension AddItemViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
            switch pickerView.tag {
            case 1:
                return brandList.count
            case 2:
                return modelList.count
            case 3:
                return generList.count
            case 4:
                return availList.count
            case 5:
                return statusList.count
            
            default:
                return 0
            }
            
            
        }
        
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            
            switch pickerView.tag {
            case 1:
                return brandList[row]
            case 2:
                return modelList[row]
            case 3:
                return generList[row]
            case 4:
                return availList[row]
            case 5:
                return statusList[row]
            
            default:
                return nil
            }
            
        }
        
            
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            
    //        let row = pickerView.selectedRow(inComponent: 0)
    //        txManufacturer.text = manufacturerlist[row]
            
            switch pickerView.tag {
            case 1:
                brandTxt.text = brandList[row]
            case 2:
                modelTxt.text = modelList[row]
            case 3:
                generationTxt.text = generList[row]
            case 4:
                availabTxt.text = availList[row]
            case 5:
                statusTxt.text = statusList[row]

            default:
                print("Ошибка")
            }
            
            
        }
        
        func createPickerView() {
            let brandPickerView = UIPickerView()
            let modelPickerView = UIPickerView()
            let generPickerView = UIPickerView()
            let availPickerView = UIPickerView()
            let statusPickerView = UIPickerView()
           
            brandPickerView.delegate = self
            modelPickerView.delegate = self
            generPickerView.delegate = self
            availPickerView.delegate = self
            statusPickerView.delegate = self
            
            brandPickerView.tag = 1
            modelPickerView.tag = 2
            generPickerView.tag = 3
            availPickerView.tag = 4
            statusPickerView.tag = 5
            
            brandTxt.inputView = brandPickerView
            modelTxt.inputView = modelPickerView
            generationTxt.inputView = generPickerView
            availabTxt.inputView = availPickerView
            statusTxt.inputView = statusPickerView
            
        }
        
        func dismissPickerView() {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            
            let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
            toolBar.setItems([button], animated: true)
            toolBar.isUserInteractionEnabled = true
            
            brandTxt.inputAccessoryView = toolBar
            modelTxt.inputAccessoryView = toolBar
            generationTxt.inputAccessoryView = toolBar
            availabTxt.inputAccessoryView = toolBar
            statusTxt.inputAccessoryView = toolBar
            
            
            
        }
}

